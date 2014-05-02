#include "lui/Window.h"

#import <Cocoa/Cocoa.h>

using namespace lui;


/// #import <Cocoa/Cocoa.h>
/// 
/// @interface LWindow : NSWindow
/// @end
/// 
/// 
/// #import <QuartzCore/CVDisplayLink.h>
/// 
/// @interface LView : NSOpenGLView 
/// {
/// }
/// 
/// - (void) drawRect: (NSRect) bounds;
/// @end
/// 
/// // ============================================================= LWindow
/// 
/// @implementation LWindow
/// 
/// -(id) init
/// {
/// #if 0
///   // Create a screen-sized window on the display you want to take over
///   NSRect screenRect = [[NSScreen mainScreen] frame];
/// 
///   // Initialize the window making it size of the screen and borderless
///   self = [super initWithContentRect:screenRect
///     styleMask:NSBorderlessWindowMask
///     backing:NSBackingStoreBuffered
///     defer:YES];
/// 
///   // Set the window level to be above the menu bar to cover everything else
///   [self setLevel:NSMainMenuWindowLevel+1];
/// 
///   // Set opaque
///   [self setOpaque:YES];
/// 
///   // Hide this when user switches to another window (or app)
///   [self setHidesOnDeactivate:YES];
/// 
/// #else
///   // normal window
/// 
/// #endif
///   return self;
/// }
/// 
/// -(BOOL) canBecomeKeyWindow
/// {
///   // Return yes so that this borderless window can receive input
///   return YES;
/// }
/// 
/// - (void) keyDown:(NSEvent *)event
/// {
///   [NSApp terminate: nil];
///   // Implement keyDown since controller will not get [ESC] key event which
///   // the controller uses to kill fullscreen
///   // [[self windowController] keyDown:event];
/// }
/// 
/// @end
/// 
/// // ============================================================= LView
/// 
/// #include <OpenGL/gl.h>
/// 
/// @implementation LView
/// 
/// - (id) initWithFrame:(CGRect)someRect
/// {
///   if (self = [super initWithFrame:someRect]) {
///     // OK
///   } else {
///     // FAIL
///     return self;
///   }
/// 
///   NSOpenGLPixelFormatAttribute attrs[] =
///   {
///     NSOpenGLPFADoubleBuffer,
///     NSOpenGLPFADepthSize, 24,
///     // Must specify the 3.2 Core Profile to use OpenGL 3.2
///     NSOpenGLPFAOpenGLProfile,
///     NSOpenGLProfileVersion3_2Core,
///     // FIXME: uncomment NSOpenGLPFADepthSize,
///     // FIXME: uncomment (NSOpenGLPixelFormatAttribute)16,
///     0
///   };
/// 
///   NSOpenGLPixelFormat *pf = [[[NSOpenGLPixelFormat alloc] initWithAttributes:attrs] autorelease];
/// 
///   if (!pf)
///   {
///     NSLog(@"No OpenGL pixel format");
///   }
/// 
///   NSOpenGLContext* context = [[[NSOpenGLContext alloc] initWithFormat:pf shareContext:nil] autorelease];
/// 
/// #if defined(DEBUG)
///   // When we're using a CoreProfile context, crash if we call a legacy OpenGL function
///   // This will make it much more obvious where and when such a function call is made so
///   // that we can remove such calls.
///   // Without this we'd simply get GL_INVALID_OPERATION error for calling legacy functions
///   // but it would be more difficult to see where that function was called.
///   CGLEnable([context CGLContextObj], kCGLCECrashOnRemovedFunctions);
/// #endif
/// 
///   [self setPixelFormat:pf];
/// 
///   [self setOpenGLContext:context];
/// 
/// #if SUPPORT_RETINA_RESOLUTION
///   // Opt-In to Retina resolution
///   [self setWantsBestResolutionOpenGLSurface:YES];
/// #endif // SUPPORT_RETINA_RESOLUTION
/// 
///   return self;
/// }
/// 
/// -(void) drawRect: (NSRect) bounds
/// {
///   NSLog(@"OpenGL version %s", glGetString(GL_VERSION));
/// }
/// 
/// @end
/// 
/// int main(int argc, char** argv)
/// {
///   NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
///   NSApplication* app = [[NSApplication alloc] init];
/// 
///   // http://www.idevgames.com/forums/thread-10123.html
///   // 
///   // vbsync with NSTimer to update image
///   // 
///   // NSTimer  renderTimer = [[NSTimer alloc] initWithFireDate:[NSDate distantFuture]
///   //               interval:0.001 // must use with vbsynch on, or you waste lots of CPU!
///   //               target:self
///   //               selector:@selector(renderTimerCallback:)
///   //               userInfo:nil
///   //               repeats:YES];
///   LWindow* window = [[LWindow alloc] 
///     initWithContentRect: NSMakeRect(0, 0, 800, 600)
///     styleMask: NSTitledWindowMask | NSMiniaturizableWindowMask
///     backing: NSBackingStoreBuffered
///     defer: NO];
///   [window setTitle: @"Lui"];
///   [window center];
///   [window makeKeyAndOrderFront:nil];
/// 
/// 
///   LView* lview = [[LView alloc] initWithFrame:NSMakeRect(0, 0, 800, 600)];
///   [window.contentView addSubview:lview];
/// 
///   [window.contentView setAutoresizesSubviews:YES];
///   [lview setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
/// 
///   [NSApp activateIgnoringOtherApps:YES];
///   [app run];
///   [pool release];
///   return 0;
/// }

