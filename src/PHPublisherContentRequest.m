//
//  PHPublisherContentRequest.m (formerly PHPublisherAdUnitRequest.m)
//  playhaven-sdk-ios
//
//  Created by Jesus Fernandez on 4/5/11.
//  Copyright 2011 Playhaven. All rights reserved.
//

#import "PHPublisherContentRequest.h"
#import "PHPublisherSubContentRequest.h"
#import "PHContent.h"
#import "PHConstants.h"
#import "NSObject+SBJSON.h"

@implementation PHPublisherContentRequest

+(id)requestForApp:(NSString *)token secret:(NSString *)secret placement:(NSString *)placement delegate:(id)delegate{
  return [[[[self class] alloc] initWithApp:token secret:secret placement:placement delegate:delegate] autorelease];
}

-(id)initWithApp:(NSString *)token secret:(NSString *)secret placement:(NSString *)placement delegate:(id)delegate{
  if ((self = [self initWithApp:token secret:secret])) {
    self.placement = placement;
    self.delegate = delegate;
  }
  
  return self;
}

-(id)initWithApp:(NSString *)token secret:(NSString *)secret{
  if ((self = [super initWithApp:token secret:secret])){
    _animated = YES;
  }
  
  return self;
}

@synthesize placement = _placement;
@synthesize animated = _animated;

-(NSMutableArray *)contentViews{
  if (_contentViews == nil){
    _contentViews = [[NSMutableArray alloc] init];
  }
  
  return _contentViews;
}

-(NSString *)urlPath{
  return PH_URL(/v3/publisher/content/);
}

-(void)dealloc{
  [_placement release], _placement = nil;
  [_contentViews release], _contentViews = nil;
  [super dealloc];
}

#pragma mark -
#pragma mark PHAPIRequest

-(NSDictionary *)additionalParameters{
  return [NSDictionary dictionaryWithObjectsAndKeys:
          self.placement, @"placement_id",
          nil];
}

-(void)didSucceedWithResponse:(NSDictionary *)responseData{
  PHContent *content = [PHContent contentWithDictionary:responseData];
  if (!!content) {
    if ([self.delegate respondsToSelector:@selector(request:contentWillDisplay:)]) {
      [self.delegate performSelector:@selector(request:contentWillDisplay:) withObject:self withObject:content];
    }
    
    [self pushContent:content];
    [self retain];
  } else {
    [self didFailWithError:nil];
  }
}

-(void)send{
  [super send];
  
  if ([self.delegate respondsToSelector:@selector(requestWillGetContent:)]) {
    [self.delegate performSelector:@selector(requestWillGetContent:) withObject:self];
  }
}

#pragma -
#pragma Sub-content
-(void)requestSubcontent:(NSDictionary *)queryParameters callback:(NSString *)callback source:(PHContentView *)source{
  PHPublisherSubContentRequest *request = [PHAPIRequest requestForApp:self.token secret:self.secret];
  request.delegate = self;
  
  request.urlPath = [queryParameters valueForKey:@"url"];
  request.callback = callback;
  request.source = source;
  
  [request send];
}

-(void)request:(PHAPIRequest *)request didSucceedWithResponse:(NSDictionary *)responseData{
  PHContent *content = [PHContent contentWithDictionary:responseData];
  PHPublisherSubContentRequest *scRequest = (PHPublisherSubContentRequest *)request;
  if (!!content) {
    [self pushContent:content];
    [scRequest.source sendCallback:scRequest.callback withResponse:responseData error:nil];
  } else{
    NSDictionary *errorDict = [NSDictionary dictionaryWithObjectsAndKeys:
                               @"1",@"error", nil];
    [scRequest.source sendCallback:scRequest.callback withResponse:nil error:errorDict];
  }
}

-(void)request:(PHAPIRequest *)request didFailWithError:(NSError *)error{
  PHPublisherSubContentRequest *scRequest = (PHPublisherSubContentRequest *)request;
  NSDictionary *errorDict = [NSDictionary dictionaryWithObjectsAndKeys:
                             @"1",@"error", nil];
  [scRequest.source sendCallback:scRequest.callback withResponse:nil error:errorDict];
}

-(void)pushContent:(PHContent *)content{
  PHContentView *contentView = [[PHContentView alloc] initWithContent:content];
  [contentView redirectRequest:@"ph://subcontent" toTarget:self action:@selector(requestSubcontent:callback:source:)];
  [contentView setDelegate:self];
  [contentView show:self.animated];
  
  [self.contentViews addObject:contentView];
  
  [contentView release];
}


#pragma -
#pragma PHContentViewDelegate
-(void)contentViewDidLoad:(PHContentView *)contentView{  
  if ([self.contentViews count] == 1) {
    //only passthrough the first contentView load
    if ([self.delegate respondsToSelector:@selector(request:contentDidDisplay:)]) {
      [self.delegate performSelector:@selector(request:contentDidDisplay:) 
                          withObject:self 
                          withObject:contentView.content];
    }
  }
}

-(void)contentViewDidDismiss:(PHContentView *)contentView{
  [self.contentViews removeObject:contentView];
  
  if ([self.contentViews count] == 0) {
    //only passthrough the last contentView to dismiss
    if ([self.delegate respondsToSelector:@selector(requestContentDidDismiss:)]) {
      [self.delegate performSelector:@selector(requestContentDidDismiss:) 
                          withObject:self];
    }
    
    [self release];
  }
}

-(void)contentView:(PHContentView *)contentView didFailWithError:(NSError *)error{
  [self.contentViews removeObject:contentView];
  
  if ([self.contentViews count] == 0) {
    //only passthrough the last contentView to error
    if ([self.delegate respondsToSelector:@selector(request:contentDidFailWithError:)]) {
      [self.delegate performSelector:@selector(request:contentDidFailWithError:) 
                          withObject:self 
                          withObject:error];
    }
    
    [self release];
  }
}

-(UIImage *)contentView:(PHContentView *)contentView imageForCloseButtonState:(UIControlState)state{
  if ([self.delegate respondsToSelector:@selector(request:closeButtonImageForControlState:content:)]) {
    return [(id <PHPublisherContentRequestDelegate>)self.delegate request:self closeButtonImageForControlState:state content:contentView.content];
  }
  
  return nil;
}

-(UIColor *)borderColorForContentView:(PHContentView *)contentView{
  if ([self.delegate respondsToSelector:@selector(request:borderColorForContent:)]) {
    return [(id <PHPublisherContentRequestDelegate>)self.delegate request:self borderColorForContent:contentView.content];
  }
  
  return nil;
}


@end
