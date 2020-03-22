
-- 合并表
function MergeTab(tFrom, tTo)
	for k,v in pairs(tFrom) do
		tTo[k] = v
	end
end