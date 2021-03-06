//
//  Services.h
//  desafio-tvos
//
//  Created by Thiago Holanda on 9/23/15.
//  Copyright © 2015 Concrete Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// Models
#import "Models.h"

// Generic
typedef void (^BaseServiceResponseBlock)(NSURLResponse *response, id responseObject, NSError *error);

typedef void (^ServiceResultListBlock)(NSArray *items, NSInteger totalPages, NSError *error);
typedef void (^ServiceResultObjectBlock)(id object, BOOL success, NSError *error);
typedef void (^ServiceResultImageBlock)(UIImage *image, NSError *error);

// Shots
typedef void (^ServiceResultShotBlock)(ShotModel *shot, NSError *error);

#pragma mark - Base Service
@interface BaseService : NSObject

+ (instancetype) sharedInstance;

#pragma mark - Request Methods
- (void) GET: (NSString *) URLString
  parameters: (NSDictionary *) parameters
    complete: (BaseServiceResponseBlock) complete;

#pragma mark - Download Image
- (void) downloadImageWithURL:(NSString *) URLString
                     complete:(ServiceResultImageBlock) complete;

@end

@interface ShotsService : NSObject

#pragma mark - Initializers
+ (instancetype) sharedInstance;

#pragma mark - Request Methods
- (void) get:(ShotModel *) shot complete:(ServiceResultShotBlock) complete;
- (void) listPopularWithPage:(NSInteger) page complete:(ServiceResultListBlock) complete;
- (void)listRecentWithPage:(NSInteger)page complete:(ServiceResultListBlock)complete;
@end