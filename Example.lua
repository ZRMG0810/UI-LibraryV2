-- Hello there! hope you use my UI Library! 😁
local link = "https://raw.githubusercontent.com/ZRMG0810/UI-LibraryV2/main/Source.lua"
local Library = loadstring(game:HttpGet(link))()

local Window = Library:CreateWindow("Example")
local Tab = Window:CreateTab("Tab")

-- Button
Tab:CreateButton("Button", function()
    print("Button clicked!")
end)

-- Toggle
Tab:CreateToggle("Toggle", false, function(state)
    print("Toggle set to", state)
end)

-- Slider
Tab:CreateSlider("Slider", 1, 100, function(value)
    print("Slider value:", value)
end)

-- Dropdown
Tab:CreateDropdown("Dropdown", {"Option 1","Option 2","Option 3"}, function(selection)
    print("Selected:", selection)
end)

-- Color Picker
Tab:CreateColorPicker("Pick Color", Color3.fromRGB(255,0,0), function(color)
    print("Picked color:", color)
end)

-- Function to delete UI
function DeleteUI()
    for _,win in pairs(Library.Windows) do
        win.ScreenGui:Destroy()
    end
    Library.Windows = {}
end

-- 🔥 Fire it right now (Opitional)
DeleteUI()
