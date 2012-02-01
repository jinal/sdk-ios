//
//  PHNotificationView.m
//  playhaven-sdk-ios
//
//  Created by Jesus Fernandez on 6/22/11.
//  Copyright 2011 Playhaven. All rights reserved.
//

#import "PHNotificationView.h"
#import "PHPublisherMetadataRequest.h"
#import "PHNotificationRenderer.h"
#import "PHNotificationBadgeRenderer.h"

static NSMutableDictionary *RendererMap;

@implementation PHNotificationView

+(void)initialize{
    if (self == [PHNotificationView class]) {
        RendererMap = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                       [PHNotificationBadgeRenderer class], @"badge",
                       nil];
    }
}

+(void)setRendererClass:(Class)rendererClass forType:(NSString *)type{
    if ([rendererClass isSubclassOfClass:[PHNotificationRenderer class]]) {
        [RendererMap setValue:rendererClass forKey:type];
    }
}

+(PHNotificationRenderer *)newRendererForData:(NSDictionary *)notificationData{
    NSString *type = [notificationData valueForKey:@"type"];
    Class RendererClass = nil;
    if (!!type) RendererClass = (Class)[RendererMap valueForKey:type];
    if (RendererClass == nil) {
        RendererClass = [PHNotificationRenderer class];
    }
    return [[RendererClass alloc] init];
}

-(id)initWithApp:(NSString *)app secret:(NSString *)secret placement:(NSString *)placement{
    if ((self = [self initWithFrame:CGRectZero])) {
        _app = [app copy];
        _secret = [secret copy];
        _placement = [placement copy];
        
        [self addObserver:self forKeyPath:@"notificationData" options:NSKeyValueObservingOptionNew context:nil];
    }
    
    return self;
}

-(id)initWithFrame:(CGRect)frame{
    if ((self = [super initWithFrame:frame])) {
        self.backgroundColor = [UIColor clearColor];
        self.opaque = NO;
        
        self.clipsToBounds = NO;
    }
    
    return  self;
}

@synthesize notificationData = _notificationData;

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if (self == object && [keyPath isEqualToString:@"notificationData"]) {
        NSDictionary *newNotificationData = self.notificationData;
        
        //create new Renderer
        [_notificationRenderer release], _notificationRenderer = [PHNotificationView newRendererForData:newNotificationData];
        
        //adjust size while preserving center;
        CGPoint oldCenter = self.center;
        CGSize newSize = [_notificationRenderer sizeForNotification:newNotificationData];
        self.frame = CGRectMake(0, 0, newSize.width, newSize.height);
        self.center = oldCenter;
        
        //prepare to redraw;
        [self setNeedsDisplay];
    }
}

-(void)dealloc{
    [_request setDelegate:nil];
    [self removeObserver:self forKeyPath:@"notificationData"];
    
    [_app release],_app = nil;
    [_secret release], _secret = nil;
    [_placement release], _placement = nil;
    [_notificationData release], _notificationData = nil;
    [_notificationRenderer release], _notificationRenderer = nil;
    [super dealloc];
}

-(void)refresh{
    if (!_request) {
        _request = [PHPublisherMetadataRequest requestForApp:_app secret:_secret placement:_placement delegate:self];
        [_request send];
    }
}

-(void)request:(PHAPIRequest *)request didSucceedWithResponse:(NSDictionary *)responseData{
    _request = nil;
    self.notificationData = [responseData valueForKey:@"notification"];
}

-(void)request:(PHAPIRequest *)request didFailWithError:(NSError *)error{
    _request = nil;
    self.notificationData = nil;
}

-(void)test{
    static NSDictionary *TestingNotificationData;
    if (TestingNotificationData == nil) {
        TestingNotificationData = [[NSDictionary alloc] initWithObjectsAndKeys:
                                   @"badge", @"type",
                                   @"1",@"value",
                                   nil];
    }
    
    self.notificationData = TestingNotificationData;
}

-(void)clear{
    if (!!_request) {
        _request.delegate = nil;
        _request = nil;
    }
    
    self.notificationData = nil;
}

- (void)drawRect:(CGRect)rect
{
    [_notificationRenderer drawNotification:self.notificationData inRect:rect];
}

@end
