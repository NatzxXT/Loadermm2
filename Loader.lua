-- ==========================================
-- YARHM LOADER (Executa o HUD e as Funções)
-- ==========================================

print("🚀 Iniciando YARHM...")

-- 1. Carrega o HUD (Repositório A)
local urlHUD = "https://raw.githubusercontent.com/NatzzXT/HUDmm2/main/HUD.md"
local sucessoHUD, erroHUD = pcall(function()
    loadstring(game:HttpGet(urlHUD))()
end)

if not sucessoHUD then
    warn("❌ Erro ao carregar o HUD: " .. tostring(erroHUD))
    return
end

-- 2. Espera o HUD criar o menu na tela
repeat task.wait() until getgenv().YARHM
print("✅ HUD carregado. Aguardando a interface aparecer...")

-- 3. Dá um tempo para o menu animar e ficar pronto
task.wait(3) 

-- 4. Carrega as Funções (Repositório B)
local urlFuncoes = "https://raw.githubusercontent.com/NatzzXT/Funcoesmm2/main/Funcoes.md"
local sucessoFuncoes, erroFuncoes = pcall(function()
    loadstring(game:HttpGet(urlFuncoes))()
end)

if not sucessoFuncoes then
    warn("❌ Erro ao carregar as Funções: " .. tostring(erroFuncoes))
    return
end

print("🚀 YARHM carregado com sucesso usando o Loader!")
