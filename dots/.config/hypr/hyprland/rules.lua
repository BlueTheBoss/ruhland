hl.window_rule({match = {title = "^(Open File)(.*)$" }, center = true, float = true})
hl.window_rule({match = {title = "^(Select a File)(.*)$" }, center = true, float = true})
hl.window_rule({match = {title = "^(Open Folder)(.*)$" }, center = true, float = true})
hl.window_rule({match = {title = "^(Save As)(.*)$" }, center = true, float = true})
hl.window_rule({match = {title = "^(File Upload)(.*)$" }, center = true, float = true})
hl.window_rule({match = {title = "^(Choose wallpaper)(.*)$" }, center = true, float = true, size = {"(monitor_w*0.60)", "(monitor_h*0.65)"}})
hl.window_rule({match = {title = "^(.*)(wants to save)$" }, center = true, float = true})
hl.window_rule({match = {title = "^(.*)(wants to open)$" }, center = true, float = true})

hl.window_rule({match = {class = "^(pavucontrol)$" }, float = true, size = {"(monitor_w*0.45)", "(monitor_h*0.45)"}, center = true})
hl.window_rule({match = {class = "^(org.pulseaudio.pavucontrol)$" }, float = true, size = {"(monitor_w*0.45)", "(monitor_h*0.45)"}, center = true})
hl.window_rule({match = {class = "^(nm-connection-editor)$" }, float = true, size = {"(monitor_w*0.45)", "(monitor_h*0.45)"}, center = true})
hl.window_rule({match = {class = "^(blueberry\\.py)$" }, float = true})
hl.window_rule({match = {class = ".*plasmawindowed.*" }, float = true})
hl.window_rule({match = {class = "kcm_.*" }, float = true})
hl.window_rule({match = {class = "org.freedesktop.impl.portal.desktop.kde" }, float = true, size = {"(monitor_w*0.60)", "(monitor_h*0.65)"}})

hl.window_rule({match = {title = "^([Pp]icture[-\\s]?[Ii]n[-\\s]?[Pp]icture)(.*)$" }, float = true, pin = true, keep_aspect_ratio = true, move = {"(monitor_w*0.73)", "(monitor_h*0.72)"}, size = {"(monitor_w*0.25)", "(monitor_h*0.25)"}})
hl.window_rule({match = {title = ".*is sharing (a window|your screen).*" }, float = true, pin = true, move = {"(monitor_w*.5-window_w*.5)", "(monitor_h-window_h-12)"}})

hl.window_rule({match = {title = ".*\\.exe" }, immediate = true})
hl.window_rule({match = {title = ".*minecraft.*" }, immediate = true})
hl.window_rule({match = {class = "^(steam_app).*" }, immediate = true})

hl.window_rule({match = {float = 0 }, no_shadow = true})

hl.workspace_rule({ workspace = "special:special", gaps_out = 30 })
