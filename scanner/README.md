

This extension was built by distriqt // 

# Scanner

The Scanner extension allows you to create an interface using the camera to scan for codes such as QR Codes, bar codes and other such encoded information. It supports many popular symbologies (types of bar codes) including EAN-13/UPC-A, UPC-E, EAN-8, Code 128, Code 39, Interleaved 2 of 5 and QR Code. However the particular support will be determined by the underlying algorithm in use.

The extension currently supports the following algorithms for code detection:

ZBar: http://zbar.sourceforge.net/


Features

- Provides the ability to create a bar code scanning interface
- Ability to set a custom target image
- Uses the built in default camera for scanning
- Works across iOS and Android with the same code
- Sample project code and ASDocs reference


## Documentation

Online version of the latest ASDocs:

http://docs.airnativeextensions.com/scanner/docs/

```actionscript
```

## License

You can purchase a license for using this extension:

http://distriqt.com/product/scanner

distriqt retains all copyright.


### Changelog

###### 2014.10.19
Update for iOS 8 and Android Additions
- iOS: iOS 8 updates
- iOS: Added overlay in ScannerOptions to use as a custom target area (resolves #154)
- Updated singleResult documentation (resolves #231)
- Android: Added auto-orientation code
- Android: Added overlay in ScannerOptions to use as a custom target area