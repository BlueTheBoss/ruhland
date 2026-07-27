local custom_dir = HOME .. "/.config/hypr/custom"

local custom_files = {
    "env.lua",
    "execs.lua",
    "general.lua",
    "rules.lua",
    "variables.lua",
    "keybinds.lua",
}

for _, file in ipairs(custom_files) do
    create_if_not_exists(custom_dir .. "/" .. file)
end

create_if_not_exists(custom_dir .. "/scripts/__placeholder")
