local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()

-- 1. CỬA SỔ LOGIN
local KeyWin = Library.CreateLib("THAIX LIVE - LOGIN SYSTEM", "BloodTheme")
local KeyTab = KeyWin:NewTab("Key System")
local KeySec = KeyTab:NewSection("Nhập Key: THAIX_PRO")

KeySec:NewTextBox("Key:", "", function(t) _G.InKey = t end)

KeySec:NewButton("Login", "Xác nhận", function()
    if _G.InKey == "THAIX_PRO" then
        -- Xóa bảng Login
        game.CoreGui:FindFirstChild("THAIX LIVE - LOGIN SYSTEM"):Destroy()
        
        -- 2. MỞ MENU CHÍNH
        local MainWin = Library.CreateLib("THAIX LIVE - PREMIUM", "BloodTheme")
        
        -- Nút nổi THAI
        local sg = Instance.new("ScreenGui", game.CoreGui)
        local btn = Instance.new("TextButton", sg)
        btn.Size, btn.Position, btn.Text = UDim2.new(0,50,0,50), UDim2.new(0,10,0.5,0), "THAI"
        btn.BackgroundColor3 = Color3.fromRGB(150,0,0)
        Instance.new("UICorner", btn)
        btn.MouseButton1Click:Connect(function() MainWin:ToggleUI() end)

        -- 3. CÀI ĐẶT FOV CHUẨN FF (Fix trắng xóa)
        local FOV = Drawing.new("Circle")
        FOV.Thickness = 2
        FOV.Color = Color3.fromRGB(255,255,255)
        FOV.Radius = 300
        FOV.Filled = false
        FOV.Visible = false
        FOV.Transparency = 0.9

        -- 4. TABS & SECTIONS
        local MTab = MainWin:NewTab("Main")
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
