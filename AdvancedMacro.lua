local iconFrames = {};
FRAME_SIZE=48
OFFSET=-20
MAIN_FRAME_WIDTH=400
MAIN_FRAME_HEIGHT=88
DEFAULT_TEXTURE_PATH = "Interface\\Icons\\Inv_misc_food_55";
local AdvancedMacro = {};

local function FrameOnMouseDown(self, button)
    self:StartMoving();
end

local function FrameOnMouseUp(self, button)
    self:StopMovingOrSizing();
end

function OnAddonLoaded(...)
    if IconFramesCache==nil then
        IconFramesCache={};
    end
    if next(iconFrames) == nil then
        AdvancedMacro_CreateIconFrames(AdvancedMacro.Frame, IconFramesCache);
        AdvancedMacro_CreateButtonNew(AdvancedMacro.Frame);
    end
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
    AdvancedMacro.Frame = AdvancedMacroFrame;
    AdvancedMacroFrame:RegisterEvent("ADDON_LOADED");
    AdvancedMacroFrame:SetScript("OnEvent", OnAddonLoaded);
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
    AdvancedMacro_SaveCache();
end

local function RedrawFrames()
    for index, frame in ipairs(iconFrames) do
        frame.icon:SetPoint("TOPLEFT", AdvancedMacro.Frame, (index-1)*FRAME_SIZE, OFFSET);
    end
end

local function DeleteButtonOnClick(self, button)
    for index, value in ipairs(iconFrames) do
        if value.macro == self:GetParent() then
            value.icon:Hide()
            table.remove(iconFrames, index);
            RedrawFrames();
            AdvancedMacro_SaveCache();
            break;
        end
    end
end

local function AdvancedMacro_CreateMacroFrame(ParentFrame, macro_str, index)
    -- Frame
    local frame = CreateFrame("Frame", "AdvancedMacroFrame", ParentFrame, "BasicFrameTemplate");
    frame:SetSize(MAIN_FRAME_WIDTH, MAIN_FRAME_HEIGHT*2.5);
    frame:SetPoint("TOPLEFT", ParentFrame:GetParent(), "TOPRIGHT", 0, 0);
    frame.TitleText:SetText("Advanced macro setting");
    frame:Hide()
    frame:EnableMouse(true);

    iconFrames[index+1].macro = frame;
    -- TODO: Make prettier textbox
    -- Textbox
    local textBox = CreateFrame("EditBox", "AdvancedMacroTextBox", frame, "LargeInputBoxTemplate");
    textBox:SetMultiLine(true); -- Allow multiline input
    textBox:SetAutoFocus(false); -- Don't automatically focus on the textbox
    textBox:EnableMouse(true); -- Allow mouse interaction with the textbox
    textBox:SetPoint("TOPLEFT", frame, 0, OFFSET*2)
    textBox:SetPoint("TOPRIGHT", frame, 0, OFFSET*2)
    textBox:SetText(macro_str);

    iconFrames[index+1].text = textBox;
    -- Save button
    local saveButton = CreateFrame("Button", "SaveButton", frame, "UIPanelButtonTemplate");
    saveButton:SetSize(MAIN_FRAME_WIDTH/2, 20);
    saveButton:SetPoint("BOTTOMLEFT", frame, 0, 0); -- Adjust position as needed
    saveButton:SetText("Save");
    saveButton:SetScript("OnClick", SaveButtonOnClick)

    -- Delete button
    local deleteButton = CreateFrame("Button", "DeleteButton", frame, "UIPanelButtonTemplate");
    deleteButton:SetSize(MAIN_FRAME_WIDTH/2, 20);
    deleteButton:SetPoint("TOPRIGHT", saveButton, "TOPRIGHT", MAIN_FRAME_WIDTH/2, 0); -- Adjust position as needed
    deleteButton:SetText("Delete");
    deleteButton:SetScript("OnClick", DeleteButtonOnClick)

    return frame
end

local function Advancedmacro_HideMacroFrames()
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
    iconFrames[index+1] = {}
    local frame = CreateFrame("Button", "AdvancedMacroIconFrame" .. index, ParentFrame, "UIPanelButtonTemplate");
    frame:SetSize(FRAME_SIZE, FRAME_SIZE);
    frame:SetPoint("TOPLEFT", ParentFrame, index*FRAME_SIZE, OFFSET);
    local texture = frame:CreateTexture(nil, "OVERLAY");
    texture:SetAllPoints();
    texture:SetTexture(texture_path);
    local macroFrame = AdvancedMacro_CreateMacroFrame(frame, macro_str, index);
    frame:SetScript("OnClick", IconFrameOnClick);
    iconFrames[index+1].icon = frame;
end

function AdvancedMacro_CreateIconFrames(ParentFrame, iconFramesCache)
    for _,iconFrame in ipairs(iconFramesCache) do
        AdvancedMacro_CreateIconFrame(ParentFrame, iconFrame.macro_str, iconFrame.texture_path )
    end
end

local function NewButtonOnClick(self, button)
    AdvancedMacro_CreateIconFrame(AdvancedMacro.Frame, "", DEFAULT_TEXTURE_PATH);
    AdvancedMacro_SaveCache();
end

function AdvancedMacro_SaveCache()
    -- list(table(macro_str, texture_path))
    IconFramesCache = {};
    for _, value in ipairs(iconFrames) do
        local index = #IconFramesCache + 1;
        IconFramesCache[index] = {};
        IconFramesCache[index].macro_str = value.text:GetText();
        IconFramesCache[index].texture_path = DEFAULT_TEXTURE_PATH;
    end
end

function AdvancedMacro_CreateButtonNew(ParentFrame)
    -- Create the "New" button
    local newButton = CreateFrame("Button", "NewButton", ParentFrame, "UIPanelButtonTemplate");
    newButton:SetSize(MAIN_FRAME_WIDTH, 20);
    newButton:SetPoint("BOTTOMLEFT", ParentFrame, 0, 0); -- Adjust position as needed
    newButton:SetText("New");

    newButton:SetScript("OnClick", NewButtonOnClick)
end

AdvancedMacro_CreateMainFrame();
AdvancedMacro_SlashCommands();
