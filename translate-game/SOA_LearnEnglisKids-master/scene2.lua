local composer = require("composer")
local widget = require("widget")
local scene = composer.newScene()
local titleText, hTextField, wTextField, bmiText
local myLogo, myRect, t1,t2
local text1, text2, text3, text4, button1, button2, button3
local JSON = require("json")
local cx, cy, txtTranslate, txfWord, button, guideText
local translate
local to = ""
local from = ""
local ThEn,Enth
local  backgroundImage = display.newImage("wall.jpg",cx,cy)
local function JSONFile2Table(filename)
    local path, file, contents
    path = system.pathForFile(filename, system.DocumentsDirectory)
    file = io.open(path, "r")
    if (file) then
        contents = file:read("*a")
        io.close(file)
        return contents
    end
    return nil
end

local function loadJSONListener(event)
    if (event.isError) then
        print("Download failed...")
    elseif (event.phase == "ended") then
        print("Saved " .. event.response.filename)
        translate = JSON.decode(JSONFile2Table("translate.json"))
        txtTranslate.text = translate["text"][1]
    end
end

local function doTranslate(word)
    network.download(
        "https://translate.yandex.net/api/v1.5/tr.json/translate?key=trnsl.1.1.20160927T025338Z.68dd354dfe623f89.15aa3c6fd8f24a9360a250e3d898bc5ccbfe2951&text=" .. word .. "&lang="..to,
        "GET",
        loadJSONListener,
        {},
        "translate.json",
        system.DocumentsDirectory
    )
end

local function buttonEvent(event)
    if (event.phase == "ended") then
        doTranslate(txfWord.text)
    end
end

local function buttonBackEvent(event)
    if (event.phase == "ended") then
        txtTranslate.isVisible =false

        ThEn.isVisible =true
        EnTh.isVisible =true
        
        imgLogo.isVisible = true
        backbutton.isVisible = false
        button.isVisible = false
        txfWord.isVisible = false

    end
end

local function tran()

ThEn.isVisible =false
EnTh.isVisible =false

imgLogo.isVisible = false
button.isVisible = true
txfWord.isVisible = true
backbutton.isVisible = true
txtTranslate.isVisible =true
txfWord.text = ""
txtTranslate.text = ""
end

local function clickStartButtonTh(event)

    if (event.phase == "ended") then
        to = "th-en"
        tran()
        end
end

local function clickStartButtonEn(event)

    if (event.phase == "ended") then
    to = "en-th"
        tran()
        end
end



local function screenTouched(event)
	local phase = event.phase
	local xStart = event.xStart
	local xEnd = event.x
	local swipeLength = math.abs(xEnd - xStart)
	if (phase == "began") then
		return true
	elseif (phase == "ended" or phase == "cancelled") then
		if (xStart > xEnd and swipeLength > 50) then
			composer.gotoScene("scene1")
		elseif (xStart < xEnd and swipeLength > 50) then
			composer.gotoScene("scene1")
		end
	end
end


function scene:create(event)
	local sceneGroup = self.view
end



function scene:show(event)
	local sceneGroup = self.view
	local phase = event.phase
	local cx, cy
	cx = display.contentCenterX
	cy = display.contentCenterY
	if (phase == "will") then

	imgLogo = display.newImage("logo.png",cx,130)
	

	txtTranslate = display.newText("", cx, 200,"Arial", 30)
	txtTranslate:setFillColor(2)
	txtTranslate.isVisible = true

	txfWord = native.newTextField(cx, 270, 200, 50)
	txfWord.align = "center"


	txtTranslate = display.newText("Input your word", cx, 130,"Tahoma", 30)
	txtTranslate:setFillColor(1,1,1)
	
	txtTranslate1 = display.newText("Input your word", cx, 130,"Tahoma", 30)
	txtTranslate1:setFillColor(1,1,1)
	


	ThEn = widget.newButton( {
			left = display.contentCenterX - (280 / 2),
			top = 280,
			width = 280,
       		cornerRadius = 15,
			shape = "roundedRect",
			label = "Thai - English",fontSize = 25,
			id = "ThEn",
			labelColor = {default={0, 0, 0, 1}, over={0, 0, 0,1 } },
			fillColor = { default={1, 1, 0.3, 1}, over={ 1, 1, 0.3, 1} },
			onEvent = clickStartButtonTh


		}
	)
	EnTh = widget.newButton( {
			left = display.contentCenterX - (280 / 2),
			top = 340,
			width = 280,
       		cornerRadius = 15,
			shape = "roundedRect",
			label = "English - Thai",fontSize = 25,
			id = "EnTh",
			labelColor = {default={0, 0, 0, 1}, over={0, 0, 0, 1} },
			fillColor = { default={1, 1, 0.3, 1}, over={ 1, 1, 0.3, 1} },
			onEvent = clickStartButtonEn

		}
	)
	

		button = widget.newButton(
		    {
		        x = cx, y = 370,
		        onEvent = buttonEvent,
		        defaultFile = "check.png",
		    }
		)

		backbutton = widget.newButton(
		    {
		        x = cx-130, y = cy-240,
		        onEvent = buttonBackEvent,
		        defaultFile = "back.png",
		    }
		)



	--sceneGroup:insert(txtTranslate)
	--sceneGroup:insert(txfWord1)
txtTranslate.isVisible =false
  txfWord.isVisible = false
  button.isVisible = false
	elseif (phase == "did") then

		Runtime:addEventListener("touch", screenTouched)
	end
end

function scene:hide(event)
	local sceneGroup = self.view
	local phase = event.phase
	if (phase == "will") then


	txtTranslate:removeSelf()
	txfWord:removeSelf()
	button:removeSelf()
	ThEn:removeSelf()
	EnTh:removeSelf()
	txtTranslate:removeSelf()
	txtTranslate1 :removeSelf()
	imgLogo:removeSelf()
	backbutton:removeSelf()

	txtTranslate = nil
	txfWord= nil
	button= nil
	ThEn= nil
	EnTh= nil
	txtTranslate=nil
	txtTranslate1=nil	
	imgLogo= nil
	backbutton= nil

		Runtime:removeEventListener("touch", screenTouched)
	elseif (phase == "did") then
	end
end

function scene:destroy(event)
	local sceneGroup = self.view
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene
