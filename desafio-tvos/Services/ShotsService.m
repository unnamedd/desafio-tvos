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
    NSString *URL = @"/shots";
    
    NSDictionary *params = @{
                             @"per_page": @(20),
                             @"page": @(page)
                             };
    
    [self.baseService GET: URL
               parameters: params
                 complete:^(NSURLResponse *response, id responseObject, NSError *error) {
                     
                     NSMutableArray *shots = [NSMutableArray new];
                     NSInteger totalPages = 0;
                     
                     if (!error) {
                         NSDictionary *responseDictionary = (NSDictionary *)responseObject;
                         totalPages = [[responseDictionary objectForKey:@"pages"] integerValue];
                         NSArray *items = [NSArray arrayWithArray: [responseDictionary objectForKey:@"shots"]];

                         [items enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
                             
                             NSError *errorModel = nil;
                             ShotModel *shot = [[ShotModel alloc] initWithDictionary: obj
                                                                               error: &errorModel];
                             
                             if (!errorModel)
                                 [shots addObject:shot];
                         }];
                     }
                     
                     if (complete)
                         complete(shots, totalPages, error);
                 }];
}


- (void)listRecentWithPage:(NSInteger)page complete:(ServiceResultListBlock)complete {
    NSString *URL = @"/shots?sort=recent";

    NSDictionary *params = @{@"per_page": @(20),
                             @"page":     @(page)};
    
    [self.baseService GET:URL
               parameters:params
                 complete:^(NSURLResponse *response, id responseObject, NSError *error) {
                     NSMutableArray *shots = [NSMutableArray new];
                     NSInteger totalPages = 0;
                     
                     if (!error) {
                         NSDictionary *responseDictionary = (NSDictionary *)responseObject;
                         totalPages = [[responseDictionary objectForKey:@"pages"] integerValue];
                         NSArray *items = [NSArray arrayWithArray: [responseDictionary objectForKey:@"shots"]];
                         
                         [items enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
                             NSError *errorModel = nil;
                             ShotModel *shot = [[ShotModel alloc] initWithDictionary: obj error: &errorModel];
                             
                             if (!errorModel)
                                 [shots addObject:shot];
                         }];
                     }
                     
                     if (complete)
                         complete(shots, totalPages, error);
                 }];
}



@end