


This extension was built by distriqt // 

# Camera Roll Extended

The CameraRollExtended extension provides a dialog where the user can select multiple assets from the device. Additionally you can use this extension to load the selected images from the device and use the loaded BitmapData objects in your application.

It extends the functionality of the AIR built in CameraRoll.

You can also customise the appearance of the extension by changing the overlay for a selected image.



Features

- Allows selection of multiple assets
- Loading the thumbnail or full resolution versions of images
- Auto loading the images after user selection
- Sample project code and ASDocs reference


## Documentation

Online version of the latest ASDocs:

http://docs.airnativeextensions.com/camerarollextended/docs/

```actionscript
var options:CameraRollExtendedBrowseOptions = new CameraRollExtendedBrowseOptions();
options.autoCloseOnCountReached = true;
options.autoLoadBitmapData = true;
options.autoLoadType = AssetRepresentation.THUMBNAIL;

CameraRollExtended.service.browseForImage( options );
```


## License

You can purchase a license for using this extension:

http://distriqt.com/product/camera-roll-extended

distriqt retains all copyright.


### Changelog

###### 2014.10.29
iOS Update for iOS 8
- iOS: Added new iOS8 process for loading images from Photo Stream (fixes #254, fixes #247) 

