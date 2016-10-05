//
//  GiftListViewController.h
//  What I Really Want
//
//  Created by Roland Thomas on 6/5/15.
//  Copyright (c) 2015 Jedisware, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "People.h"

@interface GiftListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate>
@property (nonatomic, retain) People *currentPerson;
@property (nonatomic, retain) NSMutableDictionary *recDict;
@property (nonatomic, retain) NSArray *keys;
@property (strong, nonatomic) NSMutableArray *sortedArray;
@property (strong, nonatomic) IBOutlet UITableView *tblGiftList;
@property (strong, nonatomic) IBOutlet UILabel *lblTitla;

@property (strong, nonatomic) IBOutlet UIButton *btnAddGift;

@property (strong, nonatomic) IBOutlet UIButton *btnEditGift;

@end

