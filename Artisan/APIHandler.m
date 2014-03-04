//
//  APIHandler.m
//  Artisan
//
//  Created by David Archuleta on 2/26/14.
//  Copyright (c) 2014 Nathan Mock. All rights reserved.
//
#import "APIHandler.h"
#import "AFJSONRequestOperation.h"

@interface APIHandler()

- (void)playlistQuery:(NSURL*)playlistURL;
- (NSURL*)playlistURL:(NSString*)artistName;
+ (NSString*)createRequestString:(NSString*)title;
+ (NSURL*)returnLastfmURL:(NSString*)title;
- (void)setArtistInfo;
- (void)setPlaylistInfo;
- (void)notifyController;
- (void)loadOperation:(NSURLRequest*)urlToRequest;
- (void)lastFMQuery:(NSString*)nounTitle;
- (void)lastFMQuery:(NSString *)nounTitle andMethod:(NSString*)methodName;
// setAndReturnMethod
// setAndReturnTitle
// setAndReturnPreTitle

@end

/******************************************************************************/
@implementation APIHandler
- (void)lastFMQuery:(NSString *)nounTitle
{
    if (self.method)
        [self lastFMQuery:nounTitle andMethod:self.method];
    else
        [self lastFMQuery:nounTitle andMethod:@"artist.getinfo"];   // Change this!!!
}

- (void)lastFMQuery:(NSString *)nounTitle andMethod:(NSString *)methodName // Should be general enough to take all queries.
{
    nounTitle = [APIHandler createRequestString:nounTitle];
    NSURL *url = [[NSURL alloc] init];
    url = [self returnLastFMURL:(NSString *)nounTitle];
    if (!url){
        NSLog(@"createRequestString ERROR");
    }
    NSURLRequest *request = [NSURLRequest requestWithURL: url];
    // perform query.
    
    
}

+ (NSString*)createRequestString:(NSString *)title
{
    return (__bridge NSString*)
    CFURLCreateStringByAddingPercentEscapes(
            NULL,
            (CFStringRef)title,
            NULL,
            (CFStringRef)@"!’\"();:@&=+$,/?%#[]% ",
            kCFStringEncodingISOLatin1
    );
}

- (NSURL*)returnLastFMURL:(NSString *)title
{
    NSString *prefix = [NSString stringWithFormat:
                      @"%@&%@&",
                      LFM_ENDPOINT,
                      self.method];
    NSString *suffix = [NSString stringWithFormat:
                        @"%@&%@&%@&%@&",
                        self.preTitle,
                        self.title,
                        KEY,
                        LFM_KEY];
    NSString *both = [prefix stringByAppendingString:suffix];
    both = [both stringByAppendingString:JSONFORMAT]; /* place in json format */
    return [NSURL URLWithString: both];
}

- (APIHandler*) init
{
    self = [super init];
    if (self) {
        self.method = [NSString string];
        self.title = [NSString string];
        self.preTitle = [NSString string];
        return self;
    }
    return self;
}

- (void) loadOperation:(NSURLRequest *)urlToRequest
{
    // TODO
}

- (void) artistGetInfo:(NSString *)artistName
{
    self.title = artistName;
    // 
    self.method = @"artist.getInfo";    // [methodsDictionary objectForKey:
    self.preTitle = @"&artist=";        // [preTitleDictionary objectForKey: artist];
}
































@end
