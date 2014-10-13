         __       __               __ 
    ____/ /_ ____/ /______ _ ___  / /_
   / __  / / ___/ __/ ___/ / __ `/ __/
  / /_/ / (__  ) / / /  / / /_/ / / 
  \__,_/_/____/_/ /_/  /_/\__, /_/ 
                            / / 
                            \/ 
  http://distriqt.com


This extension was built by distriqt // 


# Dialog

Dialog is an AIR Native Extension to display native dialogs. 

This extension allows developers to show native alert dialogs and messages on Android and iOS.

Features

- Display Alert dialogs
- Display multiple choice option dialogs
- Manage multiple dialogs and process user responses individually
- Android only: Show a progress dialog (either a spinner or a horizontal progress)
- Customise all button labels, dialog titles and messages
- Single API interface - your code works across iOS and Android with no modifications
- Sample project code and ASDocs reference


# Documentation

Online version of the latest ASDocs:

http://docs.airnativeextensions.com/dialog/docs/

```actionscript
Dialog.service.showAlert( "Alert using distriqt Dialog ANE" );
```


## License

### Changelog

2014.10.13
- #iOS Update for iOS 8
- #iOS Fixed compilation error 'ld: 21 duplicate symbols for architecture armv7' (resolves #119)
- #iOS Updated toast and progress dialog to latest versions
- #iOS Added cancelOnTouchOutside functionality to iPhone devices (resolves #88 & #208)

