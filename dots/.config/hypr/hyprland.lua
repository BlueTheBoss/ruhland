require("hyprland.lib")
require("hyprland.services")
require("hyprland.env")
require("hyprland.variables")

if is_file_exists(HOME .. "/.config/hypr/custom/env.lua") then
    require("custom.env")
end
if is_file_exists(HOME .. "/.config/hypr/custom/variables.lua") then
    require("custom.variables")
end

require("hyprland.execs")
require("hyprland.general")
require("hyprland.rules")
require("hyprland.colors")
require("hyprland.keybinds")

if is_file_exists(HOME .. "/.config/hypr/custom/execs.lua") then
    require("custom.execs")
end
if is_file_exists(HOME .. "/.config/hypr/custom/general.lua") then
    require("custom.general")
end
if is_file_exists(HOME .. "/.config/hypr/custom/rules.lua") then
    require("custom.rules")
end
if is_file_exists(HOME .. "/.config/hypr/custom/keybinds.lua") then
    require("custom.keybinds")
end

if is_file_exists(HOME .. "/.config/hypr/workspaces.lua") then
    require("workspaces")
end
if is_file_exists(HOME .. "/.config/hypr/monitors.lua") then
    require("monitors")
end

require("hyprland.shellOverrides.main")
