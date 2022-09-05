local drawSprite = DrawSprite

local txd = {
	'mphackinggame',
	'mphackinggamebg',
	'mphackinggamewin',
	'mporderunlock',
	'mporderunlock_decor',
	'mphackinggamewin2'
}

local innerCircles = {
	[1] = {
		{x=0.244, y=0.321},
		{x=0.244, y=0.419},
		{x=0.244, y=0.516},
		{x=0.244, y=0.614},
		{x=0.244, y=0.712},
	},

	[2] = {
		{x=0.304, y=0.321},
		{x=0.304, y=0.419},
		{x=0.304, y=0.516},
		{x=0.304, y=0.614},
		{x=0.304, y=0.712}
	},				
	
	[3] = {
		{x=0.363, y=0.321},
		{x=0.363, y=0.417},
		{x=0.363, y=0.516},
		{x=0.363, y=0.615},
		{x=0.363, y=0.711}
	},

	[4] = {
		{x=0.423, y=0.321},
		{x=0.423, y=0.418},
		{x=0.423, y=0.516},
		{x=0.423, y=0.614},
		{x=0.423, y=0.711}
	},

	[5] = {
		{x=0.483, y=0.321},
		{x=0.483, y=0.418},
		{x=0.483, y=0.515},
		{x=0.483, y=0.614},
		{x=0.483, y=0.712}	
	},

	[6] = {
		{x=0.543, y=0.321},
		{x=0.543, y=0.419},
		{x=0.543, y=0.515},
		{x=0.543, y=0.614},
		{x=0.543, y=0.712}
	}
}


local scramblePos = {
	{x=0.5, y=0.84},
	{x=0.493, y=0.84},
	{x=0.486, y=0.84},
	{x=0.479, y=0.84},
	{x=0.472, y=0.84},
	{x=0.465, y=0.84},
	{x=0.458, y=0.84},
	{x=0.451, y=0.84},
	{x=0.444, y=0.84},
	{x=0.437, y=0.84},
	{x=0.43, y=0.84},
	{x=0.423, y=0.84},
	{x=0.416, y=0.84},
	{x=0.409, y=0.84},
	{x=0.402, y=0.84},
	{x=0.395, y=0.84},
	{x=0.388, y=0.84},
	{x=0.381, y=0.84},
	{x=0.374, y=0.84},
	{x=0.367, y=0.84},
	{x=0.36, y=0.84},
	{x=0.353, y=0.84},
	{x=0.346, y=0.84},
	{x=0.353, y=0.84},
	{x=0.339, y=0.84},
	{x=0.332, y=0.84},
	{x=0.325, y=0.84},
	{x=0.318, y=0.84},
	{x=0.311, y=0.84},
	{x=0.304, y=0.84},
	{x=0.297, y=0.84},
	{x=0.29, y=0.84},
	{x=0.283, y=0.84}
}

local fakeKeyButtons = {
	{x=0.726, y=0.62},
	{x=0.669, y=0.343},
	{x=0.726, y=0.343},
	{x=0.782, y=0.343},
	{x=0.669, y=0.435},
	{x=0.726, y=0.435},
	{x=0.782, y=0.435},
	{x=0.669, y=0.527},
	{x=0.726, y=0.527},
	{x=0.782, y=0.527}
}

local resultCodePos = {
	{x=0.666, y=0.766},
	{x=0.706, y=0.767},
	{x=0.746, y=0.767},
	{x=0.786, y=0.767}
}

local lifePos = {
	{x=0.553, y=0.153},
	{x=0.587, y=0.153},
	{x=0.62, y=0.153},
	{x=0.653, y=0.153},
	{x=0.686, y=0.153},
	{x=0.719, y=0.153}
}


local showDialog = false
local dialogTexName = 'correct_0'

local toggleAnimOverlay = true

local isPlayerInputDisabled = false
local isGameActive = false
local gameWon = false

local availableLife = 0
local timer = 0	-- in seconds
local timeString = {}

local activeStage = 1
local activeColumn = 0
local activeRow = 0
local activeSelection = 0

local selectedDots = {
	correctDots = {},
	incorrectDots = {}
}

local fakepattern = {}
local passcodePattern
local passcodeResult

local callbackFn

