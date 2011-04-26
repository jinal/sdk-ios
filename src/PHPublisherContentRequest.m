//
//  PHPublisherContentRequest.m (formerly PHPublisherAdUnitRequest.m)
//  playhaven-sdk-ios
//
//  Created by Jesus Fernandez on 4/5/11.
//  Copyright 2011 Playhaven. All rights reserved.
//

#import "PHPublishercontentRequest.h"
#import "PHContent.h"
#import "PHConstants.h"

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
@synthesize contentView = _contentView;

-(NSString *)urlPath{
  return PH_URL(/v3/publisher/content/);
}

-(void)dealloc{
  [_contentView release], _contentView = nil;
  [_placement release], _placement = nil;
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
  if (_contentView == nil) {
    PHContent *content = [PHContent contentWithDictionary:responseData];
    if (!!content) {
      if ([self.delegate respondsToSelector:@selector(request:contentWillDisplay:)]) {
        [self.delegate performSelector:@selector(request:contentWillDisplay:) withObject:self withObject:content];
      }
      
      _contentView = [[PHContentView alloc] initWithContent:content];
      [_contentView setDelegate:self];
      [_contentView show:self.animated];
      
      [self retain];
    } else {
      [self didFailWithError:nil];
    }
  }
}

-(void)send{
  [super send];
  
  if ([self.delegate respondsToSelector:@selector(requestWillGetContent:)]) {
    [self.delegate performSelector:@selector(requestWillGetContent:) withObject:self];
  }
}


#pragma -
#pragma PHContentViewDelegate
-(void)contentViewDidLoad:(PHContentView *)contentView{
  if ([self.delegate respondsToSelector:@selector(request:contentDidDisplay:)]) {
    [self.delegate performSelector:@selector(request:contentDidDisplay:) 
                        withObject:self 
                        withObject:contentView.content];
  }
}

-(void)contentViewDidDismiss:(PHContentView *)contentView{
  if ([self.delegate respondsToSelector:@selector(requestContentDidDismiss:)]) {
    [self.delegate performSelector:@selector(requestContentDidDismiss:) 
                        withObject:self];
  }
  
  [self release];
}

-(void)contentView:(PHContentView *)contentView didFailWithError:(NSError *)error{
  if ([self.delegate respondsToSelector:@selector(request:contentDidFailWithError:)]) {
    [self.delegate performSelector:@selector(request:contentDidFailWithError:) 
                        withObject:self 
                        withObject:error];
  }
  
  [self release];
}

@end
