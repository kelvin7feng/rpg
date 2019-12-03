doNameSpace("pkgApplicationTool")

function IsOnMobile()
    if UnityEngine.Application.platform == UnityEngine.RuntimePlatform.Android
        or UnityEngine.Application.platform == UnityEngine.RuntimePlatform.IPhonePlayer 
        or UnityEngine.Application.platform == UnityEngine.RuntimePlatform.WP8Player 
        or UnityEngine.Application.platform == UnityEngine.RuntimePlatform.BlackBerryPlayer 
        or UnityEngine.Application.platform == UnityEngine.RuntimePlatform.TizenPlayer then            
		return true
    end
    
    return false
end

function IsEditor()
    if UnityEngine.Application.platform == UnityEngine.RuntimePlatform.WindowsEditor
        or UnityEngine.Application.platform == UnityEngine.RuntimePlatform.OSXEditor then
        return true
    end
    return false
end

function IsIPhone()
    if UnityEngine.Application.platform == UnityEngine.RuntimePlatform.IPhonePlayer then
        return true
    end
    return false
end

function IsAndroid()
    if UnityEngine.Application.platform == UnityEngine.RuntimePlatform.Android then
        return true
    end
    return false
end