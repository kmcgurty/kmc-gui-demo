--
--	Please read the API on how to use this API.  	
--

#include "lib/helper.lua"

GUI = {}
GUI.menu = {}
GUI.buttons = {}
GUI.navButtons = {
	menuOpen = 
	{
		keys = {},
		menu = ""
	}, 
	menuClose = { keys = {}},
	navUp = {keys = {}},
	navDown = {keys = {}},
	select = {keys = {}},
	navBack = {keys = {}}
}
GUI.activeButton = 1
GUI.activeMenu = ""
GUI.statusText = {text = "", time = 0}

GUI.titleColor = {r = 255, g = 100, b = 100, a = .9}
GUI.buttonColor = {r = 20, g = 20, b = 20, a = .9}
GUI.activeButtonColor = {r = 111, g = 111, b = 111, a = .9}
GUI.sound = {
	tick_up = LoadSound("media/tick_up.ogg"),
	tick_down = LoadSound("media/tick_down.ogg")
}

--UiColorF(ixed), because who the hell made rgb numbers range from 0-1????
UiColorF = function(r, g, b, a)
	local r1 = 1
	local r2 = 255

	r = helper.scale(r, r1, r2)
	g = helper.scale(g, r1, r2)
	b = helper.scale(b, r1, r2)

	UiColor(r, g, b, a)
end

function GUI.createMenu(menuName, prevMenu, title, xpos, ypos, xscale, yscale, buttonSpacing, textScale, font, saveButtonPos)
	if(GUI.menu[menuName] == nil) then
		GUI.menu[menuName] = {}
		lastOffset = ypos + yscale + buttonSpacing
	end
	
	GUI.menu[menuName] = {
		prevMenu = prevMenu,
		title = title,
		xpos = xpos,
		ypos = ypos,
		xscale = xscale,
		yscale = yscale,
		spacing = buttonSpacing,
		lastOffset = lastOffset,
		numButtons = 0,
		textScale = textScale,
		lastButton = 1,
		saveButtonPos = saveButtonPos,
		font = font
	}
end

function GUI.addButton(parentMenu, text, funct, args, toggleable, textScale, font)
	if(GUI.buttons[parentMenu] == nil or GUI.buttons[parentMenu].settings == nil) then
		GUI.buttons[parentMenu] = {settings = {}}
	end

	local currButtonNum = #GUI.buttons[parentMenu].settings + 1
	GUI.menu[parentMenu].numButtons = currButtonNum

	if(toggleable) then
		toggledOn = false
	else
	    toggledOn = nil
	end

	GUI.buttons[parentMenu].settings[currButtonNum] = {
		parentMenu = parentMenu,
		text = text,
		funct = funct,
		args = args,
		font = font,
		xpos = GUI.menu[parentMenu].xpos,
		ypos = GUI.menu[parentMenu].lastOffset,
		xscale = GUI.menu[parentMenu].xscale,
		yscale = GUI.menu[parentMenu].yscale,
		textScale = textScale,
		toggleable = toggleable,
		toggledOn = toggledOn
	}

	GUI.menu[parentMenu].lastOffset = (GUI.menu[parentMenu].lastOffset + GUI.menu[parentMenu].yscale + GUI.menu[parentMenu].spacing)
end

function GUI.setActiveMenu(menuName)
	GUI.activeMenu = menuName
	if(GUI.menu[GUI.activeMenu] ~= nil) then
		if(GUI.menu[GUI.activeMenu].saveButtonPos or GUI.menu[GUI.activeMenu].saveButtonPos == nil) then
			GUI.activeButton = GUI.menu[GUI.activeMenu].lastButton
		else
		    GUI.activeButton = 1
		end
	end
end

function GUI.updateStatusText(text, time)
	GUI.statusText = {text = text, time = time}
end

function GUI.isActiveButtonToggledOn()
	local activeButton = GUI.buttons[GUI.activeMenu].settings[GUI.activeButton]

	if(activeButton.toggleable) then
		return activeButton.toggledOn
	elseif(activeButton.toggleable == false) then
	    return nil
	end
