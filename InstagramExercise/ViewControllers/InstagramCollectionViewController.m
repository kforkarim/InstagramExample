//
//  InstagramCollectionViewController.m
//  InstagramExercise
//
//  Created by Karim Abdul on 1/22/15.
//  Copyright (c) 2015 Karim Abdul. All rights reserved.
//

#import "InstagramCollectionViewController.h"
#import "CollectionViewCell.h"
#import "InstagramService.h"
#import "AppDelegate.h"
#import "InstagramSelfie.h"
#import "UIImageView+WebCache.h"

@interface InstagramCollectionViewController ()

@property (nonatomic, strong) NSMutableArray *selfieArray;

@end

@implementation InstagramCollectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Selfie"; 
    
    UINib *collectionCellNib = [UINib nibWithNibName:@"CollectionViewCell" bundle:nil];
    [self.collectionView registerNib:collectionCellNib forCellWithReuseIdentifier:@"CellOne"];
    
    UINib *collectionCellNibTwo = [UINib nibWithNibName:@"CollectionViewCellTwo" bundle:nil];
    [self.collectionView registerNib:collectionCellNibTwo forCellWithReuseIdentifier:@"CellTwo"];
    
    UINib *collectionCellNibThree = [UINib nibWithNibName:@"CollectionViewCellThree" bundle:nil];
    [self.collectionView registerNib:collectionCellNibThree forCellWithReuseIdentifier:@"CellThree"];    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationItem setHidesBackButton:YES];
    
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    InstagramService *service = [InstagramService sharedInstance];
    [service getTagContent:appDelegate.user.accessToken completed:^(NSData *data, NSURLResponse *response, NSError *err) {
        
        NSLog(@"%@",response);
        NSError *error;
        
        if (!err) {
            NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            NSLog(@"result json: %@", jsonDict);
            dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self loadSelfieArrayWithLowResolutionImageURL:jsonDict];
                
                //Reload data once content is being downloaded.
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.collectionView reloadData];
                });
            });
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Collection View Data Sources

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.selfieArray count];
}

// The cell that is returned must be retrieved from a call to - dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%li",indexPath.row % 3);
    
    CollectionViewCell *cell = [self collectionViewCell:collectionView IndexPath:indexPath];
    if (cell)
        return cell;
    
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    int i = indexPath.row % 3;
    
    if (i == 0)
        return CGSizeMake(320, 200);

    else if (i == 1)
        return CGSizeMake(100, 100);
   
    else if (i == 2)
        return CGSizeMake(100, 100);;

    return CGSizeMake(0, 0);
}


- (CollectionViewCell*)collectionViewCell:(UICollectionView*)collectionView IndexPath:(NSIndexPath*)indexPath
{
    CollectionViewCell *cell;
    InstagramSelfie *selfie = (InstagramSelfie*)[self.selfieArray objectAtIndex:indexPath.row];
    
    int i = indexPath.row % 3;
    
    if (i == 0 ) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CellOne" forIndexPath:indexPath];
    }
    
    else if (i == 1) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CellTwo" forIndexPath:indexPath];
    }
    
    
    else if (i == 2) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CellThree" forIndexPath:indexPath];
    }
    
    // Here we use the new provided setImageWithURL: method to load the web image
    [cell.imageView sd_setImageWithURL:selfie.selfieURL
                   placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    
    return cell;
}

- (void)loadSelfieArrayWithLowResolutionImageURL:(NSDictionary*)jsonContent
{
    NSArray *data = [jsonContent valueForKey:@"data"];
    
    for (NSDictionary *contents in data) {
        
        NSString *lowResolution = [[[contents valueForKey:@"images"] valueForKey:@"low_resolution"] valueForKey:@"url"];
        InstagramSelfie *selfie = [[InstagramSelfie alloc] init];
        selfie.selfieURL = [NSURL URLWithString:lowResolution];
        [self.selfieArray addObject:selfie];
        
    }
    
    NSLog(@"%@",self.selfieArray);
}

- (NSMutableArray*)selfieArray
{
    if (!_selfieArray) {
        _selfieArray = [[NSMutableArray alloc] init];
    }
    
    return _selfieArray;
}

@end
