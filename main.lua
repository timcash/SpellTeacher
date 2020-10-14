local EventFrame1 = CreateFrame("frame", "EventFrame1")
local EventFrame2 = CreateFrame("frame", "EventFrame2")
local EventFrame3 = CreateFrame("frame", "EventFrame3")
local EventFrame4 = CreateFrame("frame", "EventFrame4")
-- EventFrame:RegisterEvent("UPDATE_MOUSEOVER_UNIT")

-- EventFrame:SetScript("OnEvent", function(self, event, ...)
--     if(event == "UPDATE_MOUSEOVER_UNIT") then
--         print(UnitHealth("mouseover"))
--         print(GetUnitSpeed("player"))
-- 	end
-- end)

local interval_1 = 1
local total_1 = 0
EventFrame1:SetScript("OnUpdate", function(self, elapsed)
    total = total + elapsed
    if(total > interval) then
        local speed, _, _, _ = GetUnitSpeed("player")
        print(speed)
        total = 0
	end
end)



local texture = GetSpellTexture(17364)
print(texture)
local button = CreateFrame("Button", nil, WorldFrame)
button:SetPoint("TOPLEFT", WorldFrame, "TOPLEFT", 0, -500)
button:SetWidth(32)
button:SetHeight(32)

-- button:SetText("test")
-- button:SetNormalFontObject("GameFontNormal")

local ntex = button:CreateTexture()
ntex:SetTexture(texture)
ntex:SetTexCoord(0, 1, 0, 1)
ntex:SetAllPoints()	
button:SetNormalTexture(ntex)

-- local htex = button:CreateTexture()
-- htex:SetTexture("Interface/Buttons/UI-Panel-Button-Highlight")
-- htex:SetTexCoord(0, 0.625, 0, 0.6875)
-- htex:SetAllPoints()
-- button:SetHighlightTexture(htex)

-- local ptex = button:CreateTexture()
-- ptex:SetTexture("Interface/Buttons/UI-Panel-Button-Down")
-- ptex:SetTexCoord(0, 0.625, 0, 0.6875)
-- ptex:SetAllPoints()
-- button:SetPushedTexture(ptex)