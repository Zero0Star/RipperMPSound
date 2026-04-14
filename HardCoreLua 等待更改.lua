if workspace:FindFirstChild("HardcoreOne") then
    return
end
local marker = Instance.new("BoolValue")
marker.Name = "HardcoreOne"
marker.Value = true
marker.Parent = workspace
local function GitAud(soundgit, filename)
    local url = soundgit
    local FileName = filename
    writefile(FileName .. ".mp3", game:HttpGet(url))
    return (getcustomasset or getsynasset)(FileName .. ".mp3")
end
local function CustomGitSound(soundlink, vol, filename)
    local sound = Instance.new("Sound")
    sound.SoundId = GitAud(soundlink, filename)
    sound.Parent = workspace
    sound.Name = filename or "Music"
    sound.Volume = vol
    sound:Play()
    return sound
end

local spawner = loadstring(game:HttpGet("https://raw.githubusercontent.com/RegularVynixu/Utilities/main/Doors/Entity%20Spawner/V2/Source.lua"))()

local entityBehaviors = {}

function entityBehaviors.runZ367()
     local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local gui = player:WaitForChild("PlayerGui")

local gameData = {
    gameActive = false,
    gameDuration = 61,
    maxPressure = 5,
    currentPressure = 5,
    remainingTime = 61,
    escapeForce = 0.03,
    recoveryRate = 1,
    drainRate = 1,
    lastSlamTime = 0,
    minSlamInterval = 2,
    maxSlamInterval = 6,
    currentSlamInterval = 4,
    timeProgress = 0
}

local isPlayerDead = false
local killEffectPlayed = false

local function showKillEffect()
    if killEffectPlayed then
        return
    end
    
    killEffectPlayed = true
    isPlayerDead = true
    
    local playerGui = player:WaitForChild("PlayerGui")
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "KillEffect"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = playerGui
    
    for _, child in ipairs(screenGui:GetChildren()) do
        child:Destroy()
    end
    
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://112123002526111"
    sound.Volume = 4
    sound.Parent = workspace
    sound:Play()
    game:GetService("Debris"):AddItem(sound, sound.TimeLength + 1)
    
    local image = Instance.new("ImageLabel")
    image.Image = "rbxassetid://99207315574595"
    image.Size = UDim2.new(0, 10, 0, 10)
    image.Position = UDim2.new(0.5, 0, 0.5, 0)
    image.AnchorPoint = Vector2.new(0.5, 0.5)
    image.BackgroundTransparency = 1
    image.ScaleType = Enum.ScaleType.Fit
    image.SizeConstraint = Enum.SizeConstraint.RelativeXY
    image.Parent = screenGui
    
    TweenService:Create(image, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(1.5, 0, 1.5, 0)
    }):Play()
    
    wait(0.3)

    local time = 0
    local duration = 0.8
    
    while time < duration do
        time = time + wait()
        local shakeX = math.sin(time * 30) * 0.002
        local shakeY = math.cos(time * 28) * 0.002
        
        image.Position = UDim2.new(0.5 + shakeX, 0, 0.5 + shakeY, 0)
    end

    replicatesignal(game.Players.LocalPlayer.Kill)
    
    TweenService:Create(image, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        ImageTransparency = 1
    }):Play()
    
    wait(0.2)
    image:Destroy()
    wait(0.5)
    screenGui:Destroy()
end

local function showSurviveEffect()
    if workspace:FindFirstChild("Z-367") then
        workspace["Z-367"]:Destroy()
    end
end

local function isPlayerAlive()
    local character = player.Character
    if not character then
        return false
    end
    
    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoid then
        return false
    end
    
    return humanoid.Health > 0
end

local function GitAud(soundgit, filename)
    local url = soundgit
    local FileName = filename
    writefile(FileName .. ".mp3", game:HttpGet(url))
    return (getcustomasset or getsynasset)(FileName .. ".mp3")
end

local function CustomGitSound(soundlink, vol, filename)
    local sound = Instance.new("Sound")
    sound.SoundId = GitAud(soundlink, filename)
    sound.Parent = workspace
    sound.Name = filename or "Music"
    sound.Volume = vol
    sound:Play()
    return sound
end

local function loadMusicOnly()
    local targetAudioUrl = "https://github.com/Zero0Star/RipperNewSound/blob/master/Z367Music.mp3?raw=true"
    local localFileName = "Z367Music"
    
    local gameMusic = nil
    local success, errorMsg = pcall(function()
        gameMusic = CustomGitSound(targetAudioUrl, 3, localFileName)
    end)
    
    if not success then
        gameMusic = Instance.new("Sound")
        gameMusic.Name = "Z367MusicFallback"
        gameMusic.Volume = 0
        gameMusic.Parent = workspace
    end
    
    if gameMusic then
        repeat
            wait(0.1)
        until gameMusic.IsPlaying
    end
    
    if gameMusic then
        wait(gameMusic.TimeLength or 61)
        if gameMusic and gameMusic.Parent then
            gameMusic:Stop()
            gameMusic:Destroy()
        end
    end
end

local function createGameUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "PressureMinigame"
    screenGui.Enabled = false
    screenGui.DisplayOrder = 10
    screenGui.Parent = gui
    
    local background = Instance.new("Frame")
    background.Name = "Background"
    background.Size = UDim2.new(1, 0, 1, 0)
    background.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    background.BackgroundTransparency = 1
    background.ZIndex = 1
    background.Parent = screenGui
    
    local centerDot = Instance.new("Frame")
    centerDot.Name = "CenterDot"
    centerDot.Size = UDim2.new(0, 8, 0, 8)
    centerDot.Position = UDim2.new(0.5, -4, 0.5, -4)
    centerDot.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    centerDot.BorderSizePixel = 0
    centerDot.AnchorPoint = Vector2.new(0.5, 0.5)
    centerDot.ZIndex = 5
    centerDot.BackgroundTransparency = 1
    
    local dotCorner = Instance.new("UICorner")
    dotCorner.CornerRadius = UDim.new(1, 0)
    dotCorner.Parent = centerDot
    
    local centerCircle = Instance.new("Frame")
    centerCircle.Name = "CenterCircle"
    centerCircle.Size = UDim2.new(0, 100, 0, 100)
    centerCircle.Position = UDim2.new(0.5, -50, 0.5, -50)
    centerCircle.BackgroundTransparency = 1
    centerCircle.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
    centerCircle.BorderColor3 = Color3.fromRGB(180, 180, 180)
    centerCircle.BorderSizePixel = 2
    centerCircle.AnchorPoint = Vector2.new(0.5, 0.5)
    centerCircle.ZIndex = 4
    centerCircle.BackgroundTransparency = 1
    
    local circleCorner = Instance.new("UICorner")
    circleCorner.CornerRadius = UDim.new(1, 0)
    circleCorner.Parent = centerCircle
    
    local controlBall = Instance.new("Frame")
    controlBall.Name = "ControlBall"
    controlBall.Size = UDim2.new(0, 30, 0, 30)
    controlBall.Position = UDim2.new(0.5, -15, 0.5, -15)
    controlBall.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    controlBall.BorderSizePixel = 0
    controlBall.AnchorPoint = Vector2.new(0.5, 0.5)
    controlBall.ZIndex = 6
    controlBall.BackgroundTransparency = 1
    
    local ballCorner = Instance.new("UICorner")
    ballCorner.CornerRadius = UDim.new(1, 0)
    ballCorner.Parent = controlBall
    
    local pressureBack = Instance.new("Frame")
    pressureBack.Name = "PressureBack"
    pressureBack.Size = UDim2.new(0.6, 0, 0, 30)
    pressureBack.Position = UDim2.new(0.2, 0, 0.05, 0)
    pressureBack.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    pressureBack.BorderSizePixel = 2
    pressureBack.BorderColor3 = Color3.fromRGB(80, 80, 80)
    pressureBack.ZIndex = 3
    pressureBack.BackgroundTransparency = 1
    
    local backCorner = Instance.new("UICorner")
    backCorner.CornerRadius = UDim.new(0, 6)
    backCorner.Parent = pressureBack
    
    local pressureFill = Instance.new("Frame")
    pressureFill.Name = "PressureFill"
    pressureFill.Size = UDim2.new(1, 0, 1, 0)
    pressureFill.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
    pressureFill.BorderSizePixel = 0
    pressureFill.ZIndex = 4
    pressureFill.BackgroundTransparency = 1
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 6)
    fillCorner.Parent = pressureFill
    
    local pressureText = Instance.new("TextLabel")
    pressureText.Name = "PressureText"
    pressureText.Size = UDim2.new(1, 0, 1, 0)
    pressureText.BackgroundTransparency = 1
    pressureText.Text = "Stay in the center!"
    pressureText.TextColor3 = Color3.fromRGB(200, 200, 200)
    pressureText.TextSize = 18
    pressureText.Font = Enum.Font.GothamBold
    pressureText.TextStrokeTransparency = 0.5
    pressureText.ZIndex = 5
    pressureText.TextTransparency = 1
    
    local timerText = Instance.new("TextLabel")
    timerText.Name = "Timer"
    timerText.Size = UDim2.new(0.3, 0, 0, 40)
    timerText.Position = UDim2.new(0.35, 0, 0.1, 0)
    timerText.BackgroundTransparency = 1
    timerText.Text = "01:01"
    timerText.TextColor3 = Color3.fromRGB(200, 200, 200)
    timerText.TextSize = 36
    timerText.Font = Enum.Font.GothamBold
    timerText.TextStrokeTransparency = 0.5
    timerText.ZIndex = 3
    timerText.TextTransparency = 1
    
    pressureFill.Parent = pressureBack
    pressureText.Parent = pressureBack
    centerDot.Parent = screenGui
    centerCircle.Parent = screenGui
    controlBall.Parent = screenGui
    pressureBack.Parent = screenGui
    timerText.Parent = screenGui
    
    return {
        ScreenGui = screenGui,
        Background = background,
        Ball = controlBall,
        CenterDot = centerDot,
        CenterCircle = centerCircle,
        PressureBack = pressureBack,
        PressureFill = pressureFill,
        PressureText = pressureText,
        Timer = timerText
    }
end

