#import <Cocoa/Cocoa.h>

@interface LWindow : NSWindow
@end


@implementation LWindow

-(id) init
{
#if 0
  // Create a screen-sized window on the display you want to take over
  NSRect screenRect = [[NSScreen mainScreen] frame];

  // Initialize the window making it size of the screen and borderless
  self = [super initWithContentRect:screenRect
              styleMask:NSBorderlessWindowMask
                backing:NSBackingStoreBuffered
                defer:YES];

  // Set the window level to be above the menu bar to cover everything else
  [self setLevel:NSMainMenuWindowLevel+1];

  // Set opaque
  [self setOpaque:YES];

  // Hide this when user switches to another window (or app)
  [self setHidesOnDeactivate:YES];

#else
// normal window

#endif
  return self;
}

-(BOOL) canBecomeKeyWindow
{
  // Return yes so that this borderless window can receive input
  return YES;
}

- (void) keyDown:(NSEvent *)event
{
  [NSApp terminate: nil];
  // Implement keyDown since controller will not get [ESC] key event which
  // the controller uses to kill fullscreen
  // [[self windowController] keyDown:event];
}

@end


int main(int argc, char** argv)
{
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    NSApplication* app = [[NSApplication alloc] init];
    LWindow* window = [[LWindow alloc] 
        initWithContentRect: NSMakeRect(0, 0, 640, 480)
        styleMask: NSTitledWindowMask | NSMiniaturizableWindowMask
        backing: NSBackingStoreBuffered
        defer: NO];
    [window setTitle: @"New Window"];
    [window center];
    [window makeKeyAndOrderFront:nil];
    [NSApp activateIgnoringOtherApps:YES];
    [app run];
    [pool release];
    return 0;
}
