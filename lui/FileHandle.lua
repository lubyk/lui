--[[------------------------------------------------------

  # FileHandle

  Wrap a filedescriptor into the OS notification system. The
  callback #activated is called when an event is available. When using
  (lens)[http://doc.lubyk.org/lens.html] library, this is a compatibility
  between the scheduler and the native GUI event loop.

  Usage example:
  
    local lui = require 'lui'

    fd = lui.FileHandle(some_fd)

    function fd:activated()
      -- called on read/write data available
    end


--]]------------------------------------------------------
local lub  = require 'lub'
local lui  = require 'lui'
local core = require 'lui.core'

local lib  = core.FileHandle
local new = lib.new


-- # Constructor

-- Create a new filehandle with a file descriptor.
-- The callback can be passed in the constructor or set as `activated` function.
function lib.new(fd, callback)
  local self = new(fd)
  print(self)
  if callback then
    self.activated = callback
  end
  return self
end


-- # Methods

-- Enable or disable notifications for this file descriptor. The notifications
-- are enabled on object creation.
-- function lib:setEnabled(should_enable)

-- # Callbacks

-- Method called when the filehandle is available for read or write operations.
-- function lib:activated()

return lib
