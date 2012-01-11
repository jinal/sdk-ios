//
//  PHContentView.m (formerly PHAdUnitView.m)
//  playhaven-sdk-ios
//
//  Created by Jesus Fernandez on 4/1/11.
//  Copyright 2011 Playhaven. All rights reserved.
//

#import "PHContentView.h"
#import "PHContent.h"
#import "PHContentWebView.h"
#import "NSObject+QueryComponents.h"
#import "JSON.h"
#import "PHConstants.h"
#import "SDURLCache.h"
#import "PHUrlPrefetchOperation.h"

#define MAX_MARGIN 20

@interface PHContentView(Private)
+(void)clearContentViews;
+(NSMutableSet *)allContentViews;
- (void)sizeToFitOrientation:(BOOL)transform;
-(CGAffineTransform)transformForOrientation:(UIInterfaceOrientation)orientation;
-(void)orientationDidChange;
-(void)viewDidShow;
-(void)viewDidDismiss;
-(void)dismissView;
-(void)loadTemplate;
-(void)handleLaunch:(NSDictionary *)queryComponents;
-(void)handleDismiss:(NSDictionary *)queryComponents;
-(void)handleLoadContext:(NSDictionary *)queryComponents callback:(NSString*)callback;
-(UIActivityIndicatorView *)activityView;
-(void)dismissWithError:(NSError *)error;
-(void) closeView:(BOOL)animated;
-(void)prepareForReuse;
-(void)resetRedirects;
@end

static NSMutableSet *allContentViews = nil;

@implementation PHContentView

#pragma mark - Static Methods

+(void)initialize{
    if  (self == [PHContentView class]){
        [[NSNotificationCenter defaultCenter] addObserver:[PHContentView class] selector:@selector(clearContentViews) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    }
}

+(NSMutableSet *)allContentViews{
    @synchronized(allContentViews){
        if (allContentViews == nil) {
            allContentViews = [[NSMutableSet alloc] init];
        }   
    }
    return allContentViews;
}

+(void)clearContentViews{
    @synchronized(allContentViews){
        [allContentViews release], allContentViews = nil;
    }
}

+(PHContentView *)dequeueContentViewInstance{
#ifdef PH_USE_CONTENT_VIEW_RECYCLING
    PHContentView *instance = [[PHContentView allContentViews] anyObject];
    if (!!instance) {
        [instance retain];
        [[PHContentView allContentViews] removeObject:instance];
        [instance autorelease];
    }
    
    return instance;
#else
    return nil;
#endif
}

+(void)enqueueContentViewInstance:(PHContentView *)contentView{
#ifdef PH_USE_CONTENT_VIEW_RECYCLING
    [[self allContentViews] addObject:contentView];    
#endif
}

#pragma mark -
-(id) initWithContent:(PHContent *)content{
    if ((self = [super initWithFrame:[[UIScreen mainScreen] applicationFrame]])) {
        NSInvocation
        *dismissRedirect = [NSInvocation invocationWithMethodSignature:[[PHContentView class] instanceMethodSignatureForSelector:@selector(handleDismiss:)]],
        *launchRedirect = [NSInvocation invocationWithMethodSignature:[[PHContentView class] instanceMethodSignatureForSelector:@selector(handleLaunch:callback:)]],
        *loadContextRedirect = [NSInvocation invocationWithMethodSignature:[[PHContentView class] instanceMethodSignatureForSelector:@selector(handleLoadContext:callback:)]];
        
        dismissRedirect.target = self;
        dismissRedirect.selector = @selector(handleDismiss:);
        
        launchRedirect.target = self;
        launchRedirect.selector = @selector(handleLaunch:callback:);
        
        loadContextRedirect.target = self;
        loadContextRedirect.selector = @selector(handleLoadContext:callback:);
        
        _redirects = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                      dismissRedirect,@"ph://dismiss",
                      launchRedirect,@"ph://launch",
                      loadContextRedirect,@"ph://loadContext",
                      nil];
        
        _webView = [[PHContentWebView alloc] initWithFrame:CGRectZero];
        [self addSubview:_webView];
        
        self.content = content;
    }
    
    return self;
}