end

function GUI.isButtonToggledOn(menu, index)
	local activeButton = GUI.buttons[menu].settings[index]
	if(activeButton.toggleable) then
		return activeButton.toggledOn
	elseif(activeButton.toggleable == false) then
	    return nil
	end
end

function GUI.toggleActiveButtonState()
	local activeButton = GUI.buttons[GUI.activeMenu].settings[GUI.activeButton]

	if(GUI.isActiveButtonToggledOn() and activeButton.toggleable) then
		activeButton.toggledOn = false
	elseif(GUI.isActiveButtonToggledOn() == false and activeButton.toggleable) then
		activeButton.toggledOn = true
	end
end

function GUI.toggleButtonState(menu, index)
	local activeButton = GUI.buttons[menu].settings[index]
	
	if(GUI.isButtonToggledOn(menu, index) and activeButton.toggleable) then
		activeButton.toggledOn = false
	elseif(GUI.isButtonToggledOn(menu, index) == false and activeButton.toggleable) then
		activeButton.toggledOn = true
	end
end

function GUI.removeButton(menu, index)
	GUI.menu[menu].lastOffset = (GUI.menu[menu].lastOffset - GUI.menu[menu].yscale - GUI.menu[menu].spacing)
	
	for i = GUI.menu[menu].numButtons, index, -1 do
		GUI.buttons[menu].settings[i].ypos = GUI.buttons[menu].settings[i].ypos - GUI.menu[menu].yscale-- - GUI.menu[parentMenu].spacing
		if i == index + 1 then
			GUI.buttons[menu].settings[i].ypos = GUI.buttons[menu].settings[i].ypos - GUI.menu[menu].spacing
		end
	end

	table.remove(GUI.buttons[menu].settings, index)
	GUI.menu[menu].numButtons = GUI.menu[menu].numButtons - 1
end

function GUI.removeMenu(menu)
	GUI.menu[menu] = nil
end

--this is called every frame from GUI.tick()
function GUI.drawStatusText()
	local currentTime = GetTime()

	if(GUI.nextDrawTime == nil or prevText ~= GUI.statusText.text) then
		GUI.nextDrawTime = currentTime + GUI.statusText.time
	end

	

	if(GUI.nextDrawTime > currentTime) then
		UiPush()
			prevText = GUI.statusText.text

			local fontHeight = 40

			UiFont("bold.ttf", fontHeight)
			UiFontHeight(fontHeight)
			UiColorF(255, 255, 255, 1)
			UiTextShadow(0, 0, 0, 0.5, 2.0)

			local textW, textH = UiGetTextSize(GUI.statusText.text)

			local x = UiWidth()/2 - textW/2
			local y = UiHeight()-200

			UiTranslate(x, y)
			UiText(GUI.statusText.text)
		UiPop()
	else
		--clear the text on screen when time is up
		GUI.statusText = {text = "", time = 0}
		GUI.nextDrawTime = nil
	end
end