local function fadeInUI(ui)
    ui.ScreenGui.Enabled = true
    
    local fadeTime = 0.8
    local fadeInfo = TweenInfo.new(fadeTime, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    
    TweenService:Create(ui.Background, fadeInfo, {BackgroundTransparency = 0.7}):Play()
    
    wait(0.2)
    TweenService:Create(ui.CenterDot, fadeInfo, {BackgroundTransparency = 0}):Play()
    wait(0.1)
    TweenService:Create(ui.CenterCircle, fadeInfo, {BackgroundTransparency = 0.7, BorderColor3 = Color3.fromRGB(180, 180, 180)}):Play()
    wait(0.1)
    TweenService:Create(ui.Ball, fadeInfo, {BackgroundTransparency = 0}):Play()
    wait(0.1)
    TweenService:Create(ui.PressureBack, fadeInfo, {BackgroundTransparency = 0.3}):Play()
    TweenService:Create(ui.PressureFill, fadeInfo, {BackgroundTransparency = 0}):Play()
    TweenService:Create(ui.PressureText, TweenInfo.new(fadeTime, Enum.EasingStyle.Linear), {TextTransparency = 0}):Play()
    TweenService:Create(ui.Timer, TweenInfo.new(fadeTime, Enum.EasingStyle.Linear), {TextTransparency = 0}):Play()
    
    wait(fadeTime)
end

local function fadeOutUI(ui, result)
    local fadeTime = 0.5
    local fadeInfo = TweenInfo.new(fadeTime, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
    
    wait(1.5)
    
    TweenService:Create(ui.Background, fadeInfo, {BackgroundTransparency = 1}):Play()
    TweenService:Create(ui.CenterDot, fadeInfo, {BackgroundTransparency = 1}):Play()
    TweenService:Create(ui.CenterCircle, fadeInfo, {BackgroundTransparency = 1}):Play()
    TweenService:Create(ui.Ball, fadeInfo, {BackgroundTransparency = 1}):Play()
    TweenService:Create(ui.PressureBack, fadeInfo, {BackgroundTransparency = 1}):Play()
    TweenService:Create(ui.PressureFill, fadeInfo, {BackgroundTransparency = 1}):Play()
    TweenService:Create(ui.PressureText, TweenInfo.new(fadeTime), {TextTransparency = 1}):Play()
    TweenService:Create(ui.Timer, TweenInfo.new(fadeTime), {TextTransparency = 1}):Play()
    
    wait(fadeTime)
    ui.ScreenGui:Destroy()
end

local function applySlamForce()
    local forceMultiplier = 0.12
    local angle = math.random() * math.pi * 2
    return Vector2.new(
        math.cos(angle) * forceMultiplier,
        math.sin(angle) * forceMultiplier
    )
end

local function updateSlamInterval(gameProgress)
    local minStart = 2
    local maxStart = 6
    local minEnd = 1
    local maxEnd = 4
    
    local currentMin = minStart + (minEnd - minStart) * gameProgress
    local currentMax = maxStart + (maxEnd - maxStart) * gameProgress
    
    local randomInterval = currentMin + (currentMax - currentMin) * math.random()
    
    return randomInterval, currentMin, currentMax
end

local function startGame()
    local targetAudioUrl = "https://github.com/Zero0Star/RipperNewSound/blob/master/Z367Music.mp3?raw=true"
    local localFileName = "Z367Music"
    
    local gameMusic = nil
    local success, errorMsg = pcall(function()
        gameMusic = CustomGitSound(targetAudioUrl, 3, localFileName)
    end)
    
    if not success then
        gameMusic = Instance.new("Sound")
        gameMusic.Name = "Z367MusicFallback"
        gameMusic.Volume = 4
        gameMusic.Parent = workspace
    end
    
    if gameMusic then
        repeat
            wait(0.1)
        until gameMusic.IsPlaying
    end
    
    local ui = createGameUI()
    fadeInUI(ui)
    
    gameData.gameActive = true
    gameData.currentPressure = gameData.maxPressure
    gameData.remainingTime = gameData.gameDuration
    gameData.lastSlamTime = tick()
    gameData.timeProgress = 0
    
    local initialInterval = 2 + (6 - 2) * math.random()
    gameData.currentSlamInterval = initialInterval
    
    local ballPos = Vector2.new(0.5, 0.5)
    local ballVelocity = Vector2.new(0, 0)
    local isDragging = false
    local lastMousePos = Vector2.new(0, 0)
    local mouseDown = false
    local isMouseControl = true
    
    local mouseSensitivity = 0.0006
    local touchSensitivity = 0.0008
    
    local viewportSize = workspace.CurrentCamera.ViewportSize
    local screenCenter = Vector2.new(viewportSize.X / 2, viewportSize.Y / 2)
    
    local inputBeganConnection = UserInputService.InputBegan:Connect(function(input)
        if not gameData.gameActive then return end
        
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            mouseDown = true
            isDragging = true
            lastMousePos = Vector2.new(input.Position.X, input.Position.Y)
        elseif input.UserInputType == Enum.UserInputType.Touch then
            mouseDown = true
            isDragging = true
            isMouseControl = false
            lastMousePos = Vector2.new(input.Position.X, input.Position.Y)
        end
    end)
    
    local inputEndedConnection = UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            mouseDown = false
            isDragging = false
        end
    end)
    
    local inputChangedConnection = UserInputService.InputChanged:Connect(function(input)
        if not gameData.gameActive or not mouseDown then return end
        
        if input.UserInputType == Enum.UserInputType.MouseMovement and isMouseControl then
            local currentMousePos = Vector2.new(input.Position.X, input.Position.Y)
            local delta = currentMousePos - lastMousePos
            
            ballVelocity = ballVelocity + Vector2.new(delta.X, delta.Y) * mouseSensitivity
            
            lastMousePos = currentMousePos
            
        elseif input.UserInputType == Enum.UserInputType.Touch and not isMouseControl then
            local currentTouchPos = Vector2.new(input.Position.X, input.Position.Y)
            local delta = currentTouchPos - lastMousePos
            
            ballVelocity = ballVelocity + Vector2.new(delta.X, delta.Y) * touchSensitivity
            
            lastMousePos = currentTouchPos
        end
    end)
    
    local lastUpdate = tick()
    local gameLoopConnection
    
    local function cleanupGame()
        if gameData.gameActive then
            gameData.gameActive = false
        end
        
        if inputBeganConnection then
            inputBeganConnection:Disconnect()
        end
        
        if inputEndedConnection then
            inputEndedConnection:Disconnect()
        end
        
        if inputChangedConnection then
            inputChangedConnection:Disconnect()
        end
        
        if gameLoopConnection then
            gameLoopConnection:Disconnect()
        end
        
        if gameMusic and gameMusic.Parent then
            gameMusic:Stop()
            wait(0.1)
            gameMusic:Destroy()
        end
    end
    
    gameLoopConnection = RunService.RenderStepped:Connect(function(deltaTime)
        if not gameData.gameActive then
            cleanupGame()
            return
        end
        
        local currentTime = tick()
        local delta = currentTime - lastUpdate
        lastUpdate = currentTime
        
        local microShake = Vector2.new(
            (math.random() - 0.5) * 0.0008,
            (math.random() - 0.5) * 0.0008
        )
        ballVelocity = ballVelocity + microShake
        
        gameData.timeProgress = 1 - (gameData.remainingTime / gameData.gameDuration)
        
        if currentTime - gameData.lastSlamTime >= gameData.currentSlamInterval then
            local slamForce = applySlamForce()
            ballVelocity = ballVelocity + slamForce
            gameData.lastSlamTime = currentTime
            
            local newInterval, currentMin, currentMax = updateSlamInterval(gameData.timeProgress)
            gameData.currentSlamInterval = newInterval
            
            ui.CenterCircle.BorderColor3 = Color3.fromRGB(255, 100, 100)
            ui.CenterCircle.BorderSizePixel = 4
            wait(0.1)
            ui.CenterCircle.BorderColor3 = Color3.fromRGB(180, 180, 180)
            ui.CenterCircle.BorderSizePixel = 2
        end
        
        ballVelocity = ballVelocity * 0.88
        
        local maxSpeed = 0.035
        if ballVelocity.Magnitude > maxSpeed then
            ballVelocity = ballVelocity.Unit * maxSpeed
        end
        
        ballPos = ballPos + ballVelocity
        ballPos = Vector2.new(
            math.clamp(ballPos.X, 0.05, 0.95),
            math.clamp(ballPos.Y, 0.05, 0.95)
        )
        
        ui.Ball.Position = UDim2.new(ballPos.X, -15, ballPos.Y, -15)
        
        local center = Vector2.new(0.5, 0.5)
        local distance = (ballPos - center).Magnitude
        local isInCenter = distance < 0.05
        
        if isInCenter then
            gameData.currentPressure = math.min(gameData.maxPressure, 
                gameData.currentPressure + gameData.recoveryRate * delta)
            ui.PressureFill.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
            ui.Ball.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
        else
            gameData.currentPressure = gameData.currentPressure - gameData.drainRate * delta
            ui.PressureFill.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
            ui.Ball.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
            
            local distanceMultiplier = 1 + (distance - 0.05) * 5
            gameData.currentPressure = gameData.currentPressure - (distanceMultiplier - 1) * delta
        end
        
        local pressurePercent = gameData.currentPressure / gameData.maxPressure
        ui.PressureFill.Size = UDim2.new(pressurePercent, 0, 1, 0)
        ui.PressureText.Text = "Stay in the center!"
        
        gameData.remainingTime = gameData.remainingTime - delta
        local seconds = math.max(0, math.ceil(gameData.remainingTime))
        local minutes = math.floor(seconds / 60)
        local remainingSeconds = seconds % 60
        ui.Timer.Text = string.format("%02d:%02d", minutes, remainingSeconds)
        
        if not isInCenter then
            local pulse = math.sin(currentTime * 8) * 0.3 + 0.7
            ui.Ball.BackgroundTransparency = 1 - pulse
        else
            ui.Ball.BackgroundTransparency = 0
        end
        
        if gameData.currentPressure <= 0 then
            fadeOutUI(ui, "lose")
            showKillEffect()
            cleanupGame()
        elseif gameData.remainingTime <= 0 then
            fadeOutUI(ui, "win")
            showSurviveEffect()
            cleanupGame()
        end
        
        if gameMusic and not gameMusic.IsPlaying and gameData.gameActive then
            wait(0.5)
            if gameMusic and gameMusic.Parent then
                gameMusic:Destroy()
                gameMusic = nil
            end
        end
    end)
    
    return ui
end

local function main()
    wait(2)
    
    if isPlayerAlive() then
        if not gameData.gameActive then
            startGame()
        end
    else
        loadMusicOnly()
    end
end

main()

end

-- 2. A60
function entityBehaviors.runA60()
    local entity = spawner.Create({
        Entity = {
            Name = "A60",
            Asset = "14169212325",
            HeightOffset = 0
        },
        Lights = {
            Flicker = {
                Enabled = false,
                Duration = 10
            },
            Shatter = false,
            Repair = false
        },
        Earthquake = {
            Enabled = false
        },
        CameraShake = {
            Enabled = true,
            Range = 200,
            Values = {1.5, 20, 0.1, 1}
        },
        Movement = {
            Speed = 150,
            Delay = 3,
            Reversed = false
        },
        Rebounding = {
            Enabled = true,
            Type = "ambush",
            Min = 3,
            Max = 3,
            Delay = math.random(10, 30) / 10
        },
        Damage = {
            Enabled = true,
            Range = 100,
            Amount = 125
        },
        Crucifixion = {
            Enabled = true,
            Range = 100,
            Resist = false,
            Break = true
        },
        Death = {
            Type = "Guiding",
            Hints = {"你死于A60", "...", "你会从Ambush那学会点什么", "他随时可能出现!"},
            Cause = ""
        }
    })
    
    entity:SetCallback("OnRebounding", function(startOfRebound)
        local entityModel = entity.Model
        local main = entityModel:WaitForChild("Main")
        local attachment = main:WaitForChild("Attachment")
        local AttachmentSwitch = main:WaitForChild("AttachmentSwitch")
        local sounds = {
            footsteps = main:WaitForChild("Footsteps"),
            playSound = main:WaitForChild("PlaySound"),
            switch = main:WaitForChild("Switch"),
            switchBack = main:WaitForChild("SwitchBack")
        }

        for _, c in attachment:GetChildren() do
            c.Enabled = (not startOfRebound)
        end
        for _, c in AttachmentSwitch:GetChildren() do
            c.Enabled = startOfRebound
        end

        if startOfRebound == true then
            sounds.footsteps.PlaybackSpeed = 0.35
            sounds.playSound.PlaybackSpeed = 0.25
            sounds.switch:Play()
        else
            sounds.footsteps.PlaybackSpeed = 0.25
            sounds.playSound.PlaybackSpeed = 0.16
            sounds.switchBack:Play()
        end
    end)
    
    entity:Run()
end

-- 3. A60 Phase 2 (Room 50)
function entityBehaviors.runA60Phase2Room()
    local Workspace = game:GetService("Workspace")
    local RunService = game:GetService("RunService")
    
    local waypointFolder = Workspace:FindFirstChild("A60_Waypoints")
    if not waypointFolder then
        waypointFolder = Instance.new("Folder")
        waypointFolder.Name = "A60_Waypoints"
        waypointFolder.Parent = Workspace
    end
    
    for _, wp in ipairs(waypointFolder:GetChildren()) do
        wp:Destroy()
    end
    
    local allWaypoints = {}
    local figureNodes = {}
    
    local currentRooms = Workspace:FindFirstChild("CurrentRooms")
    if currentRooms then
        local room50 = currentRooms:FindFirstChild("50")
        if room50 and room50:IsA("Model") then
            local figureSetup = room50:FindFirstChild("FigureSetup")
            if figureSetup then
                local figureNodesFolder = figureSetup:FindFirstChild("FigureNodes")
                if figureNodesFolder then
                    local node1 = figureNodesFolder:FindFirstChild("1")
                    if node1 and node1:IsA("BasePart") then
                        table.insert(figureNodes, {
                            part = node1,
                            position = node1.Position
                        })
                        
                        for _ = 1, 2 do
                            table.insert(allWaypoints, {
                                part = node1,
                                position = node1.Position,
                                isOnePart = true
                            })
                        end
                        
                        for _ = 1, 3 do
                            table.insert(allWaypoints, {
                                part = node1,
                                position = node1.Position + Vector3.new(
                                    math.random(-3, 3),
                                    math.random(-0.5, 0.5),
                                    math.random(-3, 3)
                                ),
                                isOnePart = true,
                                isOffset = true
                            })
                        end
                        
                        for _ = 1, math.random(3, 6) do
                            for i = #allWaypoints, 2, -1 do
                                local j = math.random(i)
                                allWaypoints[i], allWaypoints[j] = allWaypoints[j], allWaypoints[i]
                            end
                        end
                    end
                end
            end
        else
            local waypointCount = 0
            
            local function processDoor(doorModel, roomName, doorType)
                local position
                
                if doorModel.PrimaryPart then
                    position = doorModel:GetPivot().Position
                else
                    local parts = {}
                    for _, part in ipairs(doorModel:GetDescendants()) do
                        if part:IsA("BasePart") then
                            table.insert(parts, part.Position)
                        end
                    end
                    
                    if #parts > 0 then
                        local sum = Vector3.new(0, 0, 0)
                        for _, pos in ipairs(parts) do
                            sum = sum + pos
                        end
                        position = sum / #parts
                    end
                end
                
                if position then
                    waypointCount = waypointCount + 1
                    
                    local waypoint = Instance.new("Part")
                    waypoint.Name = "A60_WP_" .. waypointCount
                    waypoint.Size = Vector3.new(2, 2, 2)
                    waypoint.Position = position
                    waypoint.Anchored = true
                    waypoint.CanCollide = false
                    waypoint.Transparency = 1
                    waypoint.Parent = waypointFolder
                    
                    for _ = 1, 2 do
                        table.insert(allWaypoints, {
                            part = waypoint,
                            position = waypoint.Position,
                            room = roomName,
                            index = waypointCount,
                            doorType = doorType,
                            isDoor = true
                        })
                    end
                    
                    for _ = 1, 4 do
                        local offsetPos = position + Vector3.new(
                            math.random(-4, 4),
                            math.random(0, 2),
                            math.random(-4, 4)
                        )
                        
                        waypointCount = waypointCount + 1
                        local offsetWaypoint = Instance.new("Part")
                        offsetWaypoint.Name = "A60_WP_" .. waypointCount .. "_Offset"
                        offsetWaypoint.Size = Vector3.new(2, 2, 2)
                        offsetWaypoint.Position = offsetPos
                        offsetWaypoint.Anchored = true
                        offsetWaypoint.CanCollide = false
                        offsetWaypoint.Transparency = 1
                        offsetWaypoint.Parent = waypointFolder
                        
                        table.insert(allWaypoints, {
                            part = offsetWaypoint,
                            position = offsetPos,
                            room = roomName,
                            index = waypointCount,
                            doorType = doorType,
                            isDoor = true,
                            isOffset = true
                        })
                    end
                end
            end
            
            for _, room in ipairs(currentRooms:GetChildren()) do
                if room:IsA("Model") then
                    for _, child in ipairs(room:GetDescendants()) do
                        if child:IsA("Model") and (child.Name == "Door" or child.Name == "DoorNormal" or child.Name == "SideroomDupe") then
                            processDoor(child, room.Name, child.Name)
                        end
                    end
                end
            end
            
            for _ = 1, math.random(3, 6) do
                for i = #allWaypoints, 2, -1 do
                    local j = math.random(i)
                    allWaypoints[i], allWaypoints[j] = allWaypoints[j], allWaypoints[i]
                end
            end
        end
    end
    
    if #allWaypoints == 0 then
        return
    end
    
    local a60Model
    local success, result = pcall(function()
        return game:GetObjects("rbxassetid://85615143036194")[1]
    end)
    
    if success and result then
        a60Model = result
        a60Model.Name = "A60"
        a60Model.Parent = Workspace
        
        if #allWaypoints > 0 then
            a60Model:PivotTo(CFrame.new(allWaypoints[1].position + Vector3.new(5, 0, 5)))
        end
    else
        a60Model = Instance.new("Model")
        a60Model.Name = "A60"
        
        local torso = Instance.new("Part")
        torso.Name = "Torso"
        torso.Size = Vector3.new(2, 4, 2)
        torso.Position = Vector3.new(0, 5, 0)
        torso.Anchored = false
        torso.CanCollide = true
        torso.Color = Color3.fromRGB(139, 69, 19)
        torso.Material = Enum.Material.Wood
        torso.Parent = a60Model
        
        a60Model.PrimaryPart = torso
        a60Model.Parent = Workspace
    end
    
    local function addFaceParticleAnimation()
        local faceParticle
        for _, child in ipairs(a60Model:GetDescendants()) do
            if child:IsA("ParticleEmitter") and child.Name == "Face" then
                faceParticle = child
                break
            end
        end
        
        if not faceParticle then
            return
        end
        
        local particleTextures = {
            "rbxassetid://16020415559",
            "rbxassetid://16020423090", 
            "rbxassetid://16020425703",
            "rbxassetid://16020417711",
            "rbxassetid://16020432826",
            "rbxassetid://16020430685",
            "rbxassetid://16020435171"
        }
        
        local currentTextureIndex = 1
        local animationSpeed = 0.1
        local isAnimating = true
        
        local originalTexture = faceParticle.Texture
        local originalEnabled = faceParticle.Enabled
        
        coroutine.wrap(function()
            while a60Model and a60Model.Parent and faceParticle and faceParticle.Parent and isAnimating do
                faceParticle.Enabled = true
                
                faceParticle.Texture = particleTextures[currentTextureIndex]
                
                currentTextureIndex = currentTextureIndex + 1
                if currentTextureIndex > #particleTextures then
                    currentTextureIndex = 1
                end
                
                local currentSpeed = animationSpeed * (0.8 + math.random() * 0.4)
                wait(currentSpeed)
            end
        end)()
        
        local UserInputService = game:GetService("UserInputService")
        UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if gameProcessed then return end
            
            if input.KeyCode == Enum.KeyCode.F then
                isAnimating = not isAnimating
            end
        end)
        
        return {
            setSpeed = function(speed)
                animationSpeed = math.max(0.05, math.min(0.5, speed))
            end,
            stop = function()
                isAnimating = false
                faceParticle.Texture = originalTexture
            end,
            start = function()
                isAnimating = true
            end
        }
    end
    
    local currentWaypointIndex = 1
    local isMoving = true
    local baseSpeed = 60
    local reachedDistance = 8.0
    local smoothFactor = 0.6
    local visitCounts = {}
    local lastVisitTime = {}
    
    for i = 1, #allWaypoints do
        visitCounts[i] = 0
        lastVisitTime[i] = 0
    end
    
    local function getWaypoint()
        if #allWaypoints == 0 then
            return nil, 1
        end
        
        local currentTime = tick()
        local validWaypoints = {}
        
        for i, wp in ipairs(allWaypoints) do
            if wp and wp.part and wp.part.Parent then
                if currentTime - lastVisitTime[i] > 2 then
                    table.insert(validWaypoints, {index = i, waypoint = wp})
                end
            end
        end
        
        if #validWaypoints > 0 then
            local choice = validWaypoints[math.random(1, #validWaypoints)]
            currentWaypointIndex = choice.index
            return choice.waypoint, currentWaypointIndex
        end
        
        for i = 1, #allWaypoints do
            local wp = allWaypoints[i]
            if wp and wp.part and wp.part.Parent then
                currentWaypointIndex = i
                return wp, currentWaypointIndex
            end
        end
        
        return nil, 1
    end
    
    local function checkReachedWaypoint(waypoint)
        if not waypoint or not waypoint.part or not waypoint.part.Parent then
            return false
        end
        
        local monsterPos = a60Model:GetPivot().Position
        local waypointPos = waypoint.position
        local distance = (monsterPos - waypointPos).Magnitude
        
        return distance <= reachedDistance
    end
    
    local lastUpdate = tick()
    local currentTarget, currentIndex = getWaypoint()
    local velocity = Vector3.new(0, 0, 0)
    local wobbleIntensity = 0.15
    local wobbleSpeed = 3.0
    local wobbleTime = 0
    local targetSwitchTime = 0
    local minTargetTime = 1.0
    local maxTargetTime = 5.0
    local speedMultiplier = 1.0
    local zigzagAmount = 0
    local zigzagSpeed = 2.0
    local zigzagIntensity = 0.3

    coroutine.wrap(function()
        wait(60)
        
        for _, waypoint in ipairs(allWaypoints) do
            if not waypoint.isOnePart and waypoint.part and waypoint.part.Parent then
                waypoint.part:Destroy()
            end
        end
        
        if a60Model and a60Model.Parent then
            a60Model:Destroy()
        end
        
        if waypointFolder and waypointFolder.Parent then
            waypointFolder:Destroy()
        end
    end)()

    coroutine.wrap(function()
        while a60Model and a60Model.Parent do
            local deltaTime = math.min(tick() - lastUpdate, 0.033)
            lastUpdate = tick()
            wobbleTime = wobbleTime + deltaTime * wobbleSpeed
            zigzagAmount = zigzagAmount + deltaTime * zigzagSpeed
            
            if isMoving and currentTarget then
                local monsterCFrame = a60Model:GetPivot()
                local monsterPos = monsterCFrame.Position
                local targetPos = currentTarget.position
                
                local direction = (targetPos - monsterPos)
                local distance = direction.Magnitude
                
                if distance > 0.1 then
                    local moveDirection = direction.Unit
                    
                    local targetSpeed = baseSpeed * speedMultiplier
                    
                    if math.random() < 0.4 then
                        speedMultiplier = 0.7 + math.random() * 1.3
                    end
                    
                    if distance < 20 then
                        targetSpeed = targetSpeed * 0.8
                    elseif distance > 40 then
                        targetSpeed = targetSpeed * 1.4
                    end
                    
                    if tick() - targetSwitchTime > minTargetTime + math.random() * (maxTargetTime - minTargetTime) then
                        if math.random() < 0.6 then
                            currentTarget, currentIndex = getWaypoint()
                            targetSwitchTime = tick()
                        end
                    end
                    
                    local zigzagOffset = Vector3.new(
                        math.sin(zigzagAmount) * zigzagIntensity,
                        0,
                        math.cos(zigzagAmount * 0.7) * zigzagIntensity * 0.5
                    )
                    
                    moveDirection = (moveDirection + zigzagOffset * 0.1).Unit
                    
                    local targetVelocity = moveDirection * targetSpeed
                    velocity = velocity:Lerp(targetVelocity, smoothFactor)
                    
                    local wobbleOffset = Vector3.new(
                        math.sin(wobbleTime) * wobbleIntensity * 2.0,
                        math.cos(wobbleTime * 1.3) * wobbleIntensity * 1.0,
                        math.cos(wobbleTime * 0.9) * wobbleIntensity * 1.5
                    )
                    
                    local newPosition = monsterPos + (velocity * deltaTime) + wobbleOffset
                    
                    if moveDirection.Magnitude > 0.1 then
                        local yawOffset = math.rad(math.sin(wobbleTime * 0.7) * 8)
                        local pitchOffset = math.rad(math.cos(wobbleTime * 1.1) * 6)
                        local rollOffset = math.rad(math.sin(wobbleTime * 1.4) * 4)
                        
                        local rotatedDirection = CFrame.Angles(pitchOffset, yawOffset, rollOffset) * moveDirection
                        
                        local lookAtCFrame = CFrame.lookAt(newPosition, newPosition + rotatedDirection)
                        a60Model:PivotTo(lookAtCFrame)
                    end
                    
                    if checkReachedWaypoint(currentTarget) then
                        if currentIndex then
                            visitCounts[currentIndex] = (visitCounts[currentIndex] or 0) + 1
                            lastVisitTime[currentIndex] = tick()
                        end
                        
                        wait(math.random(0.05, 0.2))
                        
                        if math.random() < 0.8 then
                            currentTarget, currentIndex = getWaypoint()
                            targetSwitchTime = tick()
                        end
                        
                        velocity = velocity * 0.2
                    end
                else
                    if currentIndex then
                        visitCounts[currentIndex] = (visitCounts[currentIndex] or 0) + 1
                        lastVisitTime[currentIndex] = tick()
                    end
                    
                    wait(math.random(0.05, 0.2))
                    currentTarget, currentIndex = getWaypoint()
                    targetSwitchTime = tick()
                    velocity = Vector3.new(0, 0, 0)
                end
            end
            
            RunService.RenderStepped:Wait()
        end
    end)()
    
    local UserInputService = game:GetService("UserInputService")
    
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if input.KeyCode == Enum.KeyCode.R then
            currentTarget, currentIndex = getWaypoint()
            isMoving = true
            velocity = Vector3.new(0, 0, 0)
            speedMultiplier = 1.0
            
            for i = 1, #allWaypoints do
                visitCounts[i] = 0
                lastVisitTime[i] = 0
            end
            
            if #allWaypoints > 0 then
                a60Model:PivotTo(CFrame.new(allWaypoints[1].position + Vector3.new(5, 0, 5)))
            end
            
        elseif input.KeyCode == Enum.KeyCode.T then
            isMoving = not isMoving
            if isMoving then
                velocity = Vector3.new(0, 0, 0)
            end
        end
    end)
end

-- 4. A60 Phase 2 (LIB)
function entityBehaviors.runA60Phase2Lib()
    local Workspace = game:GetService("Workspace")
    local RunService = game:GetService("RunService")
    
    local waypointFolder = Workspace:FindFirstChild("A60_Waypoints")
    if not waypointFolder then
        waypointFolder = Instance.new("Folder")
        waypointFolder.Name = "A60_Waypoints"
        waypointFolder.Parent = Workspace
    end
    
    for _, wp in ipairs(waypointFolder:GetChildren()) do
        wp:Destroy()
    end
    
    local allWaypoints = {}
    local figureNodes = {}
    
    local function findAllOneParts(parent)
        for _, child in ipairs(parent:GetChildren()) do
            if child.Name == "1" and child:IsA("BasePart") then
                table.insert(figureNodes, {
                    part = child,
                    position = child.Position
                })
            end
            if #child:GetChildren() > 0 then
                findAllOneParts(child)
            end
        end
    end
    
    local currentRooms = Workspace:FindFirstChild("CurrentRooms")
    if currentRooms then
        findAllOneParts(currentRooms)
    end
    
    if #figureNodes == 0 then
        findAllOneParts(Workspace)
    end
    
    if #figureNodes > 0 then
        for _, node in ipairs(figureNodes) do
            for _ = 1, 2 do
                table.insert(allWaypoints, {
                    part = node.part,
                    position = node.position,
                    isOnePart = true
                })
            end
        end
        
        for _ = 1, 3 do
            for _, node in ipairs(figureNodes) do
                table.insert(allWaypoints, {
                    part = node.part,
                    position = node.position + Vector3.new(
                        math.random(-3, 3),
                        math.random(-0.5, 0.5),
                        math.random(-3, 3)
                    ),
                    isOnePart = true,
                    isOffset = true
                })
            end
        end
        
        for _ = 1, math.random(3, 6) do
            for i = #allWaypoints, 2, -1 do
                local j = math.random(i)
                allWaypoints[i], allWaypoints[j] = allWaypoints[j], allWaypoints[i]
            end
        end
    else
        local currentRooms = Workspace:FindFirstChild("CurrentRooms")
        if currentRooms then
            local waypointCount = 0
            
            local function processDoor(doorModel, roomName, doorType)
                local position
                
                if doorModel.PrimaryPart then
                    position = doorModel:GetPivot().Position
                else
                    local parts = {}
                    for _, part in ipairs(doorModel:GetDescendants()) do
                        if part:IsA("BasePart") then
                            table.insert(parts, part.Position)
                        end
                    end
                    
                    if #parts > 0 then
                        local sum = Vector3.new(0, 0, 0)
                        for _, pos in ipairs(parts) do
                            sum = sum + pos
                        end
                        position = sum / #parts
                    end
                end
                
                if position then
                    waypointCount = waypointCount + 1
                    
                    local waypoint = Instance.new("Part")
                    waypoint.Name = "A60_WP_" .. waypointCount
                    waypoint.Size = Vector3.new(2, 2, 2)
                    waypoint.Position = position
                    waypoint.Anchored = true
                    waypoint.CanCollide = false
                    waypoint.Transparency = 1
                    waypoint.Parent = waypointFolder
                    
                    for _ = 1, 2 do
                        table.insert(allWaypoints, {
                            part = waypoint,
                            position = waypoint.Position,
                            room = roomName,
                            index = waypointCount,
                            doorType = doorType,
                            isDoor = true
                        })
                    end
                    
                    for _ = 1, 4 do
                        local offsetPos = position + Vector3.new(
                            math.random(-4, 4),
                            math.random(0, 2),
                            math.random(-4, 4)
                        )
                        
                        waypointCount = waypointCount + 1
                        local offsetWaypoint = Instance.new("Part")
                        offsetWaypoint.Name = "A60_WP_" .. waypointCount .. "_Offset"
                        offsetWaypoint.Size = Vector3.new(2, 2, 2)
                        offsetWaypoint.Position = offsetPos
                        offsetWaypoint.Anchored = true
                        offsetWaypoint.CanCollide = false
                        offsetWaypoint.Transparency = 1
                        offsetWaypoint.Parent = waypointFolder
                        
                        table.insert(allWaypoints, {
                            part = offsetWaypoint,
                            position = offsetPos,
                            room = roomName,
                            index = waypointCount,
                            doorType = doorType,
                            isDoor = true,
                            isOffset = true
                        })
                    end
                end
            end
            
            for _, room in ipairs(currentRooms:GetChildren()) do
                if room:IsA("Model") then
                    for _, child in ipairs(room:GetDescendants()) do
                        if child:IsA("Model") and (child.Name == "Door" or child.Name == "DoorNormal" or child.Name == "SideroomDupe") then
                            processDoor(child, room.Name, child.Name)
                        end
                    end
                end
            end
            
            for _ = 1, math.random(3, 6) do
                for i = #allWaypoints, 2, -1 do
                    local j = math.random(i)
                    allWaypoints[i], allWaypoints[j] = allWaypoints[j], allWaypoints[i]
                end
            end
        end
    end
    
    local a60Model
    local success, result = pcall(function()
        return game:GetObjects("rbxassetid://85615143036194")[1]
    end)
    
    if success and result then
        a60Model = result
        a60Model.Name = "A60"
        a60Model.Parent = Workspace
        
        if #allWaypoints > 0 then
            a60Model:PivotTo(CFrame.new(allWaypoints[1].position + Vector3.new(5, 0, 5)))
        end
    else
        a60Model = Instance.new("Model")
        a60Model.Name = "A60"
        
        local torso = Instance.new("Part")
        torso.Name = "Torso"
        torso.Size = Vector3.new(2, 4, 2)
        torso.Position = Vector3.new(0, 5, 0)
        torso.Anchored = false
        torso.CanCollide = true
        torso.Color = Color3.fromRGB(139, 69, 19)
        torso.Material = Enum.Material.Wood
        torso.Parent = a60Model
        
        a60Model.PrimaryPart = torso
        a60Model.Parent = Workspace
    end
    
    local function addFaceParticleAnimation()
        local faceParticle
        for _, child in ipairs(a60Model:GetDescendants()) do
            if child:IsA("ParticleEmitter") and child.Name == "Face" then
                faceParticle = child
                break
            end
        end
        
        if not faceParticle then
            return
        end
        
        local particleTextures = {
            "rbxassetid://16020415559",
            "rbxassetid://16020423090", 
            "rbxassetid://16020425703",
            "rbxassetid://16020417711",
            "rbxassetid://16020432826",
            "rbxassetid://16020430685",
            "rbxassetid://16020435171"
        }
        
        local currentTextureIndex = 1
        local animationSpeed = 0.1
        local isAnimating = true
        
        local originalTexture = faceParticle.Texture
        local originalEnabled = faceParticle.Enabled
        
        coroutine.wrap(function()
            while a60Model and a60Model.Parent and faceParticle and faceParticle.Parent and isAnimating do
                faceParticle.Enabled = true
                
                faceParticle.Texture = particleTextures[currentTextureIndex]
                
                currentTextureIndex = currentTextureIndex + 1
                if currentTextureIndex > #particleTextures then
                    currentTextureIndex = 1
                end
                
                local currentSpeed = animationSpeed * (0.8 + math.random() * 0.4)
                wait(currentSpeed)
            end
        end)()
        
        local UserInputService = game:GetService("UserInputService")
        UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if gameProcessed then return end
            
            if input.KeyCode == Enum.KeyCode.F then
                isAnimating = not isAnimating
            end
        end)
        
        return {
            setSpeed = function(speed)
                animationSpeed = math.max(0.05, math.min(0.5, speed))
            end,
            stop = function()
                isAnimating = false
                faceParticle.Texture = originalTexture
            end,
            start = function()
                isAnimating = true
            end
        }
    end
    
    local currentWaypointIndex = 1
    local isMoving = true
    local baseSpeed = 60
    local reachedDistance = 8.0
    local smoothFactor = 0.6
    local visitCounts = {}
    local lastVisitTime = {}
    
    for i = 1, #allWaypoints do
        visitCounts[i] = 0
        lastVisitTime[i] = 0
    end
    
    local function getWaypoint()
        if #allWaypoints == 0 then
            return nil, 1
        end
        
        local currentTime = tick()
        local validWaypoints = {}
        
        for i, wp in ipairs(allWaypoints) do
            if wp and wp.part and wp.part.Parent then
                if currentTime - lastVisitTime[i] > 2 then
                    table.insert(validWaypoints, {index = i, waypoint = wp})
                end
            end
        end
        
        if #validWaypoints > 0 then
            local choice = validWaypoints[math.random(1, #validWaypoints)]
            currentWaypointIndex = choice.index
            return choice.waypoint, currentWaypointIndex
        end
        
        for i = 1, #allWaypoints do
            local wp = allWaypoints[i]
            if wp and wp.part and wp.part.Parent then
                currentWaypointIndex = i
                return wp, currentWaypointIndex
            end
        end
        
        return nil, 1
    end
    
    local function checkReachedWaypoint(waypoint)
        if not waypoint or not waypoint.part or not waypoint.part.Parent then
            return false
        end
        
        local monsterPos = a60Model:GetPivot().Position
        local waypointPos = waypoint.position
        local distance = (monsterPos - waypointPos).Magnitude
        
        return distance <= reachedDistance
    end
    
    local lastUpdate = tick()
    local currentTarget, currentIndex = getWaypoint()
    local velocity = Vector3.new(0, 0, 0)
    local wobbleIntensity = 0.15
    local wobbleSpeed = 3.0
    local wobbleTime = 0
    local targetSwitchTime = 0
    local minTargetTime = 1.0
    local maxTargetTime = 5.0
    local speedMultiplier = 1.0
    local zigzagAmount = 0
    local zigzagSpeed = 2.0
    local zigzagIntensity = 0.3

    coroutine.wrap(function()
        wait(60)
        
        for _, waypoint in ipairs(allWaypoints) do
            if not waypoint.isOnePart and waypoint.part and waypoint.part.Parent then
                waypoint.part:Destroy()
            end
        end
        
        if a60Model and a60Model.Parent then
            a60Model:Destroy()
        end
        
        if waypointFolder and waypointFolder.Parent then
            waypointFolder:Destroy()
        end
    end)()

    coroutine.wrap(function()
        while a60Model and a60Model.Parent do
            local deltaTime = math.min(tick() - lastUpdate, 0.033)
            lastUpdate = tick()
            wobbleTime = wobbleTime + deltaTime * wobbleSpeed
            zigzagAmount = zigzagAmount + deltaTime * zigzagSpeed
            
            if isMoving and currentTarget then
                local monsterCFrame = a60Model:GetPivot()
                local monsterPos = monsterCFrame.Position
                local targetPos = currentTarget.position
                
                local direction = (targetPos - monsterPos)
                local distance = direction.Magnitude
                
                if distance > 0.1 then
                    local moveDirection = direction.Unit
                    
                    local targetSpeed = baseSpeed * speedMultiplier
                    
                    if math.random() < 0.4 then
                        speedMultiplier = 0.7 + math.random() * 1.3
                    end
                    
                    if distance < 20 then
                        targetSpeed = targetSpeed * 0.8
                    elseif distance > 40 then
                        targetSpeed = targetSpeed * 1.4
                    end
                    
                    if tick() - targetSwitchTime > minTargetTime + math.random() * (maxTargetTime - minTargetTime) then
                        if math.random() < 0.6 then
                            currentTarget, currentIndex = getWaypoint()
                            targetSwitchTime = tick()
                        end
                    end
                    
                    local zigzagOffset = Vector3.new(
                        math.sin(zigzagAmount) * zigzagIntensity,
                        0,
                        math.cos(zigzagAmount * 0.7) * zigzagIntensity * 0.5
                    )
                    
                    moveDirection = (moveDirection + zigzagOffset * 0.1).Unit
                    
                    local targetVelocity = moveDirection * targetSpeed
                    velocity = velocity:Lerp(targetVelocity, smoothFactor)
                    
                    local wobbleOffset = Vector3.new(
                        math.sin(wobbleTime) * wobbleIntensity * 2.0,
                        math.cos(wobbleTime * 1.3) * wobbleIntensity * 1.0,
                        math.cos(wobbleTime * 0.9) * wobbleIntensity * 1.5
                    )
                    
                    local newPosition = monsterPos + (velocity * deltaTime) + wobbleOffset
                    
                    if moveDirection.Magnitude > 0.1 then
                        local yawOffset = math.rad(math.sin(wobbleTime * 0.7) * 8)
                        local pitchOffset = math.rad(math.cos(wobbleTime * 1.1) * 6)
                        local rollOffset = math.rad(math.sin(wobbleTime * 1.4) * 4)
                        
                        local rotatedDirection = CFrame.Angles(pitchOffset, yawOffset, rollOffset) * moveDirection
                        
                        local lookAtCFrame = CFrame.lookAt(newPosition, newPosition + rotatedDirection)
                        a60Model:PivotTo(lookAtCFrame)
                    end
                    
                    if checkReachedWaypoint(currentTarget) then
                        if currentIndex then
                            visitCounts[currentIndex] = (visitCounts[currentIndex] or 0) + 1
                            lastVisitTime[currentIndex] = tick()
                        end
                        
                        wait(math.random(0.05, 0.2))
                        
                        if math.random() < 0.8 then
                            currentTarget, currentIndex = getWaypoint()
                            targetSwitchTime = tick()
                        end
                        
                        velocity = velocity * 0.2
                    end
                else
                    if currentIndex then
                        visitCounts[currentIndex] = (visitCounts[currentIndex] or 0) + 1
                        lastVisitTime[currentIndex] = tick()
                    end
                    
                    wait(math.random(0.05, 0.2))
                    currentTarget, currentIndex = getWaypoint()
                    targetSwitchTime = tick()
                    velocity = Vector3.new(0, 0, 0)
                end
            end
            
            RunService.RenderStepped:Wait()
        end
    end)()
    
    local UserInputService = game:GetService("UserInputService")
    
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if input.KeyCode == Enum.KeyCode.R then
            currentTarget, currentIndex = getWaypoint()
            isMoving = true
            velocity = Vector3.new(0, 0, 0)
            speedMultiplier = 1.0
            
            for i = 1, #allWaypoints do
                visitCounts[i] = 0
                lastVisitTime[i] = 0
            end
            
            if #allWaypoints > 0 then
                a60Model:PivotTo(CFrame.new(allWaypoints[1].position + Vector3.new(5, 0, 5)))
            end
            
        elseif input.KeyCode == Enum.KeyCode.T then
            isMoving = not isMoving
            if isMoving then
                velocity = Vector3.new(0, 0, 0)
            end
        end
    end)
end

-- 5. A60-50 (对话)
function entityBehaviors.runA6050()
    require(game.Players.LocalPlayer.PlayerGui.MainUI.Initiator.Main_Game).caption("你认为我走了?",true)
    wait(2)
    require(game.Players.LocalPlayer.PlayerGui.MainUI.Initiator.Main_Game).caption("我不会这么轻易放过你.",true)
end

-- 6. A500
function entityBehaviors.runA500()
    local function main()
        local targetAudioUrl = "https://github.com/Zero0Star/RipperMPSound/blob/master/A500Moving.mp3?raw=true"
        local volume = 2
        local localFileName = "A500MUSIC"
        
        local sound = CustomGitSound(targetAudioUrl, volume, localFileName)

        game.ReplicatedStorage.GameData.LatestRoom.Changed:Wait()

        sound:Play()
        
        local entity = spawner.Create({
            Entity = {
                Name = "A500",
                Asset = "121633960606961",
                HeightOffset = 0.3
            },
            Lights = {
                Flicker = {
                    Enabled = false,
                    Duration = 10
                },
                Shatter = false,
                Repair = false
            },
            Earthquake = {
                Enabled = false
            },
            CameraShake = {
                Enabled = true,
                Range = 200,
                Values = {1.5, 20, 0.1, 1}
            },
            Movement = {
                Speed = 90,
                Delay = 25,
                Reversed = false
            },
            Rebounding = {
                Enabled = true,
                Type = "ambush",
                Min = 30,
                Max = 30,
                Delay = math.random(10, 30) / 10
            },
            Damage = {
                Enabled = true,
                Range = 20,
                Amount = 50
            },
            Crucifixion = {
                Enabled = false,
                Range = 20,
                Resist = false,
                Break = true
            },
            Death = {
                Type = "Guiding",
                Hints = {"你死于A500", "这是很坏的结局", "你需要不停的跑!", "保证自己在两分钟内不被追上"},
                Cause = ""
            }
        })
        
        entity:SetCallback("OnRebounding", function(startOfRebound)
            local entityModel = entity.Model
            local main = entityModel:WaitForChild("Main")
            local attachment = main:WaitForChild("Attachment")
            local AttachmentSwitch = main:WaitForChild("AttachmentSwitch")
            local sounds = {
                footsteps = main:WaitForChild("Footsteps"),
                playSound = main:WaitForChild("PlaySound"),
                switch = main:WaitForChild("Switch"),
                switchBack = main:WaitForChild("SwitchBack")
            }
            
            for _, c in attachment:GetChildren() do
                c.Enabled = (not startOfRebound)
            end
            for _, c in AttachmentSwitch:GetChildren() do
                c.Enabled = startOfRebound
            end
            
            if startOfRebound == true then
                sounds.footsteps.PlaybackSpeed = 0.35
                sounds.playSound.PlaybackSpeed = 0.25
                sounds.switch:Play()
            else
                sounds.footsteps.PlaybackSpeed = 0.25
                sounds.playSound.PlaybackSpeed = 0.16
                sounds.switchBack:Play()
            end
        end)
        
        entity:Run()
        
        local face = workspace:WaitForChild("A500"):WaitForChild("RushNew"):WaitForChild("Main"):WaitForChild("Face")
        if face and face:IsA("ParticleEmitter") then
            task.spawn(function()
                local textures = {
                    "rbxassetid://109080249848293",
                    "rbxassetid://138164251853595",
                    "rbxassetid://129267921615075",
                    "rbxassetid://138164251853595",
                    "rbxassetid://102573027299916"
                }
                while true do
                    for _, texture in ipairs(textures) do
                        face.Texture = texture
                        task.wait(0.1)
                    end
                end
            end)
        end
        
        task.wait(15)
        
        local Event = game:GetService("ReplicatedStorage").RemotesFolder.AdminPanelRunCommand
        
        Event:FireServer(
            "Apply Changes",
            {
                Players = {
                    QWQ75321 = "QWQ75321",
                    sppvve = "sppvve"
                },
                ["Max Health"] = 100,
                ["Allow Sliding"] = true,
                ["Star Shield"] = 100,
                ["Speed Boost"] = 20,
                Health = 100,
                ["Allow Jumping"] = true,
                ["God Mode"] = true
            }
        )
        
        Event:FireServer(
            "Give Items",
            {
                Players = {
                    sppvve = "sppvve",
                    QWQ75321 = "QWQ75321"
                },
                Items = {
                    Multitool = "Multitool"
                }
            }
        )
        
        if sound and sound.IsPlaying then
            sound.Ended:Wait()
        end
        
        local a500Model = workspace:FindFirstChild("A500")
        if a500Model then
            a500Model:Destroy()
        end
        
        Event:FireServer(
            "Apply Changes",
            {
                Players = {
                    QWQ75321 = "QWQ75321",
                    sppvve = "sppvve"
                },
                ["Max Health"] = 100,
                ["Allow Sliding"] = false,
                ["Star Shield"] = 0,
                ["Speed Boost"] = 0,
                Health = 100,
                ["Allow Jumping"] = false,
                ["God Mode"] = false
            }
        )
        
        if sound then
            sound:Destroy()
        end
    end
    
    local success, err = pcall(main)
    if not success then
        -- 错误处理
    end
end

-- 7. X-Bramble
function entityBehaviors.runXBramble()
    local targetModel = workspace:WaitForChild("LiveEntityBramble", 5)
    if not targetModel then
        return
    end

    local ModelID = 87341133560380

    local success, modelData = pcall(function()
        return game:GetObjects("rbxassetid://" .. ModelID)
    end)

    if not success or #modelData == 0 then
        return
    end

    local NewModel = modelData[1]:Clone()
    NewModel.Parent = workspace
    NewModel.Name = "LiveEntityBramble1"

    for _, part in ipairs(NewModel:GetDescendants()) do
        if part:IsA("BasePart") or part:IsA("MeshPart") or part:IsA("Part") then
            part.Transparency = 0
            part.CanCollide = true
        end
    end

    local partsToCopy = {
        "RightArm",
        "LeftArm", 
        "Head"
    }

    local copiedParts = {}

    for _, partName in ipairs(partsToCopy) do
        local sourcePart = NewModel:FindFirstChild(partName, true)
        
        if sourcePart then
            if sourcePart:IsA("Model") then
                for _, child in ipairs(sourcePart:GetDescendants()) do
                    if child:IsA("BasePart") or child:IsA("MeshPart") then
                        -- 可以添加代码
                    end
                end
            end

            local clonedPart = sourcePart:Clone()
            clonedPart.Parent = targetModel

            local existingPart = targetModel:FindFirstChild(partName)
            if existingPart then
                clonedPart.Name = partName .. "_New"
            else
                clonedPart.Name = partName
            end

            if clonedPart:IsA("BasePart") or clonedPart:IsA("MeshPart") then
                clonedPart.Transparency = 0
                clonedPart.CanCollide = true
            end
            
            table.insert(copiedParts, clonedPart)
        else
            for _, child in ipairs(NewModel:GetChildren()) do
                -- 可以添加代码
            end
        end
    end

    local originalHead = targetModel:FindFirstChild("Head")
    if originalHead then
        if originalHead:IsA("BasePart") or originalHead:IsA("MeshPart") then
            originalHead.Transparency = 1
            originalHead.CanCollide = false
        elseif originalHead:IsA("Model") then
            for _, part in ipairs(originalHead:GetDescendants()) do
                if part:IsA("BasePart") or part:IsA("MeshPart") then
                    part.Transparency = 1
                    part.CanCollide = false
                end
            end
        end
    end

    local RunService = game:GetService("RunService")
    local followConnection
    followConnection = RunService.Heartbeat:Connect(function()
        if not targetModel or not targetModel.Parent or not NewModel or not NewModel.Parent then
            if followConnection then
                followConnection:Disconnect()
            end
            return
        end

        local mainPartTarget = targetModel.PrimaryPart or targetModel:FindFirstChild("HumanoidRootPart") or 
                               targetModel:FindFirstChild("Torso") or targetModel:FindFirstChildWhichIsA("BasePart")
        
        local mainPartNew = NewModel.PrimaryPart or NewModel:FindFirstChild("HumanoidRootPart") or 
                           NewModel:FindFirstChild("Torso") or NewModel:FindFirstChildWhichIsA("BasePart")
        
        if mainPartTarget and mainPartNew then
            mainPartNew.CFrame = mainPartTarget.CFrame
        end
    end)

    task.wait(1)

    for _, part in ipairs(NewModel:GetDescendants()) do
        if part:IsA("BasePart") or part:IsA("MeshPart") or part:IsA("Part") then
            part.Transparency = 1
            part.CanCollide = false
        end
    end

    local model = workspace.LiveEntityBramble
    local rightArm = model:FindFirstChild("RightArm", true)
    local darkGrayColor = Color3.fromRGB(36, 36, 36) 

    if rightArm then
        for _, part in ipairs(rightArm:GetDescendants()) do
            if part:IsA("BasePart") or part:IsA("MeshPart") then
                part.Color = darkGrayColor
            end
        end
    end
    
    wait(1)
    
    local model = workspace.LiveEntityBramble
    local LeftLeg = model:FindFirstChild("LeftLeg", true)
    local darkGrayColor = Color3.fromRGB(36, 36, 36) 

    if LeftLeg then
        for _, part in ipairs(LeftLeg:GetDescendants()) do
            if part:IsA("BasePart") or part:IsA("MeshPart") then
                part.Color = darkGrayColor
            end
        end
    end
    
    wait(1)
    
    local model = workspace.LiveEntityBramble
    local RightLeg = model:FindFirstChild("RightLeg", true)
    local darkGrayColor = Color3.fromRGB(14, 14, 14) 

    if RightLeg then
        for _, part in ipairs(RightLeg:GetDescendants()) do
            if part:IsA("BasePart") or part:IsA("MeshPart") then
                part.Color = darkGrayColor
            end
        end
    end
    
    wait(0.5)
    
    local model = workspace.LiveEntityBramble
    local Torso = model:FindFirstChild("Torso", true)
    local darkGrayColor = Color3.fromRGB(14, 14, 14) 

    if Torso then
        for _, part in ipairs(Torso:GetDescendants()) do
            if part:IsA("BasePart") or part:IsA("MeshPart") then
                part.Color = darkGrayColor
            end
        end
    end
    
    wait(0.5)
    
    local model = workspace.LiveEntityBramble
    local LeftArm = model:FindFirstChild("LeftArm", true)
    local darkGrayColor = Color3.fromRGB(14, 14, 14) 

    if LeftArm then
        for _, part in ipairs(LeftArm:GetDescendants()) do
            if part:IsA("BasePart") or part:IsA("MeshPart") then
                part.Color = darkGrayColor
            end
        end
    end

    local targetModel = workspace:WaitForChild("LiveEntityBramble", 5)
    if not targetModel then
        return
    end

    local targetColor = Color3.fromRGB(160, 0, 0)

    local pointLights = {}
    local changedLights = 0

    for _, light in ipairs(targetModel:GetDescendants()) do
        if light:IsA("PointLight") then
            table.insert(pointLights, {
                instance = light,
                originalColor = light.Color, 
                originalBrightness = light.Brightness,
                originalRange = light.Range
            })
        end
    end

    if #pointLights == 0 then
        local lightTypes = {}
        for _, child in ipairs(targetModel:GetDescendants()) do
            if child:IsA("Light") then
                local typeName = child.ClassName
                if not lightTypes[typeName] then
                    lightTypes[typeName] = true
                end
            end
        end
        return
    end

    for _, data in ipairs(pointLights) do
        local light = data.instance

        light.Color = targetColor
        light.Brightness = 5
        light.Range = 10      
        changedLights = changedLights + 1
    end

    task.wait(0.5)

    local correctCount = 0
    local incorrectCount = 0

    for _, data in ipairs(pointLights) do
        local light = data.instance
        local r = math.floor(light.Color.R * 255)
        local g = math.floor(light.Color.G * 255)
        local b = math.floor(light.Color.B * 255)
        
        if r == 160 and g == 0 and b == 0 then
            correctCount = correctCount + 1
        else
            incorrectCount = incorrectCount + 1
        end
    end
    
    local targetModel = workspace:WaitForChild("LiveEntityBramble", 5)
    if not targetModel then
        return
    end
    
    local targetColor = Color3.fromRGB(255, 0, 0)

    local particlePaths = {
        "Head.LanternNeon.Attachment.CenterAttach.CenterAttach",
        "Head.UpperHead.Glass.FliesParticles"
    }

    local changedParticles = 0

    for _, path in ipairs(particlePaths) do
        local parts = {}
        for part in path:gmatch("([^.]+)") do
            table.insert(parts, part)
        end

        local current = targetModel
        local found = true
        
        for i, partName in ipairs(parts) do
            current = current:FindFirstChild(partName)
            if not current then
                found = false
                break
            end
        end
        
        if found and current:IsA("ParticleEmitter") then
            local originalColor = nil
            if current.Color and current.Color.Keypoints and #current.Color.Keypoints > 0 then
                originalColor = current.Color.Keypoints[1].Value
            end

            local redColorSequence = ColorSequence.new(targetColor)
            current.Color = redColorSequence

            current.Lifetime = NumberRange.new(1, 2)
            current.Rate = 50
            current.Speed = NumberRange.new(5, 10)

            current.Size = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.1),
                NumberSequenceKeypoint.new(0.5, 0.3),
                NumberSequenceKeypoint.new(1, 0)
            })

            current.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.2),
                NumberSequenceKeypoint.new(0.5, 0.1),
                NumberSequenceKeypoint.new(1, 1)
            })
            
            changedParticles = changedParticles + 1
        elseif found then
            for _, particle in ipairs(current:GetDescendants()) do
                if particle:IsA("ParticleEmitter") then
                    particle.Color = ColorSequence.new(targetColor)
                    particle.Rate = 50
                    changedParticles = changedParticles + 1
                end
            end
        end
    end

    local model = workspace:WaitForChild("LiveEntityBramble")
    local targetColor = Color3.fromRGB(255, 0, 0)

    local function findAndModifyParticle(path)
        local parts = path:split("-")
        local current = model
        
        for _, partName in ipairs(parts) do
            current = current:FindFirstChild(partName)
            if not current then 
                return false 
            end
        end
        
        if current and current:IsA("ParticleEmitter") then
            current.Color = ColorSequence.new(targetColor)
            return true
        end
        
        return false
    end

    findAndModifyParticle("Head-LanternNeon-Attachment-CenterAttach-LightCenterParticle")

    local model = workspace:WaitForChild("LiveEntityBramble")
    local lowerHead = model:FindFirstChild("LowerHead", true)
    if lowerHead then
        if lowerHead:IsA("BasePart") or lowerHead:IsA("MeshPart") then
            lowerHead.Transparency = 1
        end
        for _, part in ipairs(lowerHead:GetDescendants()) do
            if part:IsA("BasePart") or part:IsA("MeshPart") then
                part.Transparency = 1
            end
        end
    end

    local model = workspace:WaitForChild("LiveEntityBramble")
    local head = model:FindFirstChild("Head", true)

    if head then
        local tongue = head:FindFirstChild("Tongue", true)
        if tongue then
            if tongue:IsA("BasePart") or tongue:IsA("MeshPart") then
                tongue.Color = Color3.fromRGB(0, 0, 0)
            elseif tongue:IsA("Model") then
                for _, part in ipairs(tongue:GetDescendants()) do
                    if part:IsA("BasePart") or part:IsA("MeshPart") then
                        part.Color = Color3.fromRGB(0, 0, 0)
                    end
                end
            end
        end

        local lanternNeon = head:FindFirstChild("LanternNeon", true)
        if lanternNeon then
            if lanternNeon:IsA("BasePart") or lanternNeon:IsA("MeshPart") then
                lanternNeon.Color = Color3.fromRGB(168, 0, 0)
            elseif lanternNeon:IsA("Model") then
                for _, part in ipairs(lanternNeon:GetDescendants()) do
                    if part:IsA("BasePart") or part:IsA("MeshPart") then
                        part.Color = Color3.fromRGB(168, 0, 0)
                    end
                end
            end
        end
    end

    local model = workspace:WaitForChild("LiveEntityBramble")
    local head = model:FindFirstChild("Head", true)
    local lowerHead = head and head:FindFirstChild("LowerHead", true)

    if lowerHead then
        local newModel = game:GetObjects("rbxassetid://77857688443174")[1]:Clone()
        newModel.Parent = lowerHead
        newModel.Name = "PART"
    end
    
    wait(1)
    
    local PART = workspace.LiveEntityBramble.Head.LowerHead.PART
    local target = workspace.LiveEntityBramble:FindFirstChild("Head", true):FindFirstChild("LowerHead", true)
    local RunService = game:GetService("RunService")

    if PART and target then
        local targetPart = target:IsA("BasePart") and target or target:FindFirstChildWhichIsA("BasePart")
        RunService.Heartbeat:Connect(function()
            PART.CFrame = targetPart.CFrame
        end)
    end
