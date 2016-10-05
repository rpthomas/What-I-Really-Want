//
//  ImageCollectionViewController.m
//  What I Really Want
//
//  Created by Roland Thomas on 6/17/15.
//  Copyright (c) 2015 Jedisware, LLC. All rights reserved.
//

#import "ImageCollectionViewController.h"
#import "ImageObject.h"
#import "Global.h"
#import "FullSizeViewController.h"
#import "GiftController.h"


@interface ImageCollectionViewController ()

@end

@implementation ImageCollectionViewController

static NSString * const reuseIdentifier = @"Cell";
UIImage *chosenImage;
NSMutableString *lastFileName;
NSMutableString *lastIdentifier;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    lastFileName = [[NSMutableString alloc]init];
    lastIdentifier = [[NSMutableString alloc]init];
    
    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    self.lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGestures:)];
    self.lpgr.minimumPressDuration = 1.0f;
    self.lpgr.allowableMovement = 100.0f;
    
    [self.view addGestureRecognizer:self.lpgr];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self preProcessData];
}

#pragma mark -- Gestures
- (void)handleLongPressGestures:(UILongPressGestureRecognizer *)sender
{
    if ([sender isEqual:self.lpgr]) {
        if (sender.state == UIGestureRecognizerStateBegan)
        {
            
            
            UIAlertController * alert=   [UIAlertController
                                          alertControllerWithTitle:@"Confirm"
                                          message:@"Would you like to delete this image?"
                                          preferredStyle:UIAlertControllerStyleAlert];
            
            
            UIAlertAction* yes = [UIAlertAction
                                  actionWithTitle:@"Yes"
                                  style:UIAlertActionStyleDefault
                                  handler:^(UIAlertAction * action)
                                  {
                                      
                                      [self deleteImage];
                                      [alert dismissViewControllerAnimated:YES completion:nil];
                                      
                                  }];
            UIAlertAction* no = [UIAlertAction
                                 actionWithTitle:@"No"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                     
                                 }];
            
            [alert addAction:yes];
            [alert addAction:no];
            
            [self presentViewController:alert animated:YES completion:nil];


        }
    }
}

#pragma mark -- Alerts


/*
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{

        if (buttonIndex == 0)
        {
            [self deleteImage];
        }
}
*/

-(void)deleteImage
{
    GiftController *control = [[GiftController alloc]init];
    [control deleteImage:lastFileName];
    
    [_selectedGift.imageDict removeObjectForKey:lastIdentifier];
    NSLog(@"Count: %lu", (unsigned long)[_selectedGift.imageDict count]);
    [self reloadData];
}



#pragma mark - Pre-process data for table and cells
/*======================================================*/

- (void)preProcessData
{
    //Load the dictionary values into an array,
    //in preparation of building the table view
    
    _dataSource = [[NSMutableArray alloc]init];
    _allKeys = [[NSMutableArray alloc]init];
    
    Global *sharedManager = [Global sharedManager];
    _selectedGift = [sharedManager gifts];

    id key;
    for (key in [_selectedGift.imageDict allKeys])
    {
        NSLog(@"Key: %@", key);
        
        NSLog(@"Object: %@", [_selectedGift.imageDict objectForKey:key]);
        
        [_dataSource addObject:[_selectedGift.imageDict objectForKey:key]];
        [_allKeys addObject:key];
        
        NSLog(@"Key: %@", key);
    }
    
    //NSLog(@"Count: %lu", (unsigned long)[_dataSource count]);

    self.tblImages.delegate = self;
    self.tblImages.dataSource = self;
    [self.tblImages reloadData];
}

- (void)reloadData
{
    //Load the dictionary values into an array,
    //in preparation of building the table view
    
    [_dataSource removeAllObjects];
    [_allKeys removeAllObjects];
    
    
    id key;
    for (key in [_selectedGift.imageDict allKeys])
    {
        //NSLog(@"Key: %@", key);
        
        //NSLog(@"Object: %@", [_selectedGift.imageDict objectForKey:key]);
        
        [_dataSource addObject:[_selectedGift.imageDict objectForKey:key]];
        [_allKeys addObject:key];
    }
    
    //NSLog(@"Count: %lu", (unsigned long)[_dataSource count]);
    
    self.tblImages.delegate = self;
    self.tblImages.dataSource = self;
    [self.tblImages reloadData];
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    //NSLog(@"Count: %lu", (unsigned long)[_dataSource count]);
    
    return [_dataSource count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = nil;
    identifier = @"mainCell";
    
    MyCollectionViewCell *myCell = [collectionView
                dequeueReusableCellWithReuseIdentifier:identifier
                forIndexPath:indexPath];
    

    ImageObject  *img = [[ImageObject alloc]init];
    myCell.imageView.image = [img loadImage:[_dataSource objectAtIndex:indexPath.row]];
    myCell.accessibilityLabel = [_dataSource objectAtIndex:indexPath.row];
    myCell.accessibilityIdentifier  = [_allKeys objectAtIndex:indexPath.row];
    
    NSLog(@"Accessibility Label: %@", myCell.accessibilityLabel);
    NSLog(@"Accessibility Identifier: %@", myCell.accessibilityIdentifier);
    return myCell;

}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell =[collectionView cellForItemAtIndexPath:indexPath];
    UIImageView *imgView = cell.contentView.subviews[0];
    chosenImage = imgView.image;
    
    [self performSegueWithIdentifier:@"fullSize" sender:self];
}


- (BOOL)collectionView:(UICollectionView *)collectionView
shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell =[collectionView cellForItemAtIndexPath:indexPath];
    [lastFileName setString:cell.accessibilityLabel];
    [lastIdentifier setString:cell.accessibilityIdentifier];
    
    //NSLog(@"Accessibility Label: %@", cell.accessibilityLabel);
    return true;
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    @try {
        
        // Make sure your segue name in storyboard is the same as this line
        if ([[segue identifier] isEqualToString:@"fullSize"])
        {
            // Get reference to the destination view controller
            FullSizeViewController *fz = [segue destinationViewController];
            fz.chosenImage = chosenImage;
        }
    }
    @catch (NSException * e) {
        
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Error occurred"
                                      message:e.description
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
        
        [alert addAction:ok];
        
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    @finally {
        //NSLog(@"finally");
    }
    
}




- (IBAction)BackButtonClick:(id)sender {
    
     [self dismissViewControllerAnimated:YES completion:Nil];
}
@end