function GUI.drawGUI()
	if(GUI.activeMenu ~= "" and GUI.activeMenu ~= nil) then
		local name = GUI.activeMenu

		if(GUI.menu[name] ~= nil) then
			--draw title for one frame
			local xpos = GUI.menu[name].xpos
			local ypos = GUI.menu[name].ypos
			local xscale = GUI.menu[name].xscale
			local yscale = GUI.menu[name].yscale
			
			local text = GUI.menu[name].title
			local textScale = GUI.menu[name].textScale
			local font = GUI.menu[name].font
			
			local colors = GUI.titleColor
			
			UiPush()
				UiColorF(colors.r, colors.g, colors.b, colors.a)
				UiTranslate(xpos, ypos)
				UiRect(xscale, yscale);
			UiPop()


			GUI.addButtonText(text, xpos, ypos, textScale, font)

			--done drawing the title for that frame, now draw the buttons
			if(GUI.buttons[name] ~= nil) then
				for i, v in pairs(GUI.buttons[name].settings) do
					local buttonSettings = GUI.buttons[name].settings[i]
					local xpos = buttonSettings.xpos
					local ypos = buttonSettings.ypos
					local xscale = buttonSettings.xscale
					local yscale = buttonSettings.yscale
					
					local font = buttonSettings.font
					local text = buttonSettings.text
					local textScale = buttonSettings.textScale
					local toggleable = buttonSettings.toggleable
					local colors = GUI.buttonColor

					
					if(i == GUI.activeButton) then
						colors = GUI.activeButtonColor
					end

					UiPush()
						UiColorF(colors.r, colors.g, colors.b, colors.a)
						UiTranslate(xpos, ypos)
						UiRect(xscale, yscale)
					UiPop()


					local statusText = ""
					local color = {}

					if(buttonSettings.toggledOn == true) then
						statusText = " [ON]"
						color = {0, 255, 0, 1}
					elseif(buttonSettings.toggledOn == false) then
						statusText = " [OFF]"
						color = {255, 0, 0, 1}
					end

					local buttonTextSize = GUI.addButtonText(text, xpos, ypos, textScale, font, nil, nil, nil, toggleable, statusText)

					local textW = buttonTextSize[1]
					local textH = buttonTextSize[2]
					local statusTextW = buttonTextSize[3]

					--this part is to center the text to the button we are currently drawing
					UiPush()
						local xOverride = (xpos + GUI.menu[name].xscale/2 - textW/2)+textW - statusTextW/2
						local yOverride = ypos + GUI.menu[name].yscale/2 + textH/4

						GUI.addButtonText(statusText, 0, 0, textScale, font, color, xOverride, yOverride)
					UiPop()
				end
			else
				helper.print("Menu ", name, " has no buttons!")
				GUI.setActiveMenu("")
			end
		else
			helper.print("No menu created with the name: ", GUI.activeMenu)
			GUI.setActiveMenu("")
		end
	end
end

function GUI.addButtonText(text, xpos, ypos, textScale, font, color, xOverride, yOverride, toggleable, statusText)
	--this function is significantly more complicated compared to the original version of this GUI because 
	--of how Teardown handles UI drawing. Trying to center text in a square gets pretty wacky
	--especially when wanting multiple colors in the same line of text
	if(text ~= nil and xpos ~= nil and ypos ~= nil and textScale ~= nil and font ~= nil) then
		local menu = GUI.menu[GUI.activeMenu]

		if(color == nil or next(color) == nil) then
			color = {255, 255, 255, 1} 
		end

		local textW = 0
		local textH = 0
		local statusTextW = 0

		UiPush()
			UiFont(font, textScale)
			UiFontHeight(textScale)

			textW, textH = UiGetTextSize(text)

			if(xOverride == nil or yOverride == nil) then
				xpos = xpos + menu.xscale/2 - textW/2
				ypos = ypos + menu.yscale/2 + textH/4

				if(toggleable) then
					statusTextW = UiGetTextSize(statusText)
					xpos = xpos - statusTextW/2
				end
			else
				xpos = xOverride
				ypos = yOverride
			end

			UiTranslate(xpos, ypos)

			UiColorF(color[1], color[2], color[3], color[4])
			UiText(text)

			
		UiPop()

		return {textW, textH, statusTextW}
	else
		helper.print("text: ", text, ", xpos: ", xpos, ", ypos: ", ypos, ", textScale: ", textScale, ", font: ", font)
	    helper.print("There seems to be a nil value when trying to add text to button (see above)")
	    GUI.setActiveMenu("")
	end
end

