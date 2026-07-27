hl.monitor({
    output = "",
    mode = "preferred",
    position = "auto",
    scale = 1
})

hl.gesture({
    fingers = 3,
    direction = "swipe",
    action = "move"
})
hl.gesture({
    fingers = 3,
    direction = "pinch",
    action = "fullscreen"
})
hl.gesture({
    fingers = 4,
    direction = "horizontal",
    action = "workspace"
})

hl.config({
    gestures = {
        workspace_swipe_distance = 700,
        workspace_swipe_cancel_ratio = 0.2,
        workspace_swipe_min_speed_to_force = 5,
        workspace_swipe_direction_lock = true,
        workspace_swipe_direction_lock_threshold = 10,
        workspace_swipe_create_new = true
    },
    general = {
        gaps_in = 5,
        gaps_out = 8,
        border_size = 2,
        col = {
            active_border = "rgba(cba6f7FF)",
            inactive_border = "rgba(45475aFF)"
        },
        cursor_inactive_timeout = 3,
        layout = "dwindle",
        no_border_on_floating = false,
        resize_on_border = true,
        no_focus_fallback = true,
        allow_tearing = true,
        snap = {
            enabled = true,
            window_gap = 4,
            monitor_gap = 5,
            respect_gaps = true
        }
    },
    decoration = {
        rounding_power = 2.5,
        rounding = 14,
        active_opacity = 1.0,
        inactive_opacity = 0.9,
        fullscreen_opacity = 1.0,
        blur = {
            enabled = true,
            xray = true,
            special = false,
            new_optimizations = true,
            size = 8,
            passes = 3,
            brightness = 1,
            noise = 0.05,
            contrast = 0.89,
            vibrancy = 0.5,
            vibrancy_darkness = 0.5
        },
        shadow = {
            enabled = true,
            range = 20,
            offset = {0, 2},
            render_power = 10,
            color = "rgba(00000020)"
        },
        dim_inactive = true,
        dim_strength = 0.05,
        dim_special = 0.2
    },
    animations = {
        enabled = true
    },
    dwindle = {
        preserve_split = true,
        smart_split = false,
        smart_resizing = false
    },
})

-- Standard Material Design 3 and custom Bezier Curves
hl.curve("md3_standard", {
    type = "bezier",
    points = {{0.2, 0}, {0, 1}}
})
hl.curve("md3_decel", {
    type = "bezier",
    points = {{0.05, 0.7}, {0.1, 1}}
})
hl.curve("md3_accel", {
    type = "bezier",
    points = {{0.3, 0}, {0.8, 0.15}}
})
hl.curve("menu_decel", {
    type = "bezier",
    points = {{0.1, 1}, {0, 1}}
})
hl.curve("menu_accel", {
    type = "bezier",
    points = {{0.52, 0.03}, {0.72, 0.08}}
})
hl.curve("stall", {
    type = "bezier",
    points = {{1, -0.1}, {0.7, 0.85}}
})

-- Modern spring curves for ultra fluid physics (Hyprland 0.55+ / 0.56+)
-- Mass, stiffness, and dampening are tuned for responsive snaps with premium bounce
hl.curve("spring_window", {
    type = "spring",
    mass = 1,
    stiffness = 160,
    dampening = 21
})
hl.curve("spring_workspace", {
    type = "spring",
    mass = 1,
    stiffness = 130,
    dampening = 20
})
hl.curve("spring_special", {
    type = "spring",
    mass = 1,
    stiffness = 140,
    dampening = 18
})

-- Up-to-date modern animation configurations
hl.animation({ leaf = "windowsIn", enabled = true, speed = 4, spring = "spring_window", style = "popin 85%" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 3, bezier = "md3_decel" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 3.5, spring = "spring_window", style = "popin 90%" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 2, bezier = "md3_decel" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 4, spring = "spring_window", style = "slide" })
hl.animation({ leaf = "border", enabled = true, speed = 10, bezier = "md3_decel" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 3.5, spring = "spring_window", style = "popin 93%" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 3, spring = "spring_window", style = "popin 94%" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 0.5, bezier = "menu_decel" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 3, bezier = "stall" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 5, spring = "spring_workspace", style = "slide" })
hl.animation({ leaf = "specialWorkspaceIn", enabled = true, speed = 4, spring = "spring_special", style = "slidevert" })
hl.animation({ leaf = "specialWorkspaceOut", enabled = true, speed = 3, spring = "spring_special", style = "slidevert" })
hl.animation({ leaf = "zoomFactor", enabled = true, speed = 3, bezier = "md3_standard" })

hl.config({
    input = {
        kb_layout = "us",
        numlock_by_default = true,
        repeat_delay = 250,
        repeat_rate = 35,
        follow_mouse = 1,
        touchpad = {
            natural_scroll = true,
            disable_while_typing = true,
            clickfinger_behavior = true,
            scroll_factor = 0.7
        }
    },
    misc = {
        disable_hyprland_logo = true,
        disable_splash_rendering = true,
        vrr = 0,
        mouse_move_enables_dpms = true,
        key_press_enables_dpms = true,
        animate_manual_resizes = false,
        animate_mouse_windowdragging = false,
        enable_swallow = false,
        swallow_regex = "(foot|kitty|alacritty|Alacritty)",
        focus_on_activate = true
    },
    binds = {
        scroll_event_delay = 0,
        hide_special_on_workspace_change = true
    },
    cursor = {
        zoom_factor = 1,
        zoom_rigid = false,
        hotspot_padding = 1
    },
    xwayland = {
        force_zero_scaling = true
    }
})
