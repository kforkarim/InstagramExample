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
#import <objc/runtime.h>

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
        
        NSError *error;
        
        if (!err) {
            NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
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
    
    if (i == 0 )
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CellOne" forIndexPath:indexPath];

    else if (i == 1)
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CellTwo" forIndexPath:indexPath];

    else if (i == 2)
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CellThree" forIndexPath:indexPath];
    
    // Here we use the new provided setImageWithURL: method to load the web image
    [cell.imageView sd_setImageWithURL:selfie.selfieURL placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    
    return cell;
}

- (void)loadSelfieArrayWithLowResolutionImageURL:(NSDictionary*)jsonContent
{
    NSArray *data = [jsonContent valueForKey:@"data"];
    
    if (data && [data count] > 0) {
        
        for (NSDictionary *contents in data) {
            
            NSString *lowResolution = [[[contents valueForKey:@"images"] valueForKey:@"low_resolution"] valueForKey:@"url"];
            InstagramSelfie *selfie = [[InstagramSelfie alloc] init];
            if (lowResolution) {
                selfie.selfieURL = [NSURL URLWithString:lowResolution];
                [self.selfieArray addObject:selfie];
            }
        }
    }
}

- (NSMutableArray*)selfieArray
{
    if (!_selfieArray) {
        _selfieArray = [[NSMutableArray alloc] init];
    }
    
    return _selfieArray;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionViewCell* cell = (CollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    
    UIImageView *cellImageView = cell.imageView;
    UIImageView *expandableImageView = [[UIImageView alloc] initWithImage: cellImageView.image];
    expandableImageView.contentMode = cellImageView.contentMode;
    expandableImageView.frame = [self.view convertRect: cellImageView.frame fromView: cellImageView.superview];
    expandableImageView.userInteractionEnabled = YES;
    expandableImageView.clipsToBounds = YES;
    
    objc_setAssociatedObject(expandableImageView,"original_frame",[NSValue valueWithCGRect:expandableImageView.frame],OBJC_ASSOCIATION_RETAIN);
    
    [UIView transitionWithView:self.view
                      duration:0.5
                       options:UIViewAnimationOptionAllowAnimatedContent
                    animations:^{
                        [self.navigationController.view addSubview:expandableImageView];
                        expandableImageView.frame = self.view.bounds;
                    }
                    completion:^(BOOL finished) {
                        UITapGestureRecognizer *imageViewGesture = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(onTap:)];
                        [expandableImageView addGestureRecognizer:imageViewGesture];
                    }];
}

- (void)onTap:(UITapGestureRecognizer*)imageViewGesture
{
    [UIView animateWithDuration:0.5
                     animations:^{
                         imageViewGesture.view.frame = [objc_getAssociatedObject(imageViewGesture.view,"original_frame") CGRectValue];
                     }
                     completion:^(BOOL finished) {
                         [imageViewGesture.view removeFromSuperview];
                     }];
}

@end
