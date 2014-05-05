--[[--
# lui.View test
--]]--

local lut = require 'lut'
local lui = require 'lui'
local should = lut.Test 'lui.View'
local View   = lui.View

local function makeView(...)
  local view = View(...)
  view:animateFrame(false)
  view:show()
  return view
end

function should.autoload()
  assertType('table', View)
end

function should.print()
  local view = makeView()
  assertMatch('lui.View: 0x%d', view:__tostring())
end


function should.respondToDeleted()
  local view = makeView()
  assertFalse(view:deleted())
end

function should.respondToMove()
  local view = makeView()
  view:move(15, 32)
  local x, y = view:frame()
  assertEqual(15, x)
  assertEqual(32, y)
end

function should.respondToResize()
  local view = makeView()
  view:resize(150, 320)
  local _, _, w, h = view:frame()
  assertEqual(150, w)
  assertEqual(320, h)
end

function should.getScreenSize()
  local w, h = lui.View.screenSize()
  assertInRange(200, 10000, w)
  assertInRange(200, 10000, h)
end

function should.getTitleBarSize()
  local t1 = View(lui.View.Borderless):titleBarHeight()
  local t2 = View(lui.View.Titled):titleBarHeight()
  assertType('number', t1)
  assertLessThen(t2, t1)
end

function should.setAndReturnFrame()
  local view = makeView()
  view:setFrame(100, 20, 200, 300)
  local x, y, w, h = view:frame()
  assertEqual(100, x)
  assertEqual(20, y)
  assertEqual(200, w)
  assertEqual(300, h)
end

function should.triggerResizedCallback()
  local view = makeView()
  view:animateFrame(false)
  local s = {}
  function view:resized(w, h)
    s.w, s.h = w, h
  end
  view:resize(150, 320)
  assertEqual(150, s.w)
  assertEqual(320, s.h)
end

function should.triggerMovedCallback()
  local view = makeView()
  view:animateFrame(false)
  local s = {}
  function view:moved(x, y)
    s.x, s.y = x, y
  end
  view:move(15, 32)
  assertEqual(15, s.x)
  assertEqual(32, s.y)
end

function should.receiveClick()
  local view = makeView()
  local ev
  function view:click(x, y, op, btn, mod)
    ev = {
      x = x,
      y = y,
      op = op,
      btn = btn,
      mod = mod,
    }
  end
  view:simulateClick(30, 40)
  assertValueEqual({
    x   = 30,
    y   = 40,
    op  = lui.View.MouseDown,
    btn = lui.View.LeftButton,
    mod = 0,
  }, ev)
end

function should.respondToAnimateFrame()
  local view = makeView()
  assertPass(function()
    view:animateFrame(false)
  end)
end

function should.hide()
  local view = makeView()
  view:show()
  assertPass(function()
    view:hide()
    view:show()
    view:hide()
  end)
end

function should.setParent()
  local win = makeView()
  local view = lui.View()
  win:show()
  assertPass(function()
    view:setParent(win)
  end)
  view:show()
end

function should.addChild()
  local win = makeView()
  local view = lui.View()
  win:show()
  assertPass(function()
    win:addChild(view)
  end)
  view:show()
end

should:test()


