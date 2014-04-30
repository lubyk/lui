#include "lui/Application.h"

#import <Cocoa/Cocoa.h>

using namespace lui;

class Application::Implementation {
  Application *master_;
  NSApplication *app_;
  NSAutoreleasePool* pool_;

public:
  Implementation(Application *master)
   : master_(master)
  {
    pool_ = [[NSAutoreleasePool alloc] init];
    app_  = [[NSApplication alloc] init];
  }

  ~Implementation() {
    [pool_ release];
  }

  int exec() {
    [app_ run];
    return 0;
  }
};

Application::Application() {
  // if (!sAppKey) pthread_key_create(&sAppKey, NULL);

  // Avoid nasty number parsing bugs (0.5 not parsed)
  // setlocale(LC_NUMERIC, "C");
  impl_ = new Application::Implementation(this);
}

Application::~Application() {
  if (impl_) delete impl_;
}

void Application::bringToFront() {
  [NSApp activateIgnoringOtherApps:YES];
}

int Application::exec() {
  return impl_->exec();
}