@synthesize content = _content;
@synthesize delegate = _delegate;
@synthesize targetView = _targetView;

-(void)resetRedirects{
#ifdef PH_USE_CONTENT_VIEW_RECYCLING
    NSEnumerator *keyEnumerator = [[_redirects allKeys] objectEnumerator];
    NSString *key;
    while (key = [keyEnumerator nextObject]){
        NSInvocation *invocation = [_redirects valueForKey:key];
        if (invocation.target != self) {
            [_redirects removeObjectForKey:key];
        }
    }
#endif
}

-(void)prepareForReuse{
    self.content = nil;
    self.delegate = nil;
    [self resetRedirects];
    [_webView stringByEvaluatingJavaScriptFromString:@"document.open();document.close();"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [PHURLLoader invalidateAllLoadersWithDelegate:self];
}

-(UIActivityIndicatorView *)activityView{
    if (_activityView == nil){
        _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activityView.hidesWhenStopped = YES;
        [_activityView startAnimating];
    }
    
    return _activityView;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [PHURLLoader invalidateAllLoadersWithDelegate:self];    
    [_content release], _content = nil;
    [_webView release], _webView = nil;
    [_redirects release], _redirects = nil;
    [_activityView release] , _activityView = nil;
    [super dealloc];
}

-(void) orientationDidChange{
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (orientation != _orientation) {
        if (CGRectIsNull([self.content frameForOrientation:orientation])) {
            [self dismissWithError:PHCreateError(PHOrientationErrorType)];
            return;
        }
        
        CGFloat duration = [UIApplication sharedApplication].statusBarOrientationAnimationDuration;
        
        if (self.content.transition == PHContentTransitionDialog) {
            CGFloat barHeight = ([[UIApplication sharedApplication] isStatusBarHidden])? 0 : 20;
            CGRect contentFrame = CGRectOffset([self.content frameForOrientation:orientation], 0, barHeight);
            _webView.frame = contentFrame;
            
        }
        
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:duration];
        [self sizeToFitOrientation:YES];
        [UIView commitAnimations];
    }
}

- (void)sizeToFitOrientation:(BOOL)transform {
    if (transform) {
        self.transform = CGAffineTransformIdentity;
    }
    
    CGRect frame = [UIScreen mainScreen].bounds;
    CGPoint center = CGPointMake(
                                 frame.origin.x + ceil(frame.size.width/2),
                                 frame.origin.y + ceil(frame.size.height/2));
    
    CGFloat scale_factor = 1.0f;
    
    CGFloat width = floor(scale_factor * frame.size.width);
    CGFloat height = floor(scale_factor * frame.size.height);
    
    _orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsLandscape(_orientation)) {
        self.frame = CGRectMake(0, 0, height, width);
    } else {
        self.frame = CGRectMake(0, 0, width, height);
    }
        
    self.center = center;
    
    if (transform) {
        self.transform = [self transformForOrientation:_orientation];
    }
}

-(CGAffineTransform)transformForOrientation:(UIInterfaceOrientation)orientation{
    if (orientation == UIInterfaceOrientationLandscapeLeft) {
        return CGAffineTransformMakeRotation(-M_PI/2);
    } else if (orientation == UIInterfaceOrientationLandscapeRight) {
        return CGAffineTransformMakeRotation(M_PI/2);
    } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
        return CGAffineTransformMakeRotation(-M_PI);
    } else {
        return CGAffineTransformIdentity;
    }
}

