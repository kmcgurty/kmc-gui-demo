anotherexample = {}

anotherexample.noArguments = function()
    helper.print("This text doesn't change...")
    GUI.updateStatusText("Printed!", 2.5)
end

anotherexample.arguments = function(one, two, three)
    helper.print(one, two, three)
    GUI.updateStatusText("Printed!", 2.5)
end

anotherexample.init = function()
    GUI.createMenu("submenu2", "main", "Sub Menu 2", g.menuX, g.menuY, g.buttonWidth, g.buttonHeight, g.buttonSpacing, g.fontSize, g.fontName, g.saveLastButtonPos)
    GUI.addButton("submenu2", "No Arguments", anotherexample.noArguments, nil, false, g.fontSize, g.fontName)
    GUI.addButton("submenu2", "Arguments", anotherexample.arguments, {"one", "two", "three"}, false, g.fontSize, g.fontName)
end