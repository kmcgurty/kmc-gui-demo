blankbuttons = {}

blankbuttons.emptyFunction = function()

end

--this function demonstrates saveLastButtonPos
--when set to false: when you leave the menu and come back, the selection will be set back to the first button
--when set to true: when you leave the menu and come back, the selection will remember what button you left off on
blankbuttons.init = function()
    blankbuttons.saveLastButtonPos = false

    GUI.createMenu("emptymenu", "main", "Empty Menu", g.menuX, g.menuY, g.buttonWidth, g.buttonHeight, g.buttonSpacing, g.fontSize, g.fontName, blankbuttons.saveLastButtonPos)
    GUI.addButton("emptymenu", "Empty", blankbuttons.emptyFunction, "submenu1", false, g.fontSize, g.fontName)
    GUI.addButton("emptymenu", "Empty", blankbuttons.emptyFunction, "submenu2", false, g.fontSize, g.fontName)
    GUI.addButton("emptymenu", "Empty", blankbuttons.emptyFunction, "submenu2", false, g.fontSize, g.fontName)
    GUI.addButton("emptymenu", "Empty", blankbuttons.emptyFunction, "submenu2", false, g.fontSize, g.fontName)
    GUI.addButton("emptymenu", "Empty", blankbuttons.emptyFunction, "submenu2", false, g.fontSize, g.fontName)
    GUI.addButton("emptymenu", "Empty", blankbuttons.emptyFunction, "submenu2", false, g.fontSize, g.fontName)
    GUI.addButton("emptymenu", "Empty", blankbuttons.emptyFunction, "submenu2", false, g.fontSize, g.fontName)
    GUI.addButton("emptymenu", "Empty", blankbuttons.emptyFunction, "submenu2", false, g.fontSize, g.fontName)
    GUI.addButton("emptymenu", "Empty", blankbuttons.emptyFunction, "submenu2", false, g.fontSize, g.fontName)
    GUI.addButton("emptymenu", "Empty", blankbuttons.emptyFunction, "submenu2", false, g.fontSize, g.fontName)
end