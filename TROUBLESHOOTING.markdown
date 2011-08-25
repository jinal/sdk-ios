PlayHaven SDK Troubleshooting Guide
===================================

This guide is designed to help you troubleshoot common issues encountered while implementing the PlayHaven SDK in your game. If your issue isn't covered here please get in touch with PlayHaven through our support page. https://dashboard.playhaven.com/#/support/

Requests
--------
### "I get 403 errors when making requests to the API"
- Are you using the correct publisher token and secret?

The most common cause of any 403 status in the new SDK is an incorrect token or secret. You can see the token and secret values for your game on the PlayHaven Developer Dashboard.

- Are you updating from a legacy SDK?

If your publisher token has a colon (":") character in it, you will need to get a new token and secret from the PlayHaven Developer Dashboard. These older tokens are not compatible with new API features.

Content Units
-------------
### "If I don't set up any content units on a placement I'm requesting, the request error delegate( _-request:didFailWithError:_ ) is called."

The SDK calls the request error delegate on any content request that doesn't produce a valid content unit. Your app will need to accomodate this behavior if you are planning on having placements that will only sometimes have content units assigned to them.

### "When I'm showing a content unit, the close button seems to be invisible."
- Did you include PlayHaven.bundle?

The SDK looks for the default close button graphics in PlayHaven.bundle, which should be included in your XCode project. If PlayHaven.bundle is in your project, make sure it has been added to the "Copy Resource Files" stage in your active build target.