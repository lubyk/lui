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
#ifndef LUBYK_INCLUDE_LUI_VIEW_H_
#define LUBYK_INCLUDE_LUI_VIEW_H_

#include "dub/dub.h"

namespace lui {

/** The view is used to display an OpenGL 3 window context. A view without a
 * parent is a window.
 *
 * @dub push: dub_pushobject
 *      ignore: resized, moved, click, redraw
 */
class View : public dub::Thread {
  /** Whether to animate resizing and move operations.
   */
  bool animate_frame_;

  /** Just for a test with four, remove when done.
   */
  unsigned char *debug_buffer_;
  size_t debug_buffer_sz_;
public:

  enum WindowStyles {
    Borderless         = 0,
    Titled             = 1 << 0,
    Closable           = 1 << 1,
    Miniaturizable     = 1 << 2,
    Resizable          = 1 << 3,
    TexturedBackground = 1 << 8,
    Default            = 1 + 2 + 4 + 8,
  };

  enum ClickTypes {
    MouseDown    = 1,
    MouseUp      = 2,
    DoubleClick  = 3,
  };
  
  enum MouseButtons {
    // NoButton     = 0,
    LeftButton   = 1,
    RightButton  = 2,
    // MiddleButton = 3,
  };

  
  /** Create a view without parent = window.
   */
  View(int style = Default);

  ~View();

  void setParent(View *parent = NULL);

  static LuaStackSize screenSize(lua_State *L);

  void animateFrame(bool should_animate) {
    animate_frame_ = should_animate;
  }

  void setFrame(double x, double y, double w, double h);

  LuaStackSize frame(lua_State *L);

  void show();

  void hide();

  void setFullscreen(bool should_fullscreen);

  bool isFullscreen();

  /** Simulate mouse event (used for automated testing).
   */
  void simulateClick(double x, double y, int op = View::MouseDown, int btn = View::LeftButton, int mod = 0);

  void swapBuffers();

  LuaStackSize debugTest(int val, lua_State *L) {
    for(int i = 0; i < 64; ++i) {
      for(int j = 0; j < 64; ++j) {
        debug_buffer_[i*64*4 + j*4    ] = (i+j)*2;
        debug_buffer_[i*64*4 + j*4 + 1] = (i+j)*2;
        debug_buffer_[i*64*4 + j*4 + 2] = (i+j)*2;
        debug_buffer_[i*64*4 + j*4 + 3] = 255;
      }
    }
    lua_pushlightuserdata(L, debug_buffer_);
    return 1;
  }

  // =================================== CALLBACKS

  // Called when the OS decides that a redraw is needed.
  void redraw() {
    if (!dub_pushcallback("redraw")) return;
    // <func> <self>
    dub_call(1, 0);
  }

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

  void click(double x, double y, int op, int btn, int mod) {
    if (!dub_pushcallback("click")) return;
    // <func> <self>
    lua_pushnumber(dub_L, x);
    lua_pushnumber(dub_L, y);
    lua_pushnumber(dub_L, op);
    lua_pushnumber(dub_L, btn);
    lua_pushnumber(dub_L, mod);
    // <func> <self> <x> <y> <op> <btn> <mod>
    dub_call(6, 0);
  }

private:
  class Implementation;
  Implementation *impl_;
};

} // namespace lui

#endif // LUBYK_INCLUDE_LUI_VIEW_H_

