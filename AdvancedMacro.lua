-- Define paths to your icons
local iconPaths = {
    "Interface\\Icons\\Ability_Racial_Avatar",
    "Interface\\Icons\\Ability_Racial_BloodRage",
};
local iconFrames = {};

local function IconOnClick(self, button)
    print("Icon clicked!"); -- Example action when the icon is clicked
    -- Add your desired actions here
end

function MyAddon_CreateIconFrames(ParentFrame)
    for i, path in ipairs(iconPaths) do
        FRAME_SIZE=48
        local frame = CreateFrame("Button", "AdvancedMacroIconFrame" .. i, ParentFrame, "UIPanelButtonTemplate");
        frame:SetSize(FRAME_SIZE, FRAME_SIZE);
        frame:SetPoint("TOPLEFT", ParentFrame, (i-1)*FRAME_SIZE, -20);
        local texture = frame:CreateTexture(nil, "BACKGROUND");
        texture:SetAllPoints();
        texture:SetTexture(path);

        frame:SetScript("OnClick", IconOnClick);

        iconFrames[i] = frame;
    end
end


local AdvancedMacro = {};

local AdvancedMacroFrame = CreateFrame("Frame", "AdvancedMacroFrame", UIParent, "BasicFrameTemplate");
AdvancedMacroFrame:SetSize(400, 300);
AdvancedMacroFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 0);
AdvancedMacroFrame.TitleText:SetText("Advanced Macro Window");
AdvancedMacroFrame:Hide()

SLASH_ADVANCEDMACRO1 = "/am"
SLASH_ADVANCEDMACRO2 = "/advancedmacro"
SlashCmdList["ADVANCEDMACRO"] = function(msg)
   AdvancedMacroFrame:Show()
end

MyAddon_CreateIconFrames(AdvancedMacroFrame);


-- Assign your frame to your addon's namespace for future reference
AdvancedMacro.Frame = AdvancedMacroFrame;
