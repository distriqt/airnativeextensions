SET PACKAGE_NAME=air.com.distriqt.test.debug
SET APPNAME=TestNativeMaps
SET APKNAME=TestNativeMaps.apk
SET CERTIFICATE=distriqt_air_selfsign_cert.p12
SET PASSWORD=d1str1qt
SET TARGET=apk-debug
SET EXTDIR=..\..\bin
SET ADT_PATH="C:\Program Files\Adobe\Adobe Flash Builder 4.7\eclipse\plugins\com.adobe.flash.compiler_4.7.0.349722\AIRSDK\bin\adt"
SET ADB_PATH="C:\Program Files\Adobe\Adobe Flash Builder 4.7\sdks\4.6.0\lib\android\bin\adb"

ECHO Compile debug APK...
call %ADT_PATH% -package -target %TARGET% -storetype pkcs12 -keystore %CERTIFICATE% -storepass %PASSWORD% %APKNAME% %APPNAME%-app.xml %APPNAME%.swf icons res -extdir %EXTDIR%


ECHO "Attempting to install and run application...";
:: Uninstall the old version of the app 
call %ADB_PATH% uninstall %PACKAGE_NAME%
:: Install new apk
call %ADB_PATH% install %APKNAME%
:: Run the app
call %ADB_PATH% shell am start -a android.intent.action.MAIN -n %PACKAGE_NAME%/.AppEntry
ECHO "Done.";


SET PACKAGE_NAME=
SET APPNAME=
SET APKNAME=
SET CERTIFICATE=
SET PASSWORD=
SET TARGET=
SET EXTDIR=
SET ADT_PATH=
SET ADB_PATH=

ECHO "Finished."