doNameSpace("pkgMathTool")

function RandomFloat(dMin, dMax)
    if dMin > dMax then
        local dTemp = dMin
        dMin = dMax
        dMax = dMin
    end
    return dMin + math.random() * (dMax - dMin)
end