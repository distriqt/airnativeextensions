


This extension was built by distriqt // 

# Push Notifications

This extension enables the use of Push Notifications on your device using Apple Push Notification Service (APNS) on iOS and the Google Cloud Messaging (GCM) service on Android. The simple extension API will have you quickly up and running with remote notifications.

Features

- Apple Push Notification Service support for iOS devices
- Google Cloud Messaging service support for Android devices
- Register for and receive notifications from remote services with only a few lines of code
- Receive notifications on application start if the user started from a notification
- Single simple API interface - your code works across iOS and Android with no modifications
- Sample project code and ASDocs reference

## Documentation

If you have any additional questions you can check out the FAQs here: http://distriqt.uservoice.com/knowledgebase/articles/254098-push-notifications

Additionally we have a series of tutorials:

- Part 1: Covers setting up certificates and services here: http://distriqt.uservoice.com/knowledgebase/articles/252914-push-notifications-tutorial-part-1
- Part 2: Covers including and using the extension here: http://distriqt.uservoice.com/knowledgebase/articles/252915-push-notifications-tutorial-part-2


Online version of the latest ASDocs:

http://docs.airnativeextensions.com/pushnotifications/docs/

```actionscript
PushNotifications.service.addEventListener( PushNotificationEvent.NOTIFICATION, notificationHandler );
PushNotifications.service.register( GCM_SENDER_ID );

...

private function notificationHandler( event:PushNotificationEvent ):void
{
	try
	{
		JSON.parse( event.data );
	}
	catch (e:Error)
	{
	}
}				
```


## License

You can purchase a license for using this extension:

http://distriqt.com/product/push-notifications

distriqt retains all copyright.

