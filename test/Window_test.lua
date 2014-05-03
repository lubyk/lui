--[[--
# lui.Window test
--]]--

local lut = require 'lut'
local lui = require 'lui'
local should = lut.Test 'lui.Window'
local Window = lui.Window

local function makeWin(...)
  local win = Window(...)
  win:animateFrame(false)
  win:show()
  return win
end

function should.autoload()
  assertType('table', Window)
end

function should.print()
  local win = makeWin()
  assertMatch('lui.Window: 0x%d', win:__tostring())
end


function should.respondToDeleted()
  local win = makeWin()
  assertFalse(win:deleted())
end

function should.respondToMove()
  local win = makeWin()
  win:move(15, 32)
  local x, y = win:frame()
  assertEqual(15, x)
  assertEqual(32, y)
end

function should.respondToResize()
  local win = makeWin()
  win:resize(150, 320)
  local _, _, w, h = win:frame()
  assertEqual(150, w)
  assertEqual(320, h)
end

function should.getScreenSize()
  local w, h = lui.Window.screenSize()
  assertInRange(200, 10000, w)
  assertInRange(200, 10000, h)
end

function should.getTitleBarSize()
  local t1 = Window(lui.Window.Borderless):titleBarHeight()
  local t2 = Window(lui.Window.Titled):titleBarHeight()
  assertType('number', t1)
  assertLessThen(t2, t1)
end

function should.setAndReturnFrame()
  local win = makeWin()
  win:setFrame(100, 20, 200, 300)
  local x, y, w, h = win:frame()
  assertEqual(100, x)
  assertEqual(20, y)
  assertEqual(200, w)
  assertEqual(300, h)
end

function should.triggerResizedCallback()
  local win = makeWin()
  win:animateFrame(false)
  local s = {}
  function win:resized(w, h)
    s.w, s.h = w, h
  end
  win:resize(150, 320)
  assertEqual(150, s.w)
  assertEqual(320, s.h)
end

function should.triggerMovedCallback()
  local win = makeWin()
  win:animateFrame(false)
  local s = {}
  function win:moved(x, y)
    s.x, s.y = x, y
  end
  win:move(15, 32)
  assertEqual(15, s.x)
  assertEqual(32, s.y)
end

function should.receiveClick()
  local win = makeWin()
  local ev
  function win:click(x, y, op, btn, mod)
    ev = {
      x = x,
      y = y,
      op = op,
      btn = btn,
      mod = mod,
    }
  end
  win:simulateClick(30, 40)
  assertValueEqual({
    x   = 30,
    y   = 40,
    op  = lui.Window.MouseDown,
    btn = lui.Window.LeftButton,
    mod = 0,
  }, ev)
end

function should.respondToAnimateFrame()
  local win = makeWin()
  assertPass(function()
    win:animateFrame(false)
  end)
end

function should.hide()
  local win = makeWin()
  win:show()
  assertPass(function()
    win:hide()
    win:show()
    win:hide()
  end)
end

should:test()

