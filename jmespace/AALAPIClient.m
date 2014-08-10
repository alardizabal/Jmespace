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

+ (void) getUserInterestsWithReference:(NSString *)photoreferenceWithCompletion:(void (^)(NSDictionary *dictionary))completionBlock {
    
    NSOperationQueue *backgroundQueue = [[NSOperationQueue alloc] init];
    NSString *getSpaceImageURL = [NSString stringWithFormat:@"%@", kGPLACES_PHOTOS_API_URL];
   // NSDictionary *params = @{@"key":kGOOGLE_API_KEY, @"photoreference":email, @"maxheight": 1600};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:getSpaceImageURL
      parameters:nil
         success:^(NSURLSessionDataTask *task, id responseObject)
     {
         [backgroundQueue addOperationWithBlock:^{
             completionBlock(responseObject);
         }];
         
         
     } failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         NSLog(@"Fail: %@",error.localizedDescription);
     }];
}

@end
