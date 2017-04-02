local composer = require("composer")
local widget = require("widget")
require("google-translate")
local scene = composer.newScene()
local vocab = {}
local cx, p, n, vocabTitle, vocabPos, clickSound,txfWord
local titleText, hTextField, wTextField
cx = display.contentCenterX
cy = display.contentCenterY
local backgroundImage = display.newImage("wall.jpg",cx,cy)

 function vocabImage()
	return string.gsub(vocab[p], ".png", "")
end

 function imageTouch(event)
	if (event.phase == "ended") then
 		reqTranslate(vocabImage(), "en")
 	end
end

function loadTextVocab()
	local path = system.pathForFile("res/vocab.txt", system.ResourceDirectory)
	local file = io.open(path, "r")
	if (file) then
		for line in file:lines() do
			vocab[#vocab + 1] = line;
		end
		io.close(file)
		file = nil
		n = #vocab
	else
		print("Error loading file..")
		n = 0
	end
end

function changeImage(event)
	if (event.phase == "ended") then
		if (image) then
			image:removeSelf()
			image = nil
		end
		image = display.newImage(event.response.filename, system.DocumentsDirectory)
		image:translate(cx, 180)
		image:addEventListener("touch", imageTouch)
	end
end

 function updatePos(x)
	p = p + x
	if (p > n) then
		p = 1
	elseif (p < 1) then
		p = n
	end
end

 function checkword()
	if(vocabTitle.text==txfWord.text)then
		reqTranslate("well done", "en")
		txfWord.text=""
		updatePos(1)
		elseif(txfWord.text=="")then
			reqTranslate("Please type your answer", "en")
else
	reqTranslate("false", "en")
end

end

function loadImageVocab()
	local params = {}
	local imageFile = vocab[p]
	local url = "http://www.phuketsmartcity.com/app/vocab/" .. imageFile
	network.download(
		url,
		"GET",
		changeImage,
		params,
		imageFile,
		system.DocumentsDirectory)
	vocabPos.text = p .. "of" .. n
	vocabTitle.text = vocabImage()


end



 function buttonPress(event)
	local button = event.target.id
	if (event.phase == "began") then
		audio.play(clickSound)
		if (button == "next") then
			updatePos(1)
			txfWord.text=""
		elseif (button == "prev") then
			updatePos(-1)
			txfWord.text=""
		elseif (button == "rand") then
			--p = math.random(1, n)
			checkword()
		else
			txfWord.text=vocabTitle.text
		end
		loadImageVocab()
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
			composer.gotoScene("scene2")

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

 randButton = widget.newButton(
	{
		defaultFile = "res/fly.png",
		overFile = "res/fly-over.png",
		id = "rand",
		onEvent = buttonPress
	}
)

 prevButton = widget.newButton(
	{
		defaultFile = "res/prev.png",
		overFile = "res/prev-over.png",
		id = "prev",
		onEvent = buttonPress
	}
)

 nextButton = widget.newButton(
	{
		defaultFile = "res/next.png",
		overFile = "res/next-over.png",
		id = "next",
		onEvent = buttonPress
	}
)

 awsButton = widget.newButton(
	{
		defaultFile = "res/help.png",
		overFile = "res/help-over.png",
		id = "ans",
		onEvent = buttonPress
	}
)

cx = display.contentCenterX
cy = display.contentCenterY
randButton.x = cx
randButton.y = 395
nextButton.x = cx + 100
nextButton.y = 395
prevButton.x = cx - 100
prevButton.y = 395
awsButton.x = cx
awsButton.y = 470

loadTextVocab()
clickSound = audio.loadSound("res/click.mp3")

p = 1 --set position for first round


txfWord = native.newTextField(cx, 20, 200, 40)
txfWord.align = "center"
txfWord.isVisible = true

vocabTitle = display.newText("", cx, 30, "Arial", 50)
vocabTitle:setFillColor(1, 1, 1)
vocabTitle.isVisible = false

vocabPos = display.newText("1 of " .. n, cx, 335, "Arial", 30)

vocabPos:setFillColor(1, 1, 1)

image = display.newImage("res/apple.png")
image:translate(cx, 180)
image:addEventListener("touch", imageTouch)

loadImageVocab()
	elseif (phase == "did") then
		Runtime:addEventListener("touch", screenTouched)
	end
end

function scene:hide(event)
	local sceneGroup = self.view
	local phase = event.phase
	if (phase == "will") then

		randButton.isVisible=false
		prevButton.isVisible=false
		nextButton.isVisible=false
		awsButton.isVisible=false
		txfWord:removeSelf()
		vocabTitle:removeSelf()
		vocabPos:removeSelf()
		image:removeSelf()

		txfWord= nil
		vocabTitle= nil
		vocabPos= nil
		image= nil

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
