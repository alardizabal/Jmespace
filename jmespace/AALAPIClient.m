//
//  AALAPIClient.m
//  jmespace
//
//  Created by Albert Lardizabal on 8/7/14.
//  Copyright (c) 2014 Albert Lardizabal. All rights reserved.
//

#import "AALAPIClient.h"
#import "AALConstants.h"
#import "AALViewController.h"
#import <AFNetworking.h>

@implementation AALAPIClient

//+ (void) getSpacesNearbyWithLatitude:(CGFloat)latitude
//                           longitude:(CGFloat)longitude
//                              radius:(NSUInteger)radius
//                             keyword:(NSString *)keyword
//                          completion:(void (^)(NSDictionary *dictionary))completionBlock {
//    
//    NSOperationQueue *backgroundQueue = [[NSOperationQueue alloc] init];
//    
//    [backgroundQueue addOperationWithBlock:^{
//        
//        CGFloat location =
//        
//        NSString *getGooglePlacesURL = [NSString stringWithFormat:@"%@", kGPLACES_API_URL];
//        
//        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//        
//        NSDictionary *params = @{@"key":kGOOGLE_API_KEY, @"location":latitude
//        
//        [manager GET:getGooglePlacesURL
//          parameters:nil
//             success:^(NSURLSessionDataTask *task, id responseObject)
//         {
//             [backgroundQueue addOperationWithBlock:^{
//                 completionBlock(responseObject);
//             }];
//             
//         } failure:^(NSURLSessionDataTask *task, NSError *error)
//         {
//             NSLog(@"Fail: %@",error.localizedDescription);
//         }];
//    }];
//}

@end
