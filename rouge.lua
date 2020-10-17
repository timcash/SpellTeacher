local addonName, NS = ...
local nothingSpellId = 6196

local flameShockId = 188389
local flameShockDebuffId = 188389
local maelstromWeaponBuffId = 344179
local lavaLashId = 60103
local astralShiftId = 108271
local stormStikeId = 17364
local crashLightningId = 187874
local frostShockId = 196840
local lightningBoltId = 188196
local chainLightningId = 188443
local healingSurgeId = 8004

local gcdTime = 0.1

-- ======================
--        SPELLS
-- ======================

local function FlameShock()
    local id = flameShockId
    local debuffId = flameShockDebuffId
    if NS.range("target") <= 40 then
        if NS.debuffRemaining(debuffId, "target") < 2 then 
            if NS.spellReadyIn(id) < gcdTime then 
                return true 
            end
        end
    end
    return false
end

local function LavaLash()
    local id = lavaLashId
    if NS.range("target") <= 5 then
        if NS.spellReadyIn(id) < gcdTime then 
            return true 
        end
    end
    return false
end

local function StormStrike()
    local id = stormStikeId
    if NS.range("target") <= 5 then 
        if NS.spellReadyIn(id) < gcdTime then 
            return true 
        end
    end
    return false
end

local function CrashLightning()
    local id = crashLightningId
    if NS.range("target") <= 5 then
        if NS.spellReadyIn(id) < gcdTime then 
            return true 
        end
    end
    return false
end

local function FrostShock()
    local id = frostShockId
    if NS.range("target") <= 40 then
        if NS.debuffRemaining(flameShockDebuffId, "target") > 5 then
            if NS.spellReadyIn(id) < gcdTime then 
                return true 
            end
        end
    end
    return false
end

local function LightningBolt()
    local id = lightningBoltId
    local rem, stacks = NS.buffRemaining(maelstromWeaponBuffId, "player")
    local cooldown = NS.spellReadyIn(id)
    if NS.range("target") <= 40 then 
        if cooldown < gcdTime then
            if stacks > 8 then 
                if NS.dbGet("player_last_spell_id") ~= id then 
                    return true
                end 
            end
        end
        if cooldown == 0 then
            if stacks > 4 then 
                if NS.dbGet("player_last_spell_id") ~= id then 
                    return true
                end 
            end
        end
    end

    if NS.range("target") > 5 then 
        if NS.getSpeed() == 0 then 
            if NS.debuffRemaining(flameShockDebuffId, "target") > 1 then
                return true
            end
        end
    end
    return false
end

local function HealSelf()
    local id = healingSurgeId
    local rem, stacks = NS.buffRemaining(maelstromWeaponBuffId, "player")
    local cooldown = NS.spellReadyIn(id)
   
    if NS.getHealthPercent("player") < 90 then
        if stacks > 4 then
            if NS.dbGet("player_last_spell_id") == id then
                print("SPELL DOUBLE", healingSurgeId)
                return false
            end 
            if NS.dbGet("player_last_spell_id") ~= id then
                return true
            end 
        end
    end

    return false
end

local function ChainLightning()
    local id = chainLightningId
    local rem, stacks = NS.buffRemaining(maelstromWeaponBuffId, "player")
    if NS.range("target") <= 40 then 
        if NS.spellReadyIn(id) < gcdTime then
            if stacks > 8 then 
                if NS.dbGet("player_last_spell_id") ~= id then 
                    return true
                end 
            end
        end
        if NS.spellReadyIn(id) == 0 then
            if stacks > 4 then 
                if NS.dbGet("player_last_spell_id") ~= id then 
                    return true
                end 
            end
        end
    end
    if NS.range("target") > 5 then 
        if NS.getSpeed() == 0 and NS.debuffRemaining(flameShockDebuffId, "target") > 1 then
            return true
        end
    end
    return false
end

local function AsralShift()
    return 108271
end

-- ======================
--        CALCULATE
-- ======================

local function calc1()
    if HealSelf() then return healingSurgeId end
    if StormStrike() then return stormStikeId end
    if FlameShock() then return flameShockId end
    if LavaLash() then return lavaLashId end
    if CrashLightning() then return crashLightningId end
    if FrostShock() then return frostShockId end
    if LightningBolt() then return lightningBoltId end
    return nothingSpellId
end

local function calc2()
    if StormStrike() then return stormStikeId end
    if CrashLightning() then return crashLightningId end
    if FlameShock() then return flameShockId end
    if ChainLightning() then return chainLightningId end
    if FrostShock() then return frostShockId end
    if LavaLash() then return lavaLashId end
    return nothingSpellId
end

local function calc3()
    return nothingSpellId
end

local function calc4()
    return nothingSpellId
end

-- ======================
--        EXPORT
-- ======================

NS["ROGUE/Subtlety"] = {}
NS["ROGUE/Subtlety"].calc1 = calc1
NS["ROGUE/Subtlety"].calc2 = calc2
NS["ROGUE/Subtlety"].calc3 = calc3
NS["ROGUE/Subtlety"].calc4 = calc4