//
//  ImageCollectionViewController.h
//  What I Really Want
//
//  Created by Roland Thomas on 6/17/15.
//  Copyright (c) 2015 Jedisware, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Gifts.h"
#import "MyCollectionViewCell.h"

@interface ImageCollectionViewController : UICollectionViewController <UICollectionViewDataSource, UICollectionViewDelegate>
@property (strong, nonatomic) IBOutlet UICollectionView *tblImages;
@property (nonatomic, retain) NSMutableArray *dataSource;//will be storing all the data
@property (nonatomic, retain) NSMutableArray *allKeys;//will be storing all the data

@property (nonatomic, retain) Gifts *selectedGift;
@property (strong, nonatomic) IBOutlet UICollectionViewCell *imageView;
@property (strong, nonatomic) IBOutlet UIImageView *myImageView;

@property (nonatomic,strong) UILongPressGestureRecognizer *lpgr;


- (IBAction)BackButtonClick:(id)sender;
@end
