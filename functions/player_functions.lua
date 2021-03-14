player_functions = {}

player_functions.toggleGodMode = function()
    if(GUI.isActiveButtonToggledOn()) then
        --do something
        GUI.updateStatusText("Enabled God mode (not really)", 2.5)
    else
        --do something
        GUI.updateStatusText("Disabled God mode (not really)", 2.5)
    end
end

player_functions.toggleInfAmmo = function()
    if(GUI.isActiveButtonToggledOn()) then
        --do something
        GUI.updateStatusText("Enabled infinite ammo (not really)", 2.5)
    else
        --do something
        GUI.updateStatusText("Disabled infinite ammo (not really)", 2.5)
    end
end

player_functions.togglesomething = function()
    if(GUI.isActiveButtonToggledOn()) then
        player_functions.toggled = true
    else
        player_functions.toggled = false
        helper.print("Toggle turned off!")
    end
end

player_functions.tick = function()
    if(player_functions.toggled) then
        helper.print("Toggle turned on!")
    end
end

player_functions.init = function()
    player_functions.toggled = false

    GUI.createMenu("player_functions", "main", "Player Menu", g.menuX, g.menuY, g.buttonWidth, g.buttonHeight, g.buttonSpacing, g.fontSize, g.fontName, g.saveLastButtonPos)
    GUI.addButton("player_functions", "God mode", player_functions.toggleGodMode, nil, true, g.fontSize, g.fontName)
    GUI.addButton("player_functions", "Inf. Ammo", player_functions.toggleInfAmmo, nil, true, g.fontSize, g.fontName)
    GUI.addButton("player_functions", "Another Toggle", player_functions.togglesomething, nil, true, g.fontSize, g.fontName)
end