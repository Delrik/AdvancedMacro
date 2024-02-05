local AdvancedMacro = {};

local AdvancedMacroFrame = CreateFrame("Frame", "AdvancedMacroFrame", UIParent, "BasicFrameTemplate");
AdvancedMacroFrame:SetSize(300, 200); -- Width and height
AdvancedMacroFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 0); -- Center the frame on the screen
AdvancedMacroFrame.TitleText:SetText("Advanced Macro Window");
AdvancedMacroFrame:Hide()

SLASH_ADVANCEDMACRO1 = "/am"
SLASH_ADVANCEDMACRO2 = "/advancedmacro"
SlashCmdList["ADVANCEDMACRO"] = function(msg)
   AdvancedMacroFrame:Show()
end

-- Assign your frame to your addon's namespace for future reference
AdvancedMacro.Frame = AdvancedMacroFrame;