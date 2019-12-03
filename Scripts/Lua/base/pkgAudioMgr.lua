doNameSpace("pkgAudioMgr")

local prefabName = "AudioMgr"
local bgMusicPath = "Audio/BGM/BGM_03"
local jumpEffectPath = "Audio/Clip/jump"
local deadEffectPath = "Audio/Clip/dead"

audioMixerGo = audioMixerGo or nil
bgMusicSource = bgMusicSource or nil
jumpMusicSource = jumpMusicSource or nil
deadMusicSource = deadMusicSource or nil

function Init()
    local function onLoadComplete(prefab)
        audioMixerGo = UnityEngine.GameObject.Instantiate(prefab, UnityEngine.Vector3(0,0,0), UnityEngine.Quaternion.identity)
        audioMixerGo.name = prefabName
        pkgGlobalGoMgr.AddToGlobalGo(audioMixerGo)
        
        bgMusicSource = CreateAudioSourceObject("bgMusic", bgMusicPath, true, pkgGameDataMgr.GetMusicVolumn())
        if bgMusicSource then
            bgMusicSource.transform.parent = audioMixerGo.transform
            PlayBgMusic()
        end

        jumpMusicSource = CreateAudioSourceObject("jumpEffect", jumpEffectPath, false, pkgGameDataMgr.GetEffectVolumn())
        if jumpMusicSource then
            jumpMusicSource.transform.parent = audioMixerGo.transform
        end

        deadMusicSource = CreateAudioSourceObject("deadEffectPath", deadEffectPath, false, pkgGameDataMgr.GetEffectVolumn())
        if deadMusicSource then
            deadMusicSource.transform.parent = audioMixerGo.transform
        end
    end

    pkgAssetBundleMgr.LoadAssetBundle(pkgGlobalConfig.AssetBundleName.PREFAB, prefabName, onLoadComplete)
end

function CreateAudioSourceObject(objectName, audioClipPath, bIsLoop, dVolumn)
    if not IsBoolean(bIsLoop) then
        bIsLoop = false
    end
    local auidoSource = UnityEngine.GameObject(objectName)
    auidoSource:AddComponent(UnityEngine.AudioSource)
    local audioClip = UnityEngine.Resources.Load(audioClipPath)
    if audioClip then
        local audioSrcComponent = auidoSource:GetComponent(UnityEngine.AudioSource)
        audioSrcComponent.clip = audioClip
        audioSrcComponent.volume = dVolumn
        audioSrcComponent.loop = bIsLoop
        audioSrcComponent.playOnAwake = false
    else
        print("failed to load audio clip")
    end

    return auidoSource
end

function SetAudioVolume(auidoSource, dVolume)
    if not IsNumber(dVolume) then
        print("the type of dVolume is not number")
        return
    end

    if auidoSource then
        local audioSrcComponent = auidoSource:GetComponent(UnityEngine.AudioSource)
        if audioSrcComponent then
            audioSrcComponent.volume = dVolume
        end
    end
end

function GetAudioVolume(auidoSource)
    local dVolume = pkgGlobalConfig.DefaultVolume
    if auidoSource then
        local audioSrcComponent = auidoSource:GetComponent(UnityEngine.AudioSource)
        if audioSrcComponent then
            dVolume = audioSrcComponent.volume
        end
    end

    return dVolume
end

function PlayAudio(auidoSource, bStopCurrent)
    if auidoSource then
        local audioSrcComponent = auidoSource:GetComponent(UnityEngine.AudioSource)
        if audioSrcComponent then
            if bStopCurrent then
                audioSrcComponent:Stop()
            end
            audioSrcComponent:Play()
        end
    end
end

function PlayBgMusic()
    PlayAudio(bgMusicSource, true)
end

function PlayJumpEffectAudio()
    PlayAudio(jumpMusicSource, true)
end

function PlayDeadEffectAudio()
    PlayAudio(deadMusicSource, true)
end

function SetBgMusicVolumn(dVolumn)
    SetAudioVolume(bgMusicSource, dVolumn)
    pkgGameDataMgr.SetMusicVolumn(dVolumn)
end

function SetJumpEffectVolumn(dVolumn)
    SetAudioVolume(jumpMusicSource, dVolumn)
    SetAudioVolume(deadMusicSource, dVolumn)
    pkgGameDataMgr.SetEffectVolumn(dVolumn)
end