function secondsToString(seconds)
	local seconds = tonumber(seconds)
	local hours = string.format("%02.f", math.floor(seconds/3600));
	local mins = string.format("%02.f", math.floor(seconds/60 - (hours*60)));
	local secs = string.format("%02.f", math.floor(seconds - hours*3600 - mins *60));

	local time={}
	mins:gsub(".",function(c) table.insert(time,c) end)
	secs:gsub(".",function(c) table.insert(time,c) end)
	return time
end


function shuffle(t)
	local tbl = {}
	for i = 1, #t do
		Wait(0)
		tbl[i] = t[i]
	end
	for i = #tbl, 2, -1 do
		Wait(0)
		math.randomseed(GetGameTimer()*GetFrameTime())
		local j = math.random(i)
		tbl[i], tbl[j] = tbl[j], tbl[i]
	end
	if table.concat(t) == table.concat(tbl) then
		tbl = shuffle(t)
	end
	return tbl
end


function randNumExclusive(n, a, b)
	local numbers = {}
	for i = a, b do
		Wait(0)
		numbers[i] = i
	end

	for i = 1, #numbers - 1 do
		Wait(0)
		local j = math.random(i, #numbers)
		numbers[i], numbers[j] = numbers[j], numbers[i]
	end
	numbers = shuffle(numbers)
	return {table.unpack(numbers, 1, n)}
end


function generatePattern(n, a, b)
	local numbers = {}

	for i=1,5 do
		numbers[i] = i
	end
	numbers = shuffle(numbers)

	math.randomseed(GetGameTimer()*GetFrameTime()*GetRandomIntInRange(1000, 36415))
	numbers[#numbers+1] = math.random(a, b)
	numbers = shuffle(numbers)

	return {table.unpack(numbers, 1, n)}
end


function generateFakePattern()
	fakepattern = {}
	for i=1,math.random(4,7) do
		table.insert(fakepattern, generatePattern(6, 1, 5))
	end
end


function showTimer()
	if(not timeString[1] or not timeString[2] or not timeString[3] or not timeString[4]) then return end

	drawSprite(
		'mphackinggame', 
		'numbers_'..timeString[1], 
		0.258, 0.152, 0.025, 0.055, 0, 255, 255, 255, 255
	)

	drawSprite(
		'mphackinggame', 
		'numbers_'..timeString[2], 
		0.283, 0.152, 0.025, 0.055, 0, 255, 255, 255, 255
	)

	drawSprite(
		'mphackinggame', 
		'numbers_colon', 
		0.307, 0.154, 0.025, 0.055, 0, 255, 255, 255, 255
	)

	drawSprite(
		'mphackinggame', 
		'numbers_'..timeString[3], 
		0.33, 0.153, 0.025, 0.055, 0, 255, 255, 255, 255
	)

	drawSprite(
		'mphackinggame', 
		'numbers_'..timeString[4], 
		0.355, 0.153, 0.025, 0.055, 0, 255, 255, 255, 255
	)

end


function blinkDialog(result)
	local flash = 3000
	local tex1
	local tex2
	if result == true then
		tex1 = 'correct_1'
		tex2 = 'correct_0'
	else
		tex1 = 'incorrect_1'
		tex2 = 'incorrect_0'
	end

	CreateThread(function()
		for i=1,4 do
			flash = flash - 500
			dialogTexName = tex1
			Wait(500)
			showDialog = true

			flash = flash - 500
			dialogTexName = tex2
			Wait(500)
		end
		showDialog = false
	end)
end


function startGame()

	CreateThread(function()

		for i=1,#txd do
			Wait(0)
			RequestStreamedTextureDict(txd[i], false)
		end

		for i=1,#txd do
			Wait(0)
			while not HasStreamedTextureDictLoaded(txd[i]) do
				Wait(0)
			end
		end 

		-- Generate target
		passcodePattern = generatePattern(6, 1, 5)
		passcodeResult = randNumExclusive(4, 0, 9)
		while passcodePattern == nil and passcodeResult == nil do
			Wait(0)
		end

		SendNUIMessage({type  = 'intro'})
		Wait(3500)

		-- Update timer string
		CreateThread(function()
			while timer > 0 and isGameActive do
				timer = timer - 1
				timeString = secondsToString(timer)
				toggleAnimOverlay = not toggleAnimOverlay
				Wait(1000)
			end
			
			if not gameWon and isGameActive then
				isPlayerInputDisabled = true
				gameWon = false
				blinkDialog(false)
				CreateThread(function()
					Wait(3000)
					callbackFn(2,'ran out of time')
					SendNUIMessage({type  = 'fail'})
					isGameActive = false
				end)
			end
		end)

		-- Update scrable count
		local count = 1
		CreateThread(function()
			waitTimer = (timer*1000)/#scramblePos
			while count <= #scramblePos do
				Wait(waitTimer)
				count = count + 1
			end
		end)

		local showFakePattern = false
		local curFakePattern
		CreateThread(function()
			generateFakePattern()
			local newthread = false
			local draw = true
			isPlayerInputDisabled = true
			
			-- Show fake patterns
			for index,itemTable in pairs(fakepattern) do
				showFakePattern = true
				curFakePattern = {}
				for colnum,rownum in pairs(itemTable) do
					table.insert(curFakePattern, innerCircles[colnum][rownum])
				end
				SendNUIMessage({type  = 'audio', audioType = 'fake'})
				Wait(800)
				showFakePattern = false
				Wait(200)
			end

			-- Show real pattern at the end
			for i=1,2 do
				showFakePattern = true
				curFakePattern = {}
				for colnum,rownum in pairs(passcodePattern) do
					table.insert(curFakePattern, innerCircles[colnum][rownum])
				end
				SendNUIMessage({type  = 'audio', audioType = 'real'})
				Wait(300)
				showFakePattern = false
				Wait(200)
			end

			showFakePattern = false
			activeColumn = 1
			isPlayerInputDisabled = false
		end)

		while isGameActive do
			Wait(0)

			drawSprite(
				'mphackinggamebg', 
				'bg', 
				0.50, 0.50, 1.0, 1.0, 0, 255, 255, 255, 255
			)
			
			-- Animation stuff
			if toggleAnimOverlay then
				drawSprite(
					'mphackinggamewin', 
					'tech_1_3', 
					0.2, 0.40, 0.3, 0.5, 0, 255, 255, 255, 255
				)

				drawSprite(
					'mphackinggamewin2', 
					'tech_2_2', 
					0.18, 0.80, 0.3, 0.3, 0, 255, 255, 255, 255
				)

				drawSprite(
					'mphackinggamewin', 
					'tech_1_1', 
					0.8, 0.50, 0.3, 0.6, 0, 0, 140, 150, 255
				)

			else
				drawSprite(
					'mphackinggamewin', 
					'tech_1_1', 
					0.2, 0.40, 0.3, 0.5, 0, 255, 255, 255, 255
				)

				drawSprite(
					'mphackinggamewin2', 
					'tech_2_0', 
					0.18, 0.80, 0.3, 0.3, 0, 255, 255, 255, 255
				)

				drawSprite(
					'mphackinggamewin', 
					'tech_1_4', 
					0.8, 0.50, 0.3, 0.6, 0, 0, 140, 150, 255
				)
			end

			-- Draw main overlay over background
			drawSprite(
				'mporderunlock', 
				'background_layout', 
				0.50, 0.50, 0.7, 0.85, 0, 255, 255, 255, 255
			)

			-- More animation stuff
			if toggleAnimOverlay then
				drawSprite('mporderunlock_decor',
					'techaration_0', 
					0.50, 0.50, 0.7, 0.85, 0, 255, 255, 255, 255
				)
			else
				drawSprite('mporderunlock_decor',
					'techaration_1', 
					0.50, 0.50, 0.7, 0.85, 0, 255, 255, 255, 255
				)
			end


			-- Life counter
			for i=1, availableLife do
				drawSprite(
					'mphackinggame', 
					'life', 
					lifePos[i].x, lifePos[i].y, 0.035, 0.055, 0, 255, 255, 255, 255
				)
			end
			
			showTimer()

			-- Show fake patterns when toggled before every level start
			if showFakePattern then
				if curFakePattern ~= nil then
					for i,k in pairs(curFakePattern) do
						drawSprite(
							'mporderunlock', 
							'correct_circles', 
							k.x, k.y, 0.06, 0.10, 0, 255, 255, 255, 255
						)
					end
				end
			end


			-- Draw past columns
			for i=1,activeColumn do
				for j=1,#innerCircles[i] do
					drawSprite(
						'mporderunlock', 
						'inner_circles', 
						innerCircles[i][j].x, innerCircles[i][j].y, 0.07, 0.11, 0, 255, 255, 255, 255
					)
				end
			end
			
			-- Draw selected/active column
			if activeColumn > 0 and activeRow > 0 then
				drawSprite(
					'mporderunlock', 
					'selector', 
					innerCircles[activeColumn][activeRow].x, innerCircles[activeColumn][activeRow].y, 0.07, 0.11, 0, 255, 255, 255, 255
				)
			end
			
			-- Scramble reduction logic loop 
			for i=count,#scramblePos do
				drawSprite(
					'mphackinggame', 
					'scrambler_fill_segment', 
					scramblePos[i].x, scramblePos[i].y, 0.005, 0.07, 0, 255, 255, 255, 255
				)
			end

			-- Render passcode for completed levels
			if activeStage-1 > 0 then
				local upperLimit = 1
				if activeStage == 5 then
					upperLimit = 4
				else
					upperLimit = activeStage-1
				end
				for i=1, upperLimit do
					drawSprite(
						'mporderunlock', 
						'keypad_feedback_'..passcodeResult[i], 
						resultCodePos[i].x, resultCodePos[i].y, 0.035, 0.06, 0, 255, 255, 255, 255
					)

					local keypadPos = fakeKeyButtons[(passcodeResult[i]+1)]
					drawSprite(
						'mporderunlock', 
						'keypad_'..passcodeResult[i], 
						keypadPos.x, keypadPos.y, 0.055, 0.09, 0, 255, 255, 255, 255
					)
					
				end 
			end


			-- Render border box for code which needs to be cracked
			if activeStage < 5 then
				drawSprite(
					'mporderunlock', 
					'keypad_feedback_box', 
					resultCodePos[activeStage].x, resultCodePos[activeStage].y, 0.045, 0.07, 0, 255, 255, 255, 255
				)
			end

			-- Draw all correct selections
			for i=1,#selectedDots['correctDots'] do
				local rowNum = selectedDots['correctDots'][i].row
				local colNum = selectedDots['correctDots'][i].col
				local pos = innerCircles[colNum][rowNum]
				drawSprite(
					'mporderunlock', 
					'correct_circles', 
					pos.x, pos.y, 0.06, 0.10, 0, 255, 255, 255, 255
				)
			end

			-- Draw all incorrect selections
			for i=1,#selectedDots['incorrectDots'] do
				local rowNum = selectedDots['incorrectDots'][i].row
				local colNum = selectedDots['incorrectDots'][i].col
				local pos = innerCircles[colNum][rowNum]
				drawSprite(
					'mporderunlock', 
					'incorrect_circles', 
					pos.x, pos.y, 0.02, 0.03, 0, 255, 255, 255, 255
				)
			end

			-- Only show when its toggled by blinkDialog function
			if showDialog then
				drawSprite('mphackinggame', dialogTexName, 0.5, 0.5, 0.35, 0.15, 0.0, 255, 255, 255, 1.0)
			end

			if not isPlayerInputDisabled then	-- Make sure player doesn't input when things are being processed
				
				if IsControlJustPressed(0, 194) then -- Backspace
					gameWon = false
					timer = 0
					
				elseif IsControlJustPressed(0, 172) then -- Arrow up
					if activeRow > 1 then
						SendNUIMessage({type  = 'audio', audioType = 'keypress'})
						activeRow = activeRow - 1
					end

				elseif IsControlJustPressed(0, 173) then -- Arrow down
					if activeRow < 5 then
						SendNUIMessage({type  = 'audio', audioType = 'keypress'})
						activeRow = activeRow + 1
					end

				elseif IsControlJustPressed(0, 191) then -- Enter
					if activeColumn > 0 and activeColumn < 7  and activeRow ~= 0 then
						if passcodePattern[activeColumn] == activeRow then	-- If the selected position is correct then
							local isCircleAlreadyPresent = false
							-- Verify that it hasn't already been selected
							for i=1, #selectedDots['correctDots'] do
								if selectedDots['correctDots'][i].row == activeRow and selectedDots['correctDots'][i].col == activeColumn then
									isCircleAlreadyPresent = true
									break
								end
							end
							if not isCircleAlreadyPresent then
								SendNUIMessage({type  = 'audio', audioType = 'correct'})
								table.insert(selectedDots['correctDots'], {row=activeRow, col=activeColumn})
							end

							-- Logic for processing next stage
							if activeColumn == 6 and activeStage < 4 then
								blinkDialog(true)
								showFakePattern = false
								curFakePattern = {}
								activeColumn = 0
								activeRow = 0

								if activeStage <=4 then
									activeStage = activeStage + 1
									CreateThread(function()

										local newthread = false
										local draw = true
										isPlayerInputDisabled = true
										selectedDots['correctDots'] = {}
										selectedDots['incorrectDots'] = {}

										generateFakePattern()
										
										passcodePattern = generatePattern(6, 1, 5)
										while passcodePattern == nil do
											Wait(0)
										end
										
										while showDialog do
											Wait(500)
										end

										for index,itemTable in pairs(fakepattern) do
											showFakePattern = true
											curFakePattern = {}
											for colnum,rownum in pairs(itemTable) do
												table.insert(curFakePattern, innerCircles[colnum][rownum])
											end
											SendNUIMessage({type  = 'audio', audioType = 'fake'})
											
											Wait(800)
											showFakePattern = false
											Wait(200)
										end

										for i=1,2 do
											showFakePattern = true
											curFakePattern = {}
											for colnum,rownum in pairs(passcodePattern) do
												table.insert(curFakePattern, innerCircles[colnum][rownum])
											end
											SendNUIMessage({type  = 'audio', audioType = 'real'})
											Wait(300)
											showFakePattern = false
											Wait(200)
										end
					
										showFakePattern = false
										activeRow = 0
										activeColumn = 1
										isPlayerInputDisabled = false
										
									end)
								end
							
							elseif activeColumn == 6 and activeStage == 4 then
								activeStage = activeStage + 1
								activeRow = 0
								activeColumn = 0
								isPlayerInputDisabled = true
								gameWon = true
								blinkDialog(true)
								CreateThread(function()
									Wait(3000)
									callbackFn(1,'Hack successful')
									SendNUIMessage({type  = 'success'})
									isGameActive = false
								end)								
							end

							if activeColumn < 6 then
								activeColumn = activeColumn + 1
							end
						else
							
							SendNUIMessage({type  = 'audio', audioType = 'incorrect'})
							local isCircleAlreadyPresent = false
							for i=1, #selectedDots['incorrectDots'] do
								if selectedDots['incorrectDots'][i].row == activeRow and selectedDots['incorrectDots'][i].col == activeColumn then
									isCircleAlreadyPresent = true
									break
								end
							end
							if not isCircleAlreadyPresent then
								table.insert(selectedDots['incorrectDots'], {row=activeRow, col=activeColumn})
							end

							
							if availableLife > 0 then 
								availableLife = availableLife - 1
							end

							if availableLife <= 0 then
								availableLife = 0
								isPlayerInputDisabled = true
								gameWon = false
								blinkDialog(false)
								CreateThread(function()
									Wait(3000)
									callbackFn(0,'Lives ran out')
									SendNUIMessage({type  = 'fail'})
									isGameActive = false
								end)
							end
						end
					end
				end
			end
		end
	end)
end



AddEventHandler("ultra-keypadhack", function(life, time, returnFn)
	if life and time and returnFn then
		callbackFn = returnFn

		if life <= 0 or life > 6 then
			callbackFn(-1,'Invalid lives passed')
			return
		end

		if time < minTime or time > maxTime then
			callbackFn(-1,'Invalid time passed')
			return
		end

		timer = tonumber(time)
		availableLife = tonumber(life)
		timeString = {}

		activeStage = 1
		activeColumn = 0
		activeRow = 0
		activeSelection = 0

		selectedDots['correctDots'] = {}
		selectedDots['incorrectDots'] = {}

		toggleAnimOverlay = true
		isPlayerInputDisabled = false
		gameWon = false

		if not isGameActive then
			isGameActive = true
			startGame()
		else
			isGameActive = false
		end
	else
		callbackFn(-1,'Invalid parameters passed')
	end
end)

