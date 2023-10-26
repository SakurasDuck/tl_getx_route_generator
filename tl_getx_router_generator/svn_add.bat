@echo off
chcp 65001

echo 开始执行添加


:: 获取当前目录名
set curf=%~p0%
set curf=%curf:~0,-1%
:getfolder
FOR /F "tokens=1,* delims=\/" %%i in ("%curf%") do (
    if not "%%j"=="" (
        set curf=%%j
        goto getfolder
    )
)

echo Current folder: %curf%


cd ..

:: 添加空目录
svn add --parents ./%curf%/ --non-recursive

:: 添加资源文件
if  exist ./%curf%/assets/ (
    svn add --depth infinity --force  ./%curf%/assets/
)

:: 添加lib/
svn add --depth infinity --force in ./%curf%/lib/ 

:: 添加test/
svn add  --depth infinity --force ./%curf%/test/

::添加yaml,ignore
svn add ./%curf%/.gitignore

svn add ./%curf%/analysis_options.yaml

svn add ./%curf%/CHANGELOG.md

svn add ./%curf%/LICENSE

svn add ./%curf%/pubspec.yaml

svn add ./%curf%/README.md

svn add ./%curf%/svn_add.bat

:: 判断是否存在example,不存在直接退出
if not exist ./%curf%/example/ (
    echo 没有 example 目录,完成
    pause
    goto end
)

:: 添加example 目录
svn add ./%curf%/example/ --non-recursive

:: 添加example 需要提交文件
svn add  --depth infinity --force ./%curf%/example/lib/
svn add  --depth infinity --force ./%curf%/example/test/
svn add ./%curf%/example/pubspec.yaml
svn add --parents ./%curf%/example/android/app/src/main/AndroidManifest.xml
svn add --parents ./%curf%/example/android/app/build.gradle
svn add --parents ./%curf%/example/android/build.gradle


::等待确认
pause

:end