-(void)show:(BOOL)animated{
    
    _willAnimate = animated;
    [self.targetView addSubview: self];
    [self sizeToFitOrientation:YES];
    
    [_webView setDelegate:self];
    _webView.transform = CGAffineTransformIdentity;
    _webView.alpha = 1.0;
    
    [self loadTemplate];
    
    if (CGRectIsNull([self.content frameForOrientation:_orientation])) {
        //this is an invalid frame and we should dismiss immediately!
        [self dismissWithError:PHCreateError(PHOrientationErrorType)];
        return;
    }
    
    CGFloat barHeight = ([[UIApplication sharedApplication] isStatusBarHidden])? 0 : 20;
    
    if (self.content.transition == PHContentTransitionModal) {
        self.backgroundColor = [UIColor clearColor];
        self.opaque = NO;
        
        CGFloat width, height;
        if (UIInterfaceOrientationIsPortrait(_orientation)) {
            width = self.frame.size.width;
            height = self.frame.size.height;
        } else {
            width = self.frame.size.height;
            height = self.frame.size.width;
        }
        
        _webView.frame = CGRectMake(0, barHeight, width, height-barHeight);
        
        [self activityView].center = _webView.center;
        
        if (animated) {
            CGAffineTransform oldTransform = self.transform;
            self.transform = CGAffineTransformTranslate(oldTransform, 0, self.frame.size.height);
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
            [UIView setAnimationDuration:0.25];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDidStopSelector:@selector(viewDidShow)];
            self.transform = oldTransform;
            [UIView commitAnimations];
        } else {
            [self viewDidShow];
        }
    } else if (self.content.transition == PHContentTransitionDialog) {
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.1];
        self.opaque = NO;
        
        UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
        CGRect contentFrame = CGRectOffset([self.content frameForOrientation:orientation], 0, barHeight);
        
        _webView.frame = contentFrame;
        _webView.layer.borderColor = [[UIColor blackColor] CGColor];
        _webView.layer.borderWidth = 1.0f;
        
        if ([self.delegate respondsToSelector:@selector(borderColorForContentView:)]) {
            _webView.layer.borderColor = [[self.delegate borderColorForContentView:self] CGColor];
        }
                
        [self activityView].center = _webView.center;
        
        if (animated) {
            [_webView bounceInWithTarget:self action:@selector(viewDidShow)];
        } else {
            [self viewDidShow];
        }
    }
    
    [self addSubview:[self activityView]];
    
    //TRACK_ORIENTATION see STOP_TRACK_ORIENTATION
    [[NSNotificationCenter defaultCenter] 
     addObserver:self
     selector:@selector(orientationDidChange) 
     name:UIDeviceOrientationDidChangeNotification
     object:nil];
}

-(void)dismiss:(BOOL)animated{
    [self closeView:animated];
}

-(void)dismissFromButton{
    NSDictionary *queryComponents = [NSDictionary dictionaryWithObjectsAndKeys:
                                     self.content.closeButtonURLPath, @"ping", nil];
    [self handleDismiss:queryComponents];
}

-(void)dismissWithError:(NSError *)error{

    // This is here because get called 2x
    // first from handleLoadContext:
    // second from webView:didFailLoadWithError:
    // Only need to handle once
    if (self.delegate == nil)
        return;
    
    id oldDelegate = self.delegate;
    self.delegate = nil;
    [self closeView:_willAnimate];
    
    if ([oldDelegate respondsToSelector:(@selector(contentView:didFailWithError:))]) {
        PH_LOG(@"Error with content view: %@", [error localizedDescription]);
        [oldDelegate contentView:self didFailWithError:error];
    }
}

-(void)closeView:(BOOL)animated
{
    [_webView setDelegate:nil];
    [_webView stopLoading];
    
    _willAnimate = animated;    
    if (self.content.transition == PHContentTransitionModal) {
        if (animated) {
            CGAffineTransform oldTransform = self.transform;
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
            [UIView setAnimationDuration:0.25];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDidStopSelector:@selector(viewDidDismiss)];
            self.transform = CGAffineTransformTranslate(oldTransform, 0, self.frame.size.height);
            [UIView commitAnimations];
        } else {
            [self viewDidDismiss];
        }
    } else if (self.content.transition == PHContentTransitionDialog){
        if (_willAnimate) {
            [_webView bounceOutWithTarget:self action:@selector(viewDidDismiss)];
        } else {
            [self viewDidDismiss];
        }
    }
    
    //STOP_TRACK_ORIENTATION see TRACK_ORIENTATION
    [[NSNotificationCenter defaultCenter] 
     removeObserver:self 
     name:UIDeviceOrientationDidChangeNotification 
     object:nil];
}

