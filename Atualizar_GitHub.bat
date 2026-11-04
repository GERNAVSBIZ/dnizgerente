@echo off
chcp 65001 >nul
cd /d "%~dp0"
echo ======================================================
echo   ATUALIZANDO PORTAL GERENTE DNIZ NO GITHUB (NUVEM)
echo   Repositorio: https://github.com/gernavsbiz/dnizgerente
echo   Site:        https://gernavsbiz.github.io/dnizgerente/
echo ======================================================
echo.

:: Forca o Git a usar especificamente o usuario gernavsbiz (e nao wilksonac)
git remote set-url origin https://gernavsbiz@github.com/gernavsbiz/dnizgerente.git

echo [1/3] Preparando arquivos modificados...
git add index.html server.js vercel.json Iniciar_Portal.bat Atualizar_GitHub.bat

echo [2/3] Criando commit local...
git commit -m "Atualiza Portal Gerente DNIZ (%date% %time:~0,5%)" 2>nul

echo [3/3] Enviando para o GitHub (conta: gernavsbiz)...
echo (Se abrir janela de login do GitHub na primeira vez, faca login com a conta gernavsbiz)
echo.
git push -u origin main --force

if %errorlevel% neq 0 (
    echo.
    echo [!] Nao foi possivel enviar direto pelo Git.
    echo Abrindo pagina de upload do GitHub e selecionando o index.html na pasta...
    start "" "https://github.com/gernavsbiz/dnizgerente/upload/main"
    explorer.exe /select,"%~dp0index.html"
) else (
    echo.
    echo ======================================================
    echo [OK] ENVIADO COM SUCESSO PARA A NUVEM!
    echo O GitHub Pages atualiza em cerca de 40 a 60 segundos.
    echo Acesse: https://gernavsbiz.github.io/dnizgerente/
    echo ======================================================
)
echo.
pause
