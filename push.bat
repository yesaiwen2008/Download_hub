@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

REM 让脚本总是以脚本所在目录为当前目录（可复制到任意仓库直接用）
cd /d %~dp0

echo === Git 变更预览 ===
git status -s
echo.

REM 默认提交信息（可改）
set "default_msg=批量更新内容"

REM 允许输入自定义提交信息；直接回车使用默认
set /p user_msg=请输入提交信息(直接回车用默认“%default_msg%”): 
if not defined user_msg set "user_msg=%default_msg%"

echo.
echo === 正在添加所有改动 ===
git add -A

REM 无改动则退出（避免空提交）
git diff --cached --quiet
if %errorlevel%==0 (
  echo 没有需要提交的改动，已跳过 commit/push。
  pause
  exit /b 0
)

echo.
echo === 正在提交 ===
git commit -m "%user_msg%"

echo.
echo === 同步远程(main)以避免冲突 ===
git pull --rebase origin main

echo.
echo === 推送到远程(main) ===
git push origin main

echo.
echo 完成！✅
pause
