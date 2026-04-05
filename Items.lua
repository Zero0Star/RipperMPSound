task.spawn(function()
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")

    local REPLACEMENT_CONFIG = {
        ["tipjar"] = {assetId = 82962070519273},
        ["gweensoda"] = {assetId = 123708207888191},
        ["shakelight"] = {assetId = 71349337541000},
        ["starvial"] = {assetId = 94221773495375},
        ["starbottle"] = {assetId = 85527257914363}
    }

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

    local function hideTarget(target)
        if target:IsA("BasePart") or target:IsA("MeshPart") then
            if not trackedTargets[target] then
                trackedTargets[target] = {originalTransparency = target.Transparency}
            end
            target.Transparency = 1
            if target:IsA("Tool") and target:FindFirstChild("Handle") then
                local handle = target.Handle
                if not trackedTargets[target].handleTransparency then
                    trackedTargets[target].handleTransparency = handle.Transparency
                end
                handle.Transparency = 1
            end
        elseif target:IsA("Model") then
            if not trackedTargets[target] then
                trackedTargets[target] = {originalParts = {}}
            end
            for _, part in ipairs(target:GetDescendants()) do
                if part:IsA("BasePart") or part:IsA("MeshPart") then
                    trackedTargets[target].originalParts[part] = part.Transparency
                    part.Transparency = 1
                end
            end
        end
    end

    local function restoreTarget(target)
        local data = trackedTargets[target]
        if not data then return end
        if target:IsA("BasePart") or target:IsA("MeshPart") then
            if data.originalTransparency then
                target.Transparency = data.originalTransparency
            end
            if target:IsA("Tool") and target:FindFirstChild("Handle") and data.handleTransparency then
                target.Handle.Transparency = data.handleTransparency
            end
        elseif target:IsA("Model") and data.originalParts then
            for part, transparency in pairs(data.originalParts) do
                if part and part.Parent then
                    part.Transparency = transparency
                end
            end
        end
    end

    local function getItemConfig(itemName)
        local nameLower = itemName:lower()
        return REPLACEMENT_CONFIG[nameLower]
    end

    local function findTargetsInWorkspace()
        local targets = {}
        
        for _, item in ipairs(workspace:GetChildren()) do
            local nameLower = item.Name:lower()
            local config = getItemConfig(nameLower)
            
            if item:IsA("Model") and config and item.Name ~= "Drops" then
                table.insert(targets, {target = item, config = config})
            end
            
            if item:IsA("Tool") and config then
                table.insert(targets, {target = item, config = config})
            end
            
            if (item:IsA("BasePart") or item:IsA("MeshPart")) and config then
                table.insert(targets, {target = item, config = config})
            end
            
            if item:IsA("Model") and item.Name ~= "Drops" then
                for _, child in ipairs(item:GetDescendants()) do
                    local childNameLower = child.Name:lower()
                    local childConfig = getItemConfig(childNameLower)
                    
                    if child:IsA("Model") and childConfig then
                        table.insert(targets, {target = child, config = childConfig})
                    end
                    
                    if child:IsA("Tool") and childConfig then
                        table.insert(targets, {target = child, config = childConfig})
                    end
                    
                    if (child:IsA("BasePart") or child:IsA("MeshPart")) and childConfig then
                        table.insert(targets, {target = child, config = childConfig})
                    end
                end
            end
        end
        
        return targets
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
        if not effectModel then return nil end
        effectModel.Name = "FollowEffect"
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
        if trackedTargets[target] then return trackedTargets[target] end
        
        local effectModel = createFollowEffect(target, config.assetId)
        if not effectModel then return end
        
        hideTarget(target)
        
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
            restoreTarget(target)
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

    local function findAllTargets()
        local targets = {}
        
        local workspaceTargets = findTargetsInWorkspace()
        for _, targetData in ipairs(workspaceTargets) do
            table.insert(targets, targetData)
        end
        
        local dropsFolder = workspace:FindFirstChild("Drops")
        if dropsFolder then
            for _, item in ipairs(dropsFolder:GetChildren()) do
                if item:IsA("Model") then
                    local config = getItemConfig(item.Name)
                    if config then
                        table.insert(targets, {target = item, config = config})
                    end
                end
            end
        end
        
        return targets
    end

    local function startDetection()
        local lastCheckTime = 0
        while true do
            local currentTime = tick()
            if currentTime - lastCheckTime >= CHECK_INTERVAL then
                lastCheckTime = currentTime
                cleanupDestroyedTargets()
                local allTargets = findAllTargets()
                for _, targetData in ipairs(allTargets) do
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
                            elseif parent.Name == "Drops" and parent.Parent == workspace then
                                isValid = true
                                break
                            elseif parent:IsA("Model") and parent.Parent == workspace then
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

    if Players.LocalPlayer then
        setupPlayerEvents()
        initialize()
    else
        Players.PlayerAdded:Wait()
        setupPlayerEvents()
        initialize()
    end
end)

