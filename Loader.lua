-- ==========================================
-- YARHM LOADER CORRIGIDO (Compatibilidade Yub-X)
-- ==========================================

print("🚀 Iniciando YARHM...")

-- CORREÇÃO PARA EXECUTORES ANTIGOS (Yub-X, Xeno)
pcall(function()
    if not Enum.ScreenInsets then
        Enum.ScreenInsets = { DeviceSafeInsets = "DeviceSafeInsets", None = "None" }
    end
    if not Enum.SafeAreaCompatibility then
        Enum.SafeAreaCompatibility = { None = "None", FullscreenExtension = "FullscreenExtension" }
    end
end)

-- 1. TESTE DE SUPORTE DO EXECUTOR
if not game.HttpGet then
    warn("❌ ERRO FATAL: Seu executor NÃO suporta a função 'game:HttpGet'.")
    return
end

if not loadstring then
    warn("❌ ERRO FATAL: Seu executor NÃO suporta a função 'loadstring'.")
    return
end

-- 2. Carrega o HUD (Repositório A) - USANDO LINK CURTO
local urlHUD = "https://raw.githubusercontent.com/NatzxXT/HUDmm2/main/HUD.lua"
print("📥 Baixando HUD...")

local hudCode = game:HttpGet(urlHUD)

if not hudCode or hudCode == "" or string.find(hudCode, "404: Not Found") then
    warn("❌ ERRO: Não foi possível baixar o HUD. Verifique se você clicou em 'Commit changes' no GitHub!")
    return
end

print("✅ HUD baixado com sucesso. Executando...")
local sucessoHUD, erroHUD = pcall(function()
    loadstring(hudCode)()
end)

if not sucessoHUD then
    warn("❌ Erro ao executar o HUD: " .. tostring(erroHUD))
    return
end

-- 3. Espera o HUD criar o menu na tela
print("⏳ Aguardando a interface do HUD aparecer...")
local tentativas = 0
repeat 
    task.wait(0.5)
    tentativas = tentativas + 1
until getgenv().YARHM or tentativas > 20

if not getgenv().YARHM then
    warn("❌ ERRO: O HUD não criou a variável 'getgenv().YARHM'. O Yub-X pode não ter memória suficiente para carregar o HUD.")
    return
end

print("✅ HUD carregado e interface visível!")
task.wait(3)

-- 4. Carrega as Funções (Repositório B) - USANDO LINK CURTO
local urlFuncoes = "https://raw.githubusercontent.com/NatzxXT/Funcoesmm2/main/Funcoes.lua"
print("📥 Baixando Funções...")

local funcoesCode = game:HttpGet(urlFuncoes)

if not funcoesCode or funcoesCode == "" or string.find(funcoesCode, "404: Not Found") then
    warn("❌ ERRO: Não foi possível baixar as Funções. Verifique o GitHub.")
    return
end

print("✅ Funções baixadas com sucesso. Executando...")
local sucessoFuncoes, erroFuncoes = pcall(function()
    loadstring(funcoesCode)()
end)

if not sucessoFuncoes then
    warn("❌ Erro ao executar as Funções: " .. tostring(erroFuncoes))
    return
end

print("🚀 YARHM carregado com sucesso!")
