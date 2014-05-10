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
#ifndef LUBYK_INCLUDE_LUI_FILE_HANDLE_H_
#define LUBYK_INCLUDE_LUI_FILE_HANDLE_H_

#include "dub/dub.h"

namespace lui {

/** Simple native OS FileHandle. Can be used to bridge lens.Scheduler with
 * GUI run loop for sockets and file handles.
 *
 * @dub push: dub_pushobject
 *      ignore: timeout
 */
class FileHandle : public dub::Thread {
public:

  FileHandle(int fd);

  virtual ~FileHandle();

  void setEnabled(bool enabled);
  
  LuaStackSize __tostring(lua_State *L);

  // =================================== CALLBACKS
  void activated() {
    if (dub_pushcallback("activated")) {
      // <func> <self>
      dub_call(1, 0);
    }
  }
private:
  class Implementation;
  Implementation *impl_;
};

} // namespace lui

#endif // LUBYK_INCLUDE_LUI_FILE_HANDLE_H_


