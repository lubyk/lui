/**
 *
 * MACHINE GENERATED FILE. DO NOT EDIT.
 *
 * Bindings for class Timer
 *
 * This file has been generated by dub 2.2.0.
 */
#include "dub/dub.h"
#include "lui/Timer.h"

using namespace lui;

/** lui::Timer::Timer(double interval)
 * include/lui/Timer.h:44
 */
static int Timer_Timer(lua_State *L) {
  try {
    double interval = dub::checknumber(L, 1);
    Timer *retval__ = new Timer(interval);
    retval__->dub_pushobject(L, retval__, "lui.Timer", true);
    return 1;
  } catch (std::exception &e) {
    lua_pushfstring(L, "new: %s", e.what());
  } catch (...) {
    lua_pushfstring(L, "new: Unknown exception");
  }
  return dub::error(L);
}

/** virtual lui::Timer::~Timer()
 * include/lui/Timer.h:46
 */
static int Timer__Timer(lua_State *L) {
  try {
    DubUserdata *userdata = ((DubUserdata*)dub::checksdata_d(L, 1, "lui.Timer"));
    if (userdata->gc) {
      Timer *self = (Timer *)userdata->ptr;
      delete self;
    }
    userdata->gc = false;
    return 0;
  } catch (std::exception &e) {
    lua_pushfstring(L, "__gc: %s", e.what());
  } catch (...) {
    lua_pushfstring(L, "__gc: Unknown exception");
  }
  return dub::error(L);
}

/** void lui::Timer::start(double fire_in_seconds)
 * include/lui/Timer.h:50
 */
static int Timer_start(lua_State *L) {
  try {
    Timer *self = *((Timer **)dub::checksdata(L, 1, "lui.Timer"));
    int top__ = lua_gettop(L);
    if (top__ >= 2) {
      double fire_in_seconds = dub::checknumber(L, 2);
      self->start(fire_in_seconds);
      return 0;
    } else {
      self->start();
      return 0;
    }
  } catch (std::exception &e) {
    lua_pushfstring(L, "start: %s", e.what());
  } catch (...) {
    lua_pushfstring(L, "start: Unknown exception");
  }
  return dub::error(L);
}

/** void lui::Timer::stop()
 * include/lui/Timer.h:56
 */
static int Timer_stop(lua_State *L) {
  try {
    Timer *self = *((Timer **)dub::checksdata(L, 1, "lui.Timer"));
    self->stop();
    return 0;
  } catch (std::exception &e) {
    lua_pushfstring(L, "stop: %s", e.what());
  } catch (...) {
    lua_pushfstring(L, "stop: Unknown exception");
  }
  return dub::error(L);
}

/** void lui::Timer::setInterval(double interval)
 * include/lui/Timer.h:61
 */
static int Timer_setInterval(lua_State *L) {
  try {
    Timer *self = *((Timer **)dub::checksdata(L, 1, "lui.Timer"));
    double interval = dub::checknumber(L, 2);
    self->setInterval(interval);
    return 0;
  } catch (std::exception &e) {
    lua_pushfstring(L, "setInterval: %s", e.what());
  } catch (...) {
    lua_pushfstring(L, "setInterval: Unknown exception");
  }
  return dub::error(L);
}

/** LuaStackSize lui::Timer::__tostring(lua_State *L)
 * include/lui/Timer.h:63
 */
static int Timer___tostring(lua_State *L) {
  try {
    Timer *self = *((Timer **)dub::checksdata(L, 1, "lui.Timer"));
    return self->__tostring(L);
  } catch (std::exception &e) {
    lua_pushfstring(L, "__tostring: %s", e.what());
  } catch (...) {
    lua_pushfstring(L, "__tostring: Unknown exception");
  }
  return dub::error(L);
}



// --=============================================== METHODS

static const struct luaL_Reg Timer_member_methods[] = {
  { "new"          , Timer_Timer          },
  { "__gc"         , Timer__Timer         },
  { "start"        , Timer_start          },
  { "stop"         , Timer_stop           },
  { "setInterval"  , Timer_setInterval    },
  { "__tostring"   , Timer___tostring     },
  { "deleted"      , dub::isDeleted       },
  { NULL, NULL},
};


extern "C" int luaopen_lui_Timer(lua_State *L)
{
  // Create the metatable which will contain all the member methods
  luaL_newmetatable(L, "lui.Timer");
  // <mt>

  // register member methods
  dub::fregister(L, Timer_member_methods);
  // setup meta-table
  dub::setup(L, "lui.Timer");
  // <mt>
  return 1;
}