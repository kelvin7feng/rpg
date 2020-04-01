local random = math.random

-- 随机库
-- eg:tbCfgLib = {"prob1" = 10,"prob2" = 10,"prob3" = 10,"prob4" = 10}, strProb = "prob"
-- return: number, index
function randomKey(tbCfgLib, strProb)
    
    if not strProb then
        strProb = "prob"
    end

    local dKey = nil
    local dTotalProb = 0
    if not tbCfgLib then
        print(" tbCfgLib -------------------------------------- is nil")
        return dKey
    end

    local dKeyCount = 1
    while true do
        if not tbCfgLib[strProb..dKeyCount] then
            break
        end
        dTotalProb = dTotalProb + (tbCfgLib[strProb..dKeyCount] or 0)
        dKeyCount = dKeyCount + 1
    end
  
    if dTotalProb <= 0 then
        print("randomKey warning -------------------------------------- dTotalProb is nil")
        return dKey
    end
  
    local dCurrntProb = 0
    local dRandomProb = math.random(1,dTotalProb)
    for i=1, dKeyCount do
        local dTempProb = tbCfgLib[strProb..i]
        if dRandomProb > dCurrntProb and dRandomProb <= dCurrntProb + dTempProb then
            dKey = i
            break
        end
  
        dCurrntProb = dCurrntProb + dTempProb
    end
  
    if dKey == nil then
        print("can not random one equip")
    end
    assert(dKey)
    return dKey
end

function uuid()
    local template ='xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
    return string.gsub(template, '[xy]', function (c)
        local v = (c == 'x') and random(0, 0xf) or random(8, 0xb)
        return string.format('%x', v)
    end)
end