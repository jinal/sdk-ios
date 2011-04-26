//
//  PHConstants.h
//  playhaven-sdk-ios
//
//  Created by Jesus Fernandez on 4/14/11.
//  Copyright 2011 Playhaven. All rights reserved.
//


#ifndef PH_BASE_URL
#define PH_BASE_URL @"http://api.playhaven.com"
#endif

#define PH_URL(PATH) [PH_BASE_URL stringByAppendingString:@#PATH]
#define PH_URL_FMT(PATH,FMT) [PH_BASE_URL stringByAppendingFormat:@#PATH, FMT]