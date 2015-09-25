//
//  ShotsService.m
//  desafio-tvos
//
//  Created by Thiago Holanda on 9/23/15.
//  Copyright © 2015 Concrete Solutions. All rights reserved.
//

#import "Services.h"

@interface ShotsService()

@property (strong, nonatomic) BaseService *baseService;

@end

@implementation ShotsService

+ (instancetype) sharedInstance {
    static ShotsService *shareClient;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        shareClient = [[self alloc] init];
    });
    
    return shareClient;
}

- (instancetype)init {
    self = [super init];
    if (self)
        self.baseService = [BaseService sharedInstance];
    
    return self;
}

- (void) get:(ShotModel *) shot complete:(ServiceResultShotBlock) complete {
    NSString *URL = [NSString stringWithFormat:@"/shots/%@", shot.uuid];
    
    [self.baseService GET: URL
               parameters: nil
                 complete: ^(NSURLResponse *response, id responseObject, NSError *error) {
                     
                     ShotModel *shot;
                     
                     if (!error && [responseObject isKindOfClass: NSDictionary.class]) {
                         shot = [[ShotModel alloc] initWithDictionary: responseObject
                                                                error: &error];
                     }
                     
                     if (complete)
                         complete(shot, error);
                 }];
}

- (void) listPopularWithPage:(NSInteger) page complete:(ServiceResultListBlock) complete {
    NSString *URL = @"/shots/popular";
    
    NSDictionary *params = @{
                             @"per_page": @(10),
                             @"page": @(page)
                             };
    
    [self.baseService GET: URL
               parameters: params
                 complete:^(NSURLResponse *response, id responseObject, NSError *error) {
                     NSLog(@"Object: %@", responseObject);
                 }];
}

@end

