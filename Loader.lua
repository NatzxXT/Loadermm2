-- ==========================================
-- CORREÇÃO DE COMPATIBILIDADE PARA EXECUTORES ANTIGOS (Yub-X, Xeno, etc.)
-- ==========================================
pcall(function()
    if not Enum.ScreenInsets then
        Enum.ScreenInsets = { DeviceSafeInsets = "DeviceSafeInsets", None = "None" }
    end
    if not Enum.SafeAreaCompatibility then
        Enum.SafeAreaCompatibility = { None = "None", FullscreenExtension = "FullscreenExtension" }
    end
end)
-- ==========================================

print("🚀 Iniciando YARHM...")

-- 1. TESTE DE SUPORTE DO EXECUTOR
if not game.HttpGet then
    warn("❌ ERRO FATAL: Seu executor NÃO suporta a função 'game:HttpGet'.")
    warn("Tente usar o Solara, Wave ou Delta. O Xeno não funciona para isso.")
    return
end

if not loadstring then
    warn("❌ ERRO FATAL: Seu executor NÃO suporta a função 'loadstring'.")
    return
end

-- 2. Carrega o HUD (Repositório A)
local urlHUD = "https://raw.githubusercontent.com/NatzxXT/HUDmm2/refs/heads/main/HUD.lua"
print("📥 Baixando HUD...")

local hudCode = game:HttpGet(urlHUD)

if not hudCode or hudCode == "" or string.find(hudCode, "404: Not Found") then
    warn("❌ ERRO: Não foi possível baixar o HUD. Verifique se o link está correto e se o arquivo se chama HUD.lua no GitHub!")
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
repeat task.wait() until getgenv().YARHM
print("✅ HUD carregado. Aguardando a interface aparecer...")

-- 4. Dá um tempo para o menu animar
task.wait(3) 

-- 5. Carrega as Funções (Repositório B)
local urlFuncoes = "https://raw.githubusercontent.com/NatzxXT/Funcoesmm2/refs/heads/main/Funcoes.lua"
print("📥 Baixando Funções...")

local funcoesCode = game:HttpGet(urlFuncoes)

if not funcoesCode or funcoesCode == "" or string.find(funcoesCode, "404: Not Found") then
    warn("❌ ERRO: Não foi possível baixar as Funções. Verifique se o link está correto e se o arquivo se chama Funcoes.lua no GitHub!")
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
