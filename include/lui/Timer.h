/*
  ==============================================================================

   This file is part of the LUBYK project (http://lubyk.org)
   Copyright (c) 2007-2014 by Gaspard Bucher (http://teti.ch).

  ------------------------------------------------------------------------------

   Permission is hereby granted, free of charge, to any person obtaining a copy
   of this software and associated documentation files (the "Software"), to deal
   in the Software without restriction, including without limitation the rights
   to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
   copies of the Software, and to permit persons to whom the Software is
   furnished to do so, subject to the following conditions:

   The above copyright notice and this permission notice shall be included in
   all copies or substantial portions of the Software.

   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
   IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
   FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
   AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
   LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
   OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
   THE SOFTWARE.

  ==============================================================================
*/
#ifndef LUBYK_INCLUDE_LUI_TIMER_H_
#define LUBYK_INCLUDE_LUI_TIMER_H_

#include "dub/dub.h"

namespace lui {

/** The timer is used to bridge OS GUI with lens.Scheduler or create simple
 * apps.
 *
 * @dub push: dub_pushobject
 *      ignore: timeout
 */
class Timer : public dub::Thread {
public:
  Timer(double interval);

  virtual ~Timer();

  /** Start, first timeout in fire_in_seconds.
   */
  void start(double fire_in_seconds);

  /** First timeout now.
   */
  void start();

  void stop();

  bool running();

  /** Expects an interval in seconds. Use start(interval) for irregular
   * timers instead.
   */
  void setInterval(double interval);

  LuaStackSize __tostring(lua_State *L);


  // =================================== CALLBACKS

  double timeout() {
    double retval = -1.0;

    if (!dub_pushcallback("timeout")) return retval;
    // <func> <self>
    dub_call(1, 1);
    // <nb>
    if (lua_isnumber(dub_L, -1)) {
      retval = lua_tonumber(dub_L, -1);
    }
    // <nb>
    lua_pop(dub_L, 1);
    //
    return retval;
  }

private:
  class Implementation;
  Implementation *impl_;
};

} // namespace lui

#endif // LUBYK_INCLUDE_LUI_TIMER_H_
