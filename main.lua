local addonName, NS = ...
local nothingSpellId = 344862

-- ======================
--        SETUP
-- ======================

local function makeButton(offset, init_icon) 
    
    local last_spell_id = init_icon
    local button = CreateFrame("Button", nil, WorldFrame)
    button:SetPoint("TOPLEFT", WorldFrame, "TOPLEFT", 0, -400 - offset)
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
local setIcon2 = makeButton(1 * size, nothingSpellId)
local setIcon3 = makeButton(2 * size, nothingSpellId)
local setIcon4 = makeButton(3 * size, nothingSpellId)

-- ======================
--       MAIN LOOP
-- ======================

local interval = 0.11
local total = 0

local UpdateFrame1 = CreateFrame("frame", "UpdateFrame1")
UpdateFrame1:SetScript("OnUpdate", function(self, elapsed)
    total = total + elapsed
    if(total > interval) then
        total = 0
        local specKey = NS.getSpecKey()

        -- SCRIPT AREA -------------------------------------------
        
        NS.clearCache()
        setIcon1(NS[specKey].calc1())
        setIcon2(NS[specKey].calc2())
        setIcon3(NS[specKey].calc3())
        setIcon4(NS[specKey].calc4())
	end
end)

local function test_cacheGet()
    cache = {}
    local x1, y1 = cacheGetSet("foo", 100, 0)
    local x2, y2 = cacheGet("foo")
    local x3, y3 = cacheGet("bar")
    local x4, y4 = cacheGetSet("bar", 42)
    local x5, y5 = cacheGet("bar")

    print("TEST1", x1 == x2, y1 == y2)
    print("TEST2", x3 == nil, y3 == nil)
    print("TEST3", x4 == 42, y4 == nil)
    print("TEST4", x5 == 42, y5 == nil)
end

UpdateFrame1:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
UpdateFrame1:RegisterEvent("UNIT_SPELLCAST_SENT")
UpdateFrame1:SetScript("OnEvent", function(self, event, ...)
    if(event == "UPDATE_MOUSEOVER_UNIT") then
        -- print(NS.getSpecKey())
        -- test_cacheGet()
        -- print("Health", UnitHealth("mouseover"))
        -- print("calcKey", NS.getSpecKey())
    end
    if(event == "UNIT_SPELLCAST_SENT") then
        local unit, _,_,spellId = ...
        if unit == "player" then
            NS.dbPut("player_last_spell_id", spellId)
        end
    end
end)

-- ======================
--         HOOKS
-- ======================

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