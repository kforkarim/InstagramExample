//
//  InstagramService.m
//  InstagramExercise
//
//  Created by Karim Abdul on 1/22/15.
//  Copyright (c) 2015 Karim Abdul. All rights reserved.
//

#import "InstagramService.h"
#import "Constants.h"

static InstagramService *_sharedInstance = nil;

@interface InstagramService ()

@end

@implementation InstagramService
+ (InstagramService *)sharedInstance {
    static dispatch_once_t onceQueue;
    
    dispatch_once(&onceQueue, ^{
        _sharedInstance = [[InstagramService alloc] init];
    });
    
    return _sharedInstance;
}

- (instancetype)init {
    
    self = [super init];
    
    if (self) {

    }
    
    return self;
}

- (void)getAccessToken:(NSString *)parameters
                        completed:(void (^)(NSData *data, NSURLResponse *response, NSError *err))resp
{
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:[parameters dataUsingEncoding:NSUTF8StringEncoding]];

    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        // Do your stuff...
        if (resp) {
            resp(data,response,error);
        }
    }] resume];
}




@end