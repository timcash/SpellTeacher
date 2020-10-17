local addonName, NS = ...
local nothingSpellId = 344862
local cobraShotId = 193455
local barbedShotId = 217200
local killCommandId = 34026
local multiShotId = 2643
local beastialWrathId = 19574
local petFrenzyBuffId = 272790

-- ======================
--        SPELLS
-- ======================

local function BarbedShot()
    local id = barbedShotId
    local buffId = petFrenzyBuffId
    if NS.range("target") <= 40 then
        if NS.buffRemaining(buffId, "pet") < 2 then
            if NS.spellReadyIn(id) < 0.3 then return true end
        end
    end
    return false
end
-- ======================
--        CALCULATE
-- ======================

local function calc1()
    if BarbedShot() then
        return barbedShotId
    end
    return nothingSpellId
end

local function calc2()
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

NS["HUNTER/Beast Mastery"] = {}
NS["HUNTER/Beast Mastery"].calc1 = calc1
NS["HUNTER/Beast Mastery"].calc2 = calc2
NS["HUNTER/Beast Mastery"].calc3 = calc3
NS["HUNTER/Beast Mastery"].calc4 = calc4