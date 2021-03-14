#include "lib/kmc_gui.lua"
#include "lib/helper.lua"

#include "functions/player_functions.lua"
#include "functions/anotherexample.lua"
#include "functions/blankbuttons.lua"

g = {}

function init()
    g.initGUI()

    player_functions.init()
    anotherexample.init()
    blankbuttons.init()
end

function tick()
    player_functions.tick()
end

function update()
end

function draw()
    GUI.tick()
end

g.initGUI = function()
    GUI.navButtons = {
        menuOpen = {
            keys = {"m"},
            menu = "main"
        },
        menuClose = {keys = {}},
        navUp = {keys = {"i", "up"}},
        navDown = {keys = {"k", "down"}},
        select = {keys = {"l", "return", "right"}},
        navBack = {keys = {"j", "left"}}
    }
    
    
    g.menuX = 10
    g.menuY = 10
    g.buttonWidth = 225
    g.buttonHeight = 50
    g.buttonSpacing = 3
    g.fontSize = 23
    g.fontName = "bold.ttf"
    g.saveLastButtonPos = true
    
    GUI.createMenu("main", nil, "Mod Menu", g.menuX, g.menuY, g.buttonWidth, g.buttonHeight, g.buttonSpacing, g.fontSize, g.fontName, g.saveLastButtonPos)
    GUI.addButton("main", "Player Menu >", GUI.setActiveMenu, "player_functions", false, g.fontSize, g.fontName)
    GUI.addButton("main", "Sub Menu 2 >", GUI.setActiveMenu, "submenu2", false, g.fontSize, g.fontName)
    GUI.addButton("main", "Empty Menu >", GUI.setActiveMenu, "emptymenu", false, g.fontSize, g.fontName)
    GUI.addButton("main", "Exit", GUI.setActiveMenu, nil, false, g.fontSize, g.fontName)
end
