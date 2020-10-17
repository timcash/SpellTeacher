local addonName, NS = ...
local cache = {}
local database = {}

-- ======================
--        HELPERS
-- ======================

local function dbPut(path, data)
    database[path] = data
    return data
end
NS.dbPut = dbPut

local function dbGet(path)
    return database[path]
end
NS.dbGet = dbGet

local function nilToZero(data)
    if data == nil then
        return 0
    end
    return data
end
NS.nilToZero = nilToZero

local function minZero(data)
    if data == nil then
        return 0
    end
    if data < 0 then
        return 0
    end
    return data
end
NS.minZero = minZero

local function clearCache() 
    cache = {}
    return cache
end
NS.clearCache = clearCache

local function cacheGet(path)
    if cache[path] == nil then
        return nil
    end
    local values = cache[path]
    return unpack(values)
end
NS.cacheGet = cacheGet

local function cacheGetSet(path, ...) 
    if cacheGet(path) == nil then
        cache[path] = {...}
        return ...
    end
    return ...
end
NS.cacheGetSet = cacheGetSet

local function getHealthPercent(unit)
    local percent = UnitHealth(unit) / UnitHealthMax(unit)
    return percent * 100
end
NS.getHealthPercent = getHealthPercent

local function getSpec()
    local currentSpec = GetSpecialization()
    local currentSpecName = currentSpec and select(2, GetSpecializationInfo(currentSpec)) or "None"
    return currentSpecName
end
NS.getSpec = getSpec

local function getClass(unit)
    return select(2, UnitClass(unit));
end
NS.getClass = getClass

local function getSpecKey() 
    local spec = getSpec()
    local class = getClass("player")
    local calcKey = class .. "/" .. spec
    return calcKey
end
NS.getSpecKey = getSpecKey

local function spellReadyIn(id)
    local path = "/spellReadyIn/" .. id
    local c = cacheGet(path)
    if c == nil then
        local start, duration, enabled = GetSpellCooldown(id);
        local remaing_time = (start + duration) - GetTime()
        return cacheGetSet(path, minZero(remaing_time), 0)
    end
    return cacheGet(path)
end
NS.spellReadyIn = spellReadyIn

local function range(unit)
    local path = "/range/" .. unit
    local c = cacheGet(path)
    if c == nil then
        local r5 = IsSpellInRange("Lava Lash", unit)
        if r5 == 1 then
            return cacheGetSet(path, 5)
        end
        local r40 = IsSpellInRange("Flame Shock", unit)
        if r40 == 1 then
            return cacheGetSet(path, 40)
        end
        return cacheGetSet(path, 100)
    end
    return cacheGet(path)
end
NS.range = range

local function debuffRemaining(auraId, unit)
    local path = "/debuffRemaining/" .. unit .."/" ..auraId
    local c = cacheGet(path)
    if c == nil then
        for i = 1,10,1
        do
            local name, icon, count, debuffType, duration, expirationTime, source, isStealable, nameplateShowPersonal, spellId, canApplyAura, isBossDebuff, castByPlayer, nameplateShowAll, timeMod = UnitAura(unit, i, "PLAYER")
            if(spellId == auraId) then
                local timeLeft = expirationTime - GetTime()
                return cacheGetSet(path, timeLeft, nilToZero(count))
            end
        end
        return cacheGetSet(path, 0, 0)
    end
    return cacheGet(path)
end
NS.debuffRemaining = debuffRemaining

local function buffRemaining(auraId, unit)
    local path = "/debuffRemaining/" .. unit .."/" ..auraId
    local c = cacheGet(path)
    if c == nil then
    for i = 1,10,1
    do
        local name, icon, count, debuffType, duration, expirationTime, source, isStealable, nameplateShowPersonal, spellId, canApplyAura, isBossDebuff, castByPlayer, nameplateShowAll, timeMod = UnitAura(unit, i)
        if(spellId == auraId) then
            local timeLeft = expirationTime - GetTime()
            -- If we find a match
            return cacheGetSet(path, timeLeft, nilToZero(count))
        end
    end
    -- If we do not find a match
        return cacheGetSet(path, 0, 0) 
    end
    return cacheGet(path)
end
NS.buffRemaining = buffRemaining
    
local function getSpeed()
    local s, _, _, _ = GetUnitSpeed("player")
    return s
end
NS.getSpeed = getSpeed

local function canInterrupt(unit)
    local spell, rank, displayName, icon, startTime, endTime, isTradeSkill, interrupt, someNumber  = UnitCastingInfo(unit)
    -- print(spell, someNumber, interrupt)
    if spell == nil then 
        return false
    end
    return interrupt == false
end
NS.canInterrupt = canInterrupt