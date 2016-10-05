//
//  SendRequestViewController.h
//  What I Really Want
//
//  Created by Roland Thomas on 6/7/15.
//  Copyright (c) 2015 Jedisware, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "People.h"
#import "MobileCoreServices/MobileCoreServices.h"

@interface SendRequestViewController : UIViewController <MFMessageComposeViewControllerDelegate>
@property (nonatomic, retain) People *currentPerson;
@property (nonatomic, retain) NSMutableDictionary *recDict;
@property (nonatomic, retain) NSArray *keys;
@property (nonatomic, retain) NSMutableString *message;
@property (nonatomic, retain) NSMutableArray *dataSource;//will be storing all the data
@end
