-- Define paths to your icons
local iconPaths = {
    "Interface\\Icons\\Inv_misc_food_55",
    "Interface\\Icons\\Inv_misc_food_55",
};
local iconFrames = {};
FRAME_SIZE=48
OFFSET=-20

function AdvancedMacro_CreateMainFrame()
    local AdvancedMacroFrame = CreateFrame("Frame", "AdvancedMacroFrame", UIParent, "BasicFrameTemplate");
    AdvancedMacroFrame:SetSize(400, 88);
    AdvancedMacroFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 0);
    AdvancedMacroFrame.TitleText:SetText("Advanced Macro Window");
    AdvancedMacroFrame:Hide();
    return AdvancedMacroFrame;
end

function AdvancedMacro_SlashCommands()
    SLASH_ADVANCEDMACRO1 = "/am"
    SLASH_ADVANCEDMACRO2 = "/advancedmacro"
    SlashCmdList["ADVANCEDMACRO"] = function(msg)
        AdvancedMacroFrame:Show()
    end
end

local function IconFrameOnClick(self, button)
    -- TODO
    print("Icon clicked!");
end

function AdvancedMacro_CreateIconFrames(ParentFrame)
    for i, path in ipairs(iconPaths) do
        local frame = CreateFrame("Button", "AdvancedMacroIconFrame" .. i, ParentFrame, "UIPanelButtonTemplate");
        frame:SetSize(FRAME_SIZE, FRAME_SIZE);
        frame:SetPoint("TOPLEFT", ParentFrame, (i-1)*FRAME_SIZE, OFFSET);
        local texture = frame:CreateTexture(nil, "BACKGROUND");
        texture:SetAllPoints();
        texture:SetTexture(path);

        frame:SetScript("OnClick", IconFrameOnClick);

        iconFrames[i] = frame;
    end
end

local function NewButtonOnClick(self, button)
    -- TODO
    print("\"New\" button clicked!");
end

function AdvancedMacro_CreateButtonNew(ParentFrame)
    -- Create the "New" button
    local newButton = CreateFrame("Button", "NewButton", ParentFrame, "UIPanelButtonTemplate");
    newButton:SetSize(400, 20);
    newButton:SetPoint("TOPLEFT", ParentFrame, 0, OFFSET-FRAME_SIZE); -- Adjust position as needed
    newButton:SetText("New");

    newButton:SetScript("OnClick", NewButtonOnClick)
end

local AdvancedMacro = {};

local AdvancedMacroFrame = AdvancedMacro_CreateMainFrame();
AdvancedMacro_SlashCommands();
AdvancedMacro_CreateIconFrames(AdvancedMacroFrame);
AdvancedMacro_CreateButtonNew(AdvancedMacroFrame);



-- Assign your frame to your addon's namespace for future reference
AdvancedMacro.Frame = AdvancedMacroFrame;