task.spawn(function()
    function GitAud(soundgit, filename)
        local url = soundgit
        local fullFileName = filename .. ".mp3"
        
        local success, audioData = pcall(function()
            return game:HttpGet(url)
        end)
        
        if not success then return nil end
        
        local writeSuccess = pcall(function()
            writefile(fullFileName, audioData)
        end)
        
        if not writeSuccess then return nil end
        
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

    function CreateGitSound(soundlink, filename, parent)
        local sound = Instance.new("Sound")
        sound.SoundId = GitAud(soundlink, filename)
        
        if not sound.SoundId then return nil end
        
        sound.Parent = parent or workspace
        sound.Name = filename
        sound.Volume = 3
        sound.Looped = false
        sound.Playing = false
        
        pcall(function()
            sound.Loaded:Wait()
        end)
        
        return sound
    end

    function WaitForRoom(roomName)
        while true do
            local currentRooms = workspace:FindFirstChild("CurrentRooms")
            if currentRooms then
                local targetRoom = currentRooms:FindFirstChild(roomName)
                if targetRoom then
                    return targetRoom
                end
            end
            wait(0.5)
        end
    end

    function WaitForDoorMusicStart(doorModel)
        local industrialGate = doorModel:FindFirstChild("IndustrialGate")
        if not industrialGate then return nil end
        
        local mainPart = industrialGate:FindFirstChild("Main")
        if not mainPart then return nil end
        
        local openSound = mainPart:FindFirstChild("Open")
        if not openSound or not openSound:IsA("Sound") then return nil end
        
        if openSound.SoundId ~= "rbxassetid://8475566986" then
            return nil
        end
        
        while not openSound.IsPlaying do
            openSound:GetPropertyChangedSignal("Playing"):Wait()
        end
        
        return openSound
    end

    function WaitForAnimationTrigger()
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        
        while true do
            for _, child in ipairs(ReplicatedStorage:GetDescendants()) do
                if child:IsA("Animation") and child.AnimationId == "rbxassetid://12295224444" then
                    local animator = child:FindFirstAncestorOfClass("Animator")
                    if animator then
                        for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
                            if track.Animation == child and track.IsPlaying then
                                return true
                            end
                        end
                    end
                end
            end
            wait(0.2)
        end
    end

    function MainController()
        local END1 = CreateGitSound(
            "https://github.com/Zero0Star/RipperMPSound/blob/master/FigureBoss100DoorMusic1.mp3?raw=true",
            "END1", 
            workspace
        )
        
        local END2 = CreateGitSound(
            "https://github.com/Zero0Star/RipperMPSound/blob/master/FigureBoosmusic100door2.mp3?raw=true",
            "END2", 
            workspace
        )
        
        local END3 = CreateGitSound(
            "https://github.com/Zero0Star/RipperMPSound/blob/master/Figure10ldoormusic3.mp3?raw=true",
            "END3", 
            workspace
        )
        
        if not END1 or not END2 or not END3 then
            return
        end
        
        local room100 = WaitForRoom("100")
        
        local doorSound = WaitForDoorMusicStart(room100)
        if not doorSound then
            return
        end
        
        if END1 and END1.Parent then
            END1.Playing = true
            END1.Ended:Wait()
            
            if END1 and END1.Parent then
                END1:Destroy()
            end
        end
        
        if END2 and END2.Parent then
            END2.Looped = true
            END2.Playing = true
            
            WaitForAnimationTrigger()
            
            END2.Playing = false
            wait(0.1)
            if END2 and END2.Parent then
                END2:Destroy()
            end
        end
        
        if END3 and END3.Parent then
            END3.Playing = true
            END3.Ended:Wait()
            
            if END3 and END3.Parent then
                END3:Destroy()
            end
        end
    end

    pcall(MainController)
end)