PlayHaven SDK 1.6.1
====================
PlayHaven is a real-time mobile game marketing platform to help you take control of the business of your games.

Acquire, retain, re-engage, and monetize your players with the help of PlayHaven's powerful marketing platform. Integrate once and embrace the flexibility of the web as you build, schedule, deploy, and analyze your in-game promotions and monetization in real-time through PlayHaven's easy-to-use, web-based dashboard. 

An API token and secret is required to use this SDK. These tokens uniquely identify your app to PlayHaven and prevent others from making requests to the API on your behalf. To get a token and secret, please visit the PlayHaven developer dashboard at https://dashboard.playhaven.com

What's new in 1.6.1
===================
* Fixes crash bug that occasionally appears after multiple content unit dismisses.

1.6.0
=====
* After a successful open call, the SDK will pre-cache content template data in the background. Be sure to add the source in the Cache directory to your project.
* CFNetwork.framework is now required.
* Fixes memory leaks in reachability code.

1.3.14
======
* Content units will no longer crash the app during a dismiss.
* PlayHaven.bundle is no longer required, PlayHaven now includes all image assets into the SDK
* New dismiss delegate for content unit requests that indicates the reason the view was dismissed. The old dismiss delegate will continue to work but has been deprecated.
* PHPublisherContentRequests may be preloaded. See "Preloading requests" in the API Reference section for more details
* *WARNING:* if you have been creating API request class instances directly using -(id)initWithApp... methods, you must now use the static +(id)requestForApp... methods instead. Content request instances created using -(id)initWithApp... may not work as expected for preloading requests.

1.3.10
======
* Adds the ability to cancel active content requests, or cancel all active content requests for a given delegate. See "Cancelling requests" in the API Reference section for more details

Integration
-----------
If you are using Unity for your game, please integrate the Unity SDK located here: https://github.com/playhaven/sdk-unity/

1. Add the following from the sdk-ios directory that you downloaded or cloned from github to your project:
  * src directory 
  * JSON directory
  * Cache directory
1. Ensure the following frameworks are included with your project, add any missing frameworks in the Build Phases tab for your application's target:
  * UIKit.framework
  * Foundation.framework
  * CoreGraphics.framework
  * QuartzCore.framework
  * SystemConfiguration.framework
  * CFNetwork.framework
1. Include the PlayHavenSDK headers in your code wherever you will be using PlayHaven request classes.

    \#import "PlayHavenSDK.h"

Example App
-----------
Included with the SDK is an example implementation in its own XCode project. It features open and content request implementations including relevant delegate methods for each. You will need a PlayHaven API token and secret to make requests with the Example app.

Adding a Cross-Promotion Widget to Your Game
--------------------------------------------
Each game is pre-configured for our Cross-Promotion Widget, which will give your game the ability to deliver quality game recommendations to your users. To integrate the Cross-Promotion Widget, you'll need to do the following:

### Record game opens
In order to better optimize your content units, it is necessary for your app to report each time your application comes to the foreground. PlayHaven uses these events to measure the click-through rate of your Cross-Promotion Widget to help optimize the performance of your implementation. This request is asynchronous and may run in the background while your game is loading.

The best place to run this code in your app is in the implementation of the UIApplicationDelegate's -(void)applicationDidBecomeActive:(UIApplication *)application method. This will record a game open each time the app is launched. The following line will send a request:

	[[PHPublisherOpenRequest requestForApp:MYTOKEN secret:MYSECRET] send];

Where MYTOKEN and MYSECRET are the token and secret for your game. That's it!
See "Recording game opens" in the API Reference section for more information about recording game opens.

### Request the Cross-Promotion Widget
We recommend adding the Cross-Promotion Widget to an attractive "More Games" button in a prominent part of your game's UI. The most popular place to add this button is in the main menu, but we have seen great results from buttons on game over or level complete screens as well. Be creative and find places in your game where it is natural for users to want to jump to a new game.

Inside your button's event handler, use the following code to request the pre-configured Cross-Promotion Widget:

	PHPublisherContentRequest *request = [PHPublisherContentRequest requestForApp:MYTOKEN secret:MYSECRET placement:@"more_games" delegate:self];
	request.showsOverlayImmediately = YES;
	[request send];
	
*NOTE:* The Cross-Promotion Widget only supports the "more_games" placement tag.  Please ensure that this tag is used for any location you wish to integrate the Cross-Promotion Widget.  Support for custom placements is coming soon!

You will need to implement PHPublisherContentRequestDelegate methods if you would like to know when the Cross-Promotion Widget has loaded or dismissed. See "Requesting content for your placements" in the API Reference section for more information about these delegate methods as well as other things you can do with PHPublisherContentRequest.

### Add a Notification View (Notifier Badge)
Adding a notification view to your "More Games" button will greatly increase the number of Cross-Promotion Widget opens for your game, by up to 300%. To create a notification view:

    PHNotificationView *notificationView = [[PHNotificationView alloc] initWithApp:MYTOKEN secret:MYSECRET placement:@"more_games"];
    [myView addSubview:notificationView];
    [notificationView release];
    
