local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Fluent " .. Fluent.Version,
    SubTitle = "by dawid",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark", -- "Dark", "Light", "Darker", "Rose", "Aqua", "Amethyst"
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Options = Fluent.Options
