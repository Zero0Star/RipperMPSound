local Players = game:GetService("Players")

function GitAud(url, name)
    local fileName = name .. ".mp3"
    
    if isfile and isfile(fileName) then
        if getsynasset then
            return getsynasset(fileName)
        elseif getcustomasset then
            return getcustomasset(fileName)
        end
    end
    
    local data
    local success, result = pcall(function()
        return game:HttpGet(url)
    end)
    
    if not success or not result then
        return nil
    end
    
    data = result
    
    local writeSuccess = pcall(function()
        writefile(fileName, data)
    end)
    
    if not writeSuccess then
        return nil
    end
    
    if getsynasset then
        return getsynasset(fileName)
    elseif getcustomasset then
        return getcustomasset(fileName)
    end
    
    return nil
end

function WaitRoom(room)
    while true do
        if workspace.CurrentRooms then
            local target = workspace.CurrentRooms:FindFirstChild(tostring(room))
            if target then
                return target
            end
        end
        wait(0.5)
    end
end

function CheckDoorSound(door)
    if not door then return nil end
    
    local gate = door.IndustrialGate
    if not gate then return nil end
    
    local main = gate.Main
    if not main then return nil end
    
    local sound = main.Open
    if not sound or not sound:IsA("Sound") then return nil end
    
    if sound.SoundId ~= "rbxassetid://8475566986" then
        return nil
    end
    
    while not sound.IsPlaying do
        sound:GetPropertyChangedSignal("Playing"):Wait()
    end
    
    return sound
end

function WaitAnim()
    local rs = game:GetService("ReplicatedStorage")
    
    while true do
        for _, v in ipairs(rs:GetDescendants()) do
            if v:IsA("Animation") and v.AnimationId == "rbxassetid://12295224444" then
                local animator = v:FindFirstAncestorOfClass("Animator")
                if animator then
                    for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
                        if track.Animation == v and track.IsPlaying then
                            return true
                        end
                    end
                end
            end
        end
        wait(0.2)
    end
end

function Main()
    local soundURLs = {
        LB1 = "https://github.com/Zero0Star/RipperMPSound/raw/main/FigureMusicOne.mp3",
        LB2 = "https://github.com/Zero0Star/RipperMPSound/raw/main/FigureMusicTwo.mp3", 
        LB3 = "https://github.com/Zero0Star/RipperMPSound/raw/main/FigureMusicThree.mp3",
        END1 = "https://github.com/Zero0Star/RipperMPSound/raw/main/FigureBoss100DoorMusic1.mp3",
        END2 = "https://github.com/Zero0Star/RipperMPSound/raw/main/FigureBoosmusic100door2.mp3",
        END3 = "https://github.com/Zero0Star/RipperMPSound/raw/main/Figure10ldoormusic3.mp3"
    }
    
    local backupURLs = {
        LB1 = "https://raw.githubusercontent.com/Zero0Star/RipperMPSound/main/FigureMusicOne.mp3",
        LB2 = "https://raw.githubusercontent.com/Zero0Star/RipperMPSound/main/FigureMusicTwo.mp3",
        LB3 = "https://raw.githubusercontent.com/Zero0Star/RipperMPSound/main/FigureMusicThree.mp3",
        END1 = "https://raw.githubusercontent.com/Zero0Star/RipperMPSound/main/FigureBoss100DoorMusic1.mp3",
        END2 = "https://raw.githubusercontent.com/Zero0Star/RipperMPSound/main/FigureBoosmusic100door2.mp3",
        END3 = "https://raw.githubusercontent.com/Zero0Star/RipperMPSound/main/Figure10ldoormusic3.mp3"
    }
    
    -- 下载并创建音频
    local sounds = {}
    
    for name, url in pairs(soundURLs) do
        local soundId = GitAud(url, name)
        
        if not soundId then
            soundId = GitAud(backupURLs[name], name)
        end
        
        if soundId then
            local sound = Instance.new("Sound")
            sound.Name = name
            sound.SoundId = soundId
            sound.Volume = 2
            sound.Looped = false
            sound.Playing = false
            sound.Parent = workspace
            sounds[name] = sound
            
            pcall(function()
                sound.Loaded:Wait()
            end)
        end
    end
    
    wait(1)
    
    -- 房间50的音乐逻辑
    if sounds.LB1 and sounds.LB2 and sounds.LB3 then
        -- 等待房间50出现
        WaitRoom("50")
        
        local data = game.ReplicatedStorage:FindFirstChild("GameData")
        if data then
            local latest = data:FindFirstChild("LatestRoom")
            if latest then
                -- 等待房间变化（进入房间50后）
                latest.Changed:Wait()
                
                -- 播放LB1
                if sounds.LB1 and sounds.LB1.Parent then
                    sounds.LB1.Playing = true
                    
                    -- 等待LB1播放结束
                    sounds.LB1.Ended:Wait()
                    
                    -- 删除LB1
                    if sounds.LB1 and sounds.LB1.Parent then
                        sounds.LB1:Destroy()
                    end
                    sounds.LB1 = nil
                end
                
                -- 播放LB2（循环播放）
                if sounds.LB2 and sounds.LB2.Parent then
                    sounds.LB2.Looped = true
                    sounds.LB2.Playing = true
                    
                    -- 等待第二次房间变化（离开房间50时）
                    latest.Changed:Wait()
                    
                    -- 停止LB2循环播放
                    if sounds.LB2 and sounds.LB2.Parent then
                        sounds.LB2.Playing = false
                        wait(0.1)
                        sounds.LB2:Destroy()
                    end
                    sounds.LB2 = nil
                end
                
                -- 播放LB3
                if sounds.LB3 and sounds.LB3.Parent then
                    sounds.LB3.Playing = true
                    
                    -- 等待LB3播放结束
                    sounds.LB3.Ended:Wait()
                    
                    -- 删除LB3
                    if sounds.LB3 and sounds.LB3.Parent then
                        sounds.LB3:Destroy()
                    end
                    sounds.LB3 = nil
                end
            end
        end
    end
    
    -- 房间100的音乐逻辑
    if sounds.END1 and sounds.END2 and sounds.END3 then
        local r100 = WaitRoom("100")
        
        local doorSound = CheckDoorSound(r100)
        if doorSound then
            if sounds.END1 and sounds.END1.Parent then
                sounds.END1.Playing = true
                sounds.END1.Ended:Wait()
                if sounds.END1 and sounds.END1.Parent then
                    sounds.END1:Destroy()
                end
                sounds.END1 = nil
            end
            
            if sounds.END2 and sounds.END2.Parent then
                sounds.END2.Looped = true
                sounds.END2.Playing = true
                
                WaitAnim()
                
                sounds.END2.Playing = false
                wait(0.1)
                if sounds.END2 and sounds.END2.Parent then
                    sounds.END2:Destroy()
                end
                sounds.END2 = nil
            end
            
            if sounds.END3 and sounds.END3.Parent then
                sounds.END3.Playing = true
                sounds.END3.Ended:Wait()
                if sounds.END3 and sounds.END3.Parent then
                    sounds.END3:Destroy()
                end
                sounds.END3 = nil
            end
        end
    end
end

task.spawn(function()
    if Players.LocalPlayer then
        pcall(Main)
    else
        Players.PlayerAdded:Wait()
        pcall(Main)
    end
end)