PlayHaven SDK
==============

The PlayHaven Content SDK allows you to add dynamic content to your app. It is a flexible framework capable of delivering integrated experiences; including ads, special offers, announcements and other kinds of content which can be dynamically assigned to placements within your application.

An API token and secret pair is required to use this SDK. These tokens identify your app to PlayHaven, {something something you are responsible for keeping them safe}. To obtain these credentials for your application please visit http://playhaven.com

Integration
-----------

1. In Xcode, open the PlayHaven SDK project at playhaven-sdk-ios.xcodeproj.
1. Drag and drop the "PlayHaven SDK" folder from the PlayHaven SDK project into your application's project. This will copy all necessary source, libraries, and images to your project.
1. Include the PlayHavenSDK headers in your code wherever you will be using PlayHaven request classes.

> \#import "PlayHavenSDK.h"

API Reference
-------------

### Recording game opens

In order to better optimize your campaigns, it is necessary for your app to report all game opens. This will allow us to calculate impression rates based on all game opens.

> [PHPublisherOpenRequest requestForApp:(NSString *)token secret:(NSString *)secret]

### Requesting content for your placements

You may request content for your app using your API token, secret, as well as a placement_id to identify the placement you are requesting content for. Implement PHPublisherContentRequestDelegate methods to recieve callbacks from this request. (see sections below)

> [PHPublisherContentRequest requestForApp:(NSString *)token secret:(NSString *)secret placement:(NSString *)placement delegate:(id)delegate]

#### Starting a content request

The request is about to attempt to get content from the PlayHaven API. 

> \-(void)requestWillGetContent:(PHPublisherContentRequest *)request;

#### Preparing to show a content view

If there is content for this placement, it will be loaded at this point. An overlay view will appear over your app and a spinner will indicate that the content is loading. Depending on the transition type for your content your view may or may not be visible at this time. If you haven't before, you should mute any sounds and pause any animations in your app. 

> \-(void)request:(PHPublisherContentRequest *)request contentWillDisplay:(PHContent *)content;

#### Content view finished loading

The content has been successfully loaded and the user is now interacting with the downloaded content view. 

> \-(void)request:(PHPublisherContentRequest *)request contentDidDisplay:(PHContent *)content;

#### Content view dismissing

The content has successfully dismissed and control is being returned to your app. This can happen as a result of the user clicking on the close button or clicking on a link that will open outside of the app. You may restore sounds and animations at this point.

> \-(void)requestContentDidDismiss:(PHPublisherContentRequest *)request;

#### Content request failing

If for any reason the content request does not successfully return some content to display, the request will stop. At this point, no visible changes have occurred in your app.

> \-(void)request:(PHPublisherContentRequest *)request didFailWithError:(NSError *)error;

#### Content view failing to load

If for any reason a content unit fails to load after the overlay view has appeared, the request will stop and the overlay view will be removed. You may restore sounds and animations at this point.

> \-(void)request:(PHPublisherContentRequest *)request contentDidFailWithError:(NSError *)error;

### Customizing content display

#### Replace close button graphics

Use the following request method to replace the close button image with something that more closely matches your app. Images will be scaled to a maximum size of 40x40.

> \-(UIImage *)request:(PHPublisherContentRequest *)request closeButtonImageForControlState:(UIControlState)state content:(PHContent *)content;

### Notifications with PHNotificationView

PHNotificationView provides a fully encapsulated notification view that automatically fetches an appropriate notification from the API and renders it into your view heirarchy. It is a UIView subclass that you may place in your UI where it should appear and supply it with your app token, secret, and a placement id.

> \-(id)initWithApp:(NSString *)app secret:(NSString *)secret placement:(NSString *)placement;

Notification view will remain anchored to the center of the position they are placed in the view, even as the size of the badge changes. You may refresh your notification view from the network using the -(void)refresh method on an instance. We recommend refreshing the notification view each time it will appear in your UI. See examples/PublisherContentViewController.m for an example.

You will also need to clear any notification view instances when you successfully launch a content unit. You may do this using the -(void)clear method on any notification views you wish to clear.

### Testing PHNotificationView

Most of the time, the API will return an empty response, which means a notification view will not be shown. TYou can see a sample notification by using -(void)test; wherever you would use -(void)refresh. It has been marked as deprecated to remind you to switch all instances of -(void)test in your code to -(void)refresh;

### Customizing notification rendering with PHNotificationRenderer

PHNotificationRenderer is a base class that draws a notification view for a given notification data. The base class implements a blank notification view used for unknown notification types. PHNotificationBadgeRenderer renders a iOS default-style notification badge with a given "value" string. You may customize existing notification renderers and register new ones at runtime using the following method on PHNotificationView

> \+(void)setRendererClass:(Class)class forType:(NSString *)type;

Your PHNotificationRenderer subclass needs to implement the following methods to draw and size your notification view appropriately:

> \-(void)drawNotification:(NSDictionary *)notificationData inRect:(CGRect)rect;

This method will be called inside of the PHNotificationView instance -(void)drawRect: method whenever the view needs to be drawn. You will use specific keys inside of notificationData to draw your badge in the view. If you need access to the graphics context you may use the UIGraphicsGetCurrentContext() function.

> \-(CGSize)sizeForNotification:(NSDictionary *)notificationData;

This method will be called to calculate an appropriate frame for the notification badge each time the notification data changes. Using specific keys inside of notificationData, you will need to calculate an appropriate size.

