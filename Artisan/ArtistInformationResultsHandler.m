//
//  ArtistInformationResultsHandler.m
//  Artisan
//
//  Created by Nathan Mock on 1/19/13.
//  Copyright (c) 2013 Nathan Mock. All rights reserved.
//

#import "ArtistInformationResultsHandler.h"
#import "AFJSONRequestOperation.h"
#import "Artist.h"
#import "Mix.h"
#import "NSString+HTML.h"
// Also- <Foundation.h>, AFHTTPRequestOperation.h,
// AFURLConnection.h, NSOperation.h, NSURLConnection.h,
//
@implementation ArtistInformationResultsHandler

/**
 Makes requests to the Last.fm & 8tracks.com APIs for
 artist info. Sets all properties of the Artist class:
 name, biography, imageURL, mixes.
 Needs to be broken up into smaller functions.
 */
+ (void) performArtistQuery:(Artist*)artist {
    NSString *artistParameter =
    (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes
         // CFAllocatorRef allocator:
        (NULL,
         // originalString:
         (CFStringRef)artist.name,
         // CFStringRef charactersToLeaveUnescaped:
         NULL,
         // legalURLCharactersToBeEscaped:
         (CFStringRef)@"!’\"();:@&=+$,/?%#[]% ",
         // CFStringEncoding encoding:
         kCFStringEncodingISOLatin1);
    
    /**
     bioRequest = ARTIST_API_ENDPOINT + artistParameter + API_KEY_PARAMETER + 
     LAST_FM_API_KEY
     */
    NSURLRequest *bioRequest =[NSURLRequest requestWithURL:[NSURL URLWithString:[
                    [ARTIST_API_ENDPOINT stringByAppendingString:artistParameter]
                                        stringByAppendingFormat: @"&%@%@",
                                                             API_KEY_PARAMETER,
                                                             LAST_FM_API_KEY]]];
    /**
     Once [bioOperation start], requests JSON info from Last.fm.
     If successful, sets artist.biography, artist.imageURL and
     posts notification to HomeViewController observer that
     the artist information has been received.
     If failure, NSLogs an error message with [error userInfo].
     */
    AFJSONRequestOperation *bioOperation =
        [AFJSONRequestOperation JSONRequestOperationWithRequest: bioRequest
        success: ^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
    {
        // TODO: API Error Checking / Handling
        // 
        artist.biography = [[[[JSON
                               objectForKey:@"artist"]
                              objectForKey:@"bio"]
                             objectForKey:@"summary"]
                            stringByConvertingHTMLToPlainText];
        for (NSDictionary *image in [[JSON objectForKey:@"artist"]
                                     objectForKey:@"image"])
        {
            if ([[image objectForKey:@"size"] isEqualToString:@"mega"]) {
                artist.imageURL=
                [NSURL URLWithString:[image objectForKey:@"#text"]];
            }
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:
         RECEIVED_ARTIST_INFORMATION
         object:self
         userInfo:[NSDictionary dictionaryWithObject:artist
                                              forKey:RECEIVED_ARTIST_INFORMATION]];
    }
        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON)
    {
        NSLog(@"Request Failure Because %@", [error userInfo]);
    }]; // End of AFJSONRequestOperation *bioOperation assignment
    [bioOperation start];
    
    // Creates a URL request with the 8tracks.com API
    // mixRequest.URL = MIX_API_ENDPOINT + artistParameter + API_KEY_PARAMETER +
    // EIGHT_TRACKS_API_KEY
    NSURLRequest *mixRequest = [NSURLRequest requestWithURL:
                                [NSURL URLWithString:
                                 [[MIX_API_ENDPOINT stringByAppendingString:artistParameter]
                                  stringByAppendingFormat:@"&%@%@",
                                  API_KEY_PARAMETER, EIGHT_TRACKS_API_KEY]]];
    /**
     Once [mixOperation start], requests JSON info from 8tracks.com
     If successful, initializes NSMuttableArray with the number of
     mixes within the JSON file. It then initializes each mix with data
     and adds them to the muttableArray.
     Sets artist.mixes with the array, sends notification to observers.
     If failure, NSLogs error with [error userInfo].
     */
    AFJSONRequestOperation *mixOperation =
        [AFJSONRequestOperation JSONRequestOperationWithRequest:mixRequest
        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
    {
        // TODO: API Error Checking / Handling
        NSMutableArray *mixes = [[NSMutableArray alloc] initWithCapacity:
                                 [[JSON objectForKey:@"mixes"] count]];
        
        for (NSDictionary *mixData in [JSON objectForKey:@"mixes"]) {
            Mix *mix = [[Mix alloc] initMixWithData:mixData];
            [mixes addObject:mix];
        }
        artist.mixes = mixes;
        [[NSNotificationCenter defaultCenter]postNotificationName:
         RECEIVED_ARTIST_MIXES  // Name of the notification
         object:self            // The object posting the notification.
         userInfo:[NSDictionary // Information about the the notification.
                   dictionaryWithObject:artist
                   forKey:RECEIVED_ARTIST_MIXES]];
    }
    failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON)
    {
        NSLog(@"Request Failure Because %@", [error userInfo]);
    }]; // End of AFJSONRequestOperation *mixOperation assignment
    [mixOperation start];
}
@end
