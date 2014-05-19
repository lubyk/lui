--[[------------------------------------------------------

  # Application

  GUI main application.

  The class is mainly used to pass scheduling to the OS event loop. It is
  automatically created by the lui library and works along with lens.Scheduler.
  
  Usage example:
  
    local lens = require 'lens'
    local lui  = require 'lui'

    lens.run(function()
      -- Implicit creation of lui.Application and GUI event loop integration
      -- with scheduler.
      win = lui.Window()
      -- Now running in OS GUI loop.
      win:show()
    end)

  ## Standalone

  You can also use the application without lens library:
  
    local lui  = require 'lui'

    win = lui.Window()

    -- Start OS GUI loop
    lui.Application():run()

--]]------------------------------------------------------
local lub  = require 'lub'
local lui  = require 'lui'
local core = require 'lui.core'

local lib  = core.Application
local new  = lib.new
local app

-- # Constructor

-- Create an application (singleton).
function lib.new()
  if not app then
    app = new()
    if coroutine.running() then
      -- Inform poller that we need to run GUI event loop.
      coroutine.yield('gui')
    end
  end
  return app
end

-- # Runtime

-- Enter the OS graphical interface event loop. This is implicitely called by
-- lens.Scheduler when an lui.Application is created while the scheduler is
-- running (either explicitely or implicitely by creating an lui.Window).
-- function lib:run()

return lib