function GUI.runButtonFunct(currButton)
	if(type(currButton.funct) == "function" and type(currButton.args) == "table") then
		currButton.funct(currButton.args[1], currButton.args[2], currButton.args[3], currButton.args[4], currButton.args[5], currButton.args[6], currButton.args[7], currButton.args[8], currButton.args[9], currButton.args[10], currButton.args[11], currButton.args[12], currButton.args[13], currButton.args[14], currButton.args[15], currButton.args[16], currButton.args[17], currButton.args[18], currButton.args[19], currButton.args[20])
		return true
	end

	if(type(currButton.funct) == "function" and type(currButton.args) == "string" or type(currButton.args) == "number" or type(currButton.args) == "boolean") then
		currButton.funct(currButton.args)
		return true
	end

	if(currButton.funct ~= nil and currButton.args == nil ) then
		currButton.funct()
		return true
	end

	if(currButton.funct == nil) then
		helper.print("Unable to run the function - function does not exist")
		return false
	end
end

--this needs to be called every frame
function GUI.tick()
	--this is pretty much a work around because using a while loop causes the game to freeze/crash
	--and using main:Wait(0) causes the text to flash instead of constant
	--this is called with the main:Run() loop
	GUI.drawStatusText()
	GUI.drawGUI()
	
	--on menu open key press
	for i, key in pairs(GUI.navButtons.menuOpen.keys) do
		if(InputPressed(key)) then
			
			if(GUI.activeMenu == GUI.navButtons.menuOpen.menu) then
				--if menu that is trying to be drawn is already drawn, go to the previous menu that is set for that menu 
				GUI.setActiveMenu(GUI.menu[GUI.activeMenu].prevMenu)
			else
				--if it isn't already drawn, draw as normal
			    GUI.setActiveMenu(GUI.navButtons.menuOpen.menu)
			    GUI.currentSelection = 1
			end
		end
	end

	if GUI.activeMenu ~= nil  and GUI.activeMenu ~= "" then
		--on menu close key press
		for i, key in pairs(GUI.navButtons.menuClose.keys) do
			if(InputPressed(key)) then
				PlaySound(GUI.sound.tick_down)
				GUI.setActiveMenu("")
			end
		end

		--if the navUp key is pressed, move up (down numerically) in the menu
		for k, key in pairs(GUI.navButtons.navUp.keys) do
			if(InputPressed(key) and GUI.activeMenu ~= "") then
				GUI.activeButton = GUI.activeButton - 1
				GUI.menu[GUI.activeMenu].lastButton = GUI.activeButton
				PlaySound(GUI.sound.tick_down)
				
				--loop selection to the last button if <= 0
				if(GUI.activeButton <= 0) then
					GUI.activeButton = GUI.menu[GUI.activeMenu].numButtons
					GUI.menu[GUI.activeMenu].lastButton = GUI.activeButton
				end
			end
		end

		--if the navDown key is pressed, move down (up numerically) in the menu
		for k, key in pairs(GUI.navButtons.navDown.keys) do
			if(InputPressed(key) and GUI.activeMenu ~= "") then
				GUI.activeButton = GUI.activeButton + 1
				GUI.menu[GUI.activeMenu].lastButton = GUI.activeButton
				PlaySound(GUI.sound.tick_down)

				--loop selection to the first button if > the last button
				if(GUI.activeButton > GUI.menu[GUI.activeMenu].numButtons) then
					GUI.activeButton = 1
					GUI.menu[GUI.activeMenu].lastButton = GUI.activeButton
				end
			end
		end

		--if the select key is pressed, call the function the button was pressed on
		for k, key in pairs(GUI.navButtons.select.keys) do
			if(InputPressed(key) and GUI.activeMenu ~= "") then
				
				local currButton = GUI.buttons[GUI.activeMenu].settings[GUI.activeButton]
				PlaySound(GUI.sound.tick_up)

				if(currButton.toggleable) then
					GUI.toggleActiveButtonState()
				end

				local succeded = GUI.runButtonFunct(currButton)

				if(not succeded) then
					GUI.toggleActiveButtonState()
				end
			end
		end

		--if the navBack key is pressed, draw the prevMenu
		for k, key in pairs(GUI.navButtons.navBack.keys) do
			if(InputPressed(key) and GUI.activeMenu ~= "") then
				GUI.setActiveMenu(GUI.menu[GUI.activeMenu].prevMenu)
				PlaySound(GUI.sound.tick_down)
			end
		end
	end
end