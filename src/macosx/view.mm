#include "lui/View.h"

#import <Cocoa/Cocoa.h>

// #import <QuartzCore/CVDisplayLink.h>

// Avoid including all legacy OpenGL stuff
#define __gl_h_
#define GL_DO_NOT_WARN_IF_MULTI_GL_VERSION_HEADERS_INCLUDED
#include <OpenGL/gl3.h>

using namespace lui;

// ============================================== LView (objC)

@interface LView : NSOpenGLView {
  View * master_;
  NSOpenGLContext *context_;
}

- (id)initWithFrame:(NSRect)frame master:(View*) master;
- (void)prepareOpenGL;
- (void)linkOpenGL;

@end

@implementation LView

- (id)initWithFrame:(NSRect)frame master:(View*) master {
  self = [super initWithFrame:frame];
  if (self) {
    master_ = master;
    [self prepareOpenGL];
  }
  return self;
}

// This is only called once the view has a window.
- (void)prepareOpenGL {
  NSOpenGLPixelFormatAttribute attrs[] =
  {
    // Double buffering not working. Fixe when needed.
    NSOpenGLPFADoubleBuffer,

    // Must specify the 3.2 Core Profile to use OpenGL 3.2
    NSOpenGLPFAOpenGLProfile, NSOpenGLProfileVersion3_2Core,
    NSOpenGLPFAColorSize, 24,
    NSOpenGLPFADepthSize, 24,
    NSOpenGLPFAAlphaSize, 8,
    NSOpenGLPFAAccelerated,
    0
  };

  NSOpenGLPixelFormat *pf = [[[NSOpenGLPixelFormat alloc] initWithAttributes:attrs] autorelease];

  if (!pf) {
    throw dub::Exception("No OpenGL pixel format.");
  }

  context_ = [[[NSOpenGLContext alloc] initWithFormat:pf shareContext:nil] autorelease];

  // Crash on legacy function call ? No. Error reporting should be enough.
  // CGLEnable([context_ CGLContextObj], kCGLCECrashOnRemovedFunctions);

  [self setPixelFormat:pf];


  // Turning this on means we can address all pixels on the retina display
  // instead of having our image zoomed. This has consequences on pixel
  //  coordinates and we should only work this once everything is working
  // [self setWantsBestResolutionOpenGLSurface:YES];
}

// Link OpenGL to view
- (void)linkOpenGL {
  [context_ setView:self];
  [self setOpenGLContext:context_];
  [context_ makeCurrentContext];
}

- (BOOL)acceptsFirstResponder {
  return YES;
}

- (void)drawRect:(NSRect)rect
{
  // FIXME: we cannot draw from this thread !!
  master_->redraw();
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
  bool is_fullscreen_;

public:
  Implementation(View *master, int style)
   : master_(master)
   , win_(NULL)
   , view_(NULL)
   , window_style_(style)
   , is_visible_(false)
   , is_window_(true)
   , is_fullscreen_(false)
  {
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

      [view_ linkOpenGL];

      is_visible_ = true;
    }
  }

  void hide() {
    if (is_visible_) {
      if (is_window_) {
        // store frame and hide window
        deleteWindow(true);
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
        deleteWindow(false);
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

  void setFullscreen(bool should_fullscreen) {
    if (should_fullscreen == is_fullscreen_) return;
    is_fullscreen_ = should_fullscreen;

    if (is_visible_) {
      // only store frame when passing from base to full.
      deleteWindow(should_fullscreen);
      createWindow();
      master_->resized();
    }
  }

  bool isFullscreen() {
    return is_fullscreen_;
  }

  void swapBuffers() {
    [[view_ openGLContext] flushBuffer];
  }
    
  private:

  void createWindow() {
    if (!win_) {
      if (is_fullscreen_) {
        // Create a screen-sized window on the display you want to take over
        NSRect screenRect = [[NSScreen mainScreen] frame];

        // Initialize the window making it size of the screen and borderless
        win_ = [[LWindow alloc] initWithContentRect:screenRect
                                          styleMask:NSBorderlessWindowMask
                                            backing:NSBackingStoreBuffered
                                              defer:YES
                                             master:master_
                                               view:view_];

        // Set the window level to be above the menu bar to cover everything else
        [win_ setLevel:NSMainMenuWindowLevel+1];

        // // Set opaque
        [win_ setOpaque:YES];

        // Hide this when user switches to another window (or app)
        // do not hide or when working with two screens it's bad...
        // [win_ setHidesOnDeactivate:YES];
      } else {
        win_ = [[LWindow alloc] initWithContentRect:frame_
                                          styleMask:window_style_
                                            backing:NSBackingStoreBuffered
                                              defer:YES
                                             master:master_
                                               view:view_];
      }
      [win_ makeKeyAndOrderFront:win_];
      [win_ setReleasedWhenClosed:NO];
      // [NSApp activateIgnoringOtherApps:YES];

      // Forces OpenGL context initialization.
      [view_ setNeedsDisplay:YES];
    }
  }

  void deleteWindow(bool store_frame) {
    if (win_) {
      if (store_frame) {
        frame_.origin = [win_  frame].origin;
        frame_.size   = [view_ frame].size;
      }
      [win_ autorelease];
      [win_ close];
      win_ = NULL;
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

void View::simulateClick(double x, double y, int op, int btn, int mod) {
  impl_->simulateClick(x, y, op, btn, mod);
}

void View::setParent(View *parent) {
  impl_->setParent(parent);
}

void View::setFullscreen(bool should_fullscreen) {
  impl_->setFullscreen(should_fullscreen);
}

bool View::isFullscreen() {
  return impl_->isFullscreen();
}

void View::swapBuffers() {
  impl_->swapBuffers();
}

