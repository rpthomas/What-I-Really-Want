//
//  SendRequestViewController.m
//  What I Really Want
//
//  Created by Roland Thomas on 6/7/15.
//  Copyright (c) 2015 Jedisware, LLC. All rights reserved.
//

#import "SendRequestViewController.h"
#import "Global.h"
#import "GiftController.h"
#import "ImageObject.h"
#import "MobileCoreServices/MobileCoreServices.h"


@interface SendRequestViewController ()

@end

@implementation SendRequestViewController

MFMessageComposeViewController *messageVC;
NSMutableString *currentPersonsName;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    currentPersonsName = [[NSMutableString alloc]init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    @try
    {
        Global *sharedManager = [Global sharedManager];
        _currentPerson = [sharedManager activePerson];
        
        [currentPersonsName setString: [self checkLastCharacter:_currentPerson]];
        
        messageVC = [[MFMessageComposeViewController alloc] init];
        
        [self loadData:_currentPerson];
        [self ShowTextView];
    }
    @catch (NSException *exception)
    {
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:exception.name
                                      message:exception.reason
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

}


-(NSString *)checkLastCharacter:(People *)thisPerson
{
    NSMutableString *title = [[NSMutableString alloc]init];
    
    
    
    if ([thisPerson.fName isEqualToString:@"MySelf"])
    {
        [title setString:@"My Wish List"];
    }
    else
    {
        if (thisPerson.lName.length > 1) {
            [title setString:thisPerson.fName];
            [title appendString:@" "];
            
            if([thisPerson.lName hasSuffix:@"s"] || [thisPerson.lName hasSuffix:@"S"])
            {
                [title appendString:thisPerson.lName];
                [title appendString:@"' "];
                [title appendString:@"Wish List"];
            }
            else
            {
                [title appendString:thisPerson.lName];
                [title appendString:@"'s "];
                [title appendString:@"Wish List"];
            }
        }
        else
        {
            [title setString:thisPerson.fName];
            
            if([thisPerson.fName hasSuffix:@"s"] || [thisPerson.fName hasSuffix:@"S"])
            {
                [title appendString:@"' "];
                [title appendString:@"Wish List"];
            }
            else
            {
                [title appendString:@"'s "];
                [title appendString:@"Wish List"];
            }
        }
    }
    
    return [NSString stringWithString:title];
    
}


-(void)ShowTextView
{
    
    messageVC.body = [NSString stringWithString:_message];
    //messageVC.recipients = _phoneNumberArray;
    
    
    // These checks basically make sure it's an MMS capable device with iOS7
    if([MFMessageComposeViewController respondsToSelector:@selector(canSendAttachments)] && [MFMessageComposeViewController canSendAttachments] &&
       [MFMessageComposeViewController canSendText])
    {
        @try
        {
            messageVC.messageComposeDelegate = self;
            [self presentViewController:messageVC animated:NO completion:NULL];

        }
        @catch (NSException *exception)
        {
            UIAlertController * alert=   [UIAlertController
                                          alertControllerWithTitle:exception.name
                                          message:exception.reason
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
    }
    else
    {
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Device cannot send message"
                                      message:@"This device cannot send text and/or attachments."
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
    

}


- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    switch (result) {
        case MessageComposeResultCancelled:
            //NSLog(@"Message was cancelled");
            [self dismissViewControllerAnimated:YES completion:NULL];
            break;
        case MessageComposeResultFailed:
            //NSLog(@"Message failed");
            [self dismissViewControllerAnimated:YES completion:NULL];
            break;
        case MessageComposeResultSent:
            //NSLog(@"Message was sent");
            [self dismissViewControllerAnimated:YES completion:NULL];
            break;
        default:
            [self dismissViewControllerAnimated:YES completion:NULL];
            break;
    }
    
    Global *sharedManager = [Global sharedManager];
    [self.tabBarController setSelectedIndex:[sharedManager lastTabIndex]];
}


-(void)loadData:(People *)currentPerson
{
    ImageObject  *img = [[ImageObject alloc]init];
    
    //NSLog(@"People ID: %@", _currentPerson.people_id);
    GiftController *gifts = [[GiftController alloc]init];
    _recDict = [gifts loadGiftsByPeopleID:_currentPerson.people_id];

    self.keys = [[_recDict allKeys]sortedArrayUsingSelector:@selector(compare:)];
    
    _message = [[NSMutableString alloc]init];
    
    [_message setString:[NSString stringWithString:currentPersonsName]];
    [_message appendString:@"\n"];
    [_message appendString:@"\n"];
    [_message appendString:@"What I Really Want Is:"];
    [_message appendString:@"\n"];
    [_message appendString:@"\n"];
    
    _dataSource = [[NSMutableArray alloc]init];
    
    for (int x = 0; x < _keys.count; x++)
    {
        NSString *key = [_keys objectAtIndex:x];
        NSArray *giftArray = [_recDict objectForKey:key];

        [_message appendString:key];
        [_message appendString:@"\n"];

        for (int y = 0; y < giftArray.count; y++)
        {
            
            Gifts *selectedGift = [giftArray objectAtIndex:y];
            
            //Retrieve the images from the gift
            id imgKey;
            for (imgKey in [selectedGift.imageDict allKeys])
            {
                //NSLog(@"Key: %@", imgKey);
                
                //NSLog(@"Object: %@", [selectedGift.imageDict objectForKey:imgKey]);
                
                [_dataSource addObject:[selectedGift.imageDict objectForKey:imgKey]];
            }
            

            
            [_message appendString:@"  Type of Item: "];
            [_message appendString:selectedGift.itemType];
            [_message appendString:@"\n"];
            if (selectedGift.itemBrand.length > 0) {
                [_message appendString:@"  Brand Name / Designer: "];
                [_message appendString:selectedGift.itemBrand];
                [_message appendString:@"\n"];
            }
            if (selectedGift.size.length > 0) {
                [_message appendString:@"  Size: "];
                [_message appendString:selectedGift.size];
                [_message appendString:@"\n"];
            }
            if (selectedGift.waist.length > 0) {
                [_message appendString:@"  Waist: "];
                [_message appendString:selectedGift.waist];
                [_message appendString:@"\n"];
            }
            if (selectedGift.details.length > 0) {
                if ([selectedGift.details rangeOfString:@"Details"].location == NSNotFound)
                {
                    [_message appendString:@"  Details: "];
                }
                else
                {
                    [_message appendString:@"  "];
                }
                
                [_message appendString:selectedGift.details];
                [_message appendString:@"\n"];
                [_message appendString:@"\n"];
            }

        }
        
    }
    
    for (int imgCount = 0; imgCount < _dataSource.count; imgCount++)
    {
        UIImage *myImage = [img loadImage:[_dataSource objectAtIndex:imgCount]];

        NSData* attachment = UIImageJPEGRepresentation(myImage, 1.0);
          //NSLog(@"FileName: %@", [_dataSource objectAtIndex:imgCount]);
    
        NSString* uti = (NSString*)kUTTypeMessage;
        [messageVC addAttachmentData:attachment typeIdentifier:uti filename:[_dataSource objectAtIndex:imgCount]];
        
    }
    
    [_dataSource removeAllObjects];
    
    [_message appendString:@"Sent from the App: 'What I Really Want'"];
}






@end
