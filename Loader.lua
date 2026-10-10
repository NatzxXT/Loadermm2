-- ==========================================
-- REPOSITÓRIO B: MÓDULOS DO JOGO (Funcoes.lua)
-- Versão sem 'require' - Apenas Módulo Universal
-- ==========================================

repeat task.wait() until getgenv().YARHM and getgenv().YARHM_FUNCTIONS

local script = { Parent = getgenv().YARHM }
local fu = getgenv().YARHM_FUNCTIONS

local function JWXW_routine() -- StarterGui.YARHM.Universal
    local script = { Parent = getgenv().YARHM }

    -- Como o executor bloqueia 'require', criamos tabelas vazias para não dar erro.
    local theme = { setColorTable = function() end, init = function() end }
    local flyutility = { Start = function() end, Stop = function() end, SetMaxSpeed = function() end }
    local PointSave = { new = function() return {get=function() return nil end, set=function() end, remove=function() end} end }
    local espind = {} -- Não usado no módulo Universal

    local module = {}
    module["gameId"] = 0
    if (module["gameId"] ~= game.GameId) and module["gameId"] ~= 0 then
        script.Enabled = true
    end
    
    local ts = game:GetService("TweenService")
    local uis = game:GetService("UserInputService")
    local rs = game:GetService("RunService")
    local https = game:GetService("HttpService")
    local Players = game:GetService("Players")
    
    local loopfovandws = false
    local ctrlclicktp = false
    local ws = 16
    local fov = 70
    local hidden = false
    
    local YARHMPointSave = PointSave.new("YARHM")
    
    function splitString(str,delim)
        local broken = {}
        if delim == nil then delim = "," end
        for w in string.gmatch(str,"[^"..delim.."]+") do
            table.insert(broken,w)
        end
        return broken
    end
    
    function toTokens(str)
        local tokens = {}
        for op,name in string.gmatch(str,"([+-])([^+-]+)") do
            table.insert(tokens,{Operator = op,Name = name})
        end
        return tokens
    end
    
    function onlyIncludeInTable(tab,matches)
        local matchTable = {}
        local resultTable = {}
        for i,v in pairs(matches) do matchTable[v.Name] = true end
        for i,v in pairs(tab) do if matchTable[v.Name] then table.insert(resultTable,v) end end
        return resultTable
    end
    
    function removeTableMatches(tab,matches)
        local matchTable = {}
        local resultTable = {}
        for i,v in pairs(matches) do matchTable[v.Name] = true end
        for i,v in pairs(tab) do if not matchTable[v.Name] then table.insert(resultTable,v) end end
        return resultTable
    end
    
    function getPlayersByName(Name)
        local Name,Len,Found = string.lower(Name),#Name,{}
        for _,v in pairs(Players:GetPlayers()) do
            if Name:sub(0,1) == '@' then
                if string.sub(string.lower(v.Name),1,Len-1) == Name:sub(2) then
                    table.insert(Found,v)
                end
            else
                if string.sub(string.lower(v.Name),1,Len) == Name or string.sub(string.lower(v.DisplayName),1,Len) == Name then
                    table.insert(Found,v)
                end
            end
        end
        return Found
    end
    
    function getPlayer(list,speaker)
        if list == nil then return {speaker.Name} end
        local nameList = splitString(list,",")
        local foundList = {}
        for _,name in pairs(nameList) do
            if string.sub(name,1,1) ~= "+" and string.sub(name,1,1) ~= "-" then name = "+"..name end
            local tokens = toTokens(name)
            local initialPlayers = Players:GetPlayers()
            for i,v in pairs(tokens) do
                if v.Operator == "+" then
                    local tokenContent = v.Name
                    local foundCase = false
                    if not foundCase then initialPlayers = onlyIncludeInTable(initialPlayers,getPlayersByName(tokenContent)) end
                else
                    local tokenContent = v.Name
                    local foundCase = false
                    if not foundCase then initialPlayers = removeTableMatches(initialPlayers,getPlayersByName(tokenContent)) end
                end
            end
            for i,v in pairs(initialPlayers) do table.insert(foundList,v) end
        end
        local foundNames = {}
        for i,v in pairs(foundList) do table.insert(foundNames,v.Name) end
        return foundNames[1]
    end
    
    task.spawn(function()
        rs.RenderStepped:Connect(function()
            if loopfovandws then
                workspace.CurrentCamera.FieldOfView = fov
                if game.Players.LocalPlayer.Character then
                    if game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
                        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = ws
                    end
                end
            end
        end)
    end)
    
    uis.InputBegan:Connect(function(inp, proc)
        if proc then return end
        if uis:IsKeyDown(Enum.KeyCode.LeftControl) and inp.KeyCode == Enum.KeyCode.Y and hidden then
            hidden = false
            ts:Create(script.Parent.Menu.UIScale, TweenInfo.new(1, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {Scale = 1}):Play()
        end
    end)
    
    local function getPlayerMouse()
        local player = game:GetService("Players").LocalPlayer
        if player then return player:GetMouse() end
        return nil
    end
    
    local function getRayHitPosition()
        local mouse = getPlayerMouse()
        if not mouse then return nil end
        local camera = workspace.CurrentCamera
        local unitRay = camera:ScreenPointToRay(mouse.X, mouse.Y)
        local ray = Ray.new(unitRay.Origin, unitRay.Direction * 1000)
        local part, position = workspace:FindPartOnRay(ray, game:GetService("Players").LocalPlayer.Character)
        if part then return position else return nil end
    end
    
    uis.InputBegan:Connect(function(inp, proc)
        if proc then return end
        if uis:IsKeyDown(Enum.KeyCode.LeftControl) and inp.UserInputType == Enum.UserInputType.MouseButton1 and ctrlclicktp then
            local ray = getRayHitPosition()
            if not ray then fu.notification("Couldn't find a place to teleport to.") return end
            game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(ray)
        end
    end)
    
    if uis.AccelerometerEnabled then
        uis.DeviceAccelerationChanged:Connect(function(acc)
            if hidden and acc.Position.Magnitude > 28 then
                hidden = false
                ts:Create(script.Parent.Menu.UIScale, TweenInfo.new(1, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {Scale = 1}):Play()
            end 
        end)
    end
    
    module["Name"] = "Universal"
    
    local ts = game:GetService("TweenService")
    
    table.insert(module, {
        Type = "Text",
        Args = {"<font color='#FFFF00'>Another great script</font> by YARHM developers below!"}
    })
    
    table.insert(module, {
        Type = "Button",
        Args = {"AFEM Max - The best AI-powered emote script!", function()
            loadstring(game:HttpGet("https://yarhm.mhi.im/scr?channel=afemmax"))()
            fu.notification("AFEM has been executed.")
        end,}
    })
    
    table.insert(module, {
        Type = "Text",
        Args = {"---"}
    })
    
    table.insert(module, {
        Type = "Button",
        Args = {"Join our Discord", function(Self)
            if setclipboard then setclipboard("https://discord.gg/2jbYxvDkxr") end
            fu.notification('Discord link has been copied to clipboard!')
        end,}
    })
    
    table.insert(module, { Type = "Text", Args = {""} })
    table.insert(module, { Type = "Text", Args = {"Fly"} })
    
    table.insert(module, {
        Type = "Toggle",
        Args = {"OP Fly", function(Self, state)
            if state then flyutility.Start(Players.LocalPlayer.Character)
            else flyutility.Stop(Players.LocalPlayer.Character) end
        end}
    })
    
    table.insert(module, {
        Type = "Range",
        Args = {"Fly speed", 50, 350, 10, function(Self, spd)
            flyutility.SetMaxSpeed(spd)
        end}
    })
    
    local infJump = false
    local infJumpConnection = nil
    local landedConnection = nil
    local infJumps = 0
    local infJumpDeb = false
    local infJumpOnlyTwo = false
    local landed = true
    
    local function setupHumanoid(humanoid)
        if landedConnection then landedConnection:Disconnect() end
        landedConnection = humanoid.StateChanged:Connect(function(_, n)
            if n == Enum.HumanoidStateType.Landed or n == Enum.HumanoidStateType.Running then
                landed = true
                infJumps = 0
            end
        end)
    end
    
    table.insert(module, { Type = "Text", Args = {""} })
    table.insert(module, { Type = "Text", Args = {"Jumping"} })
    
    table.insert(module, {
        Type = "Toggle",
        Args = {"Infinite jump", function(Self, state)
            infJump = state
            if state then
                local char = game.Players.LocalPlayer.Character
                if char and char:FindFirstChildWhichIsA("Humanoid") then
                    setupHumanoid(char:FindFirstChildWhichIsA("Humanoid"))
                end
                infJumpConnection = uis.JumpRequest:Connect(function()
                    local character = game.Players.LocalPlayer.Character
                    local humanoid = character and character:FindFirstChildWhichIsA("Humanoid")
                    if not humanoid then return end
                    if infJumpOnlyTwo and infJumps >= 2 and not landed then return end
                    if not infJumpDeb then
                        infJumpDeb = true
                        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                        infJumps += 1
                        landed = false
                        task.wait(.1)
                        infJumpDeb = false
                    end
                end)
            else
                if infJumpConnection then infJumpConnection:Disconnect() end
                if landedConnection then landedConnection:Disconnect() end
                infJumps = 0
                landed = true
            end
        end}
    })
    
    table.insert(module, {
        Type = "Toggle",
        Args = {"Limit infinite jump to 2 jumps only", function(Self, state)
            infJumpOnlyTwo = state
            infJumps = 0 
        end}
    })
    
    table.insert(module, { Type = "Text", Args = {""} })
    table.insert(module, { Type = "Text", Args = {"Hitbox mod"} })
    
    local aggressiveExp = false
    local hitboxExp = 1
    table.insert(module, {
        Type = "Input",
        Args = {"Hitbox expander", "Expand everyone's hitbox", function(Self, ToExpand)
            hitboxExp = ToExpand
            local players = game:GetService("Players"):GetPlayers()
            for i,v in ipairs(players) do
                if v ~= game.Players.LocalPlayer and v.Character:FindFirstChild('HumanoidRootPart') then
                    local sizeArg = tonumber(ToExpand)
                    local Size = Vector3.new(sizeArg,sizeArg,sizeArg)
                    if aggressiveExp then
                        for _, part in ipairs(v.Character:GetChildren()) do
                            if part:IsA("BasePart") then
                                if not ToExpand or sizeArg == 1 then
                                    part.Size = Vector3.new(2,1,1)
                                    part.Transparency = 0.2
                                else
                                    part.Size = Size
                                    part.Transparency = 0.2
                                end
                            end
                        end
                    else
                        local Root = v.Character:FindFirstChild('HumanoidRootPart')
                        if Root:IsA("BasePart") then
                            if not ToExpand or sizeArg == 1 then
                                Root.Size = Vector3.new(2,1,1)
                                Root.Transparency = 0.2
                            else
                                Root.Size = Size
                                Root.Transparency = 0.2
                            end
                            Root.CanCollide = false
                        end
                    end
                end
            end
            fu.notification("Hitboxes expanded.")
        end,}
    })
    
    local loopHitBoxExp
    table.insert(module, {
        Type = "Toggle",
        Args = {"Loop hitbox expansion", function(Self, state)
            if state then
                loopHitBoxExp = rs.Heartbeat:Connect(function()
                    local players = game:GetService("Players"):GetPlayers()
                    for i,v in ipairs(players) do
                        if v ~= game.Players.LocalPlayer and v.Character:FindFirstChild('HumanoidRootPart') then
                            local sizeArg = tonumber(hitboxExp)
                            local Size = Vector3.new(sizeArg,sizeArg,sizeArg)
                            local Root = v.Character:FindFirstChild('HumanoidRootPart')
                            if aggressiveExp then
                                for _, part in ipairs(v.Character:GetChildren()) do
                                    if part:IsA("BasePart") then
                                        if not hitboxExp or sizeArg == 1 then
                                            part.Size = Vector3.new(2,1,1)
                                            part.Transparency = 0.2
                                        else
                                            part.Size = Size
                                            part.Transparency = 0.2
                                        end
                                    end
                                end
                            else
                                local Root = v.Character:FindFirstChild('HumanoidRootPart')
                                if Root:IsA("BasePart") then
                                    if not hitboxExp or sizeArg == 1 then
                                        Root.Size = Vector3.new(2,1,1)
                                        Root.Transparency = 0.2
                                    else
                                        Root.Size = Size
                                        Root.Transparency = 0.2
                                    end
                                    Root.CanCollide = false
                                end
                            end
                        end
                    end
                end)
            else
                loopHitBoxExp:Disconnect()
            end
        end,}
    })
    
    table.insert(module, {
        Type = "Toggle",
        Args = {"Aggressive hitbox expasion (all parts)", function(Self, state)
            aggressiveExp = state
        end,}
    })
    
    table.insert(module, { Type = "Text", Args = {""} })
    table.insert(module, { Type = "Text", Args = {"Speed and view"} })
    
    table.insert(module, {
        Type = "Input",
        Args = {"Walkspeed", "Set speed", function(Self, speed)
            local lp = game:GetService("Players").LocalPlayer
            local char = lp.Character
            if not char then fu.notification("No character!") return end
            local hu = char:FindFirstChildOfClass("Humanoid")
            if not hu then fu.notification("No humanoid on your character..?") return end
            hu.WalkSpeed = tonumber(speed) or 16
            fu.notification("Walkspeed set.")
            ws = tonumber(speed) or 16
        end,}
    })
    
    local walkspeedInDeCrement = 2
    table.insert(module, {
        Type = "Button",
        Args = {"Increase walkspeed", function(Self)
            local lp = game:GetService("Players").LocalPlayer
            local char = lp.Character
            if not char then fu.notification("No character!") return end
            local hu = char:FindFirstChildOfClass("Humanoid")
            if not hu then fu.notification("No humanoid on your character..?") return end
            ws = ws + walkspeedInDeCrement
            hu.WalkSpeed = hu.WalkSpeed + walkspeedInDeCrement
            fu.notification("Walkspeed is now ".. hu.WalkSpeed)
        end,}
    })
    
    table.insert(module, {
        Type = "Button",
        Args = {"Decrease walkspeed", function(Self)
            local lp = game:GetService("Players").LocalPlayer
            local char = lp.Character
            if not char then fu.notification("No character!") return end
            local hu = char:FindFirstChildOfClass("Humanoid")
            if not hu then fu.notification("No humanoid on your character..?") return end
            ws = ws - walkspeedInDeCrement
            hu.WalkSpeed = hu.WalkSpeed - walkspeedInDeCrement
            fu.notification("Walkspeed is now ".. hu.WalkSpeed)
        end,}
    })
    
    table.insert(module, {
        Type = "Input",
        Args = {"Walkspeed increment (How big each increase/decrease is)", "Set", function(Self, input)
            walkspeedInDeCrement = tonumber(input) or 2
            if not tonumber(input) then fu.notification("Not a number. Setting to default (2).") end
            fu.notification("Set walkspeed increment to ".. walkspeedInDeCrement)
        end,}
    })
    
    table.insert(module, {
        Type = "Input",
        Args = {"FOV change", "Set FOV", function(Self, tofov)
            if not tonumber(tofov) then fu.notification("Not a number. Setting to default.") end
            ts:Create(workspace.CurrentCamera, TweenInfo.new(1, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {FieldOfView = tonumber(tofov) or 70}):Play()
            fov = tonumber(tofov) or 70
        end,}
    })
    
    table.insert(module, {
        Type = "Toggle",
        Args = {"Loop walkspeed and FOV", function(Self, state)
            loopfovandws = state
        end,}
    })
    
    table.insert(module, { Type = "Text", Args = {""} })
    table.insert(module, { Type = "Text", Args = {"Teleports"} })
    
    if uis.KeyboardEnabled and uis.MouseEnabled then
        table.insert(module, {
            Type = "Toggle",
            Args = {"CTRL+Click Teleport", function(Self, state)
                ctrlclicktp = state
            end,}
        })
    end
    
    local function gotoPlayer(targetPlayerName)
        local targetPlayer = Players:FindFirstChild(getPlayer(targetPlayerName, game.Players.LocalPlayer))
        if targetPlayer then
            local character = targetPlayer.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                local targetPosition = character.HumanoidRootPart.Position
                local playerCharacter = Players.LocalPlayer.Character
                if playerCharacter and playerCharacter:FindFirstChild("HumanoidRootPart") then
                    playerCharacter.HumanoidRootPart.CFrame = CFrame.new(targetPosition + Vector3.new(0, 5, 0))
                end
            end
        else print("Player '" .. targetPlayerName .. "' not found.") end
    end
    
    table.insert(module, {
        Type = "Input",
        Args = {"Enter player's name", "Teleport", function(Self, text) gotoPlayer(text) end}
    })
    
    local spectateLoop = nil
    table.insert(module, {
        Type = "Button",
        Args = {"Spectate players", function(Self)
            local listofplayers = game.Players:GetPlayers()
            local currentlyViewing = 1
            local currentPlayer = listofplayers[currentlyViewing]
            if not currentPlayer then return end
            workspace.CurrentCamera.CameraSubject = currentPlayer.Character.Humanoid
            spectateLoop = task.spawn(function()
                while true do
                    fu.dialog("Spectating...", "Now spectating: " .. workspace.CurrentCamera.CameraSubject.Parent.Name, {"Previous", "Stop", "Next"})
                    local action = fu.waitfordialog()
                    if action == "Stop" then
                        fu.closedialog()
                        workspace.CurrentCamera.CameraSubject = game.Players.LocalPlayer.Character.Humanoid
                        task.cancel(spectateLoop)
                        break
                    elseif action == "Next" then
                        currentlyViewing = currentlyViewing + 1
                        if currentlyViewing > #listofplayers then currentlyViewing = 1 end
                        currentPlayer = listofplayers[currentlyViewing]
                        if not currentPlayer then return end
                        workspace.CurrentCamera.CameraSubject = currentPlayer.Character.Humanoid
                    elseif action == "Previous" then
                        currentlyViewing = currentlyViewing - 1
                        if currentlyViewing < 1 then currentlyViewing = #listofplayers end
                        currentPlayer = listofplayers[currentlyViewing]
                        if not currentPlayer then return end
                        workspace.CurrentCamera.CameraSubject = currentPlayer.Character.Humanoid
                    end
                end
            end)
        end,}
    })
    
    table.insert(module, { Type = "Text", Args = {""} })
    table.insert(module, { Type = "Text", Args = {"Aim locking"} })
    
    local aimlockrscon
    local target
    
    table.insert(module, {
        Type = "Input",
        Args = {"Target player", "Set target", function(Self, input)
            if not Players:FindFirstChild(getPlayer(input, game.Players.LocalPlayer)) then
                fu.notification("Player not found.")
                return
            end
            fu.notification("Target is set to " .. Players:FindFirstChild(getPlayer(input, game.Players.LocalPlayer)).Name)
            target = Players:FindFirstChild(getPlayer(input, game.Players.LocalPlayer))
        end,}
    })
    
    local aimlock = false
    local cam = workspace.CurrentCamera
    table.insert(module, {
        Type = "Button",
        Args = {"Aim lock", function(Self)
            if aimlock then return end
            if aimlockrscon then aimlockrscon:Disconnect() end
            if not target then fu.notification("Set a target first.") return end
            aimlockrscon = rs.RenderStepped:Connect(function()
                if not target then fu.notification("No valid target.") aimlockrscon:Disconnect() return end
                if not target.Character then return end
                if not target.Character:FindFirstChild("HumanoidRootPart") then return end
                cam.CFrame = CFrame.new(cam.CFrame.Position, target.Character:FindFirstChild("HumanoidRootPart").Position)
            end)
            aimlock = true
            fu.notification("Aim lock is now on.")
        end,}
    })
    
    table.insert(module, {
        Type = "Button",
        Args = {"Unaim lock", function(Self)
            if not aimlock then return end
            aimlock = false
            if aimlockrscon then aimlockrscon:Disconnect() end
            fu.notification("Aim lock is now off.")
        end,}
    })
    
    table.insert(module, { Type = "Text", Args = {"Fling"} })
    
    local playerToFling
    table.insert(module, {
        Type = "Input",
        Args = {"Target fling player", "Set target", function(Self, input)
            if not Players:FindFirstChild(getPlayer(input, game.Players.LocalPlayer)) then
                fu.notification("Player not found.")
                return
            end
            fu.notification("Target is set to " .. Players:FindFirstChild(getPlayer(input, game.Players.LocalPlayer)).Name)
            playerToFling = Players:FindFirstChild(getPlayer(input, game.Players.LocalPlayer))
        end,}
    })
    
    local antiFling = false
    table.insert(module, {
        Type = "ButtonGrid",
        Args = {1, {
            Fling = function(Self)
                if not playerToFling then
                    fu.notification("You need to target a player to fling.")
                    return
                end
                if not Players:FindFirstChild(playerToFling.Name) then
                    fu.notification("You need to target a player to fling.")
                    return
                end
                if antiFling then
                    fu.notification("Turn off anti-fling to use fling.")
                    return
                end
                local player = game.Players.LocalPlayer
                local mouse = player:GetMouse()
                local Targets = {playerToFling}
                local Players = game:GetService("Players")
                local Player = Players.LocalPlayer
                local AllBool = false
                local SkidFling = function(TargetPlayer)
                    local Character = Player.Character
                    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
                    local RootPart = Humanoid and Humanoid.RootPart
                    local TCharacter = TargetPlayer.Character
                    local THumanoid
                    local TRootPart
                    local THead
                    local Accessory
                    local Handle
                    if TCharacter:FindFirstChildOfClass("Humanoid") then THumanoid = TCharacter:FindFirstChildOfClass("Humanoid") end
                    if THumanoid and THumanoid.RootPart then TRootPart = THumanoid.RootPart end
                    if TCharacter:FindFirstChild("Head") then THead = TCharacter.Head end
                    if TCharacter:FindFirstChildOfClass("Accessory") then Accessory = TCharacter:FindFirstChildOfClass("Accessory") end
                    if Accessory and Accessory:FindFirstChild("Handle") then Handle = Accessory.Handle end
                    if Character and Humanoid and RootPart then
                        if RootPart.Velocity.Magnitude < 50 then getgenv().OldPos = RootPart.CFrame end
                        if THead then
                            if THead.Velocity.Magnitude > 500 then
                                fu.dialog("Player flung", "Player is already flung. Fling again?", {"Fling again", "No"})
                                if fu.waitfordialog() == "No" then return fu.closedialog() end
                                fu.closedialog()
                            end
                        elseif not THead and Handle then
                            if Handle.Velocity.Magnitude > 500 then
                                fu.dialog("Player flung", "Player is already flung. Fling again?", {"Fling again", "No"})
                                if fu.waitfordialog() == "No" then return fu.closedialog() end
                                fu.closedialog()
                            end
                        end
                        if THead then workspace.CurrentCamera.CameraSubject = THead
                        elseif not THead and Handle then workspace.CurrentCamera.CameraSubject = Handle
                        elseif THumanoid and TRootPart then workspace.CurrentCamera.CameraSubject = THumanoid end
                        if not TCharacter:FindFirstChildWhichIsA("BasePart") then return end
                        local FPos = function(BasePart, Pos, Ang)
                            RootPart.CFrame = CFrame.new(BasePart.Position) * Pos * Ang
                            Character:SetPrimaryPartCFrame(CFrame.new(BasePart.Position) * Pos * Ang)
                            RootPart.Velocity = Vector3.new(9e7, 9e7 * 10, 9e7)
                            RootPart.RotVelocity = Vector3.new(9e8, 9e8, 9e8)
                        end
                        local SFBasePart = function(BasePart)
                            local TimeToWait = 2
                            local Time = tick()
                            local Angle = 0
                            repeat
                                if RootPart and THumanoid then
                                    if BasePart.Velocity.Magnitude < 50 then
                                        Angle = Angle + 100
                                        FPos(BasePart, CFrame.new(0, 1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle),0 ,0))
                                        task.wait()
                                        FPos(BasePart, CFrame.new(0, -1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                                        task.wait()
                                        FPos(BasePart, CFrame.new(2.25, 1.5, -2.25) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                                        task.wait()
                                        FPos(BasePart, CFrame.new(-2.25, -1.5, 2.25) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                                        task.wait()
                                        FPos(BasePart, CFrame.new(0, 1.5, 0) + THumanoid.MoveDirection,CFrame.Angles(math.rad(Angle), 0, 0))
                                        task.wait()
                                        FPos(BasePart, CFrame.new(0, -1.5, 0) + THumanoid.MoveDirection,CFrame.Angles(math.rad(Angle), 0, 0))
                                        task.wait()
                                    else
                                        FPos(BasePart, CFrame.new(0, 1.5, THumanoid.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0))
                                        task.wait()
                                        FPos(BasePart, CFrame.new(0, -1.5, -THumanoid.WalkSpeed), CFrame.Angles(0, 0, 0))
                                        task.wait()
                                        FPos(BasePart, CFrame.new(0, 1.5, THumanoid.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0))
                                        task.wait()
                                        FPos(BasePart, CFrame.new(0, 1.5, TRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(math.rad(90), 0, 0))
                                        task.wait()
                                        FPos(BasePart, CFrame.new(0, -1.5, -TRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(0, 0, 0))
                                        task.wait()
                                        FPos(BasePart, CFrame.new(0, 1.5, TRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(math.rad(90), 0, 0))
                                        task.wait()
                                        FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(math.rad(90), 0, 0))
                                        task.wait()
                                        FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(0, 0, 0))
                                        task.wait()
                                        FPos(BasePart, CFrame.new(0, -1.5 ,0), CFrame.Angles(math.rad(-90), 0, 0))
                                        task.wait()
                                        FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(0, 0, 0))
                                        task.wait()
                                    end
                                else break end
                            until BasePart.Velocity.Magnitude > 500 or BasePart.Parent ~= TargetPlayer.Character or TargetPlayer.Parent ~= Players or TargetPlayer.Character ~= TCharacter or THumanoid.Sit or Humanoid.Health <= 0 or tick() > Time + TimeToWait
                        end
                        workspace.FallenPartsDestroyHeight = 0/0
                        local BV = Instance.new("BodyVelocity")
                        BV.Name = "EpixVel"
                        BV.Parent = RootPart
                        BV.Velocity = Vector3.new(9e8, 9e8, 9e8)
                        BV.MaxForce = Vector3.new(1/0, 1/0, 1/0)
                        Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
                        if TRootPart and THead then
                            if (TRootPart.CFrame.p - THead.CFrame.p).Magnitude > 5 then SFBasePart(THead) else SFBasePart(TRootPart) end
                        elseif TRootPart and not THead then SFBasePart(TRootPart)
                        elseif not TRootPart and THead then SFBasePart(THead)
                        elseif not TRootPart and not THead and Accessory and Handle then SFBasePart(Handle)
                        else fu.notification("Can't find a proper part of target player to fling.") end
                        BV:Destroy()
                        Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
                        workspace.CurrentCamera.CameraSubject = Humanoid
                        repeat
                            RootPart.CFrame = getgenv().OldPos * CFrame.new(0, .5, 0)
                            Character:SetPrimaryPartCFrame(getgenv().OldPos * CFrame.new(0, .5, 0))
                            Humanoid:ChangeState("GettingUp")
                            table.foreach(Character:GetChildren(), function(_, x)
                                if x:IsA("BasePart") then
                                    x.Velocity, x.RotVelocity = Vector3.new(), Vector3.new()
                                end
                            end)
                            task.wait()
                        until (RootPart.Position - getgenv().OldPos.p).Magnitude < 25
                        workspace.FallenPartsDestroyHeight = getgenv().FPDH
                    else fu.notification("No valid character of said target player. May have died.") end
                end
                SkidFling(Targets[1])
            end,
        }}
    })
    
    local antiFlingLastPos = Vector3.zero
    local flingNeutralizerCon
    local flingDetectionCon
    local detectedPlayers = {}
    table.insert(module, {
        Type = "Toggle",
        Args = {"Anti-fling", function(Self, state)
            antiFling = state
            if state then
                fu.notification("Anti-fling activated.")
                flingDetectionCon = rs.Heartbeat:Connect(function()
                    for _, pl in ipairs(game:GetService("Players"):GetPlayers()) do
                        if pl.Character:IsDescendantOf(workspace) then
                            if pl.Character.PrimaryPart.AssemblyAngularVelocity.Magnitude > 50 or pl.Character.PrimaryPart.AssemblyLinearVelocity.Magnitude > 100 then
                                if not detectedPlayers[pl.Name] then
                                    fu.notification("A flinger has been detected with the name " .. pl.Name .. "!")
                                    detectedPlayers[pl.Name] = true
                                end
                                for _, p in ipairs(pl.Character:GetDescendants()) do
                                    if p:IsA("BasePart") then
                                        p.CanCollide = false
                                        p.AssemblyAngularVelocity = Vector3.zero
                                        p.AssemblyLinearVelocity = Vector3.zero
                                        p.CustomPhysicalProperties = PhysicalProperties.new(0,0,0)
                                    end
                                end
                            end
                        end
                    end
                end)
                flingNeutralizerCon = rs.Heartbeat:Connect(function()
                    if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character.PrimaryPart then
                        if game.Players.LocalPlayer.Character.PrimaryPart.AssemblyLinearVelocity.Magnitude > 250 or game.Players.LocalPlayer.Character.PrimaryPart.AssemblyAngularVelocity.Magnitude > 250 then
                            fu.notification("You were flung. Neutralizing velocity!")
                            game.Players.LocalPlayer.Character.PrimaryPart.AssemblyLinearVelocity = Vector3.zero
                            game.Players.LocalPlayer.Character.PrimaryPart.AssemblyAngularVelocity = Vector3.zero
                            if antiFlingLastPos ~= Vector3.zero then
                                game.Players.LocalPlayer.Character.PrimaryPart.CFrame = CFrame.new(antiFlingLastPos)
                            end
                        else
                            antiFlingLastPos = game.Players.LocalPlayer.Character.PrimaryPart.Position
                        end
                    end
                end)
            else
                flingDetectionCon:Disconnect()
                flingNeutralizerCon:Disconnect()
                detectedPlayers = {}
                fu.notification("Anti-fling deactivated.")
            end
        end,}
    })
    
    table.insert(module, { Type = "Text", Args = {"Miscellaneous"} })
    
    table.insert(module, {
        Type = "Button",
        Args = {"Anti AFK detection", function(Self)
            local pl = game.Players.LocalPlayer
            if getconnections then
                for _, connection in pairs(getconnections(pl.Idled)) do
                    if connection["Disable"] then connection["Disable"](connection)
                    elseif connection["Disconnect"] then connection["Disconnect"](connection) end
                end
            else
                pl.Idled:Connect(function()
                    game:GetService("VirtualUser"):CaptureController()
                    game:GetService("VirtualUser"):ClickButton2(Vector2.new())
                end)
            end
        end,}
    })
    
    pcall(function()
        if game:GetService("CoreGui"):FindFirstChild("DeltaIcon") then
            table.insert(module, {
                Type = "Toggle",
                Args = {"Hide Delta Icon", function(Self, state)
                    game:GetService("CoreGui"):FindFirstChild("DeltaIcon").Enabled = state
                end,}
            })
        end
    end)
    
    table.insert(module, {
        Type = "Button",
        Args = {"Hide YARHM", function(Self)
            if uis.KeyboardEnabled then
                ts:Create(script.Parent.Menu.UIScale, TweenInfo.new(0.6, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {Scale = 0}):Play()
                hidden=true
                fu.notification("Press CTRL+SHIFT+Y to bring back the menu.")
            elseif uis.AccelerometerEnabled then
                ts:Create(script.Parent.Menu.UIScale, TweenInfo.new(0.6, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {Scale = 0}):Play()
                hidden=true
                fu.notification("Shake your device to bring back the menu.")
            else
                fu.notification("Can't hide YARHM!")
            end
        end,}
    )
    
    table.insert(module, {
        Type = "Button",
        Args = {"FPS Boost", function(Self)
            fu.dialog("FPS boosting", "FPS boosting can have unpredictable effects. You may instead lag more using this!", {"FPS boost anyway", "Nevermind"})
            local result = fu.waitfordialog()
            fu.closedialog()
            if result == "FPS boost anyway" then
                local Terrain = workspace:FindFirstChildOfClass('Terrain')
                Terrain.WaterWaveSize = 0
                Terrain.WaterWaveSpeed = 0
                Terrain.WaterReflectance = 0
                Terrain.WaterTransparency = 0
                game.Lighting.GlobalShadows = false
                game.Lighting.FogEnd = 9e9
                pcall(function() settings().Rendering.QualityLevel = 1 end)
                for i,v in pairs(game:GetDescendants()) do
                    if v:IsA("Part") or v:IsA("UnionOperation") or v:IsA("MeshPart") or v:IsA("CornerWedgePart") or v:IsA("TrussPart") then
                        v.Material = "Plastic"
                        v.Reflectance = 0
                    elseif v:IsA("Decal") then v.Transparency = 1
                    elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then v.Lifetime = NumberRange.new(0)
                    elseif v:IsA("Explosion") then v.BlastPressure = 1; v.BlastRadius = 1 end
                end
                for i,v in pairs(game.Lighting:GetDescendants()) do
                    if v:IsA("BlurEffect") or v:IsA("SunRaysEffect") or v:IsA("ColorCorrectionEffect") or v:IsA("BloomEffect") or v:IsA("DepthOfFieldEffect") then
                        v.Enabled = false
                    end
                end
                workspace.DescendantAdded:Connect(function(child)
                    task.spawn(function()
                        if child:IsA('ForceField') then rs.Heartbeat:Wait(); child:Destroy()
                        elseif child:IsA('Sparkles') then rs.Heartbeat:Wait(); child:Destroy()
                        elseif child:IsA('Smoke') or child:IsA('Fire') then rs.Heartbeat:Wait(); child:Destroy() end
                    end)
                end)
            end
        end,}
    })
    
    local rsloopconnectionfling
    local clip = true
    local nocliploop
    
    table.insert(module, {
        Type = "ButtonGrid",
        Args = {2, {
            Noclip = function()
                clip = false
                nocliploop = rs.Stepped:Connect(function()
                    if clip == false and game.Players.LocalPlayer.Character ~= nil then
                        for _, child in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                            if child:IsA("BasePart") and child.CanCollide == true then child.CanCollide = false end
                        end
                    end
                end)
            end,
            Reclip = function()
                if clip then return end
                clip = true
                nocliploop:Disconnect()
                fu.notification("Reclipping may need you to reset your character.")
            end,
        }}})
    
    table.insert(module, { Type = "Text", Args = {"Other"} })
    
    table.insert(module, {
        Type = "Button",
        Args = {"Get ping", function(Self)
            fu.notification(game.Players.LocalPlayer:GetNetworkPing() * 1000)
        end,}
    })
    
    table.insert(module, {
        Type = "Button",
        Args = {"Open developer console (debugging)", function(Self)
            game.StarterGui:SetCore("DevConsoleVisible", true)
        end}
    )
    
    repeat task.wait() until getgenv().Modules
    getgenv().Modules[1] = module
end

-- Executa apenas o módulo Universal
coroutine.wrap(JWXW_routine)()

print("✅ [YARHM] Módulo Universal carregado com sucesso! (Sem erros de require)")
