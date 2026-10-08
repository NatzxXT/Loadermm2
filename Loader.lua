-- ==========================================
-- YARHM LOADER (Solara Edition)
-- ==========================================

print("🚀 Iniciando YARHM...")

-- 1. Carrega o HUD (Repositório A)
local urlHUD = "https://raw.githubusercontent.com/NatzzXT/HUDmm2/main/HUD.lua"
local hudCode = game:HttpGet(urlHUD)

if not hudCode or hudCode == "" or string.find(hudCode, "404: Not Found") then
    warn("❌ ERRO: Não foi possível baixar o HUD. Verifique se o arquivo se chama HUD.lua no GitHub!")
    return
end

local sucessoHUD, erroHUD = pcall(function()
    loadstring(hudCode)()
end)

if not sucessoHUD then
    warn("❌ Erro ao executar o HUD: " .. tostring(erroHUD))
    return
end

-- 2. Espera o HUD criar o menu na tela
repeat task.wait() until getgenv().YARHM
print("✅ HUD carregado. Aguardando a interface aparecer...")

-- 3. Dá um tempo para o menu animar e ficar pronto
task.wait(3) 

-- 4. Carrega as Funções (Repositório B)
local urlFuncoes = "https://raw.githubusercontent.com/NatzzXT/Funcoesmm2/main/Funcoes.lua"
local funcoesCode = game:HttpGet(urlFuncoes)

if not funcoesCode or funcoesCode == "" or string.find(funcoesCode, "404: Not Found") then
    warn("❌ ERRO: Não foi possível baixar as Funções. Verifique se o arquivo se chama Funcoes.lua no GitHub!")
    return
end

local sucessoFuncoes, erroFuncoes = pcall(function()
    loadstring(funcoesCode)()
end)

if not sucessoFuncoes then
    warn("❌ Erro ao executar as Funções: " .. tostring(erroFuncoes))
    return
end

print("🚀 YARHM carregado com sucesso no Solara!")
