


This extension was built by distriqt // 

# Calendar

This extension provides functionality to add events to the user's default Calendar.

Features

- Provides access to add events to the user's iOS Calendar.
- Provides ability to retrieve calendars on Android in addition to events
- Schedule alerts to events
- Sample project code and ASDocs reference

## Documentation

Online version of the latest ASDocs:

http://docs.airnativeextensions.com/calendar/docs/

```actionscript
var e:EventObject = new EventObject();
e.title = "Test title now";
e.startDate = new Date() ;
e.endDate = new Date();
e.startDate.minutes = e.startDate.minutes + 6;
e.endDate.hours = e.endDate.hours+1;

Calendar.service.addEventWithUI( e );
```


## License

You can purchase a license for using this extension:

http://distriqt.com/product/calendar

distriqt retains all copyright.

