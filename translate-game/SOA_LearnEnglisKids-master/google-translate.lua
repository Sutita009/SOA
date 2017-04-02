function reqTranslateListener(event)
	if (event.phase == "ended") then
		audio.play(audio.loadSound(event.response.filename,system.DocumentsDirectory))
	end
end

function reqTranslate(text, lang)
	network.download(
		"https://translate.google.com/translate_tts?ie=UTF-&&q="..text.."&tl="..lang.."&client=tw-ob",
		"GET",
		reqTranslateListener,
		{},
		math.random(15000)..".mp3",
		system.DocumentsDirectory	
	)
end

function buttonEvent(event)
	if (event.phase == "ended") then
		if not (txfText.text == "") then
			reqTranslate(txfText.text, "en")
		end
	end
end