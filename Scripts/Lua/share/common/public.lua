
--字符串查找最后一个匹配的字符下标
string.findLast = function (haystack, needle)
	
    local i=haystack:match(".*"..needle.."()")
	
    if i==nil then 
		return nil 
	else 
		return i-1 
	end
end

--字符串分解
string.split = function(s, p)
    local rt= {}
    string.gsub(s, '[^'..p..']+', function(w) table.insert(rt, w) end )
    return rt
end

--统计表的数量
table.count = function(tb)
	local nCount = 0
	for _ in pairs(tb) do nCount = nCount + 1 end
	return nCount
end

--获取时间戳
function GetTotalSeconds(nYear, nMonth, nDay, nHour, nMin, nSec)
    local tbParam = {
        year = nYear,
        month = nMonth,
        day = nDay,
        hour = nHour,
        min = nMin,
        sec = nSec,
    }
    if not next(tbParam) then
        return os.time()
    end
    return os.time(tbParam)
end

-- 获取表的元素总数
function CountTab(tb)
    local nCount = 0;

    if tb and IsTable(tb) then
        for _ in pairs(tb) do
            nCount = nCount + 1;
        end
    end

    return nCount;
end

--表复制
function CopyTab(st)
    local tab = {}
    for k, v in pairs(st or {}) do
        if type(v) ~= "table" then
            tab[k] = v
        else
            tab[k] = CopyTab(v)
        end
    end
    return tab
end