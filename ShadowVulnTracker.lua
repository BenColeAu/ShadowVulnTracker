-- 1. Configuration & Persistent Settings
if not SVT_Settings then
    SVT_Settings = { lock = false, x = 0, y = 0, width = 150, height = 150, testMode = false }
end

local ICON_PATH = "Interface\\Icons\\Spell_Shadow_ShadowBolt"
local DEBUFF_DURATION = 10 
local expiration = 0

-- 2. Create the Main Frame
local f = CreateFrame("Frame", "SVT_MainFrame", UIParent)
f:SetWidth(SVT_Settings.width)
f:SetHeight(SVT_Settings.height)
-- Default to center if no coordinates are saved
f:SetPoint("CENTER", UIParent, "CENTER", SVT_Settings.x, SVT_Settings.y)
f:SetMovable(true)
f:SetResizable(true)
f:EnableMouse(true)
f:SetClampedToScreen(true)
f:SetFrameStrata("HIGH")

-- Backdrop for Visibility
f:SetBackdrop({
    bgFile = ICON_PATH,
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = false, tileSize = 0, edgeSize = 16,
    insets = { left = 4, right = 4, top = 4, bottom = 4 }
})

-- Timer Text Display
f.text = f:CreateFontString(nil, "OVERLAY")
f.text:SetFont("Fonts\\FRIZQT__.TTF", 48, "OUTLINE") 
f.text:SetPoint("CENTER", f, "CENTER", 0, 0)
f.text:SetTextColor(1, 1, 1)

f:Hide()

-- 3. Resize Grip
local rb = CreateFrame("Button", "SVT_ResizeGrip", f)
rb:SetWidth(16) rb:SetHeight(16)
rb:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -2, 2)
rb:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
rb:SetHighlightTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")

rb:SetScript("OnMouseDown", function() if not SVT_Settings.lock then f:StartSizing() end end)
rb:SetScript("OnMouseUp", function() 
    f:StopMovingOrSizing()
    SVT_Settings.width = f:GetWidth()
    SVT_Settings.height = f:GetHeight()
end)

-- 4. Positioning Logic
f:RegisterForDrag("LeftButton")
f:SetScript("OnDragStart", function() 
    if not SVT_Settings.lock then f:StartMoving() end 
end)
f:SetScript("OnDragStop", function() 
    f:StopMovingOrSizing()
    local _, _, _, x, y = f:GetPoint()
    SVT_Settings.x, SVT_Settings.y = x, y
end)

-- 5. Minimap Button
local mm = CreateFrame("Button", "SVT_Minimap", Minimap)
mm:SetWidth(32) mm:SetHeight(32)
mm:SetFrameLevel(9)
mm:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")

local mmt = mm:CreateTexture(nil, "BACKGROUND")
mmt:SetWidth(20) mmt:SetHeight(20)
mmt:SetTexture(ICON_PATH)
mmt:SetPoint("CENTER", 0, 0)

local mm_border = mm:CreateTexture(nil, "OVERLAY")
mm_border:SetWidth(54) mm_border:SetHeight(54)
mm_border:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
mm_border:SetPoint("TOPLEFT", 0, 0)
mm:SetPoint("RIGHT", Minimap, "LEFT", 0, 0)

mm:SetScript("OnClick", function()
    if arg1 == "LeftButton" then
        SVT_Settings.testMode = not SVT_Settings.testMode
        if SVT_Settings.testMode then 
            f:Show()
            expiration = GetTime() + DEBUFF_DURATION
            DEFAULT_CHAT_FRAME:AddMessage("|cff9482c9SVT:|r Test Mode: |cff00ff00ON|r")
        else 
            f:Hide()
            DEFAULT_CHAT_FRAME:AddMessage("|cff9482c9SVT:|r Test Mode: |cff0000ffOFF|r")
        end
    else
        SVT_Settings.lock = not SVT_Settings.lock
        if SVT_Settings.lock then rb:Hide() else rb:Show() end
        DEFAULT_CHAT_FRAME:AddMessage("|cff9482c9SVT:|r " .. (SVT_Settings.lock and "LOCKED" or "UNLOCKED"))
    end
end)

-- 6. Core Tracking Logic
local function UpdateDisplay()
    -- Ignore aura scans while in Test Mode
    if SVT_Settings.testMode then return end

    local found = false
    for i = 1, 16 do
        local tex = UnitDebuff("target", i)
        if tex and string.find(tex, "ShadowBolt") then
            -- Reset timer logic
            if not f:IsShown() or (expiration - GetTime() < (DEBUFF_DURATION - 0.5)) then
                expiration = GetTime() + DEBUFF_DURATION
            end
            f:Show()
            found = true
            break
        end
    end
    if not found then f:Hide() end
end

-- 7. Update Loop (Timer & Test Mode Loop)
f:SetScript("OnUpdate", function()
    local timeLeft = expiration - GetTime()
    
    if SVT_Settings.testMode then
        -- If timer runs out in test mode, loop it
        if timeLeft <= 0 then
            expiration = GetTime() + DEBUFF_DURATION
            timeLeft = DEBUFF_DURATION
        end
        f.text:SetText(string.format("%.1f", timeLeft))
    elseif timeLeft > 0 then
        f.text:SetText(string.format("%.1f", timeLeft))
    else
        f:Hide()
    end
end)

-- 8. Event Registration
f:RegisterEvent("PLAYER_TARGET_CHANGED")
f:RegisterEvent("UNIT_AURA")
f:RegisterEvent("VARIABLES_LOADED")

f:SetScript("OnEvent", function()
    if event == "VARIABLES_LOADED" then
        -- Ensure frame uses saved sizes
        f:SetWidth(SVT_Settings.width)
        f:SetHeight(SVT_Settings.height)
        f:ClearAllPoints()
        f:SetPoint("CENTER", UIParent, "CENTER", SVT_Settings.x, SVT_Settings.y)
        if SVT_Settings.lock then rb:Hide() end
        -- Ensure TestMode resets on login to prevent confusion
        SVT_Settings.testMode = false
    else
        UpdateDisplay()
    end
end)

-- Reset Utility Command
SLASH_SVT_RESET1 = "/svtreset"
SlashCmdList["SVT_RESET"] = function()
    SVT_Settings.x = 0
    SVT_Settings.y = 0
    SVT_Settings.width = 150
    SVT_Settings.height = 150
    f:ClearAllPoints()
    f:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
    f:SetWidth(150)
    f:SetHeight(150)
    DEFAULT_CHAT_FRAME:AddMessage("SVT: Position and Size Reset to Center.")
end