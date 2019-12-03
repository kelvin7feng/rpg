doNameSpace("pkgTimer")

-- 0.1s一帧
local SECOND_PER_FRAME = 0.1 
local FRAME_RATE = 1 / SECOND_PER_FRAME 

-- 20s之内的timer
local WHEEL_SIZE_1 = 200 
-- 20分钟
local WHEEL_SIZE_2 = 60 
-- 20小时
local WHEEL_SIZE_3 = 60 
-- 50天
local WHEEL_SIZE_4 = 60

local WHEEL_SIZE_MUL12 = WHEEL_SIZE_1*WHEEL_SIZE_2
local WHEEL_SIZE_MUL123 = WHEEL_SIZE_1*WHEEL_SIZE_2*WHEEL_SIZE_3
local WHEEL_SIZE_MUL1234 = WHEEL_SIZE_1*WHEEL_SIZE_2*WHEEL_SIZE_3*WHEEL_SIZE_4

local TIMER_COUNTER = 1

local INNER_BARRIER = false 

bIsInit = false

local function _create_wheel(scale)
    local wheel = {} 
    for i=1,scale do
        wheel[i-1] = {}
    end
    wheel.index = 0 
    wheel.bound = scale

    return wheel
end

function Init()
    if bIsInit then
        return
    end
    bIsInit = true
    pkgTimer.v_elapse_time = 0
    -- 帧数
    pkgTimer.v_current_frame_idx = 0 

    pkgTimer.v_wheels = {
        _create_wheel(WHEEL_SIZE_1), 
        _create_wheel(WHEEL_SIZE_2), 
        _create_wheel(WHEEL_SIZE_3), 
        _create_wheel(WHEEL_SIZE_4)
    }

    pkgTimer.v_index_slot_map = {}
end

function _internal_add_timer(timer)
    local expires = timer.expires
    local idx = expires - pkgTimer.v_current_frame_idx
    local slot
    if idx <= 0 then
        -- 在下一次update 调用
        local wheel_idx = pkgTimer.v_wheels[1].index 
        if INNER_BARRIER then 
            wheel_idx = (wheel_idx + 1) % WHEEL_SIZE_1
        end
        slot = pkgTimer.v_wheels[1][wheel_idx]

    elseif idx < WHEEL_SIZE_1 then   
        slot = pkgTimer.v_wheels[1][ expires % WHEEL_SIZE_1 ]
    elseif idx < WHEEL_SIZE_MUL12 then
        slot = pkgTimer.v_wheels[2][ (math.floor(expires/WHEEL_SIZE_1)-1) % WHEEL_SIZE_2 ]
    elseif idx < WHEEL_SIZE_MUL123 then
        slot = pkgTimer.v_wheels[3][ (math.floor(expires/WHEEL_SIZE_MUL12)-1) % WHEEL_SIZE_3 ]
    elseif idx < WHEEL_SIZE_MUL1234 then 
        slot = pkgTimer.v_wheels[4][ (math.floor(expires/WHEEL_SIZE_MUL123)-1) % WHEEL_SIZE_4 ]
    else
        LOG_ERROR("too long timer", timer)
        return
    end

    slot[timer.id] = timer
    pkgTimer.v_index_slot_map[timer.id] = slot
end

-- 注释，
-- callback
-- 参数
-- expires 秒， 精确到0.1
-- desc 格式: model:function 比如mark_quest:add_wait_mark_timer
function AddTimer(desc, count, expires, cb, arg1, arg2)
    TIMER_COUNTER = TIMER_COUNTER + 1
    local info = {
        id = TIMER_COUNTER,
        count = count,
        span = expires,
        expires = math.floor((expires+ pkgTimer.v_elapse_time)*FRAME_RATE) + pkgTimer.v_current_frame_idx,
        arg1 = arg1,
        arg2 = arg2,
        callback = cb,
        desc = desc,
    }

    _internal_add_timer(info)

    return TIMER_COUNTER
end

-- 注释，
-- callback
-- 参数
-- expires 秒， 精确到0.1
-- desc 格式: model:function 比如mark_quest:add_wait_mark_timer
function AddOnceTimer(desc, expires, cb, arg1, arg2)
    local dTimerId = nil
    local function callback()
        if cb then
            cb(arg1, arg2)
        end
        remove_timer(dTimerId)
    end
    dTimerId = AddTimer(desc, 1, expires, callback, arg1, arg2)
end

-- 注释，
-- callback
-- 参数
-- expires 秒， 精确到0.1
-- desc 格式: model:function 比如mark_quest:add_wait_mark_timer
function AddRepeatTimer(desc, expires, cb, arg1, arg2)
    AddTimer(desc, -1, expires, cb, arg1, arg2)
end

function DeleteTimer(index)
    return remove_timer(index)
end

function remove_timer(index)
    assert(index, "nil index found")

    local slot = pkgTimer.v_index_slot_map[index]  
    if slot then
        -- remove timer
        slot[index] = nil
        pkgTimer.v_index_slot_map[index] = nil
    else
        return false
    end
end

function cascade_timers(wheel)
    local slot = wheel[wheel.index]
    
    for _, timer in pairs(slot) do
        _internal_add_timer(timer)
    end
    wheel[wheel.index] = {}
    wheel.index = wheel.index + 1
end

function Update(elapse)
    pkgTimer.v_elapse_time = pkgTimer.v_elapse_time + elapse
    while pkgTimer.v_elapse_time > SECOND_PER_FRAME do 
        -- 0.1s一帧
        pkgTimer.v_elapse_time = pkgTimer.v_elapse_time - SECOND_PER_FRAME 

        local wheel = pkgTimer.v_wheels[1]
        local wheel_idx = 1 
        while wheel.index >= wheel.bound do 

            wheel.index = 0 

            wheel_idx = wheel_idx + 1
            wheel = pkgTimer.v_wheels[wheel_idx] 
            cascade_timers(wheel) 
        end
        wheel = pkgTimer.v_wheels[1]

        local slot = wheel[ wheel.index ] 

        for idx, timer in pairs(slot) do

            INNER_BARRIER = true
            local result = timer.callback(timer.arg1, timer.arg2, timer.id)
            INNER_BARRIER = false

            remove_timer(idx)

            if timer.count > 1 or timer.count == -1 then
                timer.expires = math.floor((timer.span + pkgTimer.v_elapse_time)*FRAME_RATE) + pkgTimer.v_current_frame_idx
                _internal_add_timer(timer)
            end

            if timer.count > 1 then
                timer.count = timer.count - 1
            end
        end
        pkgTimer.v_current_frame_idx = pkgTimer.v_current_frame_idx + 1
        wheel.index = wheel.index + 1
    end
end

function clear()
    Init()
end