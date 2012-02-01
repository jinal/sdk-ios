//
//  PHContent.h (formerly PHContent.h)
//  playhaven-sdk-ios
//
//  Created by Jesus Fernandez on 3/31/11.
//  Copyright 2011 Playhaven. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum{
    PHContentTransitionUnknown,
    PHContentTransitionModal,
    PHContentTransitionDialog
} PHContentTransitionType;

@interface PHContent : NSObject {
    NSDictionary *_frameDict;
    NSURL *_URL;
    PHContentTransitionType _transition;
    NSDictionary *_context;
    NSTimeInterval _closeButtonDelay;
    NSString *_closeButtonURLPath;
}

+(id)contentWithDictionary:(NSDictionary *)dictionaryRepresentation;

@property (nonatomic, retain) NSURL *URL;
@property (nonatomic, assign) PHContentTransitionType transition;
@property (nonatomic, retain) NSDictionary *context;
@property (nonatomic, assign) NSTimeInterval closeButtonDelay;
@property (nonatomic, copy) NSString *closeButtonURLPath;

-(CGRect)frameForOrientation:(UIInterfaceOrientation)orientation;
-(void)setFramesWithDictionary:(NSDictionary *)frameDict;


@end
