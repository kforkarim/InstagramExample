//
//  InstagramLoginViewController.m
//  InstagramExercise
//
//  Created by Karim Abdul on 1/22/15.
//  Copyright (c) 2015 Karim Abdul. All rights reserved.
//

#import "InstagramLoginViewController.h"
#import "InstagramCollectionViewController.h"
#import "InstagramService.h"
#import "Constants.h"
#import "AppDelegate.h"

@interface InstagramLoginViewController ()

@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;
@end

@implementation InstagramLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.webView.delegate = self;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/oauth/authorize/?client_id=%@&redirect_uri=%@&response_type=code",kURL,kCLIENTID,kREDIRECTURI]]]];
    
    self.indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.indicatorView.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    
    [self.view addSubview:self.indicatorView];
    [self.indicatorView startAnimating];
    [self.indicatorView setHidden:YES];

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

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self.indicatorView setHidden:NO];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.indicatorView setHidden:YES];
}


- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSDictionary *info = [error userInfo];
    
    if (info) {
        
        if (!self.webView.loading) {
            //We got the transaction complete
            NSString *codeInfo = [info valueForKey:@"NSErrorFailingURLStringKey"];
            self.code = [NSString stringWithFormat:@"%@",[codeInfo stringByReplacingOccurrencesOfString:@"instagramexample:?code=" withString:@""]];
            
            InstagramService *instagramService = [InstagramService sharedInstance];
            NSString *parameters = [NSString stringWithFormat:@"client_id=%@&client_secret=%@&grant_type=%@&redirect_uri=%@&code=%@",kCLIENTID,kCLIENDSECRET,kGRANTTYPE,kREDIRECTURI,self.code];

            [instagramService getAccessToken:parameters completed:^(NSData *data, NSURLResponse *response, NSError *err) {
                
                NSError* error;
                
                if (!error) {
                    
                    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
                    InstagramUser *user = [[InstagramUser alloc] initWithUser:jsonDict];
                    appDelegate.user = user;
                    user = nil;
                    
                    InstagramCollectionViewController *listVC = [[UIStoryboard storyboardWithName:@"Main" bundle:NULL] instantiateViewControllerWithIdentifier:@"InstagramCollectionViewController"];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.navigationController pushViewController:listVC animated:YES];
                    });
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
