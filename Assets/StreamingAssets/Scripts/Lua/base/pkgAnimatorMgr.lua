doNameSpace("pkgAnimatorMgr")

function SetFloat(animator, strField, dVal)
    if not animator then
        return false
    end

    if not IsString(strField) then
        return false
    end

    if IsNil(dVal) then
        return false
    end
    
    animator:SetFloat(strField, dVal)
    return true
end

function SetInteger(animator, strField, dVal)
    if not animator then
        return false
    end

    if not IsString(strField) then
        return false
    end

    if IsNil(dVal) then
        return false
    end
    
    animator:SetInteger(strField, dVal)
    return true
end

function SetBool(animator, strField, bVal)
    if not animator then
        return false
    end

    if not IsString(strField) then
        return false
    end

    if IsNil(bVal) then
        return false
    end

    animator:SetBool(strField, bVal)
    return true
end

function SetTrigger(animator, strField)
    if not animator then
        return false
    end

    if not IsString(strField) then
        return false
    end

    animator:SetTrigger(strField)
    return true
end