// ============================================== LWindow (objC)

@interface LWindow : NSWindow <NSWindowDelegate> {
  Window * master_;
}

- (void)setMaster:(Window*) master;

@end

@implementation LWindow

- (void)setMaster:(Window*) master {
  master_ = master;
  [self setDelegate:self];
}

- (void)windowDidResize:(NSNotification *)notification {
  master_->resized();
}

- (void)windowDidMove:(NSNotification *)notification {
  master_->moved();
}

@end

// ============================================== Window::Implementation
class Window::Implementation {
  Window *master_;
  LWindow *win_;
  NSRect frame_;
  int style_;

public:
  Implementation(Window *master, int style)
   : master_(master)
   , win_(NULL)
   , style_(style) {
    NSRect screen = [[NSScreen mainScreen] frame];
    frame_ = NSMakeRect(20, screen.size.height - 20, 200, 200);
  }

  ~Implementation() {
    if (win_) {
      [win_ autorelease];
    }
  }

  inline void show() {
    if (!win_) {
      win_   = [[LWindow alloc] initWithContentRect:frame_
                                          styleMask:style_
                                            backing:NSBackingStoreBuffered
                                              defer:YES];
      [win_ setMaster:master_];
      [win_ makeKeyAndOrderFront:NSApp];
    }
  }

  inline void hide() {
    if (win_) {
      frame_ = [win_ frame];
      [win_ autorelease];
      [win_ close];
      win_ = NULL;
    }
  }

  inline LuaStackSize frame(lua_State *L) {
    NSRect frame  = win_ ? [win_ frame] : frame_;
    NSRect cframe = win_ ? [[win_ contentView] frame] : frame_;
    lua_pushnumber(L, frame.origin.x);
    lua_pushnumber(L, frame.origin.y);
    lua_pushnumber(L, cframe.size.width);
    lua_pushnumber(L, cframe.size.height);
    return 4;
  }

  inline void setFrame(double x, double y, double w, double h) {
    if (win_) {
      // Change frame. We must add space for title bar.
      [win_ setFrame:NSMakeRect(x, y, w, h + titleBarHeight())
             display:YES
             animate:master_->animate_frame_ && [win_ isVisible]];
    } else {
      // On new window, space for title bar is automatically added.
      frame_ = NSMakeRect(x, y, w, h);
    }
  }

  double titleBarHeight() {
    NSRect frame = NSMakeRect (0, 0, 100, 100);

    NSRect contentRect;
    contentRect = [NSWindow contentRectForFrameRect: frame
                                          styleMask: style_];

    return (frame.size.height - contentRect.size.height);
  }

};

Window::Window(int style) 
  : animate_frame_(true) {
  impl_ = new Window::Implementation(this, style);
}

Window::~Window() {
  if (impl_) delete impl_;
}

void Window::setFrame(double x, double y, double w, double h) {
  impl_->setFrame(x, y, w, h);
}

LuaStackSize Window::frame(lua_State *L) {
  return impl_->frame(L);
}

void Window::show() {
  impl_->show();
  moved();
  resized();
}

void Window::hide() {
  impl_->hide();
}

LuaStackSize Window::screenSize(lua_State *L) {
  NSRect frame = [[NSScreen mainScreen] frame];
  lua_pushnumber(L, frame.size.width);
  lua_pushnumber(L, frame.size.height);
  return 2;
}

double Window::titleBarHeight() {
  return impl_->titleBarHeight();
}


