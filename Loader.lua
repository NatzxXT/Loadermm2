-- ==========================================
-- YARHM LOADER ANTI-COREGUI (Para Xeno)
-- ==========================================

print("🚀 Iniciando YARHM (Modo Xeno)...")

-- 1. O TRUQUE PARA O XENO: Força o Xeno a usar o PlayerGui em vez do CoreGui
if getgenv().gethui then
    getgenv().gethui = function() 
        return game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui") 
    end
end
if getgenv().get_hidden_gui then
    getgenv().get_hidden_gui = function() 
        return game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui") 
    end
end

-- 2. Carrega o HUD (Repositório A)
local urlHUD = "https://raw.githubusercontent.com/NatzzXT/HUDmm2/main/HUD.lua"
local sucessoHUD, erroHUD = pcall(function()
    loadstring(game:HttpGet(urlHUD))()
end)

if not sucessoHUD then
    warn("❌ Erro ao carregar o HUD: " .. tostring(erroHUD))
    return
end

-- 3. Espera o HUD criar o menu na tela
repeat task.wait() until getgenv().YARHM
print("✅ HUD carregado. Aguardando a interface aparecer...")

-- 4. Dá um tempo maior para o Xeno processar tudo
task.wait(5) 

-- 5. Carrega as Funções (Repositório B)
local urlFuncoes = "https://raw.githubusercontent.com/NatzzXT/Funcoesmm2/main/Funcoes.lua"
local sucessoFuncoes, erroFuncoes = pcall(function()
    loadstring(game:HttpGet(urlFuncoes))()
end)

if not sucessoFuncoes then
    warn("❌ Erro ao carregar as Funções: " .. tostring(erroFuncoes))
    return
end

print("🚀 YARHM carregado com sucesso no Xeno!")
