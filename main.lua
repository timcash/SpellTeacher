local UpdateFrame1 = CreateFrame("frame", "UpdateFrame1")
UpdateFrame1:RegisterEvent("UPDATE_MOUSEOVER_UNIT")

UpdateFrame1:SetScript("OnEvent", function(self, event, ...)
    if(event == "UPDATE_MOUSEOVER_UNIT") then
        print("Health", UnitHealth("mouseover"))
	end
end)

local function makeButton(offset, init_icon) 
    
    local button = CreateFrame("Button", nil, WorldFrame)
    button:SetPoint("TOPLEFT", WorldFrame, "TOPLEFT", offset, -500)
    button:SetWidth(32)
    button:SetHeight(32)

    local setSpellIcon = function(spell_id)
        local texture = GetSpellTexture(spell_id)	
        button:SetNormalTexture(texture)
    end

    setSpellIcon(init_icon)
    return setSpellIcon
end

local size = 32
local setIcon1 = makeButton(0 * size, 17364)
local setIcon2 = makeButton(1 * size, 17364)
local setIcon3 = makeButton(2 * size, 17364)
local setIcon4 = makeButton(3 * size, 17364)

local nothingSpell = 344862
local flameShockId = 188389
local lavaLashId = 60103

local function flameShock()
    local name = GetSpellInfo(flameShockId)
    local rangeCheck = IsSpellInRange(name, "target")
    local start, duration, enabled = GetSpellCooldown(flameShockId);

    if (start == 0 and duration == 0 and rangeCheck == 1) then
         return flameShockId
    end

    return 0
end

local function lavaLash()
    local name = GetSpellInfo(lavaLashId)
    local rangeCheck = IsSpellInRange(name, "target")
    local start, duration, enabled = GetSpellCooldown(lavaLashId);

    if (start == 0 and duration == 0 and rangeCheck == 1) then
         return lavaLashId
    end

    return 0
end

local function StormStrike()
    return 17364
end

local function AsralShift()
    return 108271
end

local function calcNext() 
    if (lavaLash() ~= 0) then return lavaLashId end
    if (flameShock() ~= 0) then return flameShockId end
    return nothingSpell
end


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
        local new_texture_id = calcNext()
        print("new_texture_id", new_texture_id)
        if(texture_id ~= new_texture_id) then
            texture_id = new_texture_id 
            setIcon1(texture_id)
        end
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






-- local htex = iconframe:CreateTexture()
-- htex:SetTexture("Interface/Buttons/UI-Panel-Button-Highlight")
-- htex:SetTexCoord(0, 0.625, 0, 0.6875)
-- htex:SetAllPoints()
-- button:SetHighlightTexture(htex)

-- local ptex = button:CreateTexture()
-- ptex:SetTexture("Interface/Buttons/UI-Panel-Button-Down")
-- ptex:SetTexCoord(0, 0.625, 0, 0.6875)
-- ptex:SetAllPoints()
-- button:SetPushedTexture(ptex)