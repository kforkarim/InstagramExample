//
//  InstagramCollectionViewController.m
//  InstagramExercise
//
//  Created by Karim Abdul on 1/22/15.
//  Copyright (c) 2015 Karim Abdul. All rights reserved.
//

#import "InstagramCollectionViewController.h"
#import "CollectionViewCell.h"

@interface InstagramCollectionViewController ()

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
    return 20;
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
    
    int i = indexPath.row % 3;
    
    if (i == 0 ) {
        CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CellOne" forIndexPath:indexPath];
        cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"google.png"]];
        return cell;
    }
    
    else if (i == 1) {
        CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CellTwo" forIndexPath:indexPath];
        cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"test1.jpg"]];
        return cell;
    }
    
    
    else if (i == 2) {
        CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CellThree" forIndexPath:indexPath];
        cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"test2.png"]];
        return cell;
    }

    return nil;
}

@end
