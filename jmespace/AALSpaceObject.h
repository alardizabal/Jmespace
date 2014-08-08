//
//  AALSpaceObject.h
//  jmespace
//
//  Created by Albert Lardizabal on 8/6/14.
//  Copyright (c) 2014 Albert Lardizabal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AALSpaceObject : NSObject

@property (nonatomic) NSString *name;
@property (nonatomic) NSString *address;
@property (nonatomic) NSString *placeID;
@property (nonatomic) CGFloat latitude;
@property (nonatomic) CGFloat longitude;
@property (nonatomic) NSString *review;
@property (nonatomic) NSUInteger rating;
@property (nonatomic) NSMutableArray *comments;
@property (nonatomic) NSMutableArray *photos;
@property (nonatomic) NSMutableArray *videos;
@property (nonatomic) BOOL isOpen;

@end
