local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")


local loader = Instance.new("ScreenGui", CoreGui)


local games = {
    {
        name = "No Scope Arcade",
        link = "https://raw.githubusercontent.com/NebulaServicesA/washhy-xyz/refs/heads/main/NoScopeArcade.lua",
    },
    {
        name = "Basketball Legends",
        link = "https://raw.githubusercontent.com/NebulaServicesA/washhy-xyz/refs/heads/main/basketballlegends.lua",
    },
    {
        name = "Arsenal",
        link = "https://raw.githubusercontent.com/NebulaServicesA/washhy-xyz/refs/heads/main/arsenalautodetect",
    },
}


local holderStroke = Instance.new("UIStroke")
holderStroke.Color = Color3.fromRGB(24, 24, 24)
holderStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

do

    local dragging, mouseStart, frameStart
    local main = Instance.new("Frame", loader)
    main.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
    main.BorderSizePixel = 0
    main.Position = UDim2.new(0.4272, 0, 0.3931, 0)
    main.Size = UDim2.new(0.145, 0, 0.267, 0)

    local title = Instance.new("TextLabel", main)
    title.BackgroundColor3 = Color3.fromRGB(13, 13, 13)
    title.BorderSizePixel = 0
    title.Position = UDim2.new(0.0361, 0, 0.02, 0)
    title.Size = UDim2.new(0.9268, 0, 0.1125, 0)
    title.Font = Enum.Font.RobotoMono
    title.Text = "washhy.xyz  ·  gg/FH863nvsWT"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextStrokeTransparency = 0
    title.TextWrapped = true
    title.TextSize = 18
    Instance.new("UICorner", title).CornerRadius = UDim.new(0, 2)

    title.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            mouseStart = UserInputService:GetMouseLocation()
            frameStart = main.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = UserInputService:GetMouseLocation() - mouseStart
            TweenService:Create(main, TweenInfo.new(0.1), {
                Position = UDim2.new(
                    frameStart.X.Scale, frameStart.X.Offset + delta.X,
                    frameStart.Y.Scale, frameStart.Y.Offset + delta.Y
                )
            }):Play()
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if dragging then dragging = false end
    end)


    local uiStroke = Instance.new("UIStroke", main)
    uiStroke.Thickness = 2
    uiStroke.Color = Color3.fromRGB(255, 255, 255)

    local uiGradient = Instance.new("UIGradient", uiStroke)
    uiGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 174, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 85, 255)),
    })


    local holder = Instance.new("Frame", main)
    holder.BackgroundColor3 = Color3.fromRGB(13, 13, 13)
    holder.BorderSizePixel = 0
    holder.Position = UDim2.new(0.0361, 0, 0.1674, 0)
    holder.Size = UDim2.new(0.9268, 0, 0.7819, 0)
    local holderStrokeClone = holderStroke:Clone()
    holderStrokeClone.Parent = holder
    Instance.new("UICorner", holder).CornerRadius = UDim.new(0, 4)


    local scrollingFrame = Instance.new("ScrollingFrame", holder)
    scrollingFrame.Active = true
    scrollingFrame.BackgroundTransparency = 1
    scrollingFrame.BorderSizePixel = 0
    scrollingFrame.Size = UDim2.new(1, 0, 1, 0)
    scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, #games * 35 + 10)
    Instance.new("UIPadding", scrollingFrame).PaddingTop = UDim.new(0, 10)

    local grid = Instance.new("UIGridLayout", scrollingFrame)
    grid.HorizontalAlignment = Enum.HorizontalAlignment.Center
    grid.SortOrder = Enum.SortOrder.LayoutOrder
    grid.CellPadding = UDim2.new(0, 10, 0, 10)
    grid.CellSize = UDim2.new(0, 165, 0, 25)

    for _, gameInfo in ipairs(games) do
        local btn = Instance.new("TextButton", scrollingFrame)
        btn.Text = ("load %s"):format(gameInfo.name)
        btn.BackgroundColor3 = Color3.fromRGB(14, 14, 14)
        btn.BorderSizePixel = 0
        btn.Size = UDim2.new(0, 165, 0, 25)
        btn.Font = Enum.Font.RobotoMono
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextSize = 12
        btn.TextWrapped = true
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
        holderStroke:Clone().Parent = btn

        -- Safe loader + UI destroy
        btn.MouseButton1Click:Connect(function()
            local ok, err = pcall(function()
                local src = game:HttpGet(gameInfo.link, true)
                loadstring(src)()
            end)
            if ok then
                loader:Destroy()
            else
                warn("Error loading " .. gameInfo.name .. ": " .. err)
            end
        end)
    end

    RunService.Heartbeat:Connect(function()
        uiGradient.Rotation = (uiGradient.Rotation + 4) % 360
    end)
end