-(void)loadTemplate {
    [_webView stopLoading];

    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *cacheKey = [SDURLCachePH cacheKeyForURL:self.content.URL];
    NSString *cacheFilePath = [[SDURLCachePH defaultCachePath] stringByAppendingPathComponent:cacheKey];
    if (![fileManager fileExistsAtPath:cacheFilePath]){
        PH_NOTE(@"Loading content unit template from network.");
        [_webView loadRequest:[NSURLRequest requestWithURL:self.content.URL
                                            cachePolicy:NSURLRequestUseProtocolCachePolicy
                                            timeoutInterval:PH_REQUEST_TIMEOUT]];
    }
    else{

        NSURL *url = [NSURL fileURLWithPath:cacheFilePath];
        NSData *templateData = [fileManager contentsAtPath:cacheFilePath];
        
        PH_NOTE(@"Loading content unit template from prefetch cache.");
        [_webView loadData:templateData MIMEType:@"text/html" textEncodingName:@"UTF-8" baseURL:self.content.URL];
    }
}

-(void)viewDidShow{
    if ([self.delegate respondsToSelector:(@selector(contentViewDidShow:))]) {
        [self.delegate contentViewDidShow:self];
    }
}

-(void)viewDidDismiss{
    id oldDelegate = self.delegate;
    [self prepareForReuse];
    
    if ([oldDelegate respondsToSelector:(@selector(contentViewDidDismiss:))]) {
        [oldDelegate contentViewDidDismiss:self];
    }
}

#pragma mark -
#pragma mark UIWebViewDelegate
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{  
    NSURL *url = request.URL;
    NSString *urlPath;
    if ([url host] == nil) {
        // This can be nil if loading files from the local cache. The url host being nil caused the urlPath
        // not to be generated properly and the UIWebview load to fail.
        return YES;
    }
    else
        urlPath = [NSString stringWithFormat:@"%@://%@%@", [url scheme], [url host], [url path]];
    
    NSInvocation *redirect = [_redirects valueForKey:urlPath];

    if (redirect) {
        NSDictionary *queryComponents = [url queryComponents];
        NSString *callback = [queryComponents valueForKey:@"callback"];
        
        NSString *contextString = [queryComponents valueForKey:@"context"];
        
        SBJsonParserPH *parser = [SBJsonParserPH new];
        id parserObject = [parser objectWithString:contextString];
        NSDictionary *context = ([parserObject isKindOfClass:[NSDictionary class]])?(NSDictionary*) parserObject: [NSDictionary dictionary];
        
        [parser release];
        
        PH_LOG(@"Redirecting request with callback: %@ to dispatch %@", callback, urlPath);
        switch ([[redirect methodSignature] numberOfArguments]) {
            case 5:
                [redirect setArgument:&self atIndex:4]; 
            case 4:
                if(!!callback) [redirect setArgument:&callback atIndex:3]; 
            case 3:
                if(!!context) [redirect setArgument:&context atIndex:2]; 
            default:
                break;
        }
        
        //NOTE: It's important to keep the invocation object around while we're invoking. This will prevent occasional EXC_BAD_ACCESS errors.
        [redirect retain];
        [redirect invoke];
        [redirect release];
        
        return NO;
    }
    
    return ![[url scheme] isEqualToString:@"ph"];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [self dismissWithError:error];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    //This is a fix that primarily affects iOS versions older than 4.1, it should prevent http requests
    //from leaking memory from the webview. Newer iOS versions are unaffected by the bug or the fix.
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
    
    [[self activityView] stopAnimating]; 
    
    if ([self.delegate respondsToSelector:(@selector(contentViewDidLoad:))]) {
        [self.delegate contentViewDidLoad:self];
    }
}

