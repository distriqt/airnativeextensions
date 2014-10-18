


This extension was built by distriqt // 

# Notifications

Notifications is an AIR Native Extension to display local notifications. 

This extension enables local notification messages to be displayed on a device. These notifications appear in the global notifications panel for iOS and Android.

Features

- Local notification support for iOS devices
- Local notification support for Android devices
- Display local notifications with only a few lines of code
- Single API interface - your code works across iOS and Android with no modifications
- Sample project code and ASDocs reference


## Documentation

Online version of the latest ASDocs:

http://docs.airnativeextensions.com/notifications/docs/

```actionscript
var notification:Notification = new Notification();
notification.id = _notificationId;
notification.tickerText = "Hello "+notification.id;
notification.title = "My Notification "+notification.id;
notification.body = "Hello World!";

Notifications.service.notify( notification.id, notification );
```


## License

You can purchase a license for using this extension:

http://distriqt.com/product/notifications

distriqt retains all copyright.


### Changelog

###### 2014.10.18
iOS Update for iOS 8
- iOS: Fixed iOS 8 registering for notification permission (resolves #219)
- iOS: Added function to check if user has allowed notifications
- iOS: Fixed vibrate on notification selection (resolves #209, closes #177)
- Android: cancelAll was previously implemented (closes #71)

