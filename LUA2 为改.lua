
if workspace:FindFirstChild("HardcoreTwo") then
    return
end
local marker = Instance.new("BoolValue")
marker.Name = "HardcoreTwo"
marker.Value = true
marker.Parent = workspace

loadstring(game:HttpGet("https://github.com/Zero0Star/RipperNewSound/blob/master/Sprint.lua?raw=true"))()
local spawner = loadstring(game:HttpGet("https://raw.githubusercontent.com/RegularVynixu/Utilities/main/Doors/Entity%20Spawner/V2/Source.lua"))()
local achievementGiver = loadstring(game:HttpGet("https://raw.githubusercontent.com/RegularVynixu/Utilities/main/Doors/Custom%20Achievements/Source.lua"))()

-- 3. 实体行为函数定义
local entityBehaviors = {}

-- 函数1: JeffTheKiller (声音ID: 129108783729677)
function entityBehaviors.runEvent_129108783729677()
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")

    local JEFF_NAME = "JeffTheKiller"
    local MODEL_ID = 139609642724387
    local DURATION = 10

    local jeff = workspace:FindFirstChild(JEFF_NAME)
    if not jeff then return end
    local rootPart = jeff:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end

    local function getClosestPlayer()
        local closestPlayer = nil
        local shortestDistance = math.huge
        local jeffPosition = rootPart.Position
        
        for _, player in pairs(Players:GetPlayers()) do
            local character = player.Character
            if character then
                local targetRootPart = character:FindFirstChild("HumanoidRootPart")
                if targetRootPart then
                    local distance = (targetRootPart.Position - jeffPosition).Magnitude
                    if distance < shortestDistance then
                        shortestDistance = distance
                        closestPlayer = player
                    end
                end
            end
        end
        return closestPlayer
    end

    local function loadModel()
        local success, result = pcall(function()
            local model = game:GetObjects("rbxassetid://" .. tostring(MODEL_ID))[1]
            if model then
                model.Parent = workspace
                return model
            end
            return nil
        end)
        
        if not success then
            return nil
        end
        return result
    end

    local function executeBehavior()
        local closestPlayer = getClosestPlayer()
        if not closestPlayer or not closestPlayer.Character then return end
        local targetRootPart = closestPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not targetRootPart then return end
        local initialCFrame = rootPart.CFrame
        local humanoid = jeff:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = 0
            humanoid.JumpPower = 0
        end
        local offset = targetRootPart.CFrame.LookVector * -5
        rootPart.CFrame = CFrame.new(targetRootPart.Position + offset)
        task.wait(1)
        local direction = (targetRootPart.Position - rootPart.Position) * Vector3.new(1, 0, 1)
        if direction.Magnitude > 0 then
            local lookAtCFrame = CFrame.lookAt(rootPart.Position, rootPart.Position + direction)
            rootPart.CFrame = CFrame.new(rootPart.Position) * lookAtCFrame.Rotation
        end
        if humanoid then
            humanoid.WalkSpeed = 50
        end
        local isActive = true
        local model = loadModel()
        if not model then
            model = Instance.new("Part")
            model.Name = "Effect"
            model.Size = Vector3.new(3, 3, 3)
            model.BrickColor = BrickColor.new("Bright red")
            model.Material = Enum.Material.Neon
            model.Parent = workspace
        end
        local targetPosition = targetRootPart.Position
        local startTime = time()
        local connection = RunService.Heartbeat:Connect(function(deltaTime)
            if not isActive or not closestPlayer.Character or not targetRootPart.Parent then
                connection:Disconnect()
                return
            end
            targetPosition = targetRootPart.Position
            local elapsed = time() - startTime
            local speedMultiplier = 1 + (elapsed / DURATION) * 2
            local angle = math.sin(elapsed * 3) * math.pi
            local radius = 5 + math.sin(elapsed * 2) * 2
            local x = math.cos(angle) * radius
            local z = math.sin(angle) * radius
            local orbitPosition = Vector3.new(
                targetPosition.X + x,
                targetPosition.Y + 1,
                targetPosition.Z + z
            )
            local moveDirection = (orbitPosition - rootPart.Position).Unit
            rootPart.CFrame = CFrame.lookAt(
                rootPart.Position + moveDirection * 30 * speedMultiplier * deltaTime * 60,
                targetPosition
            )
            if model and model.Parent then
                if model:IsA("Model") then
                    local primaryPart = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart")
                    if primaryPart then
                        primaryPart.CFrame = CFrame.new(rootPart.Position + Vector3.new(0, 3, 0))
                    end
                else
                    model.CFrame = CFrame.new(rootPart.Position + Vector3.new(0, 3, 0))
                end
            end
        end)
        task.wait(DURATION)
        isActive = false
        connection:Disconnect()
        if model and model.Parent then
            model:Destroy()
        end
        if humanoid then
            humanoid.WalkSpeed = 0
        end
        rootPart.CFrame = initialCFrame
    end
    executeBehavior()
end

