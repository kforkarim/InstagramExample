//
//  InstagramUser.m
//  InstagramExercise
//
//  Created by Karim Abdul on 1/23/15.
//  Copyright (c) 2015 Karim Abdul. All rights reserved.
//

#import "InstagramUser.h"

@implementation InstagramUser

- (instancetype)initWithUser:(NSDictionary*)user
{
    self = [super init];
    if (self) {
        
        self.accessToken = [NSString stringWithFormat:@"%@",[user valueForKey:@"access_token"]];
        self.bio = [NSString stringWithFormat:@"%@",[[user valueForKey:@"user"] valueForKey:@"bio"]];
        self.fullName = [NSString stringWithFormat:@"%@",[[user valueForKey:@"user"] valueForKey:@"full_name"]];
        self.igId = [NSString stringWithFormat:@"%@",[[user valueForKey:@"user"] valueForKey:@"id"]];
        self.profilePictureURL = [NSString stringWithFormat:@"%@",[[user valueForKey:@"user"] valueForKey:@"profile_picture"]];
        self.username = [NSString stringWithFormat:@"%@",[[user valueForKey:@"user"] valueForKey:@"username"]];
        self.website = [NSString stringWithFormat:@"%@",[[user valueForKey:@"user"] valueForKey:@"website"]];
    }
    
    return self;
}

@end
