--[[
    HOHO HUB | FLY & SPEED HACK SCRIPT
    Compatível com a maioria dos Executors (como o REAL).
    Funcionalidades: Toggle Fly, Toggle SpeedHack.
]]

-----------------------------
-- 1. SERVIÇOS E CONFIGURAÇÃO GLOBAL
-----------------------------
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- Estados das Funções (True/False)
local isFlyActive = false
local isSpeedActive = false
local defaultWalkSpeed = 16 -- Velocidade padrão do Roblox
local flyVelocity = Vector3.new(0, 25, 0) -- Velocidade de voo (Y alto para subir)

-----------------------------
-- 2. FUNÇÕES DE LÓGICA DO SCRIPT
-----------------------------

-- Função principal que gerencia o Fly
local function toggleFly()
    isFlyActive = not isFlyActive
    if isFlyActive then
        print("✅ FLY ATIVADO! 🚀")
        Humanoid.PlatformStand = true -- Trava a gravidade e movimento normal
        
        -- Conecta um loop que constantemente aplica velocidade ao RootPart
        local flyConnection = RunService.Stepped:Connect(function()
            RootPart.Velocity = flyVelocity + Vector3.new(math.random(-5, 5), 0, math.random(-5, 5)) -- Adiciona um pouco de drift aleatório
        end)
        -- Armazena a conexão para poder desconectar mais tarde
        UIFrame.FlyButton.FlyConnection = flyConnection

    else
        print("⬇️ FLY DESATIVADO.")
        Humanoid.PlatformStand = false
        if UIFrame.FlyButton and UIFrame.FlyButton.FlyConnection then
            UIFrame.FlyButton.FlyConnection:Disconnect()
            UIFrame.FlyButton.FlyConnection = nil
        end
    end
    updateUIVisuals()
end

-- Função principal que gerencia o SpeedHack
local function toggleSpeed()
    isSpeedActive = not isSpeedActive
    if isSpeedActive then
        print("⚡ SPEEDHACK ATIVADO! 💨")
        Humanoid.WalkSpeed = 50 -- Velocidade alta de exemplo (você pode mudar)
    else
        print("🐌 SPEEDHACK DESATIVADO.")
        Humanoid.WalkSpeed = defaultWalkSpeed
    end
    updateUIVisuals()
end

-----------------------------
-- 3. GESTÃO DA INTERFACE DO USUÁRIO (UI)
-----------------------------

local UIFrame = Instance.new("Frame")
UIFrame.Name = "HOHO_Hub_UI"
UIFrame.Size = UDim2.new(0, 250, 0, 150) -- Largura x Altura em pixels
UIFrame.Position = UDim2.new(0.5, -125, 0.5, -75) -- Centraliza a UI na tela
UIFrame.AnchorPoint = Vector2.new(0.5, 0.5)
UIFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
UIFrame.BorderSizePixel = 0
UIFrame.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Título (TextLabel)
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "Title"
TitleLabel.Size = UDim2.new(1, 0, 0.4, 0)
TitleLabel.Position = UDim2.new(0, 0, 0, 0)
TitleLabel.BackgroundColor3 = Color3.fromRGB(60, 60, 90)
TitleLabel.Text = "⭐ HOHO HUB ⭐"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 24
TitleLabel.Parent = UIFrame

-- Botão Fly (TextButton)
local FlyButton = Instance.new("TextButton")
FlyButton.Name = "FlyButton"
FlyButton.Size = UDim2.new(0.9, 0, 0.35, 0)
FlyButton.Position = UDim2.new(0.05, 0, 0.4, 0) -- Posicionado abaixo do título
FlyButton.BackgroundColor3 = Color3.fromRGB(70, 70, 100)
FlyButton.Text = "Toggle Fly (F)"
FlyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
FlyButton.Font = Enum.Font.GothamBold
FlyButton.TextSize = 18
FlyButton.Parent = UIFrame

-- Botão SpeedHack (TextButton)
local SpeedButton = Instance.new("TextButton")
SpeedButton.Name = "SpeedButton"
SpeedButton.Size = UDim2.new(0.9, 0, 0.35, 0)
SpeedButton.Position = UDim2.new(0.05, 0, 0.75, 0) -- Posicionado abaixo do Fly Button
SpeedButton.BackgroundColor3 = Color3.fromRGB(70, 100, 70)
SpeedButton.Text = "Toggle Speed (S)"
SpeedButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedButton.Font = Enum.Font.GothamBold
SpeedButton.TextSize = 18
SpeedButton.Parent = UIFrame


-----------------------------
-- 4. FUNÇÕES DE INTERAÇÃO E ATUALIZAÇÃO
-----------------------------

-- Atualiza a cor e o texto do botão para refletir o estado atual
local function updateUIVisuals()
    local flyColor = isFlyActive and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(70, 70, 100)
    local speedColor = isSpeedActive and Color3.fromRGB(100, 100, 255) or Color3.fromRGB(70, 100, 70)

    FlyButton.BackgroundColor3 = flyColor
    if isFlyActive then
        FlyButton.Text = "✅ FLY ATIVO (F)"
    else
        FlyButton.Text = "Toggle Fly (F)"
    end

    SpeedButton.BackgroundColor3 = speedColor
    if isSpeedActive then
        SpeedButton.Text = "⚡ SPEED ATIVO (S)"
    else
        SpeedButton.Text = "Toggle Speed (S)"
    end
end


-- Conecta o clique do botão para chamar a função lógica
FlyButton.MouseButton1Click:Connect(toggleFly)
SpeedButton.MouseButton1Click:Connect(toggleSpeed)

-----------------------------
-- 5. INICIALIZAÇÃO E CONEXÕES DE EVENTOS (MAIN EXECUTION)
-----------------------------

-- Conecta o input do teclado para ativar as funções sem precisar clicar no botão
UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if gameProcessedEvent then return end -- Ignora se o jogador já estiver digitando em um chat/campo de texto

    if input.KeyCode == Enum.KeyCode.F then
        toggleFly()
    elseif input.KeyCode == Enum.KeyCode.S then
        toggleSpeed()
    end
end)


-- Chama a atualização inicial para configurar os botões no estado padrão (desativado)
updateUIVisuals()

print("================================")
print("🚀 HOHO HUB INICIADO COM SUCESSO!")
print("Use 'F' para Fly e 'S' para Speed.")
print("================================")
