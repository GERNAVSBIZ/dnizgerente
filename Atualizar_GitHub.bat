@echo off
chcp 65001 >nul
cd /d "%~dp0"
echo ======================================================
echo   ATUALIZANDO PORTAL GERENTE DNIZ NO GITHUB
echo   Repositorio: https://github.com/gernavsbiz/dnizgerente
echo ======================================================
echo.
git add index.html server.js vercel.json Iniciar_Portal.bat
git commit -m "Atualiza Portal Gerente DNIZ (METAR rapido + Bip Windows)" 2>nul
echo Enviando para o GitHub (se abrir a janela de login, entre com a conta gernavsbiz)...
git push -u origin main --force
if %errorlevel% neq 0 (
    echo.
    echo [!] A conta padrao do Git no Windows nao tem permissao em gernavsbiz.
    echo Abrindo a pagina de upload direto do GitHub no navegador...
    start "" "https://github.com/gernavsbiz/dnizgerente/upload/main"
    explorer.exe /select,"%~dp0index.html"
) else (
    echo.
    echo [OK] Atualizado com sucesso no GitHub! Aguarde ~1 minuto e pressione Ctrl+F5 no site.
)
echo.
pause
