@echo off
setlocal enabledelayedexpansion
chcp 65001 >nul

echo ======================================
echo 2. 自动增量上传新素材到 GitHub (Pinterest Videos)
echo 仓库: https://github.com/harrietwong/pinterest-videos.git
echo ======================================
echo.

cd /d D:\PinterestRepo

if not exist ".git" (
    echo [ERROR] D:\PinterestRepo 不是 Git 仓库，请先运行 01_Sync_From_GitHub.bat
    pause
    exit /b 1
)

echo [INFO] 正在扫描并添加新文件...
git add .

for /f %%i in ('git status --porcelain ^| find /c /v ""') do set CHANGES=%%i
if "%CHANGES%"=="0" (
  echo [INFO] 没有发现新文件或被修改的文件，不需要上传。
  pause
  exit /b 0
)

echo [INFO] 发现 %CHANGES% 个改动，准备提交...
set TIMESTAMP=%date:~0,10% %time:~0,8%
git commit -m "Auto upload new media - %TIMESTAMP%"
if errorlevel 1 (
  echo [ERROR] 提交失败。
  pause
  exit /b 1
)

echo [INFO] 正在拉取最新远程变更 (防止冲突)...
git pull origin main --rebase >nul 2>nul

echo [INFO] 正在上传到 GitHub，请耐心等待进度条完成...
git push -u origin main
if errorlevel 1 (
  echo.
  echo [ERROR] 上传失败！可能是网络原因，请重新运行此脚本。
  pause
  exit /b 1
)

echo.
echo [SUCCESS] 太棒了！新素材已成功上传到 GitHub！
pause
endlocal
