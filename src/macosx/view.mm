#include "lui/View.h"

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

// ============================================== LView (objC)

@interface LView : NSView {
  View * master_;
  NSColor *back_;
}

- (id)initWithFrame:(NSRect)frame master:(View*) master;

@end

@implementation LView

- (id)initWithFrame:(NSRect)frame master:(View*) master {
  self = [super initWithFrame:frame];
  if (self) {
    master_ = master;
    back_ = [NSColor colorWithDeviceHue:(arc4random() % 256) / 256.0
                                saturation:1.0
                                brightness:1.0
                                     alpha:0.8];
  }
  return self;
}

- (BOOL)acceptsFirstResponder {
  return YES;
}

- (void)drawRect:(NSRect)rect
{
  [back_ set];
  NSRectFill([self bounds]);
}

- (void)mouseDown:(NSEvent *)theEvent {
  NSPoint pos = [self convertPoint:[theEvent locationInWindow] fromView:nil];
  int count = [theEvent clickCount];
  int type  = count == 1 ? View::MouseDown: View::DoubleClick;
  // FIXME convert modifier flags to LWindow flags
  // [theEvent modifierFlags]);
  master_->click(pos.x, pos.y, type, View::LeftButton, 0);
}

- (void)mouseUp:(NSEvent *)theEvent {
  NSPoint pos = [self convertPoint:[theEvent locationInWindow] fromView:nil];
  int count = [theEvent clickCount];
  int type  = count == 1 ? View::MouseUp: View::DoubleClick;
  // FIXME convert modifier flags to LWindow flags
  // [theEvent modifierFlags]);
  if (type == View::MouseUp) {
    master_->click(pos.x, pos.y, type, View::LeftButton, 0);
  }
  // ignore double click mouse up
}

@end

// ============================================== LWindow (objC)

@interface LWindow : NSWindow <NSWindowDelegate> {
  View * master_;
}

- (id)initWithContentRect:(NSRect)contentRect
                styleMask:(NSUInteger)windowStyle
                  backing:(NSBackingStoreType)bufferingType
                    defer:(BOOL)deferCreation
                   master:(View*)master
                     view:(LView*)view;

@end

@implementation LWindow

- (id)initWithContentRect:(NSRect)contentRect
                styleMask:(NSUInteger)windowStyle
                  backing:(NSBackingStoreType)bufferingType
                    defer:(BOOL)deferCreation
                   master:(View*)master
                     view:(LView*)view {

  self = [super initWithContentRect:contentRect
                          styleMask:windowStyle
                            backing:bufferingType
                              defer:deferCreation];
  if (self) {
    master_ = master;
    // setup LView as content view
    [self setContentView:view];
    [self setDelegate:self];
  }
  return self;
}

- (void)windowDidResize:(NSNotification *)notification {
  master_->resized();
}

- (void)windowDidMove:(NSNotification *)notification {
  master_->moved();
}

@end

#include <stdlib.h>
// ============================================== View::Implementation
class View::Implementation {
  View *master_;
  LWindow *win_;
  LView   *view_;
  /**< Frame used when view is hidden.
   * TODO: If we can store a frame on a hidden window or view, this
   * could be removed.
   */
  NSRect frame_;
  int window_style_;
  bool is_visible_;
  bool is_window_;

public:
  Implementation(View *master, int style)
   : master_(master)
   , win_(NULL)
   , view_(NULL)
   , window_style_(style)
   , is_visible_(false)
   , is_window_(true) {
    NSRect screen = [[NSScreen mainScreen] frame];
    frame_ = NSMakeRect(20, screen.size.height - 20, 200, 200);
    view_ = [[LView alloc] initWithFrame:frame_
                                  master:master];
  }

  ~Implementation() {
    [view_ autorelease];
    if (win_) {
      [win_ autorelease];
    }
  }

  void show() {
    if (is_visible_) {
      // already visible
    } else {

      if (is_window_) {
        // Window not yet shown
        createWindow();
      } else {
        [view_ setHidden:NO];
        [view_ setFrame:frame_];
        [view_ setNeedsDisplay:YES];
      }

      is_visible_ = true;
    }
  }

  void hide() {
    if (is_visible_) {
      if (is_window_) {
        // store frame and hide window
        frame_.origin = [win_  frame].origin;
        frame_.size   = [view_ frame].size;
        [win_ autorelease];
        [win_ close];
        win_ = NULL;
      } else {
        // store frame and hide view
        frame_ = [view_ frame];
        [view_ setHidden:YES];
      }
      is_visible_ = false;
    } else {
      // already hidden
    }
  }

