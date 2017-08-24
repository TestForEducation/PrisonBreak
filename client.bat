@ECHO OFF
CD /D %~dp0

setLocal EnableDelayedExpansion
for /R .\lib %%A in (*.jar) do (
   set JARPATH=%%A;!JARPATH!
)
@START /B jre\bin\javaw -Dfile.encoding=utf-8 -Dsun.jnu.encoding=utf-8 -Duser.timezone=Asia/Shanghai -Xms256M -Xmx256M -Xmn192M  -classpath !JARPATH!.\bin\ cross.wall.Windows >> client.log
