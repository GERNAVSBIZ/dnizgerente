@echo off
chcp 65001 >nul
title Portal Gerente DNIZ - Painel Permanente
echo ======================================================
echo   INICIANDO PORTAL GERENTE DNIZ (PAINEL PERMANENTE)
echo ======================================================
echo.

where node >nul 2>nul
if %errorlevel% equ 0 (
    echo Iniciando servidor local na porta 8080...
    start "" "http://localhost:8080"
    node "%~dp0server.js"
) else (
    echo Node.js nao encontrado. Abrindo index.html diretamente no navegador...
    start "" "%~dp0index.html"
)