  LuaStackSize frame(lua_State *L) {
    NSRect frame;

    if (is_visible_) {
      if (is_window_) {
        frame.origin = [win_ frame].origin;
        frame.size   = [view_ frame].size;
      } else {
        frame.origin = [view_ frame].origin;
        frame.size   = [view_ frame].size;
      }
    } else {
      frame.origin = frame_.origin;
      frame.size   = frame_.size;
    }

    lua_pushnumber(L, frame.origin.x);
    lua_pushnumber(L, frame.origin.y);
    lua_pushnumber(L, frame.size.width);
    lua_pushnumber(L, frame.size.height);
    return 4;
  }

  void setFrame(double x, double y, double w, double h) {
    if (is_visible_) {
      if (is_window_) {
        // Change frame. We must add space for title bar.
        [win_ setFrame:NSMakeRect(x, y, w, h + titleBarHeight())
               display:YES
               animate:master_->animate_frame_];
      } else {
        [view_ setFrame:NSMakeRect(x, y, w, h)];
        [view_ setNeedsDisplay:YES];
      }
    } else {
      // hidden window does not need extra space for title bar.
      frame_ = NSMakeRect(x, y, w, h);
    }
  }

  double titleBarHeight() {
    NSRect frame = NSMakeRect (0, 0, 100, 100);

    NSRect contentRect;
    contentRect = [NSWindow contentRectForFrameRect: frame
                                          styleMask: window_style_];

    return (frame.size.height - contentRect.size.height);
  }

  // FIXME: click simulation not working (works sometimes: strange)
  void simulateClick(double x, double y, int op, int btn, int mod) {

    if (!is_visible_) {
      throw dub::Exception("Cannot simulate events on a hidden view.");
    }
    NSEventType type;
    switch(op) {
      case View::MouseUp:
        type = btn == View::RightButton ? NSRightMouseUp : NSLeftMouseUp;
        break;
      case View::MouseDown:
        type = btn == View::RightButton ? NSRightMouseDown : NSLeftMouseDown;
        break;
      default:
        type = NSLeftMouseDown;
    }

    // FIXME translate modifier flags to NS Flags
    NSPoint location;
    location.x = x;
    location.y = y;
    NSEvent *event = [NSEvent mouseEventWithType:type
                                        location:location
                                   modifierFlags:mod
                                       timestamp:[[NSProcessInfo processInfo] systemUptime]
                                    windowNumber:[[view_ window] windowNumber]
                                         context:[NSGraphicsContext currentContext]
                                     eventNumber:nil
                                      clickCount:1
                                        pressure:nil];
      
    [NSApp postEvent:event atStart:NO];
  }

  void setParent(View *parent) {
    NSRect frame = [view_ frame];
    // absolute position
    if (parent) {
      NSView *pview = parent->impl_->view_;
      // absolute position
      frame.origin = [[view_ window] convertBaseToScreen:frame.origin];
      // position in new view
      frame.origin = [[pview window] convertScreenToBase:frame.origin];

      [pview addSubview:view_];
      [view_ setFrame:frame];

      if (is_window_) {
        [win_ autorelease];
        [win_ close];

        win_ = NULL;
        is_window_ = false;
      } 

      if (is_visible_) {
        [view_ setNeedsDisplay:YES];
      } else {
        [view_ setHidden:YES];
      }
    } else {
      if (is_window_) {
        // already a window
      } else {
        // transform view into window
        frame.origin = [[view_ window] convertBaseToScreen:frame.origin];

        // store view frame
        frame_ = frame;
        is_window_ = true;

        if (is_visible_) {
          createWindow();
        } else {
          // window will be created on show()
        }
      }
    }
  }

  private:

  void createWindow() {
    if (!win_) {
      win_ = [[LWindow alloc] initWithContentRect:frame_
                                        styleMask:window_style_
                                          backing:NSBackingStoreBuffered
                                            defer:YES
                                           master:master_
                                             view:view_];
      [win_ setReleasedWhenClosed:NO];
      [win_ makeKeyAndOrderFront:NSApp];
    }
  }
    
};

View::View(int style) 
  : animate_frame_(true) {
  impl_ = new View::Implementation(this, style);
}

View::~View() {
  if (impl_) delete impl_;
}

void View::setFrame(double x, double y, double w, double h) {
  impl_->setFrame(x, y, w, h);
}

LuaStackSize View::frame(lua_State *L) {
  return impl_->frame(L);
}

void View::show() {
  impl_->show();
  moved();
  resized();
}

void View::hide() {
  impl_->hide();
}

LuaStackSize View::screenSize(lua_State *L) {
  NSRect frame = [[NSScreen mainScreen] frame];
  lua_pushnumber(L, frame.size.width);
  lua_pushnumber(L, frame.size.height);
  return 2;
}

double View::titleBarHeight() {
  return impl_->titleBarHeight();
}

void View::simulateClick(double x, double y, int op, int btn, int mod) {
  impl_->simulateClick(x, y, op, btn, mod);
}

void View::setParent(View *parent) {
  impl_->setParent(parent);
}
