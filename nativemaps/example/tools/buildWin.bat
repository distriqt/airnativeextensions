SET PACKAGE_NAME=air.com.distriqt.test.debug
SET APPNAME=TestNativeMaps
SET APKNAME=TestNativeMaps.apk
SET CERTIFICATE=distriqt_air_selfsign_cert.p12
SET PASSWORD=d1str1qt
SET TARGET=apk-debug
SET EXTDIR=..\..\bin
SET ADT_PATH="C:\Program Files\Adobe\Adobe Flash Builder 4.7\eclipse\plugins\com.adobe.flash.compiler_4.7.0.349722\AIRSDK\bin\adt"

ECHO Compile debug APK...
call %ADT_PATH% -package -target %TARGET% -storetype pkcs12 -keystore %CERTIFICATE% -storepass %PASSWORD% %APKNAME% %APPNAME%-app.xml %APPNAME%.swf icons res -extdir %EXTDIR%


SET PACKAGE_NAME=
SET APPNAME=
SET APKNAME=
SET CERTIFICATE=
SET PASSWORD=
SET TARGET=
SET EXTDIR=

ECHO "Finished."