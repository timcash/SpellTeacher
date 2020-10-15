local nothingSpellId = 344862
local flameShockId = 188389
local flameShockDebuffId = 188389
local lavaLashId = 60103
local astralShiftId = 108271
local stormStikeId = 17364
local crashLightningId = 187874
local frostShockId = 196840

-- ======================
--        SETUP
-- ======================

local UpdateFrame1 = CreateFrame("frame", "UpdateFrame1")
UpdateFrame1:RegisterEvent("UPDATE_MOUSEOVER_UNIT")

UpdateFrame1:SetScript("OnEvent", function(self, event, ...)
    if(event == "UPDATE_MOUSEOVER_UNIT") then
        print("Health", UnitHealth("mouseover"))
	end
end)

local function makeButton(offset, init_icon) 
    
    local last_spell_id = init_icon
    local button = CreateFrame("Button", nil, WorldFrame)
    button:SetPoint("TOPLEFT", WorldFrame, "TOPLEFT", offset, -400)
    button:SetWidth(32)
    button:SetHeight(32)

    local setSpellIcon = function(spell_id)
        if last_spell_id ~= spell_id then
            last_spell_id = spell_id
            local texture = GetSpellTexture(last_spell_id)	
            button:SetNormalTexture(texture)
        end
    end

    setSpellIcon(init_icon)
    return setSpellIcon
end

local size = 32
local setIcon1 = makeButton(0 * size, nothingSpellId)
local setIcon2 = makeButton(1 * size, flameShockId)
local setIcon3 = makeButton(2 * size, crashLightningId)
local setIcon4 = makeButton(3 * size, lavaLashId)

-- ======================
--        HELPERS
-- ======================

local function spellReadyIn(id)
    local start, duration, enabled = GetSpellCooldown(id);
    return (start + duration) - GetTime() 
end

local function range(unit)
    local r5 = IsSpellInRange("Lava Lash", unit)
    if r5 == 1 then return 5 end
    local r40 = IsSpellInRange("Flame Shock", unit)
    if r40 == 1 then return 40 end
    return 100
end

local function debuffRemaining(auraId, unit)
    for i = 1,10,1
    do
        local name, icon, count, debuffType, duration, expirationTime, source, isStealable, nameplateShowPersonal, spellId, canApplyAura, isBossDebuff, castByPlayer, nameplateShowAll, timeMod = UnitAura(unit, i, "PLAYER")
        if(spellId == auraId) then
            return expirationTime - GetTime()
        end
    end
    return 0
end

local function FlameShock()
    local id = flameShockId
    local debuffId = flameShockDebuffId
    if (range("target") <= 40 and debuffRemaining(debuffId, "target") < 2 and spellReadyIn(id) < 0.3) then return true end
    return false
end

local function LavaLash()
    local id = lavaLashId
    if range("target") <= 5 and spellReadyIn(id) < 0.3 then return true end
    return false
end

local function StormStrike()
    local id = stormStikeId
    if range("target") <= 5 and spellReadyIn(id) < 0.3 then return true end
    return false
end

local function CrashLightning()
    local id = crashLightningId
    if range("target") <= 5 and spellReadyIn(id) < 0.3 then return true end
    return false
end

local function AsralShift()
    return 108271
end

-- ======================
--        CALCULATE
-- ======================

local function calcNextIcon1() 
    if FlameShock() then return flameShockId end
    if StormStrike() then return stormStikeId end
    if LavaLash() then return lavaLashId end
    if CrashLightning() then return crashLightningId end
    return astralShiftId
end
local function calcNextIcon2() 
    return astralShiftId
end
local function calcNextIcon3() 
    return astralShiftId
end
local function calcNextIcon4() 
    return astralShiftId
end


--local interval = 0.3
local interval = 1
local total = 0
local speed = 0
local texture_id

UpdateFrame1:SetScript("OnUpdate", function(self, elapsed)
    total = total + elapsed
    if(total > interval) then
        local new_speed, _, _, _ = GetUnitSpeed("player")
        if(speed ~= new_speed) then
            speed = new_speed
        end
        total = 0

        -- SCRIPT AREA -------------------------------------------
        setIcon1(calcNextIcon1())
        setIcon2(calcNextIcon2())
        setIcon3(calcNextIcon3())
        setIcon4(calcNextIcon4())
	end
end)

local spell_id
GameTooltip:HookScript("OnTooltipSetSpell", function(self)
    local name, new_id = self:GetSpell()
    if (spell_id ~= new_id) then
        spell_id = new_id
        print(name, spell_id)
    end
end)

local aura_id
hooksecurefunc(GameTooltip, "SetUnitAura", function(self, ...)
    local name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, spellId = UnitAura(...)
    if (aura_id ~= spellId) then
        aura_id = spellId
        print(name, aura_id)
    end
end)

hooksecurefunc(GameTooltip, "SetUnitBuff", function(self, ...)
    local name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, spellId = UnitBuff(...)
    if (aura_id ~= spellId) then
        aura_id = spellId
        print(name, aura_id)
    end
end)
  
hooksecurefunc(GameTooltip, "SetUnitDebuff", function(self, ...)
    local name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, spellId = UnitDebuff(...)
    if (aura_id ~= spellId) then
        aura_id = spellId
        print(name, aura_id)
    end
end)