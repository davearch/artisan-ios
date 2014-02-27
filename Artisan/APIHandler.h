//
//  APIHandler.h
//  Artisan
//
//  Created by David Archuleta on 2/26/14.
//  Copyright (c) 2014 Nathan Mock. All rights reserved.
//
#define LFM_KEY @"f375cea43786f74ab2694e6c15efc754"
// #define EIGHT_TRACKS_KEY @"2ebf9ea998d07afa9111a9cf3a8ea4d9d0"

#define LFM_ENDPOINT @"http://ws.audioscrobbler.com/2.0/?method="
#define KEY @"&api_key="

#import <Foundation/Foundation.h>

@interface APIHandler : NSObject

@property (nonatomic, strong) NSString *method;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *preTitle;
// NSArrays for each?
// NSDictionary w/


- (void)lastFMQuery:(NSString*)nounTitle;
- (void)lastFMQuery:(NSString*)nounTitle andMethod:(NSString*)methodName;
- (UIImage*)imageQuery:(NSString*)artistName;
- (void)artistGetInfo:(NSString*)artistName;

@end
// add set<property> methods so there is no hardcoding
//