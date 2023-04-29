

local count = 0
term.clear()
local function iterator()
	return coroutine.wrap( function()
		for line in string.gmatch( filmText, "([^\n]*)\n") do
			count = count+1
			coroutine.yield(line)
			term.setCursorPos(1,1)
			term.write("Line: "..count)
		end
		return false
	end )
end

monitor.clear()
local it = iterator()

local bFinished = false
while not bFinished do
	-- Read the frame header
	local holdLine = it()
	if not holdLine then
		bFinished = true
		break
	end

	-- Get this every frame incase the monitor resizes	
	local w,h = monitor.getSize()
	local startX = math.floor( (w - 65) / 2 )
	local startY = math.floor( (h - 14) / 2 )

	-- Print the frame
	monitor.clear()
	for n=1,13 do
		local line = it()
		if line then
			monitor.setCursorPos(startX, startY + n)
			monitor.write( line )
		else
			bFinished = true
			break
		end
	end

	-- Hold the frame
	local hold = tonumber(holdLine) or 1
	local delay = (hold * 0.05) - 0.01
	sleep( delay )
end