end

function entityBehaviors.runA200()
    local entity = spawner.Create({
        Entity = {
            Name = "A-200",
            Asset = "103526452499813",
            HeightOffset = 1
        },
        Lights = {
            Flicker = {
                Enabled = false,
                Duration = 10
            },
            Shatter = false,
            Repair = false
        },
        Earthquake = {
            Enabled = false
        },
        CameraShake = {
            Enabled = true,
            Range = 200,
            Values = {1.5, 20, 0.1, 1}
        },
        Movement = {
            Speed = 60,
            Delay = 5,
            Reversed = true
        },
        Rebounding = {
            Enabled = false,
            Type = "ambush",
            Min = 4,
            Max = 4,
            Delay = math.random(10, 30) / 10
        },
        Damage = {
            Enabled = true,
            Range = 100,
            Amount = 1
        },
        Crucifixion = {
            Enabled = true,
            Range = 100,
            Resist = false,
            Break = true
        },
        Death = {
            Type = "Guiding",
            Hints = {"你死于A-200", "竖起耳朵仔细辨别是一个麻烦", "但你不得不这么做", "你或许会在寂静那学到点什么"},
            Cause = ""
        }
    })
    
    entity:SetCallback("OnRebounding", function(startOfRebound)
        local entityModel = entity.Model
        local main = entityModel:WaitForChild("Main")
        local attachment = main:WaitForChild("Attachment")
        local AttachmentSwitch = main:WaitForChild("AttachmentSwitch")
        local sounds = {
            footsteps = main:WaitForChild("Footsteps"),
            playSound = main:WaitForChild("PlaySound"),
            switch = main:WaitForChild("Switch"),
            switchBack = main:WaitForChild("SwitchBack")
        }

        for _, c in attachment:GetChildren() do
            c.Enabled = (not startOfRebound)
        end
        for _, c in AttachmentSwitch:GetChildren() do
            c.Enabled = startOfRebound
        end

        if startOfRebound == true then
            sounds.footsteps.PlaybackSpeed = 0.35
            sounds.playSound.PlaybackSpeed = 0.25
            sounds.switch:Play()
        else
            sounds.footsteps.PlaybackSpeed = 0.25
            sounds.playSound.PlaybackSpeed = 0.16
            sounds.switchBack:Play()
        end
    end)

    entity:Run()

    local sound = Instance.new("Sound")
    sound.Name = "A200"
    sound.SoundId = "rbxassetid://2306939610"
    sound.Volume = 0.1
    sound.Looped = true
    sound.Parent = workspace
    sound:Play()

    task.wait(10)
    sound:Stop()
    sound:Destroy()
end

-- 9. Amin-60
function entityBehaviors.runAmin60()
    local entity = spawner.Create({
        Entity = {
            Name = "Amin-60",
            Asset = "134290844453819",
            HeightOffset = 0.8
        },
        Lights = {
            Flicker = {
                Enabled = false,
                Duration = 10
            },
            Shatter = true,
            Repair = false
        },
        Earthquake = {
            Enabled = false
        },
        CameraShake = {
            Enabled = true,
            Range = 200,
            Values = {1.5, 20, 0.1, 1}
        },
        Movement = {
            Speed = 400,
            Delay = 6.5,
            Reversed = false
        },
        Rebounding = {
            Enabled = true,
            Type = "ambush",
            Min = 10,
            Max = 10,
            Delay = math.random(10, 30) / 10
        },
        Damage = {
            Enabled = true,
            Range = 100,
            Amount = 125
        },
        Crucifixion = {
            Enabled = true,
            Range = 100,
            Resist = false,
            Break = true
        },
        Death = {
            Type = "Guiding",
            Hints = {"你死于Amin-60", "极大的嘈杂声会掩盖其他声音", "他比A60更加迅速敏捷", "仔细听取木板碎裂的声音"},
            Cause = ""
        }
    })
    
    entity:SetCallback("OnRebounding", function(startOfRebound)
        local entityModel = entity.Model
        local main = entityModel:WaitForChild("Main")
        local attachment = main:WaitForChild("Attachment")
        local AttachmentSwitch = main:WaitForChild("AttachmentSwitch")
        local sounds = {
            footsteps = main:WaitForChild("Footsteps"),
            playSound = main:WaitForChild("PlaySound"),
            switch = main:WaitForChild("Switch"),
            switchBack = main:WaitForChild("SwitchBack")
        }

        for _, c in attachment:GetChildren() do
            c.Enabled = (not startOfRebound)
        end
        for _, c in AttachmentSwitch:GetChildren() do
            c.Enabled = startOfRebound
        end

        if startOfRebound == true then
            sounds.footsteps.PlaybackSpeed = 0.35
            sounds.playSound.PlaybackSpeed = 0.25
            sounds.switch:Play()
        else
            sounds.footsteps.PlaybackSpeed = 0.25
            sounds.playSound.PlaybackSpeed = 0.16
            sounds.switchBack:Play()
        end
    end)

    entity:Run()
end

-- 10. Black-A60
function entityBehaviors.runBlackA60()
    local entity = spawner.Create({
        Entity = {
            Name = "Black-A60",
            Asset = "96102326082560",
            HeightOffset = 0
        },
        Lights = {
            Flicker = {
                Enabled = false,
                Duration = 10
            },
            Shatter = true,
            Repair = false
        },
        Earthquake = {
            Enabled = false
        },
        CameraShake = {
            Enabled = true,
            Range = 200,
            Values = {1.5, 20, 0.1, 1}
        },
        Movement = {
            Speed = 350,
            Delay = 6.5,
            Reversed = false
        },
        Rebounding = {
            Enabled = true,
            Type = "ambush",
            Min = 10,
            Max = 10,
            Delay = math.random(10, 30) / 10
        },
        Damage = {
            Enabled = true,
            Range = 100,
            Amount = 125
        },
        Crucifixion = {
            Enabled = true,
            Range = 100,
            Resist = false,
            Break = true
        },
        Death = {
            Type = "Guiding",
            Hints = {"你死于BlackA60", "极大的嘈杂声会掩盖其他声音", "在不妥时使用十字架会更方便", "反复进柜子躲避它"},
            Cause = ""
        }
    })
    
    entity:SetCallback("OnRebounding", function(startOfRebound)
        local entityModel = entity.Model
        local main = entityModel:WaitForChild("Main")
        local attachment = main:WaitForChild("Attachment")
        local AttachmentSwitch = main:WaitForChild("AttachmentSwitch")
        local sounds = {
            footsteps = main:WaitForChild("Footsteps"),
            playSound = main:WaitForChild("PlaySound"),
            switch = main:WaitForChild("Switch"),
            switchBack = main:WaitForChild("SwitchBack")
        }

        for _, c in attachment:GetChildren() do
            c.Enabled = (not startOfRebound)
        end
        for _, c in AttachmentSwitch:GetChildren() do
            c.Enabled = startOfRebound
        end

        if startOfRebound == true then
            sounds.footsteps.PlaybackSpeed = 0.35
            sounds.playSound.PlaybackSpeed = 0.25
            sounds.switch:Play()
        else
            sounds.footsteps.PlaybackSpeed = 0.25
            sounds.playSound.PlaybackSpeed = 0.16
            sounds.switchBack:Play()
        end
    end)
    
    entity:Run()
end

