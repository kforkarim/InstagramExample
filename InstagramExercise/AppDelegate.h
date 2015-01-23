//
//  AppDelegate.h
//  InstagramExercise
//
//  Created by Karim Abdul on 1/22/15.
//  Copyright (c) 2015 Karim Abdul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InstagramUser.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, UIWebViewDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIWebView *webView;
@property (strong, nonatomic) InstagramUser *user;
@end
