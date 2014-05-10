--[[------------------------------------------------------

  lui.Timer
  ---------


--]]------------------------------------------------------
local lui    = require 'lui'
local lut    = require 'lut'
local lens   = require 'lens'
local should = lut.Test 'lui.Timer'

local Timer,     sleep,      elapsed =
      lui.Timer, lens.sleep, lens.elapsed

function should.createTimer()
  local t = Timer(0.5, function()
  end)
  assertEqual('lui.Timer', t.type)
end

function should.respondToDeleted()
  local t = Timer(0.5)
  assertFalse(t:deleted())
end

function should.renderToString()
  local t = Timer(0.45)
  assertMatch('lui.Timer 0.45: 0x', tostring(t))
end

function should.startTimer()
  local t = Timer(0.5)
  assertPass(function()
    t:start()
  end)
end

function should.stopTimer()
  local t = Timer(0.5)
  assertPass(function()
    t:stop()
  end)
end

function should.changeInterval()
  local t = Timer(0.5)
  assertPass(function()
    t:setInterval(0.2)
  end)
end

should:test()


--[[
local SLEEP = 40 / 1000
local should = test.Suite('lk.Timer')

function should.loopTimerInExternalThread()
  local counter = 0
  local timer = lk.Timer(SLEEP, function()
    counter = counter + 1
    -- continue until 'timer' is gc or stopped.
  end)
  timer:start() -- default = trigger on start
  -- first trigger now
  now = elapsed()
  sleep(4 * SLEEP + 0.01)
  -- 00, 20, 40, 60, 80
  assertEqual(5, counter)
  start = elapsed()
  sleep(5 * SLEEP)
  --                   , 100, 120, 140, 160, 180
  assertEqual(10, counter)
  timer:stop()
end

function should.setInterval()
  local counter = 0
  local timer = lk.Timer(10, function()
    counter = counter + 1
    -- continue until 'timer' is gc or stopped.
  end)
  timer:start(false) -- do not trigger on start
  sleep(SLEEP - 0.01) -- 10
  assertEqual(0, counter)
  timer:setInterval(SLEEP)
  assertEqual(0, counter)
  sleep(4 * SLEEP) -- triggers:
  -- 20, 40, 60, 80
  assertEqual(4, counter)
  sleep(5 * SLEEP)
  assertEqual(9, counter)
  counter = 0
  timer:stop()
end

function should.setCallback()
  local counter = 0
  local timer = lk.Timer(0.01)
  function timer:tick()
    counter = counter + 1
    -- continue until 'timer' is gc or stopped.
  end
  timer:start(false) -- do not trigger on start
  sleep(SLEEP - 10)
  assertEqual(0, counter)
  timer:setInterval(SLEEP)
  assertEqual(0, counter)
  sleep(4 * SLEEP) -- triggers:
  -- 20, 40, 60, 80
  assertEqual(4, counter)
  sleep(5 * SLEEP)
  assertEqual(9, counter)
  counter = 0
  timer:stop()
end

function should.joinTimer()
  local counter = 0
  local timer = lk.Timer(0.01, function()
    counter = counter + 1
    if counter == 5 then
      -- stop
      return 0
    end
  end)
  timer:start()
  -- wait for timer to finish
  timer:join()
  assertEqual(5, counter)
end

function should.beRegular(t)
  local values = {}
  local i = 0
  local last
  local min = 9999
  local max = -1
  local timer = lk.Timer(0.01, function()
    local now = elapsed()
    if last then
      local d = now - last
      table.insert(values, d)
      if d > max then
        max = d
      elseif d < min then
        min = d
      end
    end
    last = now
    i = i + 1
    if i == 10 then
      -- stop
      return 0
    end
  end)
  timer:start()
  t:timeout(function()
    return i == 10
  end)
  local jitter = (max - min) / 2
  assertLessThen(1, jitter)
end

test.all()
--]]


