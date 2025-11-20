@echo off
REM Script complet pour initialiser, renommer en 'main', lier et synchroniser un depot Git.

REM --- 1. Verifications et initialisation ---

REM Verifie si Git est installe et accessible.
git --version >nul 2>&1
if %errorlevel% neq 0 (
    echo Erreur: Git n'est pas installe ou pas dans le PATH.
    pause
    exit /b
)

REM Verifie si ce n'est pas deja un depot Git.
if exist ".git" (
    echo Ce dossier est deja un depot Git.
    pause
    exit /b
)

echo --- Initialisation du depot Git ---
git init

REM --- 2. Renommage et Commit Local ---

REM Renomme la branche actuelle (master/main) en 'main' pour assurer la coherence.
git branch -M main

REM Creation d'un README local pour avoir un historique a fusionner.
if not exist "README.md" (
    echo # Nouveau Projet > README.md
    echo Fichier README initial cree localement.
)
git add README.md
git commit -m "Initial commit local avec README pour fusion"

REM --- 3. Configuration du distant ---

echo.
set /p REMOTE_URL="Collez l'URL de votre depot distant (ex: https://github.com/user/repo.git) : "

if not defined REMOTE_URL (
    echo URL non valide. Operation annulee.
    REM Nettoyage en cas d'annulation.
    rmdir /s /q .git
    exit /b
)

echo.
echo --- Liaison avec le depot distant ---
git remote add origin %REMOTE_URL%

REM --- 4. Synchronisation Initiale et Fusion ---
echo.
echo --- Synchronisation : Recuperation et Fusion du README distant ---

REM On recupere les informations du distant.
git fetch origin

REM On fusionne l'historique distant (qui contient le README initial de GitHub) avec notre historique local.
REM --allow-unrelated-histories est crucial pour cette premiere fusion.
git pull origin main --allow-unrelated-histories

REM --- 5. Envoi Final (PUSH) ---
echo.
echo --- Envoi des changements locaux vers le distant ---
REM Pousse les changements et definit la branche distante 'main' comme 'upstream' (-u).
git push -u origin main

echo.
echo ************************************************************
echo *** Succes ! ***
echo Le depot local est entierement synchronise avec le distant.
echo Vous pouvez commencer a travailler et faire des "git push" normaux.
echo ************************************************************
echo.
pause