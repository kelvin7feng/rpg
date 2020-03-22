Math = {}

--随机
function Math.RoundingInteger(nNumber)
	
	local nTemp = math.floor(nNumber * 10)
	
	nTemp = nTemp % 10
	
	if nTemp >=5 then
		return math.floor(nNumber + 1)
	else 
		return math.floor(nNumber)
	end
end

return Math