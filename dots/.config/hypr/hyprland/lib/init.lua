HOME = os.getenv("HOME")

function is_file_exists(name)
   local f = io.open(name, "r")
   if f ~= nil then
      io.close(f)
      return true
   else
      return false
   end
end

function create_if_not_exists(path)
   if not is_file_exists(path) then
      -- Security: Block potential shell metacharacters to prevent command injection
      if path:find("[;&|`%$]") then
         return false
      end
      -- Escape path securely for the shell
      local escaped_path = path:gsub("\\", "\\\\"):gsub("\"", "\\\"")
      os.execute("mkdir -p \"$(dirname \"" .. escaped_path .. "\")\"")
      -- Security: Use safe Lua standard I/O to write the file, completely avoiding any shell spawn
      local f = io.open(path, "w")
      if f ~= nil then
         f:write("-- This file will not be overwritten across ruhland updates.\n")
         f:close()
         return true
      end
   end
   return false
end

function workspace_in_group(i)
    local curr = hl.get_active_workspace().id
    local newVal = math.floor((curr - 1) / workspaceGroupSize) * workspaceGroupSize + i
    return newVal
end
