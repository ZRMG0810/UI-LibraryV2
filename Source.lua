--[[  
ZZN Ultimate GUI Library  
Made by Zeian/ZRMG and Nova 😎✨  
Features: Window → Tabs → Toggles, Buttons, Sliders, Drop-downs, Color Picker, Keybinds  
--]]

local Library = {}
Library.Windows = {}

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- Drag function for frames
local function makeDraggable(frame)
    local dragging, dragInput, dragStart, startPos
    local function update(input)
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

-- Utility for smooth tween
local function tweenProperty(object, propertyTable, duration)
    local tween = TweenService:Create(object, TweenInfo.new(duration or 0.2, Enum.EasingStyle.Quad), propertyTable)
    tween:Play()
    return tween
end

-- Create main Window
function Library:CreateWindow(title)
    local Window = {}
    Window.Tabs = {}
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "ZZN_UI_"..title
    screenGui.Parent = game:GetService("CoreGui")
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0.45,0,0.6,0)
    frame.Position = UDim2.new(0.5,0,0.5,0)
    frame.AnchorPoint = Vector2.new(0.5,0.5)
    frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
    frame.BorderSizePixel = 0
    frame.Parent = screenGui
    makeDraggable(frame)
    
    Window.ScreenGui = screenGui
    Window.Frame = frame
    
    -- Create Tabs
    function Window:CreateTab(tabName)
        local Tab = {}
        Tab.Sections = {}
        local yOffset = 10
        
        -- Tab label
        local tabLabel = Instance.new("TextLabel")
        tabLabel.Size = UDim2.new(1,0,0,30)
        tabLabel.Position = UDim2.new(0,0,0,yOffset)
        tabLabel.BackgroundColor3 = Color3.fromRGB(50,50,50)
        tabLabel.Text = tabName
        tabLabel.TextColor3 = Color3.fromRGB(255,255,255)
        tabLabel.TextSize = 18
        tabLabel.Font = Enum.Font.GothamBold
        tabLabel.Parent = frame
        yOffset = yOffset + 35

        -- Toggle
        function Tab:CreateToggle(name, default, callback)
            local toggleFrame = Instance.new("Frame")
            toggleFrame.Size = UDim2.new(1, -10, 0, 30)
            toggleFrame.Position = UDim2.new(0,5,0,yOffset)
            toggleFrame.BackgroundColor3 = Color3.fromRGB(45,45,45)
            toggleFrame.Parent = frame

            local label = Instance.new("TextLabel")
            label.Text = name
            label.Size = UDim2.new(0.7,0,1,0)
            label.BackgroundTransparency = 1
            label.TextColor3 = Color3.fromRGB(255,255,255)
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Font = Enum.Font.Gotham
            label.TextSize = 16
            label.Parent = toggleFrame

            local button = Instance.new("TextButton")
            button.Size = UDim2.new(0.3,0,1,0)
            button.Position = UDim2.new(0.7,0,0,0)
            button.Text = default and "ON" or "OFF"
            button.BackgroundColor3 = default and Color3.fromRGB(0,200,0) or Color3.fromRGB(200,0,0)
            button.TextColor3 = Color3.fromRGB(255,255,255)
            button.Font = Enum.Font.GothamBold
            button.TextSize = 14
            button.Parent = toggleFrame

            local state = default
            button.MouseButton1Click:Connect(function()
                state = not state
                button.Text = state and "ON" or "OFF"
                tweenProperty(button, {BackgroundColor3 = state and Color3.fromRGB(0,200,0) or Color3.fromRGB(200,0,0)},0.15)
                callback(state)
            end)

            yOffset = yOffset + 35
            table.insert(Tab.Sections, toggleFrame)
        end

        -- Button
        function Tab:CreateButton(name, callback)
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, -10, 0, 30)
            btn.Position = UDim2.new(0,5,0,yOffset)
            btn.BackgroundColor3 = Color3.fromRGB(70,70,70)
            btn.Text = name
            btn.TextColor3 = Color3.fromRGB(255,255,255)
            btn.Font = Enum.Font.GothamBold
            btn.TextSize = 16
            btn.Parent = frame
            btn.MouseButton1Click:Connect(callback)

            yOffset = yOffset + 35
            table.insert(Tab.Sections, btn)
        end

        -- Slider
        function Tab:CreateSlider(name, min, max, callback)
            local sliderFrame = Instance.new("Frame")
            sliderFrame.Size = UDim2.new(1, -10, 0, 40)
            sliderFrame.Position = UDim2.new(0,5,0,yOffset)
            sliderFrame.BackgroundColor3 = Color3.fromRGB(50,50,50)
            sliderFrame.Parent = frame

            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1,0,0.4,0)
            label.BackgroundTransparency = 1
            label.TextColor3 = Color3.fromRGB(255,255,255)
            label.Font = Enum.Font.Gotham
            label.TextSize = 16
            label.Text = name .. ": " .. tostring(min)
            label.Parent = sliderFrame

            local bar = Instance.new("Frame")
            bar.Size = UDim2.new(1, -10, 0, 10)
            bar.Position = UDim2.new(0,5,0.5,0)
            bar.BackgroundColor3 = Color3.fromRGB(100,100,100)
            bar.Parent = sliderFrame

            local handle = Instance.new("Frame")
            handle.Size = UDim2.new(0, 15, 1, 0)
            handle.Position = UDim2.new(0,0,0,0)
            handle.BackgroundColor3 = Color3.fromRGB(0,200,200)
            handle.Parent = bar

            local dragging = false
            handle.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                end
            end)
            handle.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local relative = math.clamp(input.Position.X - bar.AbsolutePosition.X, 0, bar.AbsoluteSize.X)
                    handle.Position = UDim2.new(relative/bar.AbsoluteSize.X, 0, 0, 0)
                    local value = math.floor(min + (max - min) * (relative/bar.AbsoluteSize.X))
                    label.Text = name .. ": " .. tostring(value)
                    callback(value)
                end
            end)

            yOffset = yOffset + 45
            table.insert(Tab.Sections, sliderFrame)
        end

        -- Drop-down
        function Tab:CreateDropdown(name, options, callback)
            local dropdownFrame = Instance.new("Frame")
            dropdownFrame.Size = UDim2.new(1, -10, 0, 30)
            dropdownFrame.Position = UDim2.new(0,5,0,yOffset)
            dropdownFrame.BackgroundColor3 = Color3.fromRGB(50,50,50)
            dropdownFrame.Parent = frame

            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(0.7,0,1,0)
            label.BackgroundTransparency = 1
            label.TextColor3 = Color3.fromRGB(255,255,255)
            label.Font = Enum.Font.Gotham
            label.TextSize = 16
            label.Text = name
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = dropdownFrame

            local selected = Instance.new("TextButton")
            selected.Size = UDim2.new(0.3,0,1,0)
            selected.Position = UDim2.new(0.7,0,0,0)
            selected.Text = options[1]
            selected.Font = Enum.Font.GothamBold
            selected.TextSize = 14
            selected.BackgroundColor3 = Color3.fromRGB(70,70,70)
            selected.TextColor3 = Color3.fromRGB(255,255,255)
            selected.Parent = dropdownFrame

            local open = false
            local optionsFrame = Instance.new("Frame")
            optionsFrame.Size = UDim2.new(1,0,0,#options*25)
            optionsFrame.Position = UDim2.new(0,0,1,0)
            optionsFrame.BackgroundColor3 = Color3.fromRGB(40,40,40)
            optionsFrame.Visible = false
            optionsFrame.Parent = dropdownFrame

            for i,opt in ipairs(options) do
                local optBtn = Instance.new("TextButton")
                optBtn.Size = UDim2.new(1,0,0,25)
                optBtn.Position = UDim2.new(0,0,0,(i-1)*25)
                optBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
                optBtn.Text = opt
                optBtn.TextColor3 = Color3.fromRGB(255,255,255)
                optBtn.Font = Enum.Font.Gotham
                optBtn.TextSize = 14
                optBtn.Parent = optionsFrame

                optBtn.MouseButton1Click:Connect(function()
                    selected.Text = opt
                    optionsFrame.Visible = false
                    open = false
                    callback(opt)
                end)
            end

            selected.MouseButton1Click:Connect(function()
                open = not open
                optionsFrame.Visible = open
            end)

            yOffset = yOffset + 35 + (#options*25)
            table.insert(Tab.Sections, dropdownFrame)
        end

        -- Color Picker (simple RGB picker)
        function Tab:CreateColorPicker(name, defaultColor, callback)
            local pickerFrame = Instance.new("Frame")
            pickerFrame.Size = UDim2.new(1, -10, 0, 30)
            pickerFrame.Position = UDim2.new(0,5,0,yOffset)
            pickerFrame.BackgroundColor3 = Color3.fromRGB(50,50,50)
            pickerFrame.Parent = frame

            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(0.6,0,1,0)
            label.BackgroundTransparency = 1
            label.TextColor3 = Color3.fromRGB(255,255,255)
            label.Font = Enum.Font.Gotham
            label.TextSize = 16
            label.Text = name
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = pickerFrame

            local colorBox = Instance.new("TextButton")
            colorBox.Size = UDim2.new(0.4,0,1,0)
            colorBox.Position = UDim2.new(0.6,0,0,0)
            colorBox.BackgroundColor3 = defaultColor
            colorBox.Text = ""
            colorBox.Parent = pickerFrame

            colorBox.MouseButton1Click:Connect(function()
                -- For simplicity, we just random a color here
                local newColor = Color3.fromHSV(math.random(),1,1)
                colorBox.BackgroundColor3 = newColor
                callback(newColor)
            end)

            yOffset = yOffset + 35
            table.insert(Tab.Sections, pickerFrame)
        end

        table.insert(Window.Tabs, Tab)
        return Tab
    end

    table.insert(Library.Windows, Window)
    return Window
end

return Library
