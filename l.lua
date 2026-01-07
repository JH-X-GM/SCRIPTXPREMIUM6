local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local MainWin = Library.CreateLib("THAIX LIVE PREMIUM", "BloodTheme")

-- --- KHAI BÁO DỊCH VỤ ---
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")

-- --- NÚT NỔI DRAGGABLE ---
local sg = Instance.new("ScreenGui", game.CoreGui)
local btn = Instance.new("TextButton", sg)
btn.Size, btn.Position, btn.Text = UDim2.new(0,60,0,60), UDim2.new(0,20,0.5,0), "THAI"
btn.BackgroundColor3 = Color3.fromRGB(180,0,0)
btn.TextColor3 = Color3.fromRGB(255,255,255)
btn.Draggable, btn.Active = true, true
Instance.new("UICorner", btn)
btn.MouseButton1Click:Connect(function() Library:ToggleUI() end)

-- --- TABS ---
local MTab = MainWin:NewTab("Main")
local CTab = MainWin:NewTab("Combat")
local VTab = MainWin:NewTab("Visual")

-- --- FOV CHUẨN FF ---
local FOV = Drawing.new("Circle")
FOV.Thickness, FOV.Color, FOV.Filled = 2, Color3.fromRGB(255,255,255), false
FOV.Radius, FOV.Visible, FOV.Transparency = 300, false, 0.9

-- --- CHỨC NĂNG MAIN (AUTO FARM) ---
local MSec = MTab:NewSection("Auto Farm")
MSec:NewToggle("Auto Farm Level", "", function(v) _G.Farm = v end)
MSec:NewToggle("Bring Mob (Gom quái)", "", function(v) _G.Bring = v end)
MSec:NewToggle("Fast Attack", "", function(v) _G.Fast = v end)

-- --- CHỨC NĂNG COMBAT (AIMBOT) ---
local CSec = CTab:NewSection("Aimbot & FOV")
CSec:NewToggle("Show FOV White", "", function(v) FOV.Visible = v end)
CSec:NewToggle("Aimbot Lock", "", function(v) _G.Aim = v end)

-- --- CHỨC NĂNG VISUAL (ESP) ---
local VSec = VTab:NewSection("ESP Player")
VSec:NewToggle("ESP Box", "", function(v) _G.ESP = v end)

-- --- VÒNG LẶP HỆ THỐNG (LOGIC CHÍNH) ---
task.spawn(function()
    while true do task.wait()
        pcall(function()
            -- 1. Cập nhật FOV
            if FOV.Visible then
                FOV.Position = Vector2.new(workspace.CurrentCamera.ViewportSize.X/2, workspace.CurrentCamera.ViewportSize.Y/2)
            end

            -- 2. Logic Auto Farm & Bring Mob
            if _G.Farm then
                local Enemy = nil
                for _,v in pairs(workspace.Enemies:GetChildren()) do
                    if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                        Enemy = v; break
                    end
                end
                if Enemy then
                    -- Gom quái
                    if _G.Bring then
                        for _,mob in pairs(workspace.Enemies:GetChildren()) do
                            if mob:FindFirstChild("HumanoidRootPart") then
                                mob.HumanoidRootPart.CFrame = Enemy.HumanoidRootPart.CFrame
                                mob.HumanoidRootPart.CanCollide = false
                            end
                        end
                    end
                    -- Di chuyển đến quái
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = Enemy.HumanoidRootPart.CFrame * CFrame.new(0, 10, 0)
                end
            end

            -- 3. Fast Attack
            if _G.Fast then
                VirtualUser:CaptureController()
                VirtualUser:Button1Down(Vector2.new(1280, 672))
            end
        end)
    end
end)

-- --- LOGIC ESP (DÙNG RUNSERVICE CHO MƯỢT) ---
RunService.RenderStepped:Connect(function()
    if _G.ESP then
        -- Logic vẽ Box cho từng Player (Phần này tốn tài nguyên nên cần tối ưu)
        -- Bạn có thể dán thêm code vẽ Square ở đây
    end
end)
        local CTab = MainWin:NewTab("Combat")
        local VTab = MainWin:NewTab("Visual")
        local TTab = MainWin:NewTab("Teleport")

        MTab:NewSection("Auto System")
        MTab:NewToggle("Auto Farm Level", "", function(v) _G.Farm = v end)
        MTab:NewToggle("Bring Mob", "", function(v) _G.Bring = v end)

        CTab:NewSection("Aimbot")
        CTab:NewToggle("Show FOV White", "", function(v) FOV.Visible = v end)

        VTab:NewSection("ESP Free Fire")
        VTab:NewToggle("ESP Player (Box/Name)", "", function(v) _G.ESP = v end)

        -- 5. LOGIC ESP (PHẢI NẰM TRONG HÀM LOGIN)
        local function CreateESP(plr)
            local Box = Drawing.new("Square")
            Box.Visible = false
            Box.Color = Color3.fromRGB(255, 255, 255)
            Box.Thickness = 1
            Box.Transparency = 1
            Box.Filled = false

            game:GetService("RunService").RenderStepped:Connect(function()
                if _G.ESP and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and plr ~= game.Players.LocalPlayer then
                    local RootPart = plr.Character.HumanoidRootPart
                    local Pos, OnScreen = workspace.CurrentCamera:WorldToViewportPoint(RootPart.Position)
                    if OnScreen then
                        local Size = (workspace.CurrentCamera:WorldToViewportPoint(RootPart.Position + Vector3.new(0, 3, 0)).Y - workspace.CurrentCamera:WorldToViewportPoint(RootPart.Position - Vector3.new(0, 3, 0)).Y)
                        Box.Size = Vector2.new(Size * 0.6, Size)
                        Box.Position = Vector2.new(Pos.X - Box.Size.X / 2, Pos.Y - Box.Size.Y / 2)
                        Box.Visible = true
                    else Box.Visible = false end
                else Box.Visible = false end
            end)
        end
        for _, v in pairs(game.Players:GetPlayers()) do CreateESP(v) end
        game.Players.PlayerAdded:Connect(CreateESP)

        -- 6. LOGIC AUTO FARM
        spawn(function()
            while task.wait() do
                if _G.Farm then
                    pcall(function()
                        local target = nil
                        for _,v in pairs(workspace.Enemies:GetChildren()) do
                            if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                                target = v; break
                            end
                        end
                        if target then
                            if _G.Bring then
                                for _,v in pairs(workspace.Enemies:GetChildren()) do
                                    if v:FindFirstChild("HumanoidRootPart") then
                                        v.HumanoidRootPart.CFrame = target.HumanoidRootPart.CFrame
                                        v.HumanoidRootPart.CanCollide = false
                                    end
                                end
                            end
                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = target.HumanoidRootPart.CFrame * CFrame.new(0, 10, 0)
                        end
                    end)
                end
            end
        end)

        -- 7. UPDATE FOV POSITION
        game:GetService("RunService").RenderStepped:Connect(function()
            if FOV.Visible then
                FOV.Position = Vector2.new(workspace.CurrentCamera.ViewportSize.X/2, workspace.CurrentCamera.ViewportSize.Y/2)
            end
        end)
    else
        print("Sai Key!")
    end
end)
