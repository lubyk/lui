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

// ============================================== Window::Implementation
class Window::Implementation {
  Window *master_;
  NSWindow *win_;

public:
  Implementation(Window *master, int flags)
   : master_(master)
  {
    NSRect frame = NSMakeRect(0, 0, 200, 200);
    win_ = [[NSWindow alloc] initWithContentRect:frame
                                        styleMask:flags
                                          backing:NSBackingStoreBuffered
                                            defer:NO];
    [win_ setBackgroundColor:[NSColor blueColor]];
    [win_ makeKeyAndOrderFront:NSApp];
  }

  ~Implementation() {
    [win_ autorelease];
  }
};

Window::Window(int window_flags) {
  impl_ = new Window::Implementation(this, window_flags);
}

Window::~Window() {
  if (impl_) delete impl_;
}