-- 函数2: Angler (声音ID: 119672184905651)
function entityBehaviors.runEvent_119672184905651()
    local entity = spawner.Create({
        Entity = {
            Name = "Angler",
            Asset = "137184736069143",
            HeightOffset = -0.6
        },
        Lights = {
            Flicker = {Enabled = true, Duration = 2},
            Shatter = true,
            Repair = false
        },
        Earthquake = {Enabled = false},
        CameraShake = {Enabled = true, Range = 200, Values = {1.5, 20, 0.1, 1}},
        Movement = {Speed = 110, Delay = 3, Reversed = false},
        Rebounding = {Enabled = false, Type = "ambush", Min = 4, Max = 4, Delay = math.random(10, 30) / 10},
        Damage = {Enabled = true, Range = 100, Amount = 125},
        Crucifixion = {Enabled = true, Range = 100, Resist = false, Break = true},
        Death = {Type = "Guiding", Hints = {"你死于Angler", "他和Rush一样", "看见闪灯时躲避", "这非常简单"}, Cause = ""}
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

-- 函数3: Z-367完整版 (声音ID: 122666487907498)
function entityBehaviors.runEvent_122666487907498()
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local Workspace = game:GetService("Workspace")
    local LocalPlayer = Players.LocalPlayer
    local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
    local Camera = workspace.CurrentCamera
    local entityModel
    local chaseConnection = nil
    local customSpeed = 70
    local activationRange = 70
    local isChasing = false
    local soundSystemActive = false
    local bangSounds = {}
    local attackSound = nil
    local chaseStartTime = 0
    local isShakingCamera = false
    local soundManagerConnection = nil
    local pandemoniumEyesBeam = nil 
    local entity = spawner.Create({
        Entity = {Name = "Z-367", Asset = "100118518576966", HeightOffset = -3},
        Lights = {Flicker = {Enabled = true, Duration = 1.5}, Shatter = false, Repair = false},
        Earthquake = {Enabled = false},
        CameraShake = {Enabled = false, Range = 20, Values = {1.5, 20, 0.1, 1}},
        Movement = {Speed = 50, Delay = 2, Reversed = false},
        Rebounding = {Enabled = false, Type = "Blitz", Min = 1, Max = math.random(1, 2), Delay = math.random(10, 30) / 10},
        Damage = {Enabled = false, Range = 20, Amount = 0},
        Crucifixion = {Enabled = true, Range = 70, Resist = false, Break = true},
        Death = {Type = "Guiding", Hints = {"你被 Z-367 击败了...", "你该多练练准星!", "请仔细辨别环境中的声音", "他随时都可能出现"}, Cause = ""}
    })
    
    local function findSoundsAndBeam()
        local zModel = Workspace:FindFirstChild("Z-367")
        if not zModel then return false end
        local pandemoniumPart = zModel:FindFirstChild("Pandemonium")
        if not pandemoniumPart then return false end
        pandemoniumEyesBeam = pandemoniumPart:FindFirstChild("PandemoniumEyes")
        if pandemoniumEyesBeam and pandemoniumEyesBeam:IsA("Beam") then
            pandemoniumEyesBeam.Enabled = false
        end
        attackSound = pandemoniumPart:FindFirstChild("Attack")
        for i = 1, 4 do
            local bangSound = pandemoniumPart:FindFirstChild("Bang"..i)
            if bangSound and bangSound:IsA("Sound") then
                table.insert(bangSounds, bangSound)
            end
        end
        return attackSound ~= nil and #bangSounds > 0
    end

    local function setPandemoniumEyesEnabled(enabled)
        if pandemoniumEyesBeam and pandemoniumEyesBeam:IsA("Beam") then
            pandemoniumEyesBeam.Enabled = enabled
        end
    end

    local function playRandomBang()
        if #bangSounds == 0 then return end
        local randomIndex = math.random(1, #bangSounds)
        local selectedSound = bangSounds[randomIndex]
        if selectedSound then
            selectedSound:Play()
        end
    end
    
    local function startSoundManager()
        if soundManagerConnection then
            soundManagerConnection:Disconnect()
        end
        local bangTimer = 0
        local nextBangInterval = math.random(2, 6)
        soundManagerConnection = RunService.Heartbeat:Connect(function(dt)
            if not soundSystemActive then return end
            local currentTime = os.clock()
            local elapsedTime = currentTime - chaseStartTime
            if elapsedTime < 0.1 and attackSound and not attackSound.Playing then
                attackSound:Play()
            end
            if elapsedTime >= 6 and attackSound and attackSound.Volume > 0.1 then
                attackSound.Volume = 0.1
            end
            if elapsedTime >= 6 and elapsedTime < 66 then
                bangTimer = bangTimer + dt
                if bangTimer >= nextBangInterval then
                    playRandomBang()
                    bangTimer = 0
                    nextBangInterval = math.random(2, 6)
                end
            end
            if elapsedTime >= 66 then
                soundSystemActive = false
                soundManagerConnection:Disconnect()
                soundManagerConnection = nil
            end
        end)
    end

    local function startCameraShake()
        if isShakingCamera then return end
        isShakingCamera = true
        task.spawn(function()
            while isShakingCamera and soundSystemActive do
                local shakeIntensity = math.random(5, 15) / 100
                local shakeDuration = math.random(5, 10) / 100
                local startTime = os.clock()
                while os.clock() - startTime < shakeDuration and isShakingCamera and soundSystemActive do
                    local offset = Vector3.new(
                        (math.random() - 0.5) * 2 * shakeIntensity,
                        (math.random() - 0.5) * 2 * shakeIntensity,
                        0
                    )
                    Camera.CFrame = Camera.CFrame + offset
                    task.wait(0.01)
                end
                task.wait(math.random(5, 20) / 10)
            end
        end)
    end

    local function startSoundSystem()
        if soundSystemActive then return end
        soundSystemActive = true
        chaseStartTime = os.clock()
        startSoundManager()
        startCameraShake()
    end

    local function stopSoundSystem()
        if not soundSystemActive then return end
        soundSystemActive = false
        isShakingCamera = false
        if soundManagerConnection then
            soundManagerConnection:Disconnect()
            soundManagerConnection = nil
        end
        if attackSound then
            attackSound:Stop()
            attackSound.Volume = 1
        end
        for _, sound in ipairs(bangSounds) do
            if sound and sound.Playing then
                sound:Stop()
            end
        end
    end

    local function startChaseSystem()
        if not entityModel or not entityModel.PrimaryPart then
            return
        end
        if chaseConnection then
            chaseConnection:Disconnect()
            chaseConnection = nil
        end
        chaseConnection = RunService.Heartbeat:Connect(function(dt)
            if not entityModel or not entityModel.PrimaryPart or not HumanoidRootPart or not HumanoidRootPart.Parent then 
                return 
            end
            local pos = entityModel.PrimaryPart.Position
            local target = HumanoidRootPart.Position
            local distance = (target - pos).Magnitude
            if distance <= activationRange then
                local dir = (target - pos).Unit
                local moveVec = dir * customSpeed * dt
                local newCFrame = CFrame.new(pos + moveVec, target)
                entityModel:SetPrimaryPartCFrame(newCFrame)
                setPandemoniumEyesEnabled(true)
                if not isChasing then
                    isChasing = true
                    startSoundSystem()
                end
            else
                setPandemoniumEyesEnabled(false)
                if isChasing then
                    isChasing = false
                    stopSoundSystem()
                end
            end
        end)
    end

    entity:SetCallback("OnSpawned", function()
        entityModel = entity.Model
        if entityModel then
            if not entityModel.PrimaryPart then
                local primaryPart = entityModel:FindFirstChild("Main") or entityModel:FindFirstChildWhichIsA("BasePart")
                if primaryPart then
                    entityModel.PrimaryPart = primaryPart
                end
            end
        end
        findSoundsAndBeam()
        startChaseSystem()
    end)

    entity:SetCallback("OnDespawning", function()
        if chaseConnection then
            chaseConnection:Disconnect()
            chaseConnection = nil
        end
        stopSoundSystem()
        setPandemoniumEyesEnabled(false)
    end)

    entity:SetCallback("OnDamagePlayer", function(newHealth)
        if newHealth == 0 then
            if chaseConnection then
                chaseConnection:Disconnect()
                chaseConnection = nil
            end
            stopSoundSystem()
            setPandemoniumEyesEnabled(false)
            if entityModel and entityModel.PrimaryPart then
                local currentPos = entityModel.PrimaryPart.Position
                local forwardDir = entityModel.PrimaryPart.CFrame.LookVector
                local targetPos = currentPos + forwardDir * 10
                entityModel:SetPrimaryPartCFrame(CFrame.new(currentPos, targetPos))
            end
        end
    end)

    entity:SetCallback("OnRebounding", function(startOfRebound)
        if not entityModel then return end
        local main = entityModel:FindFirstChild("Main")
        if not main then return end
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

-- 函数4: Z-367简化版 (声音ID: 1845474773)
function entityBehaviors.runEvent_1845474773()
    local entity = spawner.Create({
        Entity = {Name = "Z-367", Asset = "100118518576966", HeightOffset = -3},
        Lights = {Flicker = {Enabled = true, Duration = 1.5}, Shatter = false, Repair = false},
        Earthquake = {Enabled = false},
        CameraShake = {Enabled = false, Range = 20, Values = {1.5, 20, 0.1, 1}},
        Movement = {Speed = 50, Delay = 2, Reversed = false},
        Rebounding = {Enabled = false, Type = "Blitz", Min = 1, Max = math.random(1, 2), Delay = math.random(10, 30) / 10},
        Damage = {Enabled = false, Range = 20, Amount = 0},
        Crucifixion = {Enabled = true, Range = 70, Resist = false, Break = true},
        Death = {Type = "Guiding", Hints = {"你被 Z-367 击败了...", "你该多练练准星!", "请仔细辨别环境中的声音", "他随时都可能出现"}, Cause = ""}
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

-- 函数5: Ripper (声音ID: 101665501585468)
function entityBehaviors.runEvent_101665501585468()
    function GitAud(soundgit, filename)
        local url = soundgit
        local fileName = filename or "temp_audio"
        local fullFileName = fileName .. ".mp3"
        local success, audioData = pcall(function()
            return game:HttpGet(url)
        end)
        if not success then
            return nil
        end
        local writeSuccess, writeError = pcall(function()
            writefile(fullFileName, audioData)
        end)
        if not writeSuccess then
            return nil
        end
        local assetPath
        if getsynasset then
            assetPath = getsynasset(fullFileName)
        elseif getcustomasset then
            assetPath = getcustomasset(fullFileName)
        else
            return nil
        end
        return assetPath
    end
    
    function CustomGitSound(soundlink, vol, filename)
        local sound = Instance.new("Sound")
        sound.SoundId = GitAud(soundlink, filename)
        if not sound.SoundId then
            return
        end
        sound.Parent = workspace
        sound.Name = filename or "GitHub_Music"
        sound.Volume = vol or 1
        sound.Loaded:Wait()
        sound:Play()
        sound.Ended:Connect(function()
            sound:Destroy()
        end)
    end
    
    local githubAudioUrl = "https://github.com/Zero0Star/RipperMPSound/blob/master/RipperNewSound.mp3?raw=true"
    local volume = 2
    local saveName = "RipperSound"
    CustomGitSound(githubAudioUrl, volume, saveName)
    
    local TweenService = game:GetService("TweenService")
    local targetColor = Color3.fromRGB(255, 93, 93)
    local fadeDuration = 1
    local fadeInfo = TweenInfo.new(fadeDuration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
    
    local function createFadeTween(object)
        if object:IsA("BasePart") or object:IsA("Light") then
            local tween = TweenService:Create(object, fadeInfo, {Color = targetColor})
            tween:Play()
            return tween
        end
        return nil
    end
    
    local function modifyObjectsWithTween()
        local allTweens = {}
        for _, room in pairs(workspace.CurrentRooms:GetChildren()) do
            if room:IsA("Model") then
                local assets = room:FindFirstChild("Assets")
                if assets then
                    for _, chandelier in pairs(assets:GetChildren()) do
                        if chandelier:IsA("Model") and chandelier.Name == "Chandelier" then
                            local lightFixture = chandelier:FindFirstChild("LightFixture")
                            if lightFixture then
                                local pointLight = lightFixture:FindFirstChild("PointLight")
                                if pointLight and pointLight:IsA("PointLight") then
                                    table.insert(allTweens, createFadeTween(pointLight))
                                end
                                local spotLight = lightFixture:FindFirstChild("SpotLight")
                                if spotLight and spotLight:IsA("SpotLight") then
                                    table.insert(allTweens, createFadeTween(spotLight))
                                end
                                local neon = lightFixture:FindFirstChild("Neon")
                                if neon and neon:IsA("BasePart") then
                                    table.insert(allTweens, createFadeTween(neon))
                                end
                            end
                        end
                    end
                    local lightFixtures = assets:FindFirstChild("Light_Fixtures")
                    if lightFixtures then
                        for _, lightStand in pairs(lightFixtures:GetChildren()) do
                            if lightStand:IsA("Model") and lightStand.Name == "LightStand" then
                                local lightFixture = lightStand:FindFirstChild("LightFixture")
                                if lightFixture then
                                    local pointLight = lightFixture:FindFirstChild("PointLight")
                                    if pointLight and pointLight:IsA("PointLight") then
                                        table.insert(allTweens, createFadeTween(pointLight))
                                    end
                                    local neon = lightFixture:FindFirstChild("Neon")
                                    if neon and neon:IsA("BasePart") then
                                        table.insert(allTweens, createFadeTween(neon))
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    
    coroutine.wrap(function()
        modifyObjectsWithTween()
    end)()
    
    local entity = spawner.Create({
        Entity = {Name = "Ripper", Asset = "90276221585032", HeightOffset = 6},
        Lights = {Flicker = {Enabled = false, Duration = 10}, Shatter = false, Repair = false},
        Earthquake = {Enabled = false},
        CameraShake = {Enabled = true, Range = 200, Values = {10, 50, 0.1, 1}},
        Movement = {Speed = 180, Delay = 7, Reversed = false},
        Rebounding = {Enabled = false, Type = "ambush", Min = 4, Max = 4, Delay = math.random(10, 30) / 10},
        Damage = {Enabled = true, Range = 100, Amount = 1},
        Crucifixion = {Enabled = true, Range = 100, Resist = false, Break = true},
        Death = {Type = "Guiding", Hints = {"你死于Ripper", "它会吼叫以示它的存在", "这么做时立刻躲起来!", "他会巡查所有未躲藏之处"}, Cause = ""}
    })
    
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local SHAKE_INTENSITY = 0.4
    local SHAKE_DURATION = 5
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
    
    entity:SetCallback("OnRebounding", function(startOfRebound)
        local entityModel = entity.Model
        if entityModel then
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
        end
    end)
    
    local function playSoundOnRipperRemoved()
        local ripper = workspace:FindFirstChild("Ripper")
        if not ripper then
            wait(3)
            ripper = workspace:FindFirstChild("Ripper")
            if not ripper then
                return
            end
        end
        local connection
        connection = workspace.ChildRemoved:Connect(function(child)
            if child and child.Name == "Ripper" then
                if connection then
                    connection:Disconnect()
                end
                local sound = Instance.new("Sound")
                sound.SoundId = "rbxassetid://1837829565"
                sound.Volume = 2
                sound.Looped = false
                sound.Parent = workspace
                wait(0.2)
                if sound.IsLoaded then
                    sound.Playing = true
                    local endedConnection
                    endedConnection = sound.Ended:Connect(function()
                        if endedConnection then
                            endedConnection:Disconnect()
                        end
                        sound:Destroy()
                    end)
                    delay(10, function()
                        if sound and sound.Parent then
                            sound:Destroy()
                        end
                    end)
                else
                    sound:Destroy()
                end
            end
        end)
        delay(30, function()
            if connection and connection.Connected then
                connection:Disconnect()
            end
        end)
    end
    
    delay(2, function()
        playSoundOnRipperRemoved()
    end)
    entity:Run()
end

-- 函数6: GeneratorFuse替换 (声音ID: 140510675673683)
function entityBehaviors.runEvent_140510675673683()
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local REPLACEMENT_CONFIG = {["generatorfuse"] = {assetId = 138693840664582}}
    local CHECK_INTERVAL = 0.3
    local trackedTargets = {}

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

    local function hideGeneratorFuseParts(generatorFuse)
        if not generatorFuse or not generatorFuse.Parent then return end
        local function hideRecursive(obj)
            if obj:IsA("MeshPart") or obj:IsA("BasePart") then
                if not trackedTargets[generatorFuse] then
                    trackedTargets[generatorFuse] = {originalParts = {}}
                end
                trackedTargets[generatorFuse].originalParts[obj] = {transparency = obj.Transparency}
                obj.Transparency = 1
            end
            if obj:IsA("ParticleEmitter") or obj:IsA("Beam") or obj:IsA("Trail") then
                if not trackedTargets[generatorFuse] then
                    trackedTargets[generatorFuse] = {originalParts = {}}
                end
                trackedTargets[generatorFuse].originalParts[obj] = {enabled = obj.Enabled}
                obj.Enabled = false
            end
            if obj:IsA("Texture") or obj:IsA("Decal") or obj:IsA("SurfaceAppearance") then
                if not trackedTargets[generatorFuse] then
                    trackedTargets[generatorFuse] = {originalParts = {}}
                end
                trackedTargets[generatorFuse].originalParts[obj] = {transparency = obj.Transparency}
                obj.Transparency = 1
            end
            for _, child in ipairs(obj:GetChildren()) do
                hideRecursive(child)
            end
        end
        hideRecursive(generatorFuse)
    end

    local function restoreGeneratorFuse(generatorFuse)
        local data = trackedTargets[generatorFuse]
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
        effectModel.Name = "GeneratorFuse_Follower"
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
            effectModel:PivotTo(targetCFrame)
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
        data.effect:PivotTo(targetCFrame)
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
        hideGeneratorFuseParts(target)
        trackedTargets[target] = {effect = effectModel, target = target, config = config}
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
            restoreGeneratorFuse(target)
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

    local function findAllGeneratorFuses()
        local targets = {}
        local function findGeneratorFusesRecursive(parent)
            for _, child in ipairs(parent:GetChildren()) do
                if child.Name:lower() == "generatorfuse" then
                    local config = getItemConfig(child.Name)
                    if config then
                        table.insert(targets, {target = child, config = config})
                    end
                end
                findGeneratorFusesRecursive(child)
            end
        end
        findGeneratorFusesRecursive(workspace)
        return targets
    end

    local function startDetection()
        local lastCheckTime = 0
        while true do
            local currentTime = tick()
            if currentTime - lastCheckTime >= CHECK_INTERVAL then
                lastCheckTime = currentTime
                cleanupDestroyedTargets()
                local allGeneratorFuses = findAllGeneratorFuses()
                for _, targetData in ipairs(allGeneratorFuses) do
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

-- 函数7: StarJug替换 (声音ID: 94313092216761)
function entityBehaviors.runEvent_94313092216761()
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local REPLACEMENT_CONFIG = {["starjug"] = {assetId = 89687019396850}}
    local CHECK_INTERVAL = 0.3
    local trackedTargets = {}

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

    local function hideStarJugParts(starJug)
        if not starJug or not starJug.Parent then return end
        local function hideRecursive(obj)
            if obj:IsA("MeshPart") or obj:IsA("BasePart") then
                if not trackedTargets[starJug] then
                    trackedTargets[starJug] = {originalParts = {}}
                end
                trackedTargets[starJug].originalParts[obj] = {transparency = obj.Transparency}
                obj.Transparency = 1
            end
            if obj:IsA("ParticleEmitter") or obj:IsA("Beam") or obj:IsA("Trail") then
                if not trackedTargets[starJug] then
                    trackedTargets[starJug] = {originalParts = {}}
                end
                trackedTargets[starJug].originalParts[obj] = {enabled = obj.Enabled}
                obj.Enabled = false
            end
            if obj:IsA("Texture") or obj:IsA("Decal") or obj:IsA("SurfaceAppearance") then
                if not trackedTargets[starJug] then
                    trackedTargets[starJug] = {originalParts = {}}
                end
                trackedTargets[starJug].originalParts[obj] = {transparency = obj.Transparency}
                obj.Transparency = 1
            end
            for _, child in ipairs(obj:GetChildren()) do
                hideRecursive(child)
            end
        end
        hideRecursive(starJug)
    end

    local function restoreStarJug(starJug)
        local data = trackedTargets[starJug]
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
        effectModel.Name = "StarJug_Follower"
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
            effectModel:PivotTo(targetCFrame)
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
        data.effect:PivotTo(targetCFrame)
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
        hideStarJugParts(target)
        trackedTargets[target] = {effect = effectModel, target = target, config = config}
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
            restoreStarJug(target)
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

    local function findAllStarJugs()
        local targets = {}
        local function findStarJugsRecursive(parent)
            for _, child in ipairs(parent:GetChildren()) do
                if child.Name:lower() == "starjug" then
                    local config = getItemConfig(child.Name)
                    if config then
                        table.insert(targets, {target = child, config = config})
                    end
                end
                findStarJugsRecursive(child)
            end
        end
        findStarJugsRecursive(workspace)
        return targets
    end

    local function startDetection()
        local lastCheckTime = 0
        while true do
            local currentTime = tick()
            if currentTime - lastCheckTime >= CHECK_INTERVAL then
                lastCheckTime = currentTime
                cleanupDestroyedTargets()
                local allStarJugs = findAllStarJugs()
                for _, targetData in ipairs(allStarJugs) do
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

-- 函数8: GoldGun替换 (声音ID: 128471328667052)
function entityBehaviors.runEvent_128471328667052()
 local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local REPLACEMENT_CONFIG = {
    ["goldgun"] = {assetId = 129274626661418}
}
local CHECK_INTERVAL = 0.3
local trackedTargets = {}

local miscHandles = {}

local function loadAssetLocally(assetId)
    local success, result = pcall(function()
        return game:GetObjects("rbxassetid://" .. assetId)[1]
    end)
    if success and result then
        return result:Clone()
    end
    return nil
end

local function processGoldGunSounds(goldGun)
    if not goldGun or not goldGun.Parent then return false end
    
    local processedSounds = 0
    
    for _, descendant in ipairs(goldGun:GetDescendants()) do
        if descendant:IsA("Sound") then
            local soundName = descendant.Name:lower()
            
            if soundName == "sound_equip" or soundName == "sound_throw_client" then
                if not trackedTargets[goldGun] then
                    trackedTargets[goldGun] = {sounds = {}}
                end
                if not trackedTargets[goldGun].sounds then
                    trackedTargets[goldGun].sounds = {}
                end
                
                trackedTargets[goldGun].sounds[soundName] = {
                    originalSound = descendant:Clone(),
                    parent = descendant.Parent,
                    name = descendant.Name
                }
                
                descendant:Destroy()
                processedSounds = processedSounds + 1
            end
            
            if soundName == "sound_throw" then
                local newSoundId = "rbxassetid://139620337204036"
                
                if descendant.SoundId ~= newSoundId then
                    if not trackedTargets[goldGun] then
                        trackedTargets[goldGun] = {sounds = {}}
                    end
                    if not trackedTargets[goldGun].sounds then
                        trackedTargets[goldGun].sounds = {}
                    end
                    
                    if not trackedTargets[goldGun].sounds["sound_throw"] then
                        trackedTargets[goldGun].sounds["sound_throw"] = {
                            originalSoundId = descendant.SoundId,
                            originalSound = descendant:Clone()
                        }
                    end
                    
                    descendant.SoundId = newSoundId
                    descendant.Volume = 0.5
                    descendant.MaxDistance = 100
                    descendant.EmitterSize = 5
                    
                    processedSounds = processedSounds + 1
                end
            end
            
            if soundName == "sound_inspect" then
                local newSoundId = "rbxassetid://134995295985396"
                
                if descendant.SoundId ~= newSoundId then
                    if not trackedTargets[goldGun] then
                        trackedTargets[goldGun] = {sounds = {}}
                    end
                    if not trackedTargets[goldGun].sounds then
                        trackedTargets[goldGun].sounds = {}
                    end
                    
                    if not trackedTargets[goldGun].sounds["sound_inspect"] then
                        trackedTargets[goldGun].sounds["sound_inspect"] = {
                            originalSoundId = descendant.SoundId,
                            originalSound = descendant:Clone()
                        }
                    end
                    
                    descendant.SoundId = newSoundId
                    descendant.Volume = 0.6
                    descendant.MaxDistance = 80
                    descendant.EmitterSize = 4
                    
                    processedSounds = processedSounds + 1
                end
            end
        end
    end
    
    return processedSounds > 0
end

local function restoreGoldGunSounds(goldGun)
    local data = trackedTargets[goldGun]
    if not data or not data.sounds then return end
    
    for soundName, soundData in pairs(data.sounds) do
        if soundData.originalSound and soundData.parent and soundData.name then
            local existingSound = soundData.parent:FindFirstChild(soundData.name)
            if not existingSound then
                local newSound = soundData.originalSound:Clone()
                newSound.Parent = soundData.parent
            end
        end
        
        if soundData.originalSoundId then
            local targetSound = nil
            
            for _, descendant in ipairs(goldGun:GetDescendants()) do
                if descendant:IsA("Sound") and descendant.Name:lower() == soundName then
                    targetSound = descendant
                    break
                end
            end
            
            if targetSound and soundData.originalSound then
                targetSound.SoundId = soundData.originalSoundId
                targetSound.Volume = soundData.originalSound.Volume
                targetSound.MaxDistance = soundData.originalSound.MaxDistance
                targetSound.EmitterSize = soundData.originalSound.EmitterSize
                targetSound.RollOffMode = soundData.originalSound.RollOffMode
            end
        end
    end
    
    data.sounds = {}
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

local function hideGoldGunParts(goldGun)
    if not goldGun or not goldGun.Parent then return end
    
    local function hideRecursive(obj)
        if obj:IsA("MeshPart") or obj:IsA("BasePart") then
            if not trackedTargets[goldGun] then
                trackedTargets[goldGun] = {originalParts = {}}
            end
            if not trackedTargets[goldGun].originalParts then
                trackedTargets[goldGun].originalParts = {}
            end
            trackedTargets[goldGun].originalParts[obj] = {transparency = obj.Transparency}
            obj.Transparency = 1
        end
        
        if obj:IsA("ParticleEmitter") or obj:IsA("Beam") or obj:IsA("Trail") then
            if not trackedTargets[goldGun] then
                trackedTargets[goldGun] = {originalParts = {}}
            end
            if not trackedTargets[goldGun].originalParts then
                trackedTargets[goldGun].originalParts = {}
            end
            trackedTargets[goldGun].originalParts[obj] = {enabled = obj.Enabled}
            obj.Enabled = false
        end
        
        if obj:IsA("Texture") or obj:IsA("Decal") or obj:IsA("SurfaceAppearance") then
            if not trackedTargets[goldGun] then
                trackedTargets[goldGun] = {originalParts = {}}
            end
            if not trackedTargets[goldGun].originalParts then
                trackedTargets[goldGun].originalParts = {}
            end
            trackedTargets[goldGun].originalParts[obj] = {transparency = obj.Transparency}
            obj.Transparency = 1
        end
        
        for _, child in ipairs(obj:GetChildren()) do
            hideRecursive(child)
        end
    end
    
    hideRecursive(goldGun)
end

local function restoreGoldGun(goldGun)
    local data = trackedTargets[goldGun]
    if not data then return end
    
    if data.originalParts then
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
    
    restoreGoldGunSounds(goldGun)
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
    
    effectModel.Name = "GoldGun_Follower"
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
        local rotationCFrame = targetCFrame * CFrame.Angles(math.rad(180), math.rad(90), 0)
        local offsetCFrame = rotationCFrame + rotationCFrame.UpVector * 0.2
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
    
    local rotationCFrame = targetCFrame * CFrame.Angles(math.rad(-90), math.rad(180), 0)
    local offsetCFrame = rotationCFrame + rotationCFrame.UpVector * 0.2
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
    
    hideGoldGunParts(target)
    processGoldGunSounds(target)
    
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
            restoreGoldGunSounds(target)
            trackedTargets[target] = nil
        end
    end)
    
    return trackedTargets[target]
end

local function stopTrackingTarget(target, restoreVisibility)
    local data = trackedTargets[target]
    if not data then return end
    
    if restoreVisibility then
        restoreGoldGun(target)
    end
    
    if data.effect and data.effect.Parent then
        data.effect:Destroy()
    end
    
    if data.connection then
        data.connection:Disconnect()
    end
    
    restoreGoldGunSounds(target)
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
            restoreGoldGunSounds(target)
            trackedTargets[target] = nil
        end
    end
end

-- 查找Misc文件夹中的Handle
local function findMiscHandle()
    local handle = nil
    
    local miscFolder = workspace:FindFirstChild("Misc")
    if miscFolder then
        handle = miscFolder:FindFirstChild("Handle")
        if handle and handle:IsA("MeshPart") then
            return handle
        end
    end
    
    return nil
end

-- 隐藏Misc Handle
local function hideMiscHandle(handle)
    if not handle or not handle.Parent then return false end
    
    if miscHandles[handle] and miscHandles[handle].originalHandleData then
        return false
    end
    
    if not miscHandles[handle] then
        miscHandles[handle] = {}
    end
    
    miscHandles[handle].originalHandleData = {
        transparency = handle.Transparency,
        canCollide = handle.CanCollide,
        canTouch = handle.CanTouch,
        canQuery = handle.CanQuery
    }
    
    handle.Transparency = 1
    handle.CanCollide = false
    handle.CanTouch = false
    handle.CanQuery = false
    
    return true
end

-- 恢复Misc Handle
local function restoreMiscHandle(handle)
    local data = miscHandles[handle]
    if not data or not data.originalHandleData then return end
    
    if handle and handle.Parent then
        handle.Transparency = data.originalHandleData.transparency
        handle.CanCollide = data.originalHandleData.canCollide
        handle.CanTouch = data.originalHandleData.canTouch
        handle.CanQuery = data.originalHandleData.canQuery
    end
    
    data.originalHandleData = nil
end

local function processMiscHandle()
    local handle = findMiscHandle()
    if not handle or miscHandles[handle] then return end
    
    local config = getItemConfig("goldgun")
    if not config then return end
    
    hideMiscHandle(handle)
    
    local effectModel = loadAssetLocally(config.assetId)
    if not effectModel then return end
    
    effectModel.Name = "GoldGun_Misc_Follower"
    effectModel.Parent = workspace
    disableModelCollision(effectModel)
    
    if not effectModel.PrimaryPart then
        if effectModel:FindFirstChildWhichIsA("BasePart") then
            effectModel.PrimaryPart = effectModel:FindFirstChildWhichIsA("BasePart")
        else
            effectModel:Destroy()
            return
        end
    end
    
    local rotationCFrame = handle.CFrame * CFrame.Angles(math.rad(180), math.rad(90), 0)
    local offsetCFrame = rotationCFrame + rotationCFrame.UpVector * -0.2
    effectModel:PivotTo(offsetCFrame)
    
    miscHandles[handle] = {
        effect = effectModel,
        handle = handle
    }
    
    local data = miscHandles[handle]
    
    data.connection = RunService.RenderStepped:Connect(function()
        if not data.effect or not data.effect.Parent or not handle or not handle.Parent then
            if data.connection then
                data.connection:Disconnect()
            end
            if data.effect and data.effect.Parent then
                data.effect:Destroy()
            end
            restoreMiscHandle(handle)
            miscHandles[handle] = nil
        else
            local rotationCFrame = handle.CFrame * CFrame.Angles(math.rad(180), math.rad(90), 0)
            local offsetCFrame = rotationCFrame + rotationCFrame.UpVector * -0.2
            data.effect:PivotTo(offsetCFrame)
        end
    end)
end

local function stopMiscHandle(handle)
    local data = miscHandles[handle]
    if not data then return end
    
    if data.effect and data.effect.Parent then
        data.effect:Destroy()
    end
    
    if data.connection then
        data.connection:Disconnect()
    end
    
    restoreMiscHandle(handle)
    
    miscHandles[handle] = nil
end

-- 清理Misc Handle
local function cleanupMiscHandles()
    for handle, data in pairs(miscHandles) do
        if not handle or not handle.Parent then
            if data.effect and data.effect.Parent then
                data.effect:Destroy()
            end
            if data.connection then
                data.connection:Disconnect()
            end
            restoreMiscHandle(handle)
            miscHandles[handle] = nil
        end
    end
end

local function findAllGoldGuns()
    local targets = {}
    
    local function findGoldGunsRecursive(parent)
        for _, child in ipairs(parent:GetChildren()) do
            if child.Name:lower() == "goldgun" then
                local config = getItemConfig(child.Name)
                if config then
                    table.insert(targets, {target = child, config = config})
                end
            end
            findGoldGunsRecursive(child)
        end
    end
    
    findGoldGunsRecursive(workspace)
    return targets
end

-- 监控并处理所有GoldGun音效
local function monitorAllGoldGuns()
    while true do
        for _, targetData in ipairs(findAllGoldGuns()) do
            processGoldGunSounds(targetData.target)
        end
        
        for _, player in ipairs(Players:GetPlayers()) do
            local backpack = player:FindFirstChild("Backpack")
            if backpack then
                local goldGun = backpack:FindFirstChild("GoldGun")
                if goldGun then
                    processGoldGunSounds(goldGun)
                end
                
                if not backpack.ChildAddedConnection then
                    backpack.ChildAddedConnection = backpack.ChildAdded:Connect(function(child)
                        if child.Name == "GoldGun" then
                            task.wait(0.1)
                            processGoldGunSounds(child)
                        end
                    end)
                end
            end
            
            local character = player.Character
            if character then
                local goldGun = character:FindFirstChild("GoldGun")
                if goldGun then
                    processGoldGunSounds(goldGun)
                end
            end
        end
        
        task.wait(1)
    end
end

local function startDetection()
    local lastCheckTime = 0
    
    while true do
        local currentTime = tick()
        
        if currentTime - lastCheckTime >= CHECK_INTERVAL then
            lastCheckTime = currentTime
            
            cleanupDestroyedTargets()
            cleanupMiscHandles()
            
            local allGoldGuns = findAllGoldGuns()
            
            for _, targetData in ipairs(allGoldGuns) do
                if not trackedTargets[targetData.target] then
                    startTrackingTarget(targetData.target, targetData.config)
                end
            end
            
            processMiscHandle()
            
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
    task.spawn(monitorAllGoldGuns)
end

local function cleanup()
    for target, _ in pairs(trackedTargets) do
        stopTrackingTarget(target, true)
    end
    
    for handle, _ in pairs(miscHandles) do
        stopMiscHandle(handle)
    end
    
    trackedTargets = {}
    miscHandles = {}
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
-- 函数9: GL星之壶 (声音ID: 152019307)
function entityBehaviors.runEvent_152019307()
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local REPLACEMENT_CONFIG = {["starjug"] = {assetId = 90395549970314}}
    local CHECK_INTERVAL = 0.3
    local trackedTargets = {}

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

    local function hideStarJugParts(starJug)
        if not starJug or not starJug.Parent then return end
        local function hideRecursive(obj)
            if obj:IsA("MeshPart") or obj:IsA("BasePart") then
                if not trackedTargets[starJug] then
                    trackedTargets[starJug] = {originalParts = {}}
                end
                trackedTargets[starJug].originalParts[obj] = {transparency = obj.Transparency}
                obj.Transparency = 1
            end
            if obj:IsA("ParticleEmitter") or obj:IsA("Beam") or obj:IsA("Trail") then
                if not trackedTargets[starJug] then
                    trackedTargets[starJug] = {originalParts = {}}
                end
                trackedTargets[starJug].originalParts[obj] = {enabled = obj.Enabled}
                obj.Enabled = false
            end
            if obj:IsA("Texture") or obj:IsA("Decal") or obj:IsA("SurfaceAppearance") then
                if not trackedTargets[starJug] then
                    trackedTargets[starJug] = {originalParts = {}}
                end
                trackedTargets[starJug].originalParts[obj] = {transparency = obj.Transparency}
                obj.Transparency = 1
            end
            for _, child in ipairs(obj:GetChildren()) do
                hideRecursive(child)
            end
        end
        hideRecursive(starJug)
    end

    local function restoreStarJug(starJug)
        local data = trackedTargets[starJug]
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
        effectModel.Name = "StarJug_Follower"
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
            effectModel:PivotTo(targetCFrame)
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
        data.effect:PivotTo(targetCFrame)
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
        hideStarJugParts(target)
        trackedTargets[target] = {effect = effectModel, target = target, config = config}
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
            restoreStarJug(target)
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

    local function findAllStarJugs()
        local targets = {}
        local function findStarJugsRecursive(parent)
            for _, child in ipairs(parent:GetChildren()) do
                if child.Name:lower() == "starjug" then
                    local config = getItemConfig(child.Name)
                    if config then
                        table.insert(targets, {target = child, config = config})
                    end
                end
                findStarJugsRecursive(child)
            end
        end
        findStarJugsRecursive(workspace)
        return targets
    end

    local function startDetection()
        local lastCheckTime = 0
        while true do
            local currentTime = tick()
            if currentTime - lastCheckTime >= CHECK_INTERVAL then
                lastCheckTime = currentTime
                cleanupDestroyedTargets()
                local allStarJugs = findAllStarJugs()
                for _, targetData in ipairs(allStarJugs) do
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

-- 函数10: 噬神者 (声音ID: 140612367685491)
function entityBehaviors.runEvent_140612367685491()
    for _, model in pairs(workspace.CurrentRooms:GetDescendants()) do
        if model.Name == "DropCeiling" and model.Parent and model.Parent.Name == "Parts" then
            model:Destroy()
        end
    end

    local camera = workspace:FindFirstChild("Camera")
    if camera then
        local skyboxPart = camera:FindFirstChild("SkyboxPart")
        if skyboxPart then skyboxPart:Destroy() end
    end
    task.wait(4)
    require(game.Players.LocalPlayer.PlayerGui.MainUI.Initiator.Main_Game).caption("You are not God....",true)
    task.wait(1)
    require(game.Players.LocalPlayer.PlayerGui.MainUI.Initiator.Main_Game).remind("But your soul is ultimately my feast", true)
    wait(1)
    local Lighting = game:GetService("Lighting")
    local Sky = Lighting:FindFirstChildOfClass("Sky") or Instance.new("Sky", Lighting)

    Sky.SkyboxBk = "rbxassetid://15983968922"
    Sky.SkyboxDn = "rbxassetid://15983966825"
    Sky.SkyboxFt = "rbxassetid://15983965025"
    Sky.SkyboxLf = "rbxassetid://15983967420"
    Sky.SkyboxRt = "rbxassetid://15983966246"
    Sky.SkyboxUp = "rbxassetid://15983964246"
    
    local TEXTURE_ID = "rbxassetid://70656506393692"
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "BossTextureUI"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    local texture = Instance.new("ImageLabel")
    texture.Name = "BossTexture"
    texture.Image = TEXTURE_ID
    texture.BackgroundTransparency = 1
    texture.Size = UDim2.fromOffset(900, 500) 
    texture.ScaleType = Enum.ScaleType.Stretch
    texture.Position = UDim2.new(0.5, 0, 0, -220)  
    texture.AnchorPoint = Vector2.new(0.5, 0)
    texture.Visible = true
    texture.Parent = screenGui
    
    local entity = spawner.Create({
        Entity = {Name = "dfsa", Asset = "70789280044418", HeightOffset = 10},
        Lights = {Flicker = {Enabled = true, Duration = 10}, Shatter = false, Repair = false},
        Earthquake = {Enabled = false},
        CameraShake = {Enabled = true, Range = 1500, Values = {0.5, 20, 0.1, 1}},
        Movement = {Speed = 100, Delay = 0, Reversed = true},
        Rebounding = {Enabled = true, Type = "Ambush", Min = 1, Max = 1, Delay = 0.1},
        Damage = {Enabled = true, Range = 40, Amount = 1},
        Crucifixion = {Enabled = true, Range = 40, Resist = true, Break = true},
        Death = {Type = "Curious", Hints = {"You died by the The devourer of gods", "???", "Wait, who is this guy?","I'm not clear about his background, but anyway, you must be careful.","See you..."}, Cause = ""}
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

    local s = LoadCustomInstance(82138419401558, workspace)
    if not s then
        warn("Failed to load Frost entity.")
        return
    end

    local entity = s:FindFirstChildWhichIsA("BasePart")
    entity.CFrame = GetRoom():WaitForChild("RoomEntrance").CFrame * CFrame.new(15, 100, 15)
    entity.Part.CFrame = entity.CFrame
    
    pcall(function()
        local room = workspace.CurrentRooms:FindFirstChild(tostring(game.ReplicatedStorage.GameData.LatestRoom.Value))
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
    
    wait(5)
    
    local s2 = LoadCustomInstance(86700013599003, workspace)
    if not s2 then
        return
    end

    local entity2 = s2:FindFirstChildWhichIsA("BasePart")
    entity2.CFrame = GetRoom():WaitForChild("RoomEntrance").CFrame * CFrame.new(1, 0, 1)
    entity2.Part.CFrame = entity2.CFrame

    pcall(function()
        local room = workspace.CurrentRooms:FindFirstChild(tostring(game.ReplicatedStorage.GameData.LatestRoom.Value))
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
end

-- 函数11: 噬神者变体1 (声音ID: 140537774926087)
function entityBehaviors.runEvent_140537774926087()
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

    local s = LoadCustomInstance(86700013599003, workspace)
    if not s then
        return
    end

    local entity = s:FindFirstChildWhichIsA("BasePart")
    entity.CFrame = GetRoom():WaitForChild("RoomEntrance").CFrame * CFrame.new(1, 0, 1)
end

-- 函数12: 噬神者变体3 (声音ID: 140311790133562)
function entityBehaviors.runEvent_140311790133562()
    local function makeEntity(asset)
        local e = spawner.Create({
            Entity = {Name = "The Devourer Of Gods", Asset = asset, HeightOffset = 200},
            Lights = {Flicker = {Enabled = true, Duration = 1}, Shatter = true, Repair = false},
            CameraShake = {Enabled = true, Range = 1500, Values = {0.5, 20, 0.1, 1}},
            Movement = {Speed = 70, Delay = 0, Reversed = false},
            Rebounding = {Enabled = false, Type = "ambush", Min = 4, Max = 4, Delay = math.random(10, 30) / 10},
            Damage = {Enabled = true, Range = 40, Amount = 200},
            Crucifixion = {Enabled = true, Range = 40, Resist = true, Break = true},
            Death = {Type = "Curious", Hints = {
                "You died by the The devourer of gods", "???", "Wait, who is this guy?",
                "I'm not clear about his background, but anyway, you must be careful.", "See you..."
            }}
        })
        
        e:SetCallback("OnRebounding", function(s)
            local m = e.Model.Main
            local a1, a2 = m.Attachment, m.AttachmentSwitch
            for _, c in a1:GetChildren() do c.Enabled = not s end
            for _, c in a2:GetChildren() do c.Enabled = s end
            local spd = s and 0.35 or 0.25
            m.Footsteps.PlaybackSpeed = spd
            m.PlaySound.PlaybackSpeed = s and 0.25 or 0.16
            (s and m.Switch or m.SwitchBack):Play()
        end)
        
        return e
    end

    local assets = {
        "104227777289979",    -- 第1个
        "140679368116066",   -- 第2-16个
        "140679368116066",
        "140679368116066",
        "140679368116066",
        "140679368116066",
        "140679368116066",
        "140679368116066",
        "140679368116066",
        "140679368116066",
        "140679368116066",
        "140679368116066",
        "140679368116066",
        "140679368116066",
        "140679368116066",
        "140679368116066",
        "104227777289979" 
    }

    for i = 1, 17 do
        spawn(function()
            local entity = makeEntity(assets[i])
            entity:Run()
        end)
        
        if i < 17 then
            wait(0.5)
        end
    end
end

-- 函数13: 噬神者变体4 (声音ID: 140083448239444)
function entityBehaviors.runEvent_140083448239444()
    local entity = spawner.Create({
        Entity = {Name = "The Devourer Of Gods", Asset = "74255725774689", HeightOffset = 10},
        Lights = {Flicker = {Enabled = true, Duration = 1}, Shatter = true, Repair = false},
        Earthquake = {Enabled = false},
        CameraShake = {Enabled = true, Range = 1500, Values = {0.5, 20, 0.1, 1}},
        Movement = {Speed = 500, Delay = 0, Reversed = false},
        Rebounding = {Enabled = false, Type = "Blitz", Min = 1, Max = math.random(1, 2), Delay = math.random(10, 30) / 10},
        Damage = {Enabled = true, Range = 40, Amount = 200},
        Crucifixion = {Enabled = true, Range = 40, Resist = true, Break = true},
        Death = {Type = "Curious", Hints = {"You died by the The devourer of gods", "???", "Wait, who is this guy?","I'm not clear about his background, but anyway, you must be careful.","See you..."}, Cause = ""}
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

-- 函数14: 屏幕特效 (声音ID: 8307248039)
function entityBehaviors.runEvent_8307248039()
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

-- 函数15: A-333 (声音ID: 135514949073433)
function entityBehaviors.runEvent_135514949073433()
    require(game.Players.LocalPlayer.PlayerGui.MainUI.Initiator.Main_Game).caption("不躲藏!", true)
    wait(0.5)
    
    local entity = spawner.Create({
        Entity = {Name = "A-333", Asset = "93292275397844", HeightOffset = 0},
        Lights = {Flicker = {Enabled = false, Duration = 10}, Shatter = false, Repair = false},
        Earthquake = {Enabled = false},
        CameraShake = {Enabled = true, Range = 30, Values = {1, 50, 0.1, 1}},
        Movement = {Speed = 1000, Delay = 0.5, Reversed = true},
        Rebounding = {Enabled = false, Type = "ambush", Min = 4, Max = 4, Delay = math.random(10, 30) / 10},
        Damage = {Enabled = true, Range = 100, Amount = 0},
        Crucifixion = {Enabled = true, Range = 100, Resist = false, Break = true},
        Death = {Type = "Guiding", Hints = {"你死于A-333", "根据他说的执意来做", "需要你拥有极强的反应所以最好带上十字架..", "祝你好运!"}, Cause = ""}
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

-- 4. 配置表 - 声音ID到行为函数的映射
local entityConfig = {
    ["rbxassetid://129108783729677"] = entityBehaviors.runEvent_129108783729677,   -- JeffTheKiller
    ["rbxassetid://119672184905651"] = entityBehaviors.runEvent_119672184905651,    -- Angler
    ["rbxassetid://122666487907498"] = entityBehaviors.runEvent_122666487907498,    -- Z-367完整版
    ["rbxassetid://1845474773"] = entityBehaviors.runEvent_1845474773,              -- Z-367简化版
    ["rbxassetid://101665501585468"] = entityBehaviors.runEvent_101665501585468,    -- Ripper
    ["rbxassetid://140510675673683"] = entityBehaviors.runEvent_140510675673683,    -- GeneratorFuse替换
    ["rbxassetid://94313092216761"] = entityBehaviors.runEvent_94313092216761,      -- StarJug替换
    ["rbxassetid://128471328667052"] = entityBehaviors.runEvent_128471328667052,    -- GoldGun替换
    ["rbxassetid://152019307"] = entityBehaviors.runEvent_152019307,                -- GL星之壶
    ["rbxassetid://140612367685491"] = entityBehaviors.runEvent_140612367685491,    -- 噬神者
    ["rbxassetid://140537774926087"] = entityBehaviors.runEvent_140537774926087,    -- 噬神者变体1
    ["rbxassetid://140311790133562"] = entityBehaviors.runEvent_140311790133562,    -- 噬神者变体3
    ["rbxassetid://140083448239444"] = entityBehaviors.runEvent_140083448239444,    -- 噬神者变体4
    ["rbxassetid://8307248039"] = entityBehaviors.runEvent_8307248039,              -- 屏幕特效
    ["rbxassetid://135514949073433"] = entityBehaviors.runEvent_135514949073433,    -- A-333
    ["rbxassetid://109690961059477"] = entityBehaviors.runEvent_140537774926087,    -- 与原函数140537774926087相同
    ["rbxassetid://111351357978027"] = entityBehaviors.runEvent_122666487907498,    -- Z-367
    ["rbxassetid://8325526433"] = entityBehaviors.runEvent_119672184905651,         -- A60 (使用Angler)
    ["rbxassetid://140305919092081"] = entityBehaviors.runEvent_140612367685491,    -- A60 Phase 2 Room
    ["rbxassetid://139308622787703"] = entityBehaviors.runEvent_140537774926087,    -- A60 Phase 2 LIB
    ["rbxassetid://140721539239314"] = entityBehaviors.runEvent_140083448239444,    -- A60-50
    ["rbxassetid://140731983342235"] = entityBehaviors.runEvent_101665501585468     -- A500
}

-- 5. 统一的监听系统
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

-- 监听新添加的声音对象
workspace.DescendantAdded:Connect(function(obj)
    wait(0.1)
    universalCheckSound(obj)
end)

-- 初始化扫描现有实体
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