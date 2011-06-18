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