-- 16. CUR 实体合集
function entityBehaviors.runCUR()
    -- 文档中的完整 CUR.lua 内容
    -- 包含所有实体的监听和触发逻辑
    local checkedEntities = {}
    local listeningSounds = {}

    local function runEvent()
        local modelID = 90889178594108
        local targetName = "Repentance_Skinned"
        local loadedModel = nil
        local targetModel = nil
        local anchorPart = nil
        local connections = {}
        local isFollowing = false
        local fadeStartTime = nil
        local isFading = false
        local isProcessing = false
        local processedModels = {}

        local RunService = game:GetService("RunService")
        local ReplicatedStorage = game:GetService("ReplicatedStorage")

        local cachedModel
        local function preloadModel()
            if cachedModel and cachedModel.Parent then
                cachedModel:Destroy()
                cachedModel = nil
            end
            
            local success, result = pcall(function()
                return game:GetObjects("rbxassetid://" .. tostring(modelID))
            end)
            
            if not success or not result or not result[1] then
                return nil
            end
            
            cachedModel = result[1]
            cachedModel.Name = "Preloaded_VFX_Model"
            cachedModel.Parent = ReplicatedStorage
            
            for _, part in ipairs(cachedModel:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Anchored = true
                    part.CanCollide = false
                    part.CanTouch = false
                    part.CanQuery = false
                    part.Massless = true
                end
            end
            
            return cachedModel
        end

        local function getModelFromCache()
            if not cachedModel or not cachedModel.Parent then
                return nil
            end
            
            local modelClone = cachedModel:Clone()
            modelClone.Parent = workspace
            modelClone.Name = "Follow_Model"
            
            return modelClone
        end

        local function createAnchorAtEntity()
            if not targetModel or not targetModel.Parent then 
                return nil 
            end
            
            local entity = targetModel:FindFirstChild("Entity")
            if not entity then
                return nil
            end
            
            local anchor = Instance.new("Part")
            anchor.Name = "Entity_Anchor"
            anchor.Size = Vector3.new(0.01, 0.01, 0.01)
            anchor.Transparency = 1
            anchor.Anchored = true
            anchor.CanCollide = false
            anchor.CanTouch = false
            anchor.CanQuery = false
            anchor.Massless = true
            anchor.CFrame = entity.CFrame + Vector3.new(0, 6.5, 0)
            anchor.Parent = workspace
            
            return anchor
        end

        local function deleteTargetParts()
            if not targetModel or not targetModel.Parent then return end
            
            local crucifix = targetModel:FindFirstChild("Crucifix")
            if crucifix then
                crucifix:Destroy()
            end
        end

        local function playAudioOnce()
            if not cachedModel or not cachedModel.Parent then
                return
            end
            
            local reversalRed = cachedModel:FindFirstChild("Reversal Red")
            if not reversalRed then
                for _, descendant in ipairs(cachedModel:GetDescendants()) do
                    if descendant.Name:lower() == "reversal red" then
                        reversalRed = descendant
                        break
                    end
                end
            end
            
            if reversalRed then
                local doorsCrucifix = reversalRed:FindFirstChild("doors crucifix")
                if not doorsCrucifix then
                    for _, descendant in ipairs(reversalRed:GetDescendants()) do
                        if descendant:IsA("Sound") and descendant.Name:lower() == "doors crucifix" then
                            doorsCrucifix = descendant
                            break
                        end
                    end
                end
                
                if doorsCrucifix and doorsCrucifix:IsA("Sound") then
                    local sound = doorsCrucifix:Clone()
                    sound.Parent = workspace
                    sound:Play()
                    
                    sound.Ended:Connect(function()
                        if sound and sound.Parent then
                            sound:Destroy()
                        end
                    end)
                end
            end
        end

        local function loadModel()
            if loadedModel and loadedModel.Parent then
                loadedModel:Destroy()
                loadedModel = nil
            end
            
            local model = getModelFromCache()
            
            if model then
                playAudioOnce()
            end
            
            return model
        end

        local function fadeOutModel()
            if not loadedModel or not loadedModel.Parent then return end
            
            isFading = true
            local fadeDuration = 2
            local startTime = tick()
            
            while loadedModel and loadedModel.Parent and tick() - startTime < fadeDuration do
                local progress = (tick() - startTime) / fadeDuration
                
                for _, part in ipairs(loadedModel:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.Transparency = progress
                    elseif part:IsA("ParticleEmitter") then
                        part.Rate = part.Rate * (1 - progress)
                    end
                end
                
                RunService.Heartbeat:Wait()
            end
            
            if loadedModel and loadedModel.Parent then
                loadedModel:Destroy()
                loadedModel = nil
            end
            
            isFading = false
            isProcessing = false
            
            if anchorPart and anchorPart.Parent then
                anchorPart:Destroy()
                anchorPart = nil
            end
            
            for _, conn in pairs(connections) do
                pcall(function() conn:Disconnect() end)
            end
            connections = {}
            
            delay(0.5, function()
                if cachedModel and cachedModel.Parent then
                    cachedModel:Destroy()
                    cachedModel = nil
                end
            end)
        end

        local function followTarget()
            if not anchorPart or not anchorPart.Parent or not loadedModel or not loadedModel.Parent then
                isFollowing = false
                return
            end
            
            isFollowing = true
            loadedModel:PivotTo(anchorPart.CFrame)
            fadeStartTime = tick()
            
            while isFollowing and anchorPart and anchorPart.Parent and loadedModel and loadedModel.Parent do
                RunService.Heartbeat:Wait()
                
                loadedModel:PivotTo(anchorPart.CFrame)
                
                if not isFading and tick() - fadeStartTime >= 8 then
                    fadeOutModel()
                end
            end
        end

        local function processTarget()
            if isProcessing or processedModels[targetModel] then
                return
            end
            
            local entity = targetModel:FindFirstChild("Entity")
            if not entity then
                return
            end
            
            processedModels[targetModel] = true
            isProcessing = true
            isFollowing = false
            isFading = false
            fadeStartTime = nil
            
            for _, conn in pairs(connections) do
                pcall(function() conn:Disconnect() end)
            end
            connections = {}
            
            if loadedModel and loadedModel.Parent then
                loadedModel:Destroy()
                loadedModel = nil
            end
            
            if anchorPart and anchorPart.Parent then
                anchorPart:Destroy()
                anchorPart = nil
            end
            
            if not targetModel or not targetModel.Parent or not targetModel:IsA("Model") then
                processedModels[targetModel] = nil
                isProcessing = false
                return
            end
            
            deleteTargetParts()
            anchorPart = createAnchorAtEntity()
            
            if not anchorPart then
                processedModels[targetModel] = nil
                isProcessing = false
                return
            end
            
            loadedModel = loadModel()
            if not loadedModel then
                anchorPart:Destroy()
                anchorPart = nil
                processedModels[targetModel] = nil
                isProcessing = false
                return
            end
            
            local conn1 = targetModel.AncestryChanged:Connect(function(_, parent)
                if not parent then
                    isFollowing = false
                    if loadedModel and loadedModel.Parent then
                        loadedModel:Destroy()
                        loadedModel = nil
                    end
                    if anchorPart and anchorPart.Parent then
                        anchorPart:Destroy()
                        anchorPart = nil
                    end
                end
            end)
            
            local conn2 = loadedModel.AncestryChanged:Connect(function(_, parent)
                if not parent then
                    isFollowing = false
                    loadedModel = nil
                end
            end)
            
            local conn3 = anchorPart.AncestryChanged:Connect(function(_, parent)
                if not parent then
                    isFollowing = false
                    anchorPart = nil
                end
            end)
            
            table.insert(connections, conn1)
            table.insert(connections, conn2)
            table.insert(connections, conn3)
            
            coroutine.wrap(followTarget)()
        end

        workspace.DescendantAdded:Connect(function(descendant)
            if descendant.Name == "Entity" then
                local model = descendant.Parent
                if model and model.Name == targetName and model:IsA("Model") and not processedModels[model] and not isProcessing then
                    wait(0.1)
                    targetModel = model
                    processTarget()
                end
            end
            
            if descendant.Name == targetName and descendant:IsA("Model") and not processedModels[descendant] and not isProcessing then
                wait(0.2)
                local entity = descendant:FindFirstChild("Entity")
                if entity then
                    targetModel = descendant
                    processTarget()
                end
            end
        end)

        local preloadSuccess = pcall(preloadModel)
        if not preloadSuccess or not cachedModel then
            return
        end

        wait(2)
    end

    local function checkSound(sound)
        if sound:IsA("Sound") and sound.SoundId == "rbxassetid://92260310162120" then
            local parent = sound.Parent
            if parent and parent.Name == "Scary Entity" then
                local grandParent = parent.Parent
                if grandParent and grandParent.Name == "CustomEntity" then
                    if not checkedEntities[grandParent] then
                        checkedEntities[grandParent] = true
                        runEvent()
                    end
                end
            end
        end
    end

    workspace.DescendantAdded:Connect(function(obj)
        wait(0.1)
        if obj:IsA("Sound") then
            checkSound(obj)
            if not listeningSounds[obj] then
                listeningSounds[obj] = true
                obj:GetPropertyChangedSignal("SoundId"):Connect(function()
                    checkSound(obj)
                end)
            end
        end
    end)

    for _, entity in pairs(workspace:GetChildren()) do
        if entity.Name == "CustomEntity" then
            local scary = entity:FindFirstChild("Scary Entity")
            if scary then
                for _, child in pairs(scary:GetChildren()) do
                    if child:IsA("Sound") then
                        checkSound(child)
                        if not listeningSounds[child] then
                            listeningSounds[child] = true
                            child:GetPropertyChangedSignal("SoundId"):Connect(function()
                                checkSound(child)
                            end)
                        end
                    end
                end
            end
        end
    end
    ------------------
    local checkedEntities = {}
    local listeningSounds = {}

    local function runEvent()
        local achievementGiver = loadstring(game:HttpGet("https://raw.githubusercontent.com/RegularVynixu/Utilities/main/Doors/Custom%20Achievements/Source.lua"))()
    achievementGiver({
    Title = "Mouth Close Ear Open",
    Desc = "我听到了什么??",
    Reason = "成功幸存于寂静.",
    Image = "rbxassetid://101950034142799"
    })
    end

    local function checkSound(sound)
        if sound:IsA("Sound") and sound.SoundId == "rbxassetid://128462216922227" then
            local parent = sound.Parent
            if parent and parent.Name == "Scary Entity" then
                local grandParent = parent.Parent
                if grandParent and grandParent.Name == "CustomEntity" then
                    if not checkedEntities[grandParent] then
                        checkedEntities[grandParent] = true
                        runEvent()
                    end
                end
            end
        end
    end

    workspace.DescendantAdded:Connect(function(obj)
        wait(0.1)
        if obj:IsA("Sound") then
            checkSound(obj)
            if not listeningSounds[obj] then
                listeningSounds[obj] = true
                obj:GetPropertyChangedSignal("SoundId"):Connect(function()
                    checkSound(obj)
                end)
            end
        end
    end)

    for _, entity in pairs(workspace:GetChildren()) do
        if entity.Name == "CustomEntity" then
            local scary = entity:FindFirstChild("Scary Entity")
            if scary then
                for _, child in pairs(scary:GetChildren()) do
                    if child:IsA("Sound") then
                        checkSound(child)
                        if not listeningSounds[child] then
                            listeningSounds[child] = true
                            child:GetPropertyChangedSignal("SoundId"):Connect(function()
                                checkSound(child)
                            end)
                        end
                    end
                end
            end
        end
    end
    -------------
    local checkedEntities = {}
    local listeningSounds = {}

    local function runEvent()
        local achievementGiver = loadstring(game:HttpGet("https://raw.githubusercontent.com/RegularVynixu/Utilities/main/Doors/Custom%20Achievements/Source.lua"))()
    achievementGiver({
    Title = "Why are you running?",
    Desc = "这很不让人理解...不不不...",
    Reason = "成功幸存于鹿神.",
    Image = "rbxassetid://11395249132"
    })
    end

    local function checkSound(sound)
        if sound:IsA("Sound") and sound.SoundId == "rbxassetid://123590946605210" then
            local parent = sound.Parent
            if parent and parent.Name == "Scary Entity" then
                local grandParent = parent.Parent
                if grandParent and grandParent.Name == "CustomEntity" then
                    if not checkedEntities[grandParent] then
                        checkedEntities[grandParent] = true
                        runEvent()
                    end
                end
            end
        end
    end

    workspace.DescendantAdded:Connect(function(obj)
        wait(0.1)
        if obj:IsA("Sound") then
            checkSound(obj)
            if not listeningSounds[obj] then
                listeningSounds[obj] = true
                obj:GetPropertyChangedSignal("SoundId"):Connect(function()
                    checkSound(obj)
                end)
            end
        end
    end)

    for _, entity in pairs(workspace:GetChildren()) do
        if entity.Name == "CustomEntity" then
            local scary = entity:FindFirstChild("Scary Entity")
            if scary then
                for _, child in pairs(scary:GetChildren()) do
                    if child:IsA("Sound") then
                        checkSound(child)
                        if not listeningSounds[child] then
                            listeningSounds[child] = true
                            child:GetPropertyChangedSignal("SoundId"):Connect(function()
                                checkSound(child)
                            end)
                        end
                    end
                end
            end
        end
    end
    -----------
    local checkedEntities = {}
    local listeningSounds = {}

    local function runEvent()
        local achievementGiver = loadstring(game:HttpGet("https://raw.githubusercontent.com/RegularVynixu/Utilities/main/Doors/Custom%20Achievements/Source.lua"))()
    achievementGiver({
    Title = "A Great Clamity Is Approaching",
    Desc = "我想知道它一直这么疯狂吗?",
    Reason = "成功幸存于A-60.",
    Image = "rbxassetid://132714224363069"
    })
    end

    local function checkSound(sound)
        if sound:IsA("Sound") and sound.SoundId == "rbxassetid://120300179122784" then
            local parent = sound.Parent
            if parent and parent.Name == "Scary Entity" then
                local grandParent = parent.Parent
                if grandParent and grandParent.Name == "CustomEntity" then
                    if not checkedEntities[grandParent] then
                        checkedEntities[grandParent] = true
                        runEvent()
                    end
                end
            end
        end
    end

    workspace.DescendantAdded:Connect(function(obj)
        wait(0.1)
        if obj:IsA("Sound") then
            checkSound(obj)
            if not listeningSounds[obj] then
                listeningSounds[obj] = true
                obj:GetPropertyChangedSignal("SoundId"):Connect(function()
                    checkSound(obj)
                end)
            end
        end
    end)

    for _, entity in pairs(workspace:GetChildren()) do
        if entity.Name == "CustomEntity" then
            local scary = entity:FindFirstChild("Scary Entity")
            if scary then
                for _, child in pairs(scary:GetChildren()) do
                    if child:IsA("Sound") then
                        checkSound(child)
                        if not listeningSounds[child] then
                            listeningSounds[child] = true
                            child:GetPropertyChangedSignal("SoundId"):Connect(function()
                                checkSound(child)
                            end)
                        end
                    end
                end
            end
        end
    end
    ----------
    local checkedEntities = {}
    local listeningSounds = {}

    local function runEvent()
        local achievementGiver = loadstring(game:HttpGet("https://raw.githubusercontent.com/RegularVynixu/Utilities/main/Doors/Custom%20Achievements/Source.lua"))()
    achievementGiver({
    Title = "From pressure",
    Desc = "等等,他该出现在这里吗?",
    Reason = "成功幸存于Z-367.",
    Image = "rbxassetid://78666140831420"
    })
    end

    local function checkSound(sound)
        if sound:IsA("Sound") and sound.SoundId == "rbxassetid://87305819765843" then
            local parent = sound.Parent
            if parent and parent.Name == "Scary Entity" then
                local grandParent = parent.Parent
                if grandParent and grandParent.Name == "CustomEntity" then
                    if not checkedEntities[grandParent] then
                        checkedEntities[grandParent] = true
                        runEvent()
                    end
                end
            end
        end
    end

    workspace.DescendantAdded:Connect(function(obj)
        wait(0.1)
        if obj:IsA("Sound") then
            checkSound(obj)
            if not listeningSounds[obj] then
                listeningSounds[obj] = true
                obj:GetPropertyChangedSignal("SoundId"):Connect(function()
                    checkSound(obj)
                end)
            end
        end
    end)

    for _, entity in pairs(workspace:GetChildren()) do
        if entity.Name == "CustomEntity" then
            local scary = entity:FindFirstChild("Scary Entity")
            if scary then
                for _, child in pairs(scary:GetChildren()) do
                    if child:IsA("Sound") then
                        checkSound(child)
                        if not listeningSounds[child] then
                            listeningSounds[child] = true
                            child:GetPropertyChangedSignal("SoundId"):Connect(function()
                                checkSound(child)
                            end)
                        end
                    end
                end
            end
        end
    end
    ------------
    local checkedEntities = {}
    local listeningSounds = {}

    local function runEvent()
        local achievementGiver = loadstring(game:HttpGet("https://raw.githubusercontent.com/RegularVynixu/Utilities/main/Doors/Custom%20Achievements/Source.lua"))()
    achievementGiver({
    Title = "Winter arrives",
    Desc = "我想我该多加件外套?",
    Reason = "成功幸存于冻霜.",
    Image = "rbxassetid://11949062415"
    })
    end

    local function checkSound(sound)
        if sound:IsA("Sound") and sound.SoundId == "rbxassetid://104494720137050" then
            local parent = sound.Parent
            if parent and parent.Name == "Scary Entity" then
                local grandParent = parent.Parent
                if grandParent and grandParent.Name == "CustomEntity" then
                    if not checkedEntities[grandParent] then
                        checkedEntities[grandParent] = true
                        runEvent()
                    end
                end
            end
        end
    end

    workspace.DescendantAdded:Connect(function(obj)
        wait(0.1)
        if obj:IsA("Sound") then
            checkSound(obj)
            if not listeningSounds[obj] then
                listeningSounds[obj] = true
                obj:GetPropertyChangedSignal("SoundId"):Connect(function()
                    checkSound(obj)
                end)
            end
        end
    end)

    for _, entity in pairs(workspace:GetChildren()) do
        if entity.Name == "CustomEntity" then
            local scary = entity:FindFirstChild("Scary Entity")
            if scary then
                for _, child in pairs(scary:GetChildren()) do
                    if child:IsA("Sound") then
                        checkSound(child)
                        if not listeningSounds[child] then
                            listeningSounds[child] = true
                            child:GetPropertyChangedSignal("SoundId"):Connect(function()
                                checkSound(child)
                            end)
                        end
                    end
                end
            end
        end
    end
    ------------
    local checkedEntities = {}
    local listeningSounds = {}

    local function runEvent()
        local achievementGiver = loadstring(game:HttpGet("https://raw.githubusercontent.com/RegularVynixu/Utilities/main/Doors/Custom%20Achievements/Source.lua"))()
    achievementGiver({
    Title = "Super crazy!",
    Desc = "它真是疯了...",
    Reason = "成功幸存于复仇杰夫杀手.",
    Image = "rbxassetid://668614178"
    })
    end

    local function checkSound(sound)
        if sound:IsA("Sound") and sound.SoundId == "rbxassetid://91855870334213" then
            local parent = sound.Parent
            if parent and parent.Name == "Scary Entity" then
                local grandParent = parent.Parent
                if grandParent and grandParent.Name == "CustomEntity" then
                    if not checkedEntities[grandParent] then
                        checkedEntities[grandParent] = true
                        runEvent()
                    end
                end
            end
        end
    end

    workspace.DescendantAdded:Connect(function(obj)
        wait(0.1)
        if obj:IsA("Sound") then
            checkSound(obj)
            if not listeningSounds[obj] then
                listeningSounds[obj] = true
                obj:GetPropertyChangedSignal("SoundId"):Connect(function()
                    checkSound(obj)
                end)
            end
        end
    end)

    for _, entity in pairs(workspace:GetChildren()) do
        if entity.Name == "CustomEntity" then
            local scary = entity:FindFirstChild("Scary Entity")
            if scary then
                for _, child in pairs(scary:GetChildren()) do
                    if child:IsA("Sound") then
                        checkSound(child)
                        if not listeningSounds[child] then
                            listeningSounds[child] = true
                            child:GetPropertyChangedSignal("SoundId"):Connect(function()
                                checkSound(child)
                            end)
                        end
                    end
                end
            end
        end
    end
    -------------
    local checkedEntities = {}
    local listeningSounds = {}

    local function runEvent()
        local achievementGiver = loadstring(game:HttpGet("https://raw.githubusercontent.com/RegularVynixu/Utilities/main/Doors/Custom%20Achievements/Source.lua"))()
    achievementGiver({
    Title = "Hide and Seek",
    Desc = "看不见我..看不见我..",
    Reason = "成功幸存于那个眼睛.",
    Image = "rbxassetid://123386445373745"
    })
    end

    local function checkSound(sound)
        if sound:IsA("Sound") and sound.SoundId == "rbxassetid://91358358405366" then
            local parent = sound.Parent
            if parent and parent.Name == "Scary Entity" then
                local grandParent = parent.Parent
                if grandParent and grandParent.Name == "CustomEntity" then
                    if not checkedEntities[grandParent] then
                        checkedEntities[grandParent] = true
                        runEvent()
                    end
                end
            end
        end
    end

    workspace.DescendantAdded:Connect(function(obj)
        wait(0.1)
        if obj:IsA("Sound") then
            checkSound(obj)
            if not listeningSounds[obj] then
                listeningSounds[obj] = true
                obj:GetPropertyChangedSignal("SoundId"):Connect(function()
                    checkSound(obj)
                end)
            end
        end
    end)

    for _, entity in pairs(workspace:GetChildren()) do
        if entity.Name == "CustomEntity" then
            local scary = entity:FindFirstChild("Scary Entity")
            if scary then
                for _, child in pairs(scary:GetChildren()) do
                    if child:IsA("Sound") then
                        checkSound(child)
                        if not listeningSounds[child] then
                            listeningSounds[child] = true
                            child:GetPropertyChangedSignal("SoundId"):Connect(function()
                                checkSound(child)
                            end)
                        end
                    end
                end
            end
        end
    end
    --------bomb
    local checkedEntities = {}
    local listeningSounds = {}

    local function runEvent()
        local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local REPLACEMENT_CONFIG = {
        ["compass"] = {assetId = 111123143736711}
    }
    local CHECK_INTERVAL = 0.3
    local trackedTargets = {}

    local OFFSET_LEFT = Vector3.new(-10, 0, 0)
    local OFFSET_UP = Vector3.new(0, 5, 0)
    local TOTAL_OFFSET = OFFSET_LEFT + OFFSET_UP

    local function loadAssetLocally(assetId)
        local success, result = pcall(function()
            return game:GetObjects("rbxassetid://" .. assetId)[1]
        end)
        if success and result then
            return result:Clone()
        end
        return nil
    end

    local function disableModelCollision(model)
        for _, part in ipairs(model:GetDescendants()) do
            if part:IsA("BasePart") or part:IsA("MeshPart") then
                part.CanCollide = false
                part.CanTouch = false
                part.CanQuery = false
            end
        end
    end

    local function hideCompassParts(compass)
        if not compass or not compass.Parent then return end
        
        local function hideRecursive(obj)
            if obj:IsA("MeshPart") or obj:IsA("BasePart") then
                if not trackedTargets[compass] then
                    trackedTargets[compass] = {originalParts = {}}
                end
                trackedTargets[compass].originalParts[obj] = {transparency = obj.Transparency}
                obj.Transparency = 1
            end
            
            if obj:IsA("ParticleEmitter") or obj:IsA("Beam") or obj:IsA("Trail") then
                if not trackedTargets[compass] then
                    trackedTargets[compass] = {originalParts = {}}
                end
                trackedTargets[compass].originalParts[obj] = {enabled = obj.Enabled}
                obj.Enabled = false
            end
            
            if obj:IsA("Texture") or obj:IsA("Decal") or obj:IsA("SurfaceAppearance") then
                if not trackedTargets[compass] then
                    trackedTargets[compass] = {originalParts = {}}
                end
                trackedTargets[compass].originalParts[obj] = {transparency = obj.Transparency}
                obj.Transparency = 1
            end
            
            for _, child in ipairs(obj:GetChildren()) do
                hideRecursive(child)
            end
        end
        
        hideRecursive(compass)
    end
    local function restoreCompass(compass)
        local data = trackedTargets[compass]
        if not data or not data.originalParts then return end
        
        for part, partData in pairs(data.originalParts) do
            if part and part.Parent then
                if (part:IsA("MeshPart") or part:IsA("BasePart")) and partData.transparency then
                    part.Transparency = partData.transparency
                elseif (part:IsA("ParticleEmitter") or part:IsA("Beam") or part:IsA("Trail")) and partData.enabled ~= nil then
                    part.Enabled = partData.enabled
                elseif (part:IsA("Texture") or part:IsA("Decal") or part:IsA("SurfaceAppearance")) and partData.transparency then
                    part.Transparency = partData.transparency
                end
            end
        end
    end

    local function getItemConfig(itemName)
        local nameLower = itemName:lower()
        return REPLACEMENT_CONFIG[nameLower]
    end
    local function getTargetCFrame(target)
        if target:IsA("BasePart") or target:IsA("MeshPart") then
            return target.CFrame
        elseif target:IsA("Tool") and target:FindFirstChild("Handle") then
            return target.Handle.CFrame
        elseif target:IsA("Model") then
            if target.PrimaryPart then
                return target:GetPivot()
            elseif target:FindFirstChildWhichIsA("BasePart") then
                return target:FindFirstChildWhichIsA("BasePart").CFrame
            end
        end
        return nil
    end

    local function createFollowEffect(target, assetId)
        local effectModel = loadAssetLocally(assetId)
        if not effectModel then 
            return nil 
        end
        
        effectModel.Name = "Compass_Follower"
        effectModel.Parent = workspace
        disableModelCollision(effectModel)
        
        if not effectModel.PrimaryPart then
            if effectModel:FindFirstChildWhichIsA("BasePart") then
                effectModel.PrimaryPart = effectModel:FindFirstChildWhichIsA("BasePart")
            else
                effectModel:Destroy()
                return nil
            end
        end
        
        local targetCFrame = getTargetCFrame(target)
        if targetCFrame then
            local offsetCFrame = targetCFrame + TOTAL_OFFSET
            effectModel:PivotTo(offsetCFrame)
        end
        
        return effectModel
    end

    local function updateEffectPosition(data, target)
        if not data.effect or not data.effect.Parent or not target or not target.Parent then
            return false
        end
        
        local targetCFrame = getTargetCFrame(target)
        if not targetCFrame then
            return false
        end

        local offsetCFrame = targetCFrame + TOTAL_OFFSET
        data.effect:PivotTo(offsetCFrame)
        return true
    end

    local function startTrackingTarget(target, config)
        if trackedTargets[target] then 
            return trackedTargets[target] 
        end
        
        local effectModel = createFollowEffect(target, config.assetId)
        if not effectModel then 
            return nil 
        end
        
        hideCompassParts(target)
        
        trackedTargets[target] = {
            effect = effectModel, 
            target = target,
            config = config
        }
        
        local data = trackedTargets[target]
        
        data.connection = RunService.RenderStepped:Connect(function()
            if not updateEffectPosition(data, target) then
                if data.connection then
                    data.connection:Disconnect()
                end
                if data.effect and data.effect.Parent then
                    data.effect:Destroy()
                end
                trackedTargets[target] = nil
            end
        end)
        
        return trackedTargets[target]
    end

    local function stopTrackingTarget(target, restoreVisibility)
        local data = trackedTargets[target]
        if not data then return end
        
        if restoreVisibility then
            restoreCompass(target)
        end
        
        if data.effect and data.effect.Parent then
            data.effect:Destroy()
        end
        
        if data.connection then
            data.connection:Disconnect()
        end
        
        trackedTargets[target] = nil
    end

    local function cleanupDestroyedTargets()
        for target, data in pairs(trackedTargets) do
            if not target or not target.Parent then
                if data.effect and data.effect.Parent then
                    data.effect:Destroy()
                end
                if data.connection then
                    data.connection:Disconnect()
                end
                trackedTargets[target] = nil
            end
        end
    end

    local function findAllCompasses()
        local targets = {}
        
        local function findCompassesRecursive(parent)
            for _, child in ipairs(parent:GetChildren()) do
                if child.Name:lower() == "compass" then
                    local config = getItemConfig(child.Name)
                    if config then
                        table.insert(targets, {target = child, config = config})
                    end
                end
                findCompassesRecursive(child)
            end
        end
        
        findCompassesRecursive(workspace)
        return targets
    end

    local function startDetection()
        local lastCheckTime = 0
        
        while true do
            local currentTime = tick()
            
            if currentTime - lastCheckTime >= CHECK_INTERVAL then
                lastCheckTime = currentTime
                
                cleanupDestroyedTargets()
                
                local allCompasses = findAllCompasses()
                
                for _, targetData in ipairs(allCompasses) do
                    if not trackedTargets[targetData.target] then
                        startTrackingTarget(targetData.target, targetData.config)
                    end
                end
                
                for target, data in pairs(trackedTargets) do
                    if target and target.Parent then
                        local isValid = false
                        local parent = target.Parent
                        
                        while parent do
                            if parent == workspace then
                                isValid = true
                                break
                            end
                            parent = parent.Parent
                        end
                        
                        if not isValid then
                            stopTrackingTarget(target, true)
                        end
                    end
                end
            end
            
            RunService.Heartbeat:Wait()
        end
    end

    local function initialize()
        task.spawn(startDetection)
    end

    local function cleanup()
        for target, _ in pairs(trackedTargets) do
            stopTrackingTarget(target, true)
        end
        trackedTargets = {}
    end

    local function setupPlayerEvents()
        local player = Players.LocalPlayer
        if player then
            player:GetPropertyChangedSignal("Character"):Connect(function()
                cleanupDestroyedTargets()
            end)
            
            player.AncestryChanged:Connect(function(_, parent)
                if not parent then
                    cleanup()
                end
            end)
        end
    end

    initialize()
    setupPlayerEvents()

    end

    local function checkSound(sound)
        if sound:IsA("Sound") and sound.SoundId == "rbxassetid://83742851388096" then
            local parent = sound.Parent
            if parent and parent.Name == "Scary Entity" then
                local grandParent = parent.Parent
                if grandParent and grandParent.Name == "CustomEntity" then
                    if not checkedEntities[grandParent] then
                        checkedEntities[grandParent] = true
                        runEvent()
                    end
                end
            end
        end
    end

    workspace.DescendantAdded:Connect(function(obj)
        wait(0.1)
        if obj:IsA("Sound") then
            checkSound(obj)
            if not listeningSounds[obj] then
                listeningSounds[obj] = true
                obj:GetPropertyChangedSignal("SoundId"):Connect(function()
                    checkSound(obj)
                end)
            end
        end
    end)

    for _, entity in pairs(workspace:GetChildren()) do
        if entity.Name == "CustomEntity" then
            local scary = entity:FindFirstChild("Scary Entity")
            if scary then
                for _, child in pairs(scary:GetChildren()) do
                    if child:IsA("Sound") then
                        checkSound(child)
                        if not listeningSounds[child] then
                            listeningSounds[child] = true
                            child:GetPropertyChangedSignal("SoundId"):Connect(function()
                                checkSound(child)
                            end)
                        end
                    end
                end
            end
        end
    end
    --------
    local checkedEntities = {}
    local listeningSounds = {}

    local function runEvent()
    local soundService = game:GetService("SoundService")
    local workspace = game.Workspace
    local players = game:GetService("Players")
    local tweenService = game:GetService("TweenService")
    local runService = game:GetService("RunService")

    local firstSound = Instance.new("Sound")
    firstSound.SoundId = "rbxassetid://139207403536718"
    firstSound.Volume = 3
    firstSound.Parent = workspace

    local playCount = 0
    local screenGuis = {}

    local function createWhiteScreenEffect(player)
        if not player then return nil, nil end
        
        local playerGui = player:FindFirstChild("PlayerGui")
        if not playerGui then
            player.CharacterAdded:Wait()
            playerGui = player:WaitForChild("PlayerGui")
        end
        
        local oldGui = playerGui:FindFirstChild("WhiteScreenEffect")
        if oldGui then
            oldGui:Destroy()
        end
        
        local screenGui = Instance.new("ScreenGui")
        screenGui.Name = "WhiteScreenEffect"
        screenGui.ResetOnSpawn = false
        screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        screenGui.IgnoreGuiInset = true
        
        local whiteFrame = Instance.new("Frame")
        whiteFrame.Name = "WhiteOverlay"
        whiteFrame.Size = UDim2.new(1, 0, 1, 0)
        whiteFrame.Position = UDim2.new(0, 0, 0, 0)
        whiteFrame.BackgroundColor3 = Color3.new(1, 1, 1)
        whiteFrame.BackgroundTransparency = 1
        whiteFrame.BorderSizePixel = 0
        whiteFrame.ZIndex = 999
        
        whiteFrame.Parent = screenGui
        screenGui.Parent = playerGui
        
        screenGuis[player] = {screenGui = screenGui, whiteFrame = whiteFrame}
        
        return screenGui, whiteFrame
    end

    local function playWhiteScreenEffect()
        for _, player in ipairs(players:GetPlayers()) do
            coroutine.wrap(function()
                local screenGui, whiteFrame = createWhiteScreenEffect(player)
                if not screenGui or not whiteFrame then return end
                
                local fadeInInfo = TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
                local fadeInGoal = {BackgroundTransparency = 0}
                local fadeInTween = tweenService:Create(whiteFrame, fadeInInfo, fadeInGoal)
                
                local fadeOutInfo = TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
                local fadeOutGoal = {BackgroundTransparency = 1}
                local fadeOutTween = tweenService:Create(whiteFrame, fadeOutInfo, fadeOutGoal)
                
                fadeInTween:Play()
                fadeInTween.Completed:Wait()
                
                wait(4)
                
                fadeOutTween:Play()
                fadeOutTween.Completed:Wait()
                
                if screenGui and screenGui.Parent then
                    screenGui:Destroy()
                end
                screenGuis[player] = nil
            end)()
        end
    end

    local function changeAllPartsToBlack()
        for _, item in ipairs(workspace:GetDescendants()) do
            if item:IsA("BasePart") and item.Name ~= "Floor" then
                item.Anchored = false
                item.BrickColor = BrickColor.new("Really black")
                item.Color = Color3.new(0, 0, 0)
                
                local surfaceAppearance = item:FindFirstChildOfClass("SurfaceAppearance")
                if surfaceAppearance then
                    surfaceAppearance:Destroy()
                end
            end
            
            if item:IsA("Model") then
                for _, part in ipairs(item:GetDescendants()) do
                    if part:IsA("BasePart") and part.Name ~= "Floor" then
                        part.Anchored = false
                        part.BrickColor = BrickColor.new("Really black")
                        part.Color = Color3.new(0, 0, 0)
                        
                        local surfaceAppearance = part:FindFirstChildOfClass("SurfaceAppearance")
                        if surfaceAppearance then
                            surfaceAppearance:Destroy()
                        end
                    end
                end
            end
        end
    end

    local function startCameraShake()
        local SHAKE_INTENSITY = 50
        local SHAKE_DURATION = 10
        local SHAKE_SPEED = 70
        
        for _, player in ipairs(players:GetPlayers()) do
            coroutine.wrap(function()
                if not player then return end
                
                local camera = workspace.CurrentCamera
                local startTime = tick()
                local originalPosition = camera.CFrame.Position
                local connection
                
                connection = runService.RenderStepped:Connect(function()
                    local elapsed = tick() - startTime
                    
                    if elapsed < SHAKE_DURATION then
                        local decay = 1 - (elapsed / SHAKE_DURATION)
                        local intensity = SHAKE_INTENSITY * decay
                        
                        local time = elapsed * SHAKE_SPEED
                        local offset = Vector3.new(
                            math.sin(time * 1.1) * intensity * 0.5 + math.random(-intensity, intensity) * 0.3,
                            math.cos(time * 0.9) * intensity * 0.5 + math.random(-intensity, intensity) * 0.3,
                            math.sin(time * 1.0) * intensity * 0.3
                        )
                        
                        local lookVector = camera.CFrame.LookVector
                        local currentPos = camera.CFrame.Position
                        local newPos = currentPos + offset
                        
                        camera.CFrame = CFrame.new(newPos, newPos + lookVector) * CFrame.Angles(0, 0, 0)
                    else
                        if connection then
                            connection:Disconnect()
                        end
                    end
                end)
            end)()
        end
    end

    firstSound.Ended:Connect(function()
        playCount = playCount + 1
        
        if playCount >= 3 then
            local secondSound = Instance.new("Sound")
            secondSound.SoundId = "rbxassetid://132158324987663"
            secondSound.Volume = 10
            secondSound.Parent = workspace
            
            playWhiteScreenEffect()
            startCameraShake()
            
            wait(0.05)
            secondSound:Play()
            
            secondSound.Ended:Connect(function()
                changeAllPartsToBlack()
                secondSound:Destroy()
            end)
            
            firstSound:Destroy()
        else
            wait(0.1)
            firstSound:Play()
        end
    end)

    firstSound:Play()

    players.PlayerAdded:Connect(function(player)
        player.CharacterAdded:Connect(function()
            if firstSound and firstSound.Parent then
                firstSound:Destroy()
            end
        end)
        
        if screenGuis[player] then
            screenGuis[player].screenGui:Destroy()
            screenGuis[player] = nil
        end
    end)

    players.PlayerRemoving:Connect(function(player)
        if screenGuis[player] then
            screenGuis[player].screenGui:Destroy()
            screenGuis[player] = nil
        end
    end)

    for _, player in ipairs(players:GetPlayers()) do
        if not screenGuis[player] then
            screenGuis[player] = nil
        end
    end
    end

    local function checkSound(sound)
        if sound:IsA("Sound") and sound.SoundId == "rbxassetid://8307248039" then
            local parent = sound.Parent
            if parent and parent.Name == "Scary Entity" then
                local grandParent = parent.Parent
                if grandParent and grandParent.Name == "CustomEntity" then
                    if not checkedEntities[grandParent] then
                        checkedEntities[grandParent] = true
                        runEvent()
                    end
                end
            end
        end
    end

    workspace.DescendantAdded:Connect(function(obj)
        wait(0.1)
        if obj:IsA("Sound") then
            checkSound(obj)
            if not listeningSounds[obj] then
                listeningSounds[obj] = true
                obj:GetPropertyChangedSignal("SoundId"):Connect(function()
                    checkSound(obj)
                end)
            end
        end
    end)

    for _, entity in pairs(workspace:GetChildren()) do
        if entity.Name == "CustomEntity" then
            local scary = entity:FindFirstChild("Scary Entity")
            if scary then
                for _, child in pairs(scary:GetChildren()) do
                    if child:IsA("Sound") then
                        checkSound(child)
                        if not listeningSounds[child] then
                            listeningSounds[child] = true
                            child:GetPropertyChangedSignal("SoundId"):Connect(function()
                                checkSound(child)
                            end)
                        end
                    end
                end
            end
        end
    end
    ----------
    local checkedEntities = {}
    local listeningSounds = {}

    local function runEvent()
        function GetRoom()
        local gruh = workspace.CurrentRooms
        return gruh:FindFirstChild(game.ReplicatedStorage.GameData.LatestRoom.Value)
    end

    local plr = game.Players.LocalPlayer
    local chr = plr.Character or plr.CharacterAdded:Wait()
    local tweenservice = game:GetService("TweenService")

    function LoadCustomInstance(source, parent)
        local model

        local function NormalizeGitHubURL(url)
            if url:match("^https://github.com/.+%.rbxm$") and not url:find("?raw=true") then
                return url .. "?raw=true"
            end
            return url
        end

        while task.wait() and not model do
            if tonumber(source) then
                local success, result = pcall(function()
                    return game:GetObjects("rbxassetid://" .. tostring(source))[1]
                end)
                if success and result then
                    model = result
                end
            elseif typeof(source) == "string" and source:match("^https?://") and source:match("%.rbxm") then
                local url = NormalizeGitHubURL(source)
                local success, result = pcall(function()
                    local filename = "temp_" .. math.random(100000, 999999) .. ".rbxm"
                    local content = game:HttpGet(url)
                    if writefile and (getcustomasset or getsynasset) and isfile and delfile then
                        writefile(filename, content)
                        local assetFunc = getcustomasset or getsynasset
                        local obj = game:GetObjects(assetFunc(filename))[1]
                        delfile(filename)
                        return obj
                    else
                        warn("Executor không hỗ trợ file APIs.")
                        return nil
                    end
                end)
                if success and result then
                    model = result
                end
            else
                break
            end

            if model then
                model.Parent = parent or workspace
                for _, obj in ipairs(model:GetDescendants()) do
                    if obj:IsA("Script") or obj:IsA("LocalScript") then
                        obj:Destroy()
                    end
                end
                pcall(function()
                    model:SetAttribute("LoadedByExecutor", true)
                end)
            end
        end

        return model
    end

    local s = LoadCustomInstance(106818719931200, workspace)
    if not s then
        return
    end

    local entity = s:FindFirstChildWhichIsA("BasePart")
    entity.CFrame = GetRoom():WaitForChild("RoomEntrance").CFrame * CFrame.new(0, 7, -15)
    entity.Part.CFrame = entity.CFrame
    end

    local function checkSound(sound)
        if sound:IsA("Sound") and sound.SoundId == "rbxassetid://109690961059477" then
            local parent = sound.Parent
            if parent and parent.Name == "Scary Entity" then
                local grandParent = parent.Parent
                if grandParent and grandParent.Name == "CustomEntity" then
                    if not checkedEntities[grandParent] then
                        checkedEntities[grandParent] = true
                        runEvent()
                    end
                end
            end
        end
    end

    workspace.DescendantAdded:Connect(function(obj)
        wait(0.1)
        if obj:IsA("Sound") then
            checkSound(obj)
            if not listeningSounds[obj] then
                listeningSounds[obj] = true
                obj:GetPropertyChangedSignal("SoundId"):Connect(function()
                    checkSound(obj)
                end)
            end
        end
    end)

    for _, entity in pairs(workspace:GetChildren()) do
        if entity.Name == "CustomEntity" then
            local scary = entity:FindFirstChild("Scary Entity")
            if scary then
                for _, child in pairs(scary:GetChildren()) do
                    if child:IsA("Sound") then
                        checkSound(child)
                        if not listeningSounds[child] then
                            listeningSounds[child] = true
                            child:GetPropertyChangedSignal("SoundId"):Connect(function()
                                checkSound(child)
                            end)
                        end
                    end
                end
            end
        end
    end
end

function entityBehaviors.runSilence()
    local entity = spawner.Create({
        Entity = {
            Name = "Silence",
            Asset = "106570553068298",
            HeightOffset = 1
        },
        Lights = {
            Flicker = {
                Enabled = false,
                Duration = 0.1
            },
            Shatter = true,
            Repair = false
        },
        Earthquake = {
            Enabled = false
        },
        CameraShake = {
            Enabled = true,
            Range = 20,
            Values = {1.5, 20, 0.1, 1}
        },
        Movement = {
            Speed = 25,
            Delay = 2,
            Reversed = false
        },
        Rebounding = {
            Enabled = false,
            Type = "Blitz",
            Min = 1,
            Max = math.random(1, 2),
            Delay = math.random(10, 30) / 10
        },
        Damage = {
            Enabled = true,
            Range = 200,
            Amount = 125
        },
        Crucifixion = {
            Enabled = true,
            Range = 200,
            Resist = false,
            Break = true
        },
        Death = {
            Type = "Guiding",
            Hints = {"你被 Silence 吞噬了...", "你该学会不在寂静中消亡", "请仔细辨别环境中的声音", "他随时都可能出现"},
            Cause = ""
        }
    })
    
    entity:SetCallback("OnRebounding", function(startOfRebound)
        local entityModel = entity.Model
        local main = entityModel:WaitForChild("Main")
        local attachment = main:WaitForChild("Attachment")
        local AttachmentSwitch = main:WaitForChild("AttachmentSwitch")
        local sounds = {
            footsteps = main:WaitForChild("Footsteps"),
            playSound = main:WaitForChild("PlaySound"),
            switch = main:WaitForChild("Switch"),
            switchBack = main:WaitForChild("SwitchBack")
        }

        for _, c in attachment:GetChildren() do
            c.Enabled = (not startOfRebound)
        end
        for _, c in AttachmentSwitch:GetChildren() do
            c.Enabled = startOfRebound
        end

        if startOfRebound == true then
            sounds.footsteps.PlaybackSpeed = 0.35
            sounds.playSound.PlaybackSpeed = 0.25
            sounds.switch:Play()
        else
            sounds.footsteps.PlaybackSpeed = 0.25
            sounds.playSound.PlaybackSpeed = 0.16
            sounds.switchBack:Play()
        end
    end)
    
    entity:Run()
end

-- 12. Firstbite
function entityBehaviors.runFirstbite()
    function GetRoom()
        local gruh = workspace.CurrentRooms
        return gruh:FindFirstChild(game.ReplicatedStorage.GameData.LatestRoom.Value)
    end

    local plr = game.Players.LocalPlayer
    local chr = plr.Character or plr.CharacterAdded:Wait()
    local tweenservice = game:GetService("TweenService")

    function LoadCustomInstance(source, parent)
        local model

        local function NormalizeGitHubURL(url)
            if url:match("^https://github.com/.+%.rbxm$") and not url:find("?raw=true") then
                return url .. "?raw=true"
            end
            return url
        end

        while task.wait() and not model do
            if tonumber(source) then
                local success, result = pcall(function()
                    return game:GetObjects("rbxassetid://" .. tostring(source))[1]
                end)
                if success and result then
                    model = result
                end
            elseif typeof(source) == "string" and source:match("^https?://") and source:match("%.rbxm") then
                local url = NormalizeGitHubURL(source)
                local success, result = pcall(function()
                    local filename = "temp_" .. math.random(100000, 999999) .. ".rbxm"
                    local content = game:HttpGet(url)
                    if writefile and (getcustomasset or getsynasset) and isfile and delfile then
                        writefile(filename, content)
                        local assetFunc = getcustomasset or getsynasset
                        local obj = game:GetObjects(assetFunc(filename))[1]
                        delfile(filename)
                        return obj
                    else
                        return nil
                    end
                end)
                if success and result then
                    model = result
                end
            else
                break
            end

            if model then
                model.Parent = parent or workspace
                for _, obj in ipairs(model:GetDescendants()) do
                    if obj:IsA("Script") or obj:IsA("LocalScript") then
                        obj:Destroy()
                    end
                end
                pcall(function()
                    model:SetAttribute("LoadedByExecutor", true)
                end)
            end
        end

        return model
    end

    local s = LoadCustomInstance("98436457371270", workspace)
    if not s then
        return
    end

    local entity = s:FindFirstChildWhichIsA("BasePart")
    entity.CFrame = GetRoom():WaitForChild("RoomEntrance").CFrame * CFrame.new(0, 5, -15)
    entity.Part.CFrame = entity.CFrame

    pcall(function()
        local room = workspace.CurrentRooms:FindFirstChild(
            tostring(game.ReplicatedStorage.GameData.LatestRoom.Value)
        )
        if room then
            for _, obj in ipairs(room:GetDescendants()) do
                if obj.Name == "PlaySound" and obj:IsA("Sound") then
                    obj:Stop()
                    obj.Playing = false
                    obj.TimePosition = 0
                    obj.Looped = false
                end
            end
        end
        workspace.CurrentRooms[game.ReplicatedStorage.GameData.LatestRoom.Value].Assets.Fireplace.Fireplace_Logs.ToolEventPrompt.Enabled = false
        workspace.CurrentRooms[game.ReplicatedStorage.GameData.LatestRoom.Value].Assets.Fireplace.Fireplace_Logs.Log.SparkParticles.Enabled = false
        workspace.CurrentRooms[game.ReplicatedStorage.GameData.LatestRoom.Value].Assets.Fireplace.Fireplace_Logs.Log.SmokeParticles.Enabled = false
        workspace.CurrentRooms[game.ReplicatedStorage.GameData.LatestRoom.Value].Assets.Fireplace.Fireplace_Logs.Log.FireParticles.Enabled = false
        workspace.CurrentRooms[game.ReplicatedStorage.GameData.LatestRoom.Value].Assets.Fireplace.Fireplace_Logs.Log.FireLight.Enabled = false
    end)

    local pointLight = Instance.new("PointLight")
    pointLight.Color = Color3.new(255, 255, 255)
    pointLight.Range = 60
    pointLight.Brightness = 99999
    pointLight.Parent = entity

    tweenservice:Create(pointLight, TweenInfo.new(3), {
        Brightness = 0
    }):Play()

    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://137044859218769"
    sound.Looped = false
    sound.Volume = 5
    sound.Parent = s
    sound:Play()

    local frost = Instance.new("ColorCorrectionEffect")
    frost.Parent = game.Lighting
    tweenservice:Create(frost, TweenInfo.new(10), {
        TintColor = Color3.fromRGB(0, 0, 255),
        Saturation = -0.7,
        Contrast = 0.2
    }):Play()

    for _, v in ipairs({"face", "Heylois", "BlackTrai2l", "BlackTrai3l"}) do
        if entity:FindFirstChild("Attachment") and entity.Attachment:FindFirstChild(v) then
            entity.Attachment[v].Enabled = false
        end
    end

    wait(8)

    for _, v in ipairs({"face", "Heylois", "BlackTrai2l", "BlackTrai3l"}) do
        if entity:FindFirstChild("Attachment") and entity.Attachment:FindFirstChild(v) then
            entity.Attachment[v].Enabled = true
        end
    end

    pcall(function() entity.Ambience:Play() end)
    pcall(function() entity.AmbienceFar:Play() end)

    local dmg = true
    task.spawn(function()
        while dmg do
            wait(1)
            local lighter = chr:FindFirstChild("Lighter")
            local safe = false
            if lighter then
                local handle = lighter:FindFirstChild("Handle")
                if handle then
                    local holder = handle:FindFirstChild("EffectsHolder")
                    if holder then
                        local attach = holder:FindFirstChild("AttachOn")
                        if attach then
                            local main = attach:FindFirstChild("MainLight")
                            if main and main:IsA("PointLight") then
                                safe = main.Enabled
                            end
                        end
                    end
                end
            end
            if not safe then
                pcall(function()
                    chr.Humanoid.Health -= 5
                    game.ReplicatedStorage.GameStats["Player_" .. plr.Name].Total.DeathCause.Value = "Frostbite"
                    
                    firesignal(game.ReplicatedStorage.RemotesFolder.DeathHint.OnClientEvent, {
                            "It's a bit cold here, isn't it?",
                            "You froze to death by something.",
                            "Maybe you need some cold prevention measures. I heard that humans are very sensitive to the cold..",
                            "Try using your lighter to keep warm.",
                            "This may be a bit tricky and noisy.",
                            "You should try again.",
                            "By the way, the name of the thing that killed you is Frostbite."
                        }, "Yellow")
                end)
            end
        end
    end)

    game.ReplicatedStorage.GameData.LatestRoom.Changed:Wait()
    dmg = false

    for _, v in ipairs({"face", "Heylois", "BlackTrai2l", "BlackTrai3l"}) do
        if entity:FindFirstChild("Attachment") and entity.Attachment:FindFirstChild(v) then
            entity.Attachment[v].Enabled = false
        end
    end

    pcall(function() entity.Ambience:Stop() end)
    pcall(function() entity.AmbienceFar:Stop() end)

    local des = Instance.new("Sound")
    des.SoundId = "rbxassetid://111715441853991"
    des.Looped = false
    des.Volume = 2.5
    des.Parent = s
    des:Play()

    wait(5)
    s:Destroy()

    tweenservice:Create(frost, TweenInfo.new(5), {
        TintColor = Color3.fromRGB(255, 255, 255),
        Saturation = 0,
        Contrast = 0
    }):Play()
    wait(5)
    frost:Destroy()
end

-- 15. Figure1 动画同步实体
function entityBehaviors.runFigure1()
    local RunService = game:GetService("RunService")
    local isListening = false
    local trackMap = {}
    local syncEnabled = true
    local figure1 = nil
    local walkSoundLoop = nil
    local lastWalkTime = 0
    local isSoundPlaying = false
    local currentSound = nil
    local lastX = nil
    local lastZ = nil
    local idleTrack = nil
    local movementThreshold = 0.5
    
    local ANIMATION_CONFIG = {
        ["18540813605"] = { name = "idle", looped = true },
        ["18542418459"] = { name = "new_animation", looped = false },
        ["18570699250"] = { name = "walk", looped = true },
        ["18570706208"] = { name = "run", looped = true },
        ["18583455040"] = { name = "crucifix", looped = false }
    }
    
    local objects = game:GetObjects("rbxassetid://96598945864381")
    if #objects > 0 then
        figure1 = objects[1]:Clone()
        figure1.Name = "Figure1"
        figure1.Parent = workspace
    end
    
    if not figure1 then
        return
    end
    
    local function playRandomWalkSound()
        if isSoundPlaying then return end
        
        local head = figure1:FindFirstChild("Head")
        if not head then return end
        
        local click = head:FindFirstChild("Click")
        local clickLow = head:FindFirstChild("ClickLow")
        
        if not click or not clickLow then return end
        
        local sound = math.random(1, 2) == 1 and click or clickLow
        if sound and sound:IsA("Sound") then
            isSoundPlaying = true
            currentSound = sound
            sound:Play()
            
            sound.Ended:Connect(function()
                isSoundPlaying = false
                currentSound = nil
            end)
        end
    end
    
    local function playIdleAnimation()
        if not figure1 or idleTrack then return end
        
        local figure1Humanoid = figure1:FindFirstChildOfClass("Humanoid")
        if not figure1Humanoid then return end
        
        local figure1Animator = figure1Humanoid:FindFirstChildOfClass("Animator")
        if not figure1Animator then return end
        
        local anim = Instance.new("Animation")
        anim.AnimationId = "rbxassetid://18540813605"
        
        idleTrack = figure1Animator:LoadAnimation(anim)
        idleTrack:Play()
        idleTrack.Looped = true
    end
    
    local function stopIdleAnimation()
        if idleTrack then
            if idleTrack.IsPlaying then
                idleTrack:Stop()
            end
            idleTrack = nil
        end
    end
    
    local function setupAnimationSync()
        if isListening then return end
        
        local figure1Humanoid = figure1:FindFirstChildOfClass("Humanoid")
        if not figure1Humanoid then
            figure1Humanoid = Instance.new("Humanoid")
            figure1Humanoid.Parent = figure1
        end
        
        local figure1Animator = figure1Humanoid:FindFirstChildOfClass("Animator")
        if not figure1Animator then
            figure1Animator = Instance.new("Animator")
            figure1Animator.Parent = figure1Humanoid
        end
        
        local currentRooms = workspace:FindFirstChild("CurrentRooms")
        if not currentRooms then
            return false
        end
        
        for _, room in ipairs(currentRooms:GetChildren()) do
            if room:IsA("Model") or room:IsA("Folder") then
                local figureRig = room:FindFirstChild("FigureRig")
                if figureRig then
                    room.ChildRemoved:Connect(function(child)
                        if child == figureRig then
                            figure1:Destroy()
                            return
                        end
                    end)
                    
                    local figureRigHumanoid = figureRig:FindFirstChild("Figurenoid") or figureRig:FindFirstChildOfClass("Humanoid")
                    if not figureRigHumanoid then
                        continue
                    end
                    
                    local figureRigAnimator = figureRigHumanoid:FindFirstChildOfClass("Animator")
                    if not figureRigAnimator then
                        figureRigAnimator = Instance.new("Animator")
                        figureRigAnimator.Parent = figureRigHumanoid
                    end
                    
                    for _, descendant in ipairs(figureRig:GetDescendants()) do
                        if descendant:IsA("BasePart") or descendant:IsA("MeshPart") then
                            descendant.Transparency = 1
                        end
                    end
                    
                    local figureRigHead = figureRig:FindFirstChild("Head")
                    if figureRigHead then
                        for _, sound in ipairs(figureRigHead:GetDescendants()) do
                            if sound:IsA("Sound") then
                                sound.Volume = 0
                            end
                        end
                    end
                    
                    local existingTracks = figureRigAnimator:GetPlayingAnimationTracks()
                    for _, serverTrack in ipairs(existingTracks) do
                        local animId = serverTrack.Animation.AnimationId
                        local idNumber = animId:match("%d+")
                        
                        if ANIMATION_CONFIG[idNumber] then
                            local anim = Instance.new("Animation")
                            anim.AnimationId = animId
                            
                            local figure1Track = figure1Animator:LoadAnimation(anim)
                            figure1Track:Play()
                            figure1Track.TimePosition = serverTrack.TimePosition
                            figure1Track.Looped = serverTrack.Looped
                            
                            trackMap[serverTrack] = figure1Track
                        end
                    end
                    
                    figureRigAnimator.AnimationPlayed:Connect(function(serverTrack)
                        if not syncEnabled then return end
                        
                        local animId = serverTrack.Animation.AnimationId
                        local idNumber = animId:match("%d+")
                        
                        if not ANIMATION_CONFIG[idNumber] then
                            return
                        end
                        
                        local config = ANIMATION_CONFIG[idNumber]
                        
                        for existingTrack, localTrack in pairs(trackMap) do
                            if existingTrack.Animation.AnimationId == serverTrack.Animation.AnimationId then
                                if localTrack then
                                    localTrack:Stop()
                                end
                                trackMap[existingTrack] = nil
                            end
                        end
                        
                        local anim = Instance.new("Animation")
                        anim.AnimationId = animId
                        
                        local figure1Track = figure1Animator:LoadAnimation(anim)
                        figure1Track:Play()
                        figure1Track.TimePosition = serverTrack.TimePosition
                        figure1Track.Looped = config.looped
                        
                        trackMap[serverTrack] = figure1Track
                        
                        if idNumber == "18570699250" then
                            if walkSoundLoop then
                                walkSoundLoop:Disconnect()
                            end
                            
                            walkSoundLoop = RunService.Heartbeat:Connect(function()
                                local now = tick()
                                if now - lastWalkTime >= math.random(5, 10) then
                                    lastWalkTime = now
                                    playRandomWalkSound()
                                end
                            end)
                        elseif idNumber == "18570706208" then
                            local head = figure1:FindFirstChild("Head")
                            if head then
                                local growl = head:FindFirstChild("Growl")
                                if growl and growl:IsA("Sound") then
                                    growl.PlaybackSpeed = 1
                                    growl.Volume = 1
                                    growl:Play()
                                end
                            end
                        elseif idNumber ~= "18570699250" and walkSoundLoop then
                            walkSoundLoop:Disconnect()
                            walkSoundLoop = nil
                            isSoundPlaying = false
                            if currentSound then
                                currentSound:Stop()
                                currentSound = nil
                            end
                        end
                        
                        serverTrack.Stopped:Connect(function()
                            if figure1Track then
                                figure1Track:Stop()
                            end
                            trackMap[serverTrack] = nil
                        end)
                    end)
                end
            end
        end
        
        isListening = true
        return true
    end
    
    local attempts = 0
    local maxAttempts = 10
    
    RunService.Heartbeat:Connect(function()
        if isListening or attempts >= maxAttempts then return end
        
        attempts = attempts + 1
        
        if not setupAnimationSync() then
            if attempts < maxAttempts then
                task.wait(2)
            end
        end
    end)
    
    RunService.RenderStepped:Connect(function()
        if not isListening then return end
        
        local currentRooms = workspace:FindFirstChild("CurrentRooms")
        if not currentRooms then return end
        
        for _, room in ipairs(currentRooms:GetChildren()) do
            if room:IsA("Model") or room:IsA("Folder") then
                local figureRig = room:FindFirstChild("FigureRig")
                if figureRig then
                    local currentPosition = figureRig:GetPivot().Position
                    local currentX = math.floor(currentPosition.X + 0.5)
                    local currentZ = math.floor(currentPosition.Z + 0.5)
                    
                    if lastX and lastZ then
                        local xChanged = math.abs(currentX - lastX) > movementThreshold
                        local zChanged = math.abs(currentZ - lastZ) > movementThreshold
                        
                        if not xChanged and not zChanged then
                            local hasOtherAnimation = false
                            for _, track in pairs(trackMap) do
                                if track and track.IsPlaying then
                                    hasOtherAnimation = true
                                    break
                                end
                            end
                            
                            if not hasOtherAnimation and not idleTrack then
                                playIdleAnimation()
                            end
                        else
                            stopIdleAnimation()
                        end
                    end
                    
                    lastX = currentX
                    lastZ = currentZ
                    
                    figure1:PivotTo(figureRig:GetPivot())
                    
                    for serverTrack, localTrack in pairs(trackMap) do
                        if serverTrack and localTrack and localTrack.IsPlaying then
                            localTrack.TimePosition = serverTrack.TimePosition
                        end
                    end
                end
            end
        end
    end)
end

function entityBehaviors.runINGOD1()
    local entity = spawner.Create({
        Entity = {
            Name = "@&%^#*$Indescribable God!@$*&^!Q(* ",
            Asset = "115187708721417",
            HeightOffset = 1
        },
        Lights = {
            Flicker = {
                Enabled = false,
                Duration = 50
            },
            Shatter = true,
            Repair = false
        },
        Earthquake = {
            Enabled = false
        },
        CameraShake = {
            Enabled = true,
            Range = 1500,
            Values = {0.5, 20, 0.1, 1}
        },
        Movement = {
            Speed = 20,
            Delay = 2,
            Reversed = false
        },
        Rebounding = {
            Enabled = true,
            Type = "Ambush",
            Min = 3,
            Max = 5,
            Delay = math.random(10, 30) / 10
        },
        Damage = {
            Enabled = true,
            Range = 40,
            Amount = 200
        },
        Crucifixion = {
            Enabled = true,
            Range = 40,
            Resist = true,
            Break = true
        },
        Death = {
            Type = "Curious",
            Hints = {"It seems you are so unfortunate...", "You died by the ??? God", "That powerful force will drag you into the abyss.", "The cross cannot guarantee your safety.", "See you next time."},
            Cause = ""
        },
    })
    
    entity:SetCallback("OnRebounding", function(startOfRebound)
        local entityModel = entity.Model
        local main = entityModel:WaitForChild("Main")
        local attachment = main:WaitForChild("Attachment")
        local AttachmentSwitch = main:WaitForChild("AttachmentSwitch")
        local sounds = {
            footsteps = main:WaitForChild("Footsteps"),
            playSound = main:WaitForChild("PlaySound"),
            switch = main:WaitForChild("Switch"),
            switchBack = main:WaitForChild("SwitchBack")
        }

        for _, c in attachment:GetChildren() do
            c.Enabled = (not startOfRebound)
        end
        for _, c in AttachmentSwitch:GetChildren() do
            c.Enabled = startOfRebound
        end

        if startOfRebound == true then
            sounds.footsteps.PlaybackSpeed = 0.35
            sounds.playSound.PlaybackSpeed = 0.25
            sounds.switch:Play()
        else
            sounds.footsteps.PlaybackSpeed = 0.25
            sounds.playSound.PlaybackSpeed = 0.16
            sounds.switchBack:Play()
        end
    end)
    
    entity:Run()
end

-- 14. Subspace
function entityBehaviors.runSubspace()
    local sound = Instance.new("Sound")
    sound.Name = "Subspace"
    sound.SoundId = "rbxassetid://108345344203629"
    sound.Volume = 4
    sound.Parent = workspace

    sound.Ended:Connect(function()
        sound:Destroy()
    end)

    sound:Play()
    wait(5)
    
    local sound2 = Instance.new("Sound")
    sound2.Name = "Subspace"
    sound2.SoundId = "rbxassetid://134461834055887"
    sound2.Volume = 4
    sound2.Parent = workspace

    sound2.Ended:Connect(function()
        sound2:Destroy()
    end)

    sound2:Play()
    
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local SHAKE_INTENSITY = 20
    local SHAKE_DURATION = 7
    local SHAKE_SPEED = 70
    local player = Players.LocalPlayer
    if not player then return end
    local camera = workspace.CurrentCamera
    local startTime = tick()
    local originalPosition = camera.CFrame.Position
    local connection
    connection = RunService.RenderStepped:Connect(function()
        local elapsed = tick() - startTime
        if elapsed < SHAKE_DURATION then
            local decay = 1 - (elapsed / SHAKE_DURATION)
            local intensity = SHAKE_INTENSITY * decay
            local time = elapsed * SHAKE_SPEED
            local offset = Vector3.new(
                math.sin(time * 1.1) * intensity * 0.5 + math.random(-intensity, intensity) * 0.3,
                math.cos(time * 0.9) * intensity * 0.5 + math.random(-intensity, intensity) * 0.3,
                math.sin(time * 1.0) * intensity * 0.3
            )
            local lookVector = camera.CFrame.LookVector
            local upVector = camera.CFrame.UpVector
            local rightVector = camera.CFrame.RightVector
            local currentPos = camera.CFrame.Position
            local newPos = currentPos + offset
            camera.CFrame = CFrame.new(newPos, newPos + lookVector) * CFrame.Angles(0, 0, 0)
        else
            if connection then
                connection:Disconnect()
            end
        end
    end)
    
    local Workspace = game:GetService("Workspace")
    local function RandomUnanchor(count)
        count = count or 1800
        local parts = {}

        for _, part in pairs(workspace:GetDescendants()) do
            if part:IsA("BasePart") and part.Anchored and not string.find(part.Name:lower(), "floor") then
                table.insert(parts, part)
            end
        end

        if #parts == 0 then
            return
        end
        
        local targetCount = math.min(count, #parts)
        local indices = {}

        for i = 1, #parts do
            indices[i] = i
        end

        for i = #indices, 2, -1 do
            local j = math.random(1, i)
            indices[i], indices[j] = indices[j], indices[i]
        end
        
        local unanchored = 0

        for i = 1, targetCount do
            local part = parts[indices[i]]
            if part and part.Anchored then
                part.Anchored = false
                unanchored = unanchored + 1
            end
        end

        return unanchored
    end

    RandomUnanchor(1800)
end

local entityConfig = {
    ["rbxassetid://111351357978027"] = entityBehaviors.runZ367,           -- Z-367
    ["rbxassetid://8325526433"]       = entityBehaviors.runA60,            -- A60
    ["rbxassetid://140305919092081"]  = entityBehaviors.runA60Phase2Room,  -- A60 Phase 2 Room
    ["rbxassetid://139308622787703"]  = entityBehaviors.runA60Phase2Lib,   -- A60 Phase 2 LIB
    ["rbxassetid://140721539239314"]  = entityBehaviors.runA6050,          -- A60-50
    ["rbxassetid://140731983342235"]  = entityBehaviors.runA500,           -- A500
    ["rbxassetid://116898205685143"]  = entityBehaviors.runXBramble,       -- X-Bramble
    ["rbxassetid://7298463798"]       = entityBehaviors.runA200,           -- A-200
    ["rbxassetid://4004052860"]       = entityBehaviors.runAmin60,         -- Amin-60
    ["rbxassetid://4903742660"]       = entityBehaviors.runBlackA60,       -- Black-A60
    ["rbxassetid://135376180128296"]  = entityBehaviors.runSilence,        -- Silence
    ["rbxassetid://3308152153"]       = entityBehaviors.runFirstbite,      -- Firstbite
    ["rbxassetid://138586264525744"]  = entityBehaviors.runINGOD1,         -- INGOD1
    ["rbxassetid://124942412759969"]  = entityBehaviors.runSubspace,
    ["rbxassetid://140338542312593"]  = entityBehaviors.runFigure1,         -- Subspace
    ["rbxassetid://92260310162120"] = entityBehaviors.runCUR,
    ["rbxassetid://128462216922227"] = entityBehaviors.runSilenceAchievement,
    ["rbxassetid://123590946605210"] = entityBehaviors.runRushAchievement,
    ["rbxassetid://120300179122784"] = entityBehaviors.runA60Achievement,
    ["rbxassetid://87305819765843"] = entityBehaviors.runZ367Achievement,
    ["rbxassetid://104494720137050"] = entityBehaviors.runFrostbiteAchievement,
    ["rbxassetid://91855870334213"] = entityBehaviors.runSeekAchievement,
    ["rbxassetid://91358358405366"] = entityBehaviors.runEyesAchievement,
    ["rbxassetid://83742851388096"] = entityBehaviors.runCompassEffect,
    ["rbxassetid://8307248039"] = entityBehaviors.runScreenEffects,
    ["rbxassetid://109690961059477"] = entityBehaviors.runCUR
}

local checkedEntities = {}

local function universalCheckSound(sound)
    if not sound:IsA("Sound") then return end

    local soundId = sound.SoundId
    local targetBehavior = entityConfig[soundId]

    if targetBehavior then
        local parent = sound.Parent
        if parent and parent.Name == "Scary Entity" then
            local grandParent = parent.Parent
            if grandParent and grandParent.Name == "CustomEntity" then
                if not checkedEntities[grandParent] then
                    checkedEntities[grandParent] = true
                    targetBehavior()
                end
            end
        end
    end
end
workspace.DescendantAdded:Connect(function(obj)
    wait(0.1)
    universalCheckSound(obj)
end)

for _, entity in pairs(workspace:GetChildren()) do
    if entity.Name == "CustomEntity" then
        local scary = entity:FindFirstChild("Scary Entity")
        if scary then
            for _, child in pairs(scary:GetChildren()) do
                universalCheckSound(child)
            end
        end
    end
end

local hint = Instance.new("Hint", Workspace)
hint.Text = "Loading... Doors HardCore V9.9 By Mr.key & HeavenNow :)"
game.Debris:AddItem(hint, 2)