Add the notification view as a subview somewhere in your view controller's view. Adjust the position of the badge by setting the notificationView's center property. 

    notificationView.center = CGPointMake(10,10);

The notification view will query and update itself when its -(void)refresh method is called.

    [notificationView refresh];

See "Notifications with PHNotificationView" in the API Reference section for more information about customizing the presentation of your PHNotificationView instances.

API Reference
-------------
### Recording game opens
Asynchronously reports a game open to PlayHaven. A delegate is not needed for this request, but if you would like to receive a callback when this request succeeds or fails refer to the implementation found in *example/PublisherOpenViewController.m*.

	[[PHPublisherOpenRequest requestForApp:(NSString *)token secret:(NSString *)secret] send]

### Requesting content for your placements
You may request content for your app using your API token, secret, as well as a placement tag to identify the placement you are requesting content for. Implement PHPublisherContentRequestDelegate methods to receive callbacks from this request. Refer to the section below as well as *example/PublisherContentViewController.m* for a sample implementation.

	PHPublisherContentRequest *request = [PHPublisherContentRequest requestForApp:(NSString *)token secret:(NSString *)secret placement:(NSString *)placement delegate:(id)delegate];
	request.showsOverlayImmediately = YES; //optional, see below.
	[request send];

*NOTE:* You may set placement_ids through the PlayHaven Developer Dashboard.

Optionally, you may choose to show the loading overlay immediately by setting the request object's *showsOverlayImmediately* property to YES. This is useful if you would like keep users from interacting with your UI while the content is loading.

#### *NEW* Preloading requests (optional)
To make content requests more responsive, you may choose to preload a content unit for a given placement. This will start a request for a content unit without displaying it, preserving the content unit until you call -(void)send on a  content request for the same placement in your app.

    [[PHPublisherContentRequest requestForApp:(NSString *)token secret:(NSString *)secret placement:(NSString *)placement delegate:(id)delegate] preload];

You may set a delegate for your preload if you would like to be informed when a content request is ready to display. See the sections below for more details.

*NOTE:* Preloading only affects the next content request for a given placement. If you are showing the same placement multiple times in your app, you will need to make additional preload requests after displaying that placement's content unit for the first time.

#### Starting a content request
The request is about to attempt to get content from the PlayHaven API. 

	-(void)requestWillGetContent:(PHPublisherContentRequest *)request;

#### Receiving content
The request received some valid content from the PlayHaven API. This will be the last delegate method a preloading request will receive, unless there is an error.

	-(void)requestDidGetContent:(PHPublisherContentRequest *)request;


#### Preparing to show a content view
If there is content for this placement, it will be loaded at this point. An overlay view will appear over your app and a spinner will indicate that the content is loading. Depending on the transition type for your content your view may or may not be visible at this time. If you haven't before, you should mute any sounds and pause any animations in your app. 

	-(void)request:(PHPublisherContentRequest *)request contentWillDisplay:(PHContent *)content;

#### Content view finished loading
The content has been successfully loaded and the user is now interacting with the downloaded content view. 

	-(void)request:(PHPublisherContentRequest *)request contentDidDisplay:(PHContent *)content;

#### *NEW* Content view dismissing
The content has successfully dismissed and control is being returned to your app. This can happen as a result of the user clicking on the close button or clicking on a link that will open outside of the app. You may restore sounds and animations at this point.

	-(void)request:(PHPublisherContentRequest *)request contentDidDismissWithType:(PHPublisherContentDismissType *)type;

Type may be one of the following constants:

1. PHPublisherContentUnitTriggeredDismiss: a user or a content unit dismissed the content request
1. PHPublisherNativeCloseButtonTriggeredDismiss: the user used the native close button to dismiss the view
1. PHPublisherApplicationBackgroundTriggeredDismiss: iOS 4.0+ only, the content unit was dismissed because the app was sent to the background
1. PHPublisherNoContentTriggeredDismiss: the content unit was dismissed because there was no content assigned to this placement id

#### Content request failing
If for any reason the content request does not successfully return some content to display or fails to load after the overlay view has appears, the request will stop any any visible overlays will be removed.

	-(void)request:(PHPublisherContentRequest *)request didFailWithError:(NSError *)error;

NOTE: -(void)request:contentDidFailWithError: is now deprecared in favor of request:didFailWithError: please update implementations accordingly.

### *NEW* Cancelling requests
You may now cancel any API request at any time using the -(void)cancel method. This will also cancel any open network connections and clean up any views in the case of content requests. Canceled requests will not send any more messages to their delegates.

Additionally you may cancel all open API requests for a given delegate. This can be useful if you are not keeping references to API request instances you may have created. As with the -(void)cancel method, canceled requests will not send any more messages to delegates. To cancel all requests:

    [PHAPIRequest cancelAllRequestsWithDelegate:(id)delegate];

### Customizing content display
#### Replace close button graphics
Use the following request method to replace the close button image with something that more closely matches your app. Images will be scaled to a maximum size of 40x40.

	-(UIImage *)request:(PHPublisherContentRequest *)request closeButtonImageForControlState:(UIControlState)state content:(PHContent *)content;

### Unlocking rewards with the SDK
PlayHaven allows you to reward users with virtual currency, in-game items, or any other content within your game. If you have configured unlockable rewards for your content units, you will receive unlock events through a delegate method. It is important to handle these unlock events in every placement that has rewards configured.

> \-(void)request:(PHPublisherContentRequest *)request unlockedReward:(PHReward *)reward;

The PHReward object passed through this method has the following helpful properties:

  * __name__: the name of your reward as configured on the dashboard
  * __quantity__: if there is a quantity associated with the reward, it will be an integer value here
  * __receipt__: a unique identifier that is used to detect duplicate reward unlocks, your app should ensure that each receipt is only unlocked once

### Notifications with PHNotificationView
PHNotificationView provides a fully encapsulated notification view that automatically fetches an appropriate notification from the API and renders it into your view heirarchy. It is a UIView subclass that you may place in your UI where it should appear and supply it with your app token, secret, and a placement id.

	-(id)initWithApp:(NSString *)app secret:(NSString *)secret placement:(NSString *)placement;

*NOTE:* You may set up placement_ids through the PlayHaven Developer Dashboard.

Notification view will remain anchored to the center of the position they are placed in the view, even as the size of the badge changes. You may refresh your notification view from the network using the -(void)refresh method on an instance. We recommend refreshing the notification view each time it will appear in your UI. See examples/PublisherContentViewController.m for an example.

You will also need to clear any notification view instances when you successfully launch a content unit. You may do this using the -(void)clear method on any notification views you wish to clear.

#### Testing PHNotificationView
Most of the time the API will return an empty response, which means a notification view will not be shown. You can see a sample notification by using -(void)test; wherever you would use -(void)refresh. It has been marked as deprecated to remind you to switch all instances of -(void)test in your code to -(void)refresh;

#### Customizing notification rendering with PHNotificationRenderer
PHNotificationRenderer is a base class that draws a notification view for a given notification data. The base class implements a blank notification view used for unknown notification types. PHNotificationBadgeRenderer renders a iOS default-style notification badge with a given "value" string. You may customize existing notification renderers and register new ones at runtime using the following method on PHNotificationView

	+(void)setRendererClass:(Class)class forType:(NSString *)type;

Your PHNotificationRenderer subclass needs to implement the following methods to draw and size your notification view appropriately:

	-(void)drawNotification:(NSDictionary *)notificationData inRect:(CGRect)rect;

This method will be called inside of the PHNotificationView instance -(void)drawRect: method whenever the view needs to be drawn. You will use specific keys inside of notificationData to draw your badge in the view. If you need access to the graphics context you may use the UIGraphicsGetCurrentContext() function.

	-(CGSize)sizeForNotification:(NSDictionary *)notificationData;

This method will be called to calculate an appropriate frame for the notification badge each time the notification data changes. Using specific keys inside of notificationData, you will need to calculate an appropriate size.

#### *NEW* Caching with prefetching of URLs in background

To use caching and prefetching of URL's a publisher only needs to make a PHPublisherOpenRequest. The Play Haven SDK is currently set up to managed the cache and prefetch the URL's automatically in the background. The publisher has more control over the caching defaults using the information provided below.

PHPublisherOpenRequest now returns an array of URL's that can be prefetched. When the response is received from the server the prefetch URL's are stored locally in a plist file and a queue of NSOperation's are created to downoad the data in concurrent background tasks. The PHConstants.h define PH_MAX_CONCURRENT_OPERATIONS is used for setting the max concurrent operations and PH_PREFETCH_URL_PLIST is the name of the plist file for storing the prefetch URL list in the cache applications directory. The Publisher can use the following methods to force a redownload of the prefetch URL list if a plist file exists, cancel any operations currently being run and clear the prefetch cache files.

    -(void) downloadPrefetchURLs;
    -(void) cancelPrefetchDownload;
    -(void) clearPrefetchCache;

When the PHPublisherOpenRequest is initialized it will create a subclass of NSURLCache called SDURLCache. This is used for caching the UIWebview data to memory and/or the file system. The setting for the size (in bytes) of the memory cache and file system cache can be found in PHConstants.h - PH_MAX_SIZE_MEMORY_CACHE and PH_MAX_SIZE_FILESYSTEM_CACHE. The current defaults are 1MB for the memory cache and 10MB for the file system cache. The class SDURLCache has methods for clearing the cache if you need more file system space in the applications cache directory. SDURLCache has several background tasks that manages the cache size. The cache data files are stored in the application cache directory.
