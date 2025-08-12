--[[
    UI Avançada Profissional para Delta Executor Mobile
    Sistema de abas, toggles, sliders, dropdowns e input boxes
    Layout responsivo e tema moderno
--]]

local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local orbEvent = ReplicatedStorage:WaitForChild("rEvents"):WaitForChild("orbEvent")

local hui = gethui()

-- Criar ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ProCollectorUI"
screenGui.Parent = hui

-- Variáveis para armazenar estados globais
getgenv().Settings = getgenv().Settings or {
    collectGem = false,
    collectRedOrb = false,
    collectInterval = 0.1,
    someSliderValue = 50,
    someDropdownChoice = "Option1",
    someTextInput = "",
}

-- Função auxiliar para criar instâncias de forma rápida
local function new(class, props)
    local obj = Instance.new(class)
    for k,v in pairs(props or {}) do
        obj[k] = v
    end
    return obj
end

-- Tema de cores
local colors = {
    background = Color3.fromRGB(22,22,22),
    primary = Color3.fromRGB(10, 132, 255),
    secondary = Color3.fromRGB(44,44,44),
    accent = Color3.fromRGB(0, 122, 204),
    text = Color3.fromRGB(235, 235, 235),
    textDisabled = Color3.fromRGB(150, 150, 150),
    toggleOn = Color3.fromRGB(0, 170, 255),
    toggleOff = Color3.fromRGB(100, 100, 100),
}

-- Main Frame
local mainFrame = new("Frame", {
    Size = UDim2.new(0, 380, 0, 450),
    Position = UDim2.new(0.5, -190, 0.5, -225),
    BackgroundColor3 = colors.background,
    AnchorPoint = Vector2.new(0.5, 0.5),
    Parent = screenGui,
    Active = true,
    Draggable = true,
    BorderSizePixel = 0,
})

-- UI Corner arredondado para mainFrame
local uiCornerMain = new("UICorner", {CornerRadius = UDim.new(0, 12), Parent = mainFrame})

-- Top bar (título)
local topBar = new("Frame", {
    Size = UDim2.new(1, 0, 0, 45),
    BackgroundColor3 = colors.secondary,
    Parent = mainFrame,
})

local uiCornerTop = new("UICorner", {CornerRadius = UDim.new(0, 12), Parent = topBar})

local titleLabel = new("TextLabel", {
    Text = "Collector Pro - Advanced UI",
    TextColor3 = colors.text,
    Font = Enum.Font.GothamBold,
    TextSize = 22,
    BackgroundTransparency = 1,
    Size = UDim2.new(1, -20, 1, 0),
    Position = UDim2.new(0, 10, 0, 0),
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = topBar,
})

-- Tab Buttons container
local tabsContainer = new("Frame", {
    Size = UDim2.new(1, 0, 0, 45),
    Position = UDim2.new(0, 0, 0, 45),
    BackgroundColor3 = colors.secondary,
    Parent = mainFrame,
})

local uiCornerTabs = new("UICorner", {CornerRadius = UDim.new(0, 12), Parent = tabsContainer})

-- Content container
local contentContainer = new("Frame", {
    Size = UDim2.new(1, -20, 1, -100),
    Position = UDim2.new(0, 10, 0, 95),
    BackgroundTransparency = 1,
    Parent = mainFrame,
})

-- Layout para conteúdo
local contentLayout = new("UIListLayout", {
    Padding = UDim.new(0, 10),
    SortOrder = Enum.SortOrder.LayoutOrder,
    Parent = contentContainer,
})

local contentPadding = new("UIPadding", {
    PaddingLeft = UDim.new(0, 10),
    PaddingRight = UDim.new(0, 10),
    PaddingTop = UDim.new(0, 10),
    PaddingBottom = UDim.new(0, 10),
    Parent = contentContainer,
})

-- Helper para criar botão de tab
local function createTabButton(name, posX)
    local btn = new("TextButton", {
        Size = UDim2.new(0, 110, 1, 0),
        Position = UDim2.new(0, posX, 0, 0),
        BackgroundColor3 = colors.secondary,
        BorderSizePixel = 0,
        Text = name,
        Font = Enum.Font.GothamBold,
        TextSize = 17,
        TextColor3 = colors.text,
        Parent = tabsContainer,
    })
    local corner = new("UICorner", {CornerRadius = UDim.new(0, 8), Parent = btn})
    return btn
end

-- Limpa conteúdo do container
local function clearContent()
    for _, child in pairs(contentContainer:GetChildren()) do
        if not (child:IsA("UIListLayout") or child:IsA("UIPadding")) then
            child:Destroy()
        end
    end
end

-- Funções para criar controles comuns

local function createLabel(text)
    local label = new("TextLabel", {
        Text = text,
        TextColor3 = colors.text,
        Font = Enum.Font.GothamBold,
        TextSize = 18,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 30),
        TextXAlignment = Enum.TextXAlignment.Left,
        LayoutOrder = 0,
        Parent = contentContainer,
    })
    return label
end

local function createToggle(text, initialState, callback)
    local frame = new("Frame", {
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = colors.secondary,
        LayoutOrder = 1,
        Parent = contentContainer,
        ClipsDescendants = true,
    })
    local corner = new("UICorner", {CornerRadius = UDim.new(0, 6), Parent = frame})

    local label = new("TextLabel", {
        Text = text,
        TextColor3 = colors.text,
        Font = Enum.Font.GothamBold,
        TextSize = 17,
        BackgroundTransparency = 1,
        Size = UDim2.new(0.7, 0, 1, 0),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = frame,
    })

    local toggleBtn = new("TextButton", {
        Size = UDim2.new(0, 55, 0, 30),
        Position = UDim2.new(0.75, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundColor3 = initialState and colors.toggleOn or colors.toggleOff,
        TextColor3 = colors.text,
        Text = initialState and "ON" or "OFF",
        Font = Enum.Font.GothamBold,
        TextSize = 16,
        Parent = frame,
    })
    local toggleCorner = new("UICorner", {CornerRadius = UDim.new(0, 6), Parent = toggleBtn})

    toggleBtn.MouseButton1Click:Connect(function()
        local newState = not (toggleBtn.Text == "ON")
        toggleBtn.Text = newState and "ON" or "OFF"
        toggleBtn.BackgroundColor3 = newState and colors.toggleOn or colors.toggleOff
        callback(newState)
    end)

    return frame
end

local function createSlider(text, min, max, default, callback)
    local frame = new("Frame", {
        Size = UDim2.new(1, 0, 0, 50),
        BackgroundColor3 = colors.secondary,
        LayoutOrder = 1,
        Parent = contentContainer,
    })
    local corner = new("UICorner", {CornerRadius = UDim.new(0, 6), Parent = frame})

    local label = new("TextLabel", {
        Text = text.." ("..default..")",
        TextColor3 = colors.text,
        Font = Enum.Font.GothamBold,
        TextSize = 17,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 20),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = frame,
    })

    local sliderBar = new("Frame", {
        Size = UDim2.new(1, -20, 0, 12),
        Position = UDim2.new(0, 10, 0, 30),
        BackgroundColor3 = Color3.fromRGB(80, 80, 80),
        Parent = frame,
    })
    local sliderCorner = new("UICorner", {CornerRadius = UDim.new(0, 6), Parent = sliderBar})

    local sliderFill = new("Frame", {
        Size = UDim2.new((default - min)/(max - min), 0, 1, 0),
        BackgroundColor3 = colors.primary,
        Parent = sliderBar,
    })
    local fillCorner = new("UICorner", {CornerRadius = UDim.new(0, 6), Parent = sliderFill})

    local dragging = false

    sliderBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            local function update(input)
                local pos = math.clamp(input.Position.X - sliderBar.AbsolutePosition.X, 0, sliderBar.AbsoluteSize.X)
                local percent = pos / sliderBar.AbsoluteSize.X
                local value = math.floor(min + (max - min) * percent)
                sliderFill.Size = UDim2.new(percent, 0, 1, 0)
                label.Text = text.." ("..value..")"
                callback(value)
            end
            update(input)
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
            input.Changed:Connect(function()
                if dragging then
                    update(input)
                end
            end)
        end
    end)

    sliderBar.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local pos = math.clamp(input.Position.X - sliderBar.AbsolutePosition.X, 0, sliderBar.AbsoluteSize.X)
            local percent = pos / sliderBar.AbsoluteSize.X
            local value = math.floor(min + (max - min) * percent)
            sliderFill.Size = UDim2.new(percent, 0, 1, 0)
            label.Text = text.." ("..value..")"
            callback(value)
        end
    end)

    return frame
end

-- Continuação do createDropdown
local function createDropdown(text, options, default, callback)
    local frame = new("Frame", {
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = colors.secondary,
        LayoutOrder = 1,
        Parent = contentContainer,
    })
    local corner = new("UICorner", {CornerRadius = UDim.new(0, 6), Parent = frame})

    local label = new("TextLabel", {
        Text = text,
        TextColor3 = colors.text,
        Font = Enum.Font.GothamBold,
        TextSize = 17,
        BackgroundTransparency = 1,
        Size = UDim2.new(0.6, 0, 1, 0),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = frame,
    })

    local dropdownBtn = new("TextButton", {
        Size = UDim2.new(0, 130, 0, 30),
        Position = UDim2.new(0.65, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundColor3 = colors.toggleOff,
        TextColor3 = colors.text,
        Text = default,
        Font = Enum.Font.GothamBold,
        TextSize = 16,
        Parent = frame,
    })
    local cornerBtn = new("UICorner", {CornerRadius = UDim.new(0, 6), Parent = dropdownBtn})

    local dropdownOpen = false
    local dropdownList = Instance.new("Frame")
    dropdownList.Size = UDim2.new(0, 130, 0, #options * 30)
    dropdownList.Position = UDim2.new(0.65, 0, 1, 2)
    dropdownList.BackgroundColor3 = colors.secondary
    dropdownList.Visible = false
    dropdownList.ClipsDescendants = true
    dropdownList.Parent = frame

    local uiList = Instance.new("UIListLayout", dropdownList)
    uiList.SortOrder = Enum.SortOrder.LayoutOrder
    uiList.Padding = UDim.new(0, 2)

    for i, option in ipairs(options) do
        local optionBtn = Instance.new("TextButton")
        optionBtn.Size = UDim2.new(1, 0, 0, 30)
        optionBtn.BackgroundColor3 = colors.secondary
        optionBtn.TextColor3 = colors.text
        optionBtn.Font = Enum.Font.GothamBold
        optionBtn.TextSize = 16
        optionBtn.Text = option
        optionBtn.Parent = dropdownList

        optionBtn.MouseEnter:Connect(function()
            optionBtn.BackgroundColor3 = colors.primary
        end)
        optionBtn.MouseLeave:Connect(function()
            optionBtn.BackgroundColor3 = colors.secondary
        end)

        optionBtn.MouseButton1Click:Connect(function()
            dropdownBtn.Text = option
            callback(option)
            dropdownList.Visible = false
            dropdownOpen = false
        end)
    end

    dropdownBtn.MouseButton1Click:Connect(function()
        dropdownOpen = not dropdownOpen
        dropdownList.Visible = dropdownOpen
    end)

    return frame
end

-- Input box (TextBox)
local function createInputBox(text, defaultText, callback)
    local frame = new("Frame", {
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = colors.secondary,
        LayoutOrder = 1,
        Parent = contentContainer,
    })
    local corner = new("UICorner", {CornerRadius = UDim.new(0, 6), Parent = frame})

    local label = new("TextLabel", {
        Text = text,
        TextColor3 = colors.text,
        Font = Enum.Font.GothamBold,
        TextSize = 17,
        BackgroundTransparency = 1,
        Size = UDim2.new(0.6, 0, 1, 0),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = frame,
    })

    local textBox = Instance.new("TextBox")
    textBox.Size = UDim2.new(0, 130, 0, 30)
    textBox.Position = UDim2.new(0.65, 0, 0.5, 0)
    textBox.AnchorPoint = Vector2.new(0, 0.5)
    textBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    textBox.TextColor3 = colors.text
    textBox.Font = Enum.Font.GothamBold
    textBox.TextSize = 16
    textBox.Text = defaultText or ""
    textBox.ClearTextOnFocus = false
    textBox.Parent = frame

    local cornerInput = new("UICorner", {CornerRadius = UDim.new(0, 6), Parent = textBox})

    textBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            callback(textBox.Text)
        end
    end)

    return frame
end

-- --- POPULAR AS ABAS ---

local currentTab = nil

local function switchTab(tabName)
    clearContent()

    if tabName == "Main" then
        -- Abas principais com toggles para orbs
        createLabel("Coleta de Orbs")

        createToggle("Coletar Gemas", getgenv().Settings.collectGem, function(state)
            getgenv().Settings.collectGem = state
        end)

        createToggle("Coletar Red Orb", getgenv().Settings.collectRedOrb, function(state)
            getgenv().Settings.collectRedOrb = state
        end)

        createSlider("Intervalo (segundos)", 0.05, 2, getgenv().Settings.collectInterval, function(value)
            getgenv().Settings.collectInterval = value
        end)

    elseif tabName == "Misc" then
        createLabel("Opções Diversas")

        createDropdown("Escolha uma opção", {"Option1", "Option2", "Option3"}, getgenv().Settings.someDropdownChoice, function(value)
            getgenv().Settings.someDropdownChoice = value
        end)

        createInputBox("Insira texto:", getgenv().Settings.someTextInput, function(text)
            getgenv().Settings.someTextInput = text
        end)

        createSlider("Exemplo Slider", 0, 100, getgenv().Settings.someSliderValue, function(value)
            getgenv().Settings.someSliderValue = value
        end)

    elseif tabName == "Settings" then
        createLabel("Configurações")

        -- Aqui você pode adicionar configurações de UI, reset, etc
        local resetBtn = new("TextButton", {
            Text = "Resetar Configurações",
            Size = UDim2.new(1, 0, 0, 40),
            BackgroundColor3 = colors.accent,
            TextColor3 = colors.text,
            Font = Enum.Font.GothamBold,
            TextSize = 18,
            Parent = contentContainer,
        })
        local cornerBtn = new("UICorner", {CornerRadius = UDim.new(0, 8), Parent = resetBtn})

        resetBtn.MouseButton1Click:Connect(function()
            -- Resetar variáveis
            getgenv().Settings.collectGem = false
            getgenv().Settings.collectRedOrb = false
            getgenv().Settings.collectInterval = 0.1
            getgenv().Settings.someSliderValue = 50
            getgenv().Settings.someDropdownChoice = "Option1"
            getgenv().Settings.someTextInput = ""
            switchTab("Main")
        end)
    end
end

-- Criar abas
local tabs = {
    {name = "Main", button = createTabButton("Main", 0)},
    {name = "Misc", button = createTabButton("Misc", 125)},
    {name = "Settings", button = createTabButton("Settings", 250)},
}

for i, tab in ipairs(tabs) do
    tab.button.MouseButton1Click:Connect(function()
        for _, t in pairs(tabs) do
            t.button.BackgroundColor3 = colors.secondary
        end
        tab.button.BackgroundColor3 = colors.primary
        switchTab(tab.name)
    end)
end

-- Inicializa com aba Main selecionada
tabs[1].button.BackgroundColor3 = colors.primary
switchTab("Main")

-- Loop principal para executar ações baseadas nas configurações
spawn(function()
    while true do
        if getgenv().Settings.collectGem then
            local args = {"collectOrb", "Gem", "City"}
            orbEvent:FireServer(unpack(args))
        end
        if getgenv().Settings.collectRedOrb then
            local args = {"collectOrb", "Red Orb", "City"}
            orbEvent:FireServer(unpack(args))
        end
        task.wait(getgenv().Settings.collectInterval)
    end
end)