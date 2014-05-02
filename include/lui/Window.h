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
#ifndef LUBYK_INCLUDE_LUI_WIDGET_H_
#define LUBYK_INCLUDE_LUI_WIDGET_H_

#include "dub/dub.h"

namespace lui {

/** The Window is used to display an OpenGL 3 window context.
 * The Widget uses the following callbacks:  paint, mouse,
 * click, keyboard, move and resized.
 *
 * @dub push: dub_pushobject
 *      ignore: resized, moved
 */
class Window : public dub::Thread {
public:

  enum {
    Borderless         = 0,
    Titled             = 1 << 0,
    Closable           = 1 << 1,
    Miniaturizable     = 1 << 2,
    Resizable          = 1 << 3,
    TexturedBackground = 1 << 8,
    Default            = 1 + 2 + 4 + 8,
  };
  
  Window(int style = Default);

  ~Window();

  static LuaStackSize screenSize(lua_State *L);

  double titleBarHeight();

  void animateFrame(bool should_animate) {
    animate_frame_ = should_animate;
  }

  void setFrame(double x, double y, double w, double h);

  LuaStackSize frame(lua_State *L);

  void show();

  void hide();

  // =================================== CALLBACK

  void resized() {
    if (!dub_pushcallback("resized")) return;
    // <func> <self>
    int top = lua_gettop(dub_L);
    frame(dub_L);
    // <func> <self> <x> <y> <w> <h>
    lua_remove(dub_L, top + 1);
    lua_remove(dub_L, top + 1);
    // <func> <self> <w> <h>
    dub_call(3, 0);
  }

  void moved() {
    if (!dub_pushcallback("moved")) return;
    // <func> <self>
    int top = lua_gettop(dub_L);
    frame(dub_L);
    // <func> <self> <x> <y> <w> <h>
    lua_remove(dub_L, top + 3);
    lua_remove(dub_L, top + 3);
    // <func> <self> <x> <y>
    dub_call(3, 0);
  }
private:
  class Implementation;
  Implementation *impl_;

  /** Whether to animate resizing and move operations.
   */
  bool animate_frame_;

};

} // namespace lui

#endif // LUBYK_INCLUDE_LUI_WIDGET_H_
