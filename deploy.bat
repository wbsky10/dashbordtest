@echo off
chcp 65001 > nul
title Firebase Hosting デプロイツール

echo ======================================================================
echo   経営ダッシュボード - Firebase Hosting デプロイツール
echo ======================================================================
echo.

:: 1. firebase コマンドの確認
where firebase >nul 2>&1
if %errorlevel% neq 0 (
    echo 【エラー】Firebase CLI がパソコンに見つかりませんでした。
    echo.
    echo 初回のみ、Firebase CLI のインストールが必要です。
    echo 以下のいずれかの方法でインストールしてください：
    echo.
    echo   1. 公式インストーラー（推奨・Node.js不要）:
    echo      https://firebase.tools/bin/win/instant/latest
    echo      ダウンロードした exe ファイルを起動、または実行パスに追加してください。
    echo.
    echo   2. npm をお持ちの場合:
    echo      npm install -g firebase-tools
    echo.
    pause
    exit /b 1
)

:: 2. プロジェクトIDの確認
findstr /C:"your-project-id" .firebaserc >nul 2>&1
if %errorlevel% equ 0 (
    echo 【初回設定】Firebase プロジェクトID を設定します。
    echo.
    echo Firebase コンソール (https://console.firebase.google.com/) で作成した
    echo プロジェクトの「プロジェクトID」を入力してください。
    echo.
    set /p PROJ_ID="プロジェクトIDを入力してください: "
    if "%PROJ_ID%"=="" (
        echo プロジェクトIDが入力されませんでした。処理を中断します。
        pause
        exit /b 1
    )
    (
        echo {
        echo   "projects": {
        echo     "default": "%PROJ_ID%"
        echo   }
        echo }
    ) > .firebaserc
    echo.
    echo プロジェクトID を %PROJ_ID% に設定しました。
    echo.
)

:: 3. ログイン状態の確認＆デプロイ
echo Firebase にデプロイを開始します...
echo.

call firebase deploy --only hosting

if %errorlevel% equ 0 (
    echo.
    echo ======================================================================
    echo   【成功】デプロイが完了しました！
    echo   役員・経営陣への共有URLが発行されました。
    echo ======================================================================
) else (
    echo.
    echo 【デプロイに失敗しました】
    echo もし「Please run firebase login」と表示されている場合は、
    echo 以下のコマンドを一度実行して Google アカウントでログインしてください：
    echo   firebase login
)

echo.
pause
