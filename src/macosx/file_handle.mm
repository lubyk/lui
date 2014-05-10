#include "lui/FileHandle.h"

#import <Cocoa/Cocoa.h>

using namespace lui;

// ============================================== LFileHandle (objC)

@interface LFileHandle : NSFileHandle {
  FileHandle * master_;
  bool enabled_;
}

- (id)initWithFileDescriptor:(int)fd master:(FileHandle*)master;
- (void)activated:(NSNotification*)notification;
- (void)setEnabled:(bool)enable;

@end

@implementation LFileHandle

- (id)initWithFileDescriptor:(int)fd master:(FileHandle*)master {
  printf("OK\n");
  self = [super initWithFileDescriptor:fd];
  printf("GOOD\n");
  if (self) {
    master_  = master;
    enabled_ = true;
    [self waitForDataInBackgroundAndNotify];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(activated:)
                                                 name:NSFileHandleDataAvailableNotification object:self];
  }
  return self;
}

- (void)activated:(NSNotification*)notification {
  if (enabled_) {
    master_->activated();
  }
}

- (void)setEnabled:(bool)enable {
  enabled_ = enable;
}

@end

// ============================================== Timer::Implementation
class FileHandle::Implementation {
  FileHandle *master_;
  LFileHandle *fh_;
  int fd_;
public:
  Implementation(FileHandle *master, int fd)
   : master_(master)
   , fd_(fd)
  {
    fh_ = [[LFileHandle alloc] initWithFileDescriptor:fd
                                               master:master];
  }

  ~Implementation() {
    [fh_ release];
  }


  void setEnabled(bool enable) {
    [fh_ setEnabled:enable];
  }

  LuaStackSize __tostring(lua_State *L) {
    lua_pushfstring(L, "lui.FileHandle %f: %p", fd_, master_);
    return 1;
  }
};

FileHandle::FileHandle(int fd) {
  impl_ = new Implementation(this, fd);
}

FileHandle::~FileHandle() {
  delete impl_;
}

void FileHandle::setEnabled(bool enabled) {
  impl_->setEnabled(enabled);
}

LuaStackSize FileHandle::__tostring(lua_State *L) {
  return impl_->__tostring(L);
}