#pragma mark -
#pragma mark Redirects
-(void)redirectRequest:(NSString *)urlPath toTarget:(id)target action:(SEL)action{
    if (!!target) {
        NSInvocation *redirect = [NSInvocation invocationWithMethodSignature:[[target class] instanceMethodSignatureForSelector:action]];
        redirect.target = target;
        redirect.selector = action;
        
        [_redirects setValue:redirect forKey:urlPath];
    } else {
        [_redirects setValue:nil forKey:urlPath];
    }
}

-(void)handleLaunch:(NSDictionary *)queryComponents callback:(NSString *)callback{
    NSString *urlPath = [queryComponents valueForKey:@"url"];
    if (!!urlPath && [urlPath isKindOfClass:[NSString class]]) {
        PHURLLoader *loader = [[PHURLLoader alloc] init];
        loader.targetURL = [NSURL URLWithString:urlPath];
        loader.delegate = self;
        loader.context = [NSDictionary dictionaryWithObject:callback forKey:@"callback"];
        [loader open];
        [loader release];
    }
}

-(void)handleDismiss:(NSDictionary *)queryComponents{
    NSString *pingPath = [queryComponents valueForKey:@"ping"];
    if (!!pingPath && [pingPath isKindOfClass:[NSString class]]) {
        PHURLLoader *loader = [[PHURLLoader alloc] init];
        loader.opensFinalURLOnDevice = NO;
        loader.targetURL = [NSURL URLWithString:pingPath];
        [loader open];
        [loader release];
    }
    
    [self dismiss:_willAnimate];
}

-(void)handleLoadContext:(NSDictionary *)queryComponents callback:(NSString*)callback{
    NSString *loadCommand = [NSString stringWithFormat:@"window.PlayHavenDispatchProtocolVersion = %d", PH_DISPATCH_PROTOCOL_VERSION];
    [_webView stringByEvaluatingJavaScriptFromString:loadCommand];
    
    if(![self sendCallback:callback withResponse:self.content.context error:nil]){
        [self dismissWithError:PHCreateError(PHLoadContextErrorType)];
    };
}

#pragma mark - callbacks
-(BOOL)sendCallback:(NSString *)callback withResponse:(id)response error:(id)error{
    NSString *_callback = @"null", *_response = @"null", *_error = @"null";
    if (!!callback) _callback = callback;
    
    SBJsonWriterPH *jsonWriter = [SBJsonWriterPH new];
    if (!!response) {
        _response = [jsonWriter stringWithObject:response];
    }
    if (!!error) {
        _error = [jsonWriter stringWithObject:error];
    }
    [jsonWriter release];
    
    NSString *callbackCommand = [NSString stringWithFormat:@"var PlayHavenAPICallback = (window[\"PlayHavenAPICallback\"])? PlayHavenAPICallback : function(c,r,e){try{PlayHaven.nativeAPI.callback(c,r,e);return \"OK\";}catch(err){ return JSON.stringify(err);}}; PlayHavenAPICallback(\"%@\",%@,%@)", _callback, _response, _error];
    NSString *callbackResponse = [_webView stringByEvaluatingJavaScriptFromString:callbackCommand];
    
    if ([callbackResponse isEqualToString:@"OK"]) {
        return YES;
    } else {
        PH_LOG(@"content template callback failed. If this is a recurring issue, please include this console message along with the following information in your support request: %@", callbackResponse);
        return NO;
    }
}

#pragma mark -
#pragma mark PHURLLoaderDelegate
-(void)loaderFinished:(PHURLLoader *)loader{
    NSDictionary *contextData = (NSDictionary *)loader.context;
    NSDictionary *responseDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [loader.targetURL absoluteString], @"url",
                                  nil];
    [self sendCallback:[contextData valueForKey:@"callback"]
          withResponse:responseDict 
                 error:nil];
}

-(void)loaderFailed:(PHURLLoader *)loader{
    NSDictionary *contextData = (NSDictionary *)loader.context;
    NSDictionary *responseDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [loader.targetURL absoluteString], @"url",
                                  nil];
    NSDictionary *errorDict = [NSDictionary dictionaryWithObject:@"1" forKey:@"error"];
    [self sendCallback:[contextData valueForKey:@"callback"]
          withResponse:responseDict 
                 error:errorDict];
}
@end
