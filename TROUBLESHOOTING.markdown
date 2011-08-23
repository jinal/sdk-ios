PlayHaven SDK Troubleshooting Guide
===================================

This guide is designed to help you troubleshoot common issues encountered while implementing the PlayHaven SDK in your game.

If your issue isn't covered here please get in touch with PlayHaven through our support page.

"403"
- Are you using the correct publisher token and secret?


- Are you updating from a legacy SDK?
If you have used our legacy More Games SDK, you should be aware that the publisher token and secret has changed from values you are used to using. If your publisher token has a colon (":") character in it, you will need to get a new token and secret from the PlayHaven Developer Dashboard.

"Close Button is invisible"
- Did you include PlayHaven.bundle?
The SDK looks for the default close button graphics in PlayHaven.bundle, which should be included in your XCode project and build targets.

- Are you returning an image in your customization delegate?



"JSON Exception"
- Did you include SBJSON?

