//
//  Services.m
//  desafio-tvos
//
//  Created by Thiago Holanda on 9/23/15.
//  Copyright © 2015 Concrete Solutions. All rights reserved.
//

#import "Services.h"
#import "CommonDefines.h"


@interface BaseService()

@property (strong, nonatomic) NSURL *baseURL;
@property (strong, nonatomic) NSURLSession *baseSession;

@end

@implementation BaseService

#pragma mark - Shared Instance

+ (instancetype) sharedInstance {
    static BaseService *sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

#pragma mark - Util

#pragma mark - Initialization

- (instancetype) init {
    self = [super init];
    
    if (self) {
        self.baseURL = [NSURL URLWithString: URL_BASE];
        
        NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        self.baseSession = [NSURLSession sessionWithConfiguration: sessionConfig
                                                         delegate: nil
                                                    delegateQueue: nil];
    }
    
    return self;
}

#pragma mark - Requests


- (NSURL *) URL:(NSString *) URLString serializeParameters:(NSDictionary *) parameters {
    
    NSMutableArray *parametersList = [NSMutableArray new];
    [parameters enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop) {
        NSString *pair = [NSString stringWithFormat:@"%@=%@", key, obj];
        [parametersList addObject: pair];
    }];
    
    NSString *query = [parametersList componentsJoinedByString:@"&"];
    if (query.length > 0)
        query = [NSString stringWithFormat:@"?%@", query];
    
    NSURL *fullURL = [NSURL URLWithString: [URLString stringByAppendingString:query]
                            relativeToURL: self.baseURL];
    
    return fullURL;
}

- (void) GET:(NSString *) URLString parameters:(NSDictionary *) parameters complete:(BaseServiceResponseBlock) complete {

    NSURL *URL = [self URL: URLString
       serializeParameters: parameters];
    
    NSURLRequest *request = [NSURLRequest requestWithURL: URL];
    
    [[self.baseSession dataTaskWithRequest: request
                         completionHandler: ^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                             
                             NSError *jsonError;
                             NSJSONSerialization *jsonSerialization = [NSJSONSerialization JSONObjectWithData: data
                                                                                                      options: NSJSONReadingAllowFragments
                                                                                                        error: &jsonError];

                             if (!error) {
                                 if (complete)
                                     complete(response, jsonSerialization, error);
                             }
                             else {
                                 NSHTTPURLResponse *urlResponse = (NSHTTPURLResponse *)response;
                                 [self treatErrorWithOperation: urlResponse
                                                         error: error
                                                    completion: complete];
                             }
                         }] resume];
}


#pragma mark - Treatment Methods

- (void) treatErrorWithOperation: (NSHTTPURLResponse *)         response
                           error: (NSError *)                   operationError
                      completion: (BaseServiceResponseBlock)    complete {
    
    NSString *commonErrorDescription = @"";
    
    // http response status code 401 (access denied)
    if (response.statusCode == 401)
        commonErrorDescription = @"Acesso negado.\nPor favor, autentique-se novamente!";
    
    // request timed out
    else if ([operationError code] == NSURLErrorTimedOut)
        commonErrorDescription = @"O tempo limite de conexão esgotou.\nPor favor, verifique sua conexão.";
    
    // undefined errors
    else
        commonErrorDescription = operationError.localizedDescription;
    
    
    NSError *error = [NSError errorWithDomain: [response.URL host]
                                         code: response.statusCode
                                     userInfo: @{ NSLocalizedDescriptionKey: commonErrorDescription }];
    
    if (complete)
        complete(response, nil, error);
}


@end
