#include "lui/FileHandle.h"

#import <Cocoa/Cocoa.h>

using namespace lui;

// ============================================== LFileHandle (objC)

@interface LFileHandle : NSObject {
  FileHandle * master_;
  NSFileHandle *fh_;
  bool enabled_;
}

- (id)initWithFileDescriptor:(int)fd master:(FileHandle*)master;
- (void)activated:(NSNotification*)notification;
- (void)setEnabled:(bool)enable;

@end

@implementation LFileHandle

- (id)initWithFileDescriptor:(int)fd master:(FileHandle*)master {
  fh_ = [[NSFileHandle alloc] initWithFileDescriptor:fd];
  if (self) {
    master_  = master;
    enabled_ = true;
    [fh_ waitForDataInBackgroundAndNotify];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(activated:)
                                                 name:NSFileHandleDataAvailableNotification object:fh_];
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

- (void)dealloc {
  [super dealloc];
  [fh_ release];
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
    lua_pushfstring(L, "lui.FileHandle %d: %p", fd_, master_);
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
