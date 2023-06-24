function love.conf (t)
    -- App Settings
    t.window.title = "Depths of the Powder Fields"
    --t.window.icon = "Graphics/Logos/windowIcon.png"
    --t.identity = "JASG"

    -- General Settings
    t.console = false

    -- Video Settings
    --t.window.fullscreen = true
    --t.window.fullscreentype = "desktop"
    t.window.vsync = 0
    --t.window.width = 0
    --t.window.height = 0

    t.window.width = 1280
    t.window.height = 720
    t.window.fullscreen = false

    --t.window.msaa = 0
    --t.window.highdpi = true
    --t.window.usedpiscale = false

    -- Permissions and Libraries
    --t.modules.joystick = false
    --t.modules.video = false
    --t.accelerometerjoystick = false
end