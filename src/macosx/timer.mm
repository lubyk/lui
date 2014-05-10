#include "lui/Timer.h"

#import <Cocoa/Cocoa.h>

using namespace lui;

// ============================================== LTimer (objC)

@interface LTimer : NSObject {
  Timer * master_;
  NSTimer *timer_;
}

- (id)initWithInterval:(double)interval date:(NSDate*)date master:(Timer*)master;
- (void)timerFireMethod:(NSTimer*)theTimer;
- (void)setFireDate:(NSDate*)date;
- (void)invalidate;

@end

@implementation LTimer

// FIXME: we could remove this class if we could have a C++ selector...
- (id)initWithInterval:(double)interval date:(NSDate*)date master:(Timer*)master {
  self = [super init];
  if (self) {
    master_ = master;
    timer_ = [[NSTimer alloc] initWithFireDate:date 
                                      interval:(NSTimeInterval)interval 
                                        target:self
                                      selector:@selector(timerFireMethod:)
                                      userInfo:nil
                                       repeats:true];
    NSRunLoop * loop = [NSRunLoop currentRunLoop];
    [loop addTimer:[timer_ autorelease] forMode:NSDefaultRunLoopMode];
  }
  return self;
}

- (void)timerFireMethod:(NSTimer*)theTimer {
  master_->timeout();
}

- (void)setFireDate:(NSDate*)date {
  [timer_ setFireDate:date];
}

- (void)invalidate {
  [timer_ invalidate];
  // timer_ is autoreleased
  timer_ = nil;
}

@end

// ============================================== Timer::Implementation
class Timer::Implementation {
  Timer *master_;
  LTimer *timer_;
  double interval_;
public:
  Implementation(Timer *master, double interval)
   : master_(master)
   , timer_(NULL)
   , interval_(interval)
  {
  }

  ~Implementation() {
    stop();
  }

  /** Expects an interval in seconds.
   */
  void start(double fire_in_seconds) {
    NSDate *nextDate = [[NSDate date] dateByAddingTimeInterval:fire_in_seconds];
    if (!timer_) {
      timer_ = [[LTimer alloc] initWithInterval:interval_
                                           date:nextDate
                                         master:master_];
    } else {
      [timer_ setFireDate:nextDate];
    }
  }

  void start() {
    if (!timer_) {
      timer_ = [[LTimer alloc] initWithInterval:interval_
                                           date:[NSDate date]
                                         master:master_];
    }
  }

  void stop() {
    if (timer_) {
      [timer_ invalidate];
      [timer_ autorelease];
      timer_ = nil;
    }
  }

  /** Expects an interval in seconds.
   */
  void setInterval(double interval) {
    interval_ = interval;
    if (timer_) {
      stop();
      start();
    }
  }

  LuaStackSize __tostring(lua_State *L) {
    lua_pushfstring(L, "lui.Timer %f: %p", interval_, master_);
    return 1;
  }
};

Timer::Timer(double timeout) {
  impl_ = new Timer::Implementation(this, timeout);
}

Timer::~Timer() {
  delete impl_;
}

/** Expects an interval in seconds.
 */
void Timer::start(double fire_in_seconds) {
  impl_->start(fire_in_seconds);
}

void Timer::start() {
  impl_->start();
}

void Timer::stop() {
  impl_->stop();
}

/** Expects an interval in seconds.
 */
void Timer::setInterval(double interval) {
  impl_->setInterval(interval);
}

LuaStackSize Timer::__tostring(lua_State *L) {
  return impl_->__tostring(L);
}
