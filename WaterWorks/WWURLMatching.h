//
//  WWURLMatching.h
//  WaterWorks
//
//  Created by Jesus Fernandez on 1/31/12.
//

#import <Foundation/Foundation.h>

@interface WWURLMatching : NSObject
+(NSInteger)matchingLevelForURL:(NSURL *)url1 withURL:(NSURL *)url2;
@end
