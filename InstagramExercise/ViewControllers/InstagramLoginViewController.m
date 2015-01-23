//
//  InstagramLoginViewController.m
//  InstagramExercise
//
//  Created by Karim Abdul on 1/22/15.
//  Copyright (c) 2015 Karim Abdul. All rights reserved.
//

#import "InstagramLoginViewController.h"
#import "InstagramService.h"
#import "Constants.h"

@interface InstagramLoginViewController ()

@property (nonatomic, strong) NSString *code;

@end

@implementation InstagramLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.webView.delegate = self;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://instagram.com/oauth/authorize/?client_id=ec3174198b9348fe8678b7826c9e5137&redirect_uri=instagramExample://&response_type=code"]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"didFinish: %@; stillLoading: %@", [[webView request]URL],
          (webView.loading?@"YES":@"NO"));
    
    NSString *currentURL = [_webView stringByEvaluatingJavaScriptFromString:@"window.location.href"];
    NSLog(@"%@",currentURL);
}


- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"didFail: %@; stillLoading: %@", [[webView request]URL],
          (webView.loading?@"YES":@"NO"));
    NSLog(@"%@",[error userInfo]);
    
    NSDictionary *info = [error userInfo];
    
    if (info) {
        
        if (!self.webView.loading) {
            //We got the transaction complete
            NSString *codeInfo = [info valueForKey:@"NSErrorFailingURLStringKey"];
            self.code = [NSString stringWithFormat:@"%@",[codeInfo stringByReplacingOccurrencesOfString:@"instagramexample:?code=" withString:@""]];
            NSLog(@"the code: %@",self.code);
            
            InstagramService *instagramService = [InstagramService sharedInstance];
            NSString *parameters = [NSString stringWithFormat:@"client_id=%@&client_secret=%@&grant_type=%@&redirect_uri=%@&code=%@",clientId,clientSecret,grantType,redirectURI,self.code];

            [instagramService getAccessToken:parameters completed:^(NSData *data, NSURLResponse *response, NSError *err) {
                
                NSLog(@"%@",response);
                NSError* error;
                
                if (!error) {
                    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                    NSLog(@"result json: %@", jsonDict);
                }
            }];
        }
    }
}

- (NSString*)code
{
    if (!_code) {
        _code = [[NSString alloc] init];
    }
    return _code;
}

@end
