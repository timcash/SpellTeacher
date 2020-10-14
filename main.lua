local nothingSpellId = 344862
local flameShockId = 188389
local lavaLashId = 60103
local astralShiftId = 108271

local UpdateFrame1 = CreateFrame("frame", "UpdateFrame1")
UpdateFrame1:RegisterEvent("UPDATE_MOUSEOVER_UNIT")

UpdateFrame1:SetScript("OnEvent", function(self, event, ...)
    if(event == "UPDATE_MOUSEOVER_UNIT") then
        print("Health", UnitHealth("mouseover"))
	end
end)

local function makeButton(offset, init_icon) 
    
    local last_spell_id = nothingSpellId
    local button = CreateFrame("Button", nil, WorldFrame)
    button:SetPoint("TOPLEFT", WorldFrame, "TOPLEFT", offset, -500)
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
local setIcon1 = makeButton(0 * size, 17364)
local setIcon2 = makeButton(1 * size, 17364)
local setIcon3 = makeButton(2 * size, 17364)
local setIcon4 = makeButton(3 * size, 17364)


local function flameShock(id)
    local name = GetSpellInfo(id)
    local rangeCheck = IsSpellInRange(name, "target")
    local start, duration, enabled = GetSpellCooldown(id);
    local finished = start + duration - GetTime()
    if (start == 0 and duration == 0 and rangeCheck == 1) then
        return true
    end
    
    return false
end

local function lavaLash(id)
    local name = GetSpellInfo(id)
    local rangeCheck = IsSpellInRange(name, "target")
    local start, duration, enabled = GetSpellCooldown(id);
    local finished = start + duration - GetTime()
    if (finished < 0.5 and rangeCheck == 1) then
         return true
    end

    return false
end

local function StormStrike()
    return 17364
end

local function AsralShift()
    return 108271
end

local function calcNextIcon1() 
    if lavaLash(lavaLashId) then return lavaLashId end
    if flameShock(flameShockId) then return flameShockId end
    return astralShiftId
end
local function calcNextIcon2() 
    if lavaLash(lavaLashId) then return lavaLashId end
    if flameShock(flameShockId) then return flameShockId end
    return astralShiftId
end
local function calcNextIcon3() 
    if lavaLash(lavaLashId) then return lavaLashId end
    if flameShock(flameShockId) then return flameShockId end
    return astralShiftId
end
local function calcNextIcon4() 
    if lavaLash(lavaLashId) then return lavaLashId end
    if flameShock(flameShockId) then return flameShockId end
    return astralShiftId
end


local interval = 0.3
-- local interval = 1
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
        -- setIcon2(calcNextIcon2())
        -- setIcon3(calcNextIcon3())
        -- setIcon4(calcNextIcon4())
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