//
//  InstagramService.h
//  InstagramExercise
//
//  Created by Karim Abdul on 1/22/15.
//  Copyright (c) 2015 Karim Abdul. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InstagramService : NSObject

/**
 Returns an instance to the shared singleton which governs access to the
 Instagram Service Calls.
 @returns The shared instagram object
 */
+ (InstagramService *)sharedInstance;

- (void)getAccessToken:(NSString *)parameters
             completed:(void (^)(NSData *data, NSURLResponse *response, NSError *err))resp;

- (void)getTagContent:(NSString*)accessToken
               completed:(void (^)(NSData *data, NSURLResponse *response, NSError *err))resp;

@end
