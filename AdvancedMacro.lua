local iconFrames = {};
FRAME_SIZE=48
OFFSET=-20
MAIN_FRAME_WIDTH=400
MAIN_FRAME_HEIGHT=88

local function FrameOnMouseDown(self, button)
    self:StartMoving();
end

local function FrameOnMouseUp(self, button)
    self:StopMovingOrSizing();
end

function AdvancedMacro_CreateMainFrame()
    local AdvancedMacroFrame = CreateFrame("Frame", "AdvancedMacroFrame", UIParent, "BasicFrameTemplate");
    AdvancedMacroFrame:SetSize(MAIN_FRAME_WIDTH, MAIN_FRAME_HEIGHT);
    AdvancedMacroFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 0);
    AdvancedMacroFrame.TitleText:SetText("Advanced Macro Window");
    AdvancedMacroFrame:Hide();
    AdvancedMacroFrame:SetMovable(true);
    AdvancedMacroFrame:EnableMouse(true);
    AdvancedMacroFrame:RegisterForDrag("LeftButton");
    AdvancedMacroFrame:SetScript("OnMouseDown", FrameOnMouseDown);
    AdvancedMacroFrame:SetScript("OnMouseUp", FrameOnMouseUp);
    return AdvancedMacroFrame;
end

function AdvancedMacro_SlashCommands()
    SLASH_ADVANCEDMACRO1 = "/am"
    SLASH_ADVANCEDMACRO2 = "/advancedmacro"
    SlashCmdList["ADVANCEDMACRO"] = function(msg)
        if AdvancedMacroFrame:IsVisible() then
            AdvancedMacroFrame:Hide()
        else
            AdvancedMacroFrame:Show()
        end
    end
end

local function SaveButtonOnClick(self, button)
    -- TODO
    print("Save button clicked!");
end

local function AdvancedMacro_CreateMacroFrame(ParentFrame, macro_str, index)
    -- Frame
    local frame = CreateFrame("Frame", "MacroFrame", ParentFrame, "BasicFrameTemplate");
    frame:SetSize(MAIN_FRAME_WIDTH, MAIN_FRAME_HEIGHT*2.5);
    frame:SetPoint("TOPRIGHT", ParentFrame:GetParent(), "TOPRIGHT", MAIN_FRAME_WIDTH, 0);
    frame.TitleText:SetText("Macro setting#" .. (index+1));
    frame:Hide()
    frame:EnableMouse(true);
    -- TODO: Make prettier textbox
    -- Textbox
    local textBox = CreateFrame("EditBox", "MacroTextBox", frame, "LargeInputBoxTemplate");
    textBox:SetMultiLine(true); -- Allow multiline input
    textBox:SetAutoFocus(false); -- Don't automatically focus on the textbox
    textBox:EnableMouse(true); -- Allow mouse interaction with the textbox
    -- textBox:SetScript("OnEscapePressed", function() textBox:ClearFocus(); end); -- Clear focus when escape is pressed

    textBox:SetPoint("TOPLEFT", frame, 0, OFFSET*2)
    textBox:SetPoint("TOPRIGHT", frame, 0, OFFSET*2)

    -- Save button
    local saveButton = CreateFrame("Button", "SaveButton", frame, "UIPanelButtonTemplate");
    saveButton:SetSize(MAIN_FRAME_WIDTH, 20);
    saveButton:SetPoint("BOTTOMLEFT", frame, 0, 0); -- Adjust position as needed
    saveButton:SetText("Save");
    saveButton:SetScript("OnClick", SaveButtonOnClick)

    return frame
end

local function HideMacroFrames()
    for _, item in ipairs(iconFrames) do
        item.macro:Hide()
    end
end

local function IconFrameOnClick(self, button)
    HideMacroFrames();
    for _, item in ipairs(iconFrames) do
        if self == item.icon then
            item.macro:Show();
            break;
        end
    end
end

function AdvancedMacro_CreateIconFrame(ParentFrame, macro_str, texture_path )
    local index = #iconFrames;
    local frame = CreateFrame("Button", "AdvancedMacroIconFrame" .. index, ParentFrame, "UIPanelButtonTemplate");
    frame:SetSize(FRAME_SIZE, FRAME_SIZE);
    frame:SetPoint("TOPLEFT", ParentFrame, index*FRAME_SIZE, OFFSET);
    local texture = frame:CreateTexture(nil, "OVERLAY");
    texture:SetAllPoints();
    texture:SetTexture(texture_path);
    local macroFrame = AdvancedMacro_CreateMacroFrame(frame, macro_str, index);
    frame:SetScript("OnClick", IconFrameOnClick);
    iconFrames[index+1]={}
    iconFrames[index+1].icon = frame;
    iconFrames[index+1].macro = macroFrame;
end

function AdvancedMacro_CreateIconFrames(ParentFrame, iconFramesCache)
    for _,iconFrame in ipairs(iconFramesCache) do
        AdvancedMacro_CreateIconFrame(ParentFrame, iconFrame.macro_str, iconFrame.texture_path )
    end
end

local function NewButtonOnClick(self, button)
    -- TODO
    print("\"New\" button clicked!");
end

function AdvancedMacro_CreateButtonNew(ParentFrame)
    -- Create the "New" button
    local newButton = CreateFrame("Button", "NewButton", ParentFrame, "UIPanelButtonTemplate");
    newButton:SetSize(MAIN_FRAME_WIDTH, 20);
    newButton:SetPoint("BOTTOMLEFT", ParentFrame, 0, 0); -- Adjust position as needed
    newButton:SetText("New");

    newButton:SetScript("OnClick", NewButtonOnClick)
end

-- return: list(table(macro_str, texture_path))
function AdvancedMacro_LoadCache()
    local item1 = {};
    item1.macro_str = "";
    item1.texture_path = "Interface\\Icons\\Inv_misc_food_55";
    local item2 = {};
    item2.macro_str = "";
    item2.texture_path = "Interface\\Icons\\Inv_misc_food_55";
    local result = {item1, item2};
    return result;
end

local AdvancedMacro = {};
local AdvancedMacroFrame = AdvancedMacro_CreateMainFrame();
AdvancedMacro_SlashCommands();
local iconFramesCache = AdvancedMacro_LoadCache();
AdvancedMacro_CreateIconFrames(AdvancedMacroFrame, iconFramesCache);
AdvancedMacro_CreateButtonNew(AdvancedMacroFrame);

-- Assign your frame to your addon's namespace for future reference
AdvancedMacro.Frame = AdvancedMacroFrame;
