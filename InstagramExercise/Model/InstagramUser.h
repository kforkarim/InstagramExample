//
//  InstagramUser.h
//  InstagramExercise
//
//  Created by Karim Abdul on 1/23/15.
//  Copyright (c) 2015 Karim Abdul. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InstagramUser : NSObject

@property (nonatomic, copy) NSString *accessToken;
@property (nonatomic, copy) NSString *bio;
@property (nonatomic, copy) NSString *fullName;
@property (nonatomic, copy) NSString *igId;
@property (nonatomic, copy) NSString *profilePictureURL;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *website;

@end
