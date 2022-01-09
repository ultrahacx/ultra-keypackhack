Keypad hack is the recreated heist minigame from Casino DLC. Player has to remember the generated pattern and create the same pattern again within the given time limit.

### Usage example:
Following is a client side code:
```
RegisterCommand('starthack', function()
	TriggerEvent('ultra-keypadhack', 6, 40, function(outcome, reason)
		if outcome == 0 then
			print('Hack failed', reason)
		elseif outcome == 1 then
			print('Hack successful')
		elseif outcome == 2 then
			print('Timed out')
		elseif outcome == -1 then
			print('Error occured',reason)
		end
	end)
end)
```