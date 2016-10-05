//
//  DetailsViewController.m
//  What I Really Want
//
//  Created by Roland Thomas on 6/13/15.
//  Copyright (c) 2015 Jedisware, LLC. All rights reserved.
//

#import "DetailsViewController.h"
#import "ImageCollectionViewController.h"
#import "Global.h"

@interface DetailsViewController ()

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self displayGift];
}

-(void)displayGift
{
    self.txtDetailsView.layer.cornerRadius = 20;
    self.txtDetailsView.layer.borderWidth = 4;
    self.txtDetailsView.layer.borderColor = [UIColor blackColor].CGColor;
    
    self.btnClose.layer.cornerRadius = 10;
    self.btnClose.layer.borderWidth = 2;
    self.btnClose.layer.borderColor = [UIColor blackColor].CGColor;
    
    self.btnViewImages.layer.cornerRadius = 10;
    self.btnViewImages.layer.borderWidth = 2;
    self.btnViewImages.layer.borderColor = [UIColor blackColor].CGColor;

    
    NSMutableString *displayText = [[NSMutableString alloc]init];
    [displayText setString:@"\n"];
    [displayText appendString:@"\n"];
    [displayText appendString:@"\n"];
    //[displayText appendString:@"\n"];
    //[displayText appendString:@"\n"];
    
    [displayText appendString:@"  Type of Item: "];
    [displayText appendString:_selectedGift.itemType];
    [displayText appendString:@"\n"];
    if (_selectedGift.itemBrand.length > 0) {
        [displayText appendString:@"  Brand Name / Designer: "];
        [displayText appendString:_selectedGift.itemBrand];
        [displayText appendString:@"\n"];
    }
    if (_selectedGift.size.length > 0) {
        [displayText appendString:@"  Size: "];
        [displayText appendString:_selectedGift.size];
        [displayText appendString:@"\n"];
    }
    if (_selectedGift.waist.length > 0) {
        [displayText appendString:@"  Waist: "];
        [displayText appendString:_selectedGift.waist];
        [displayText appendString:@"\n"];
    }
    if (_selectedGift.details.length > 0) {
        if ([_selectedGift.details rangeOfString:@"Details"].location == NSNotFound)
        {
            [displayText appendString:@"  Details: "];
        }
        else
        {
           [displayText appendString:@"  "];
        }
        
        [displayText appendString:_selectedGift.details];
        [displayText appendString:@"\n"];
    }
    
    _txtDetailsView.text = [NSString stringWithString:displayText];
    
    
    if ([_selectedGift.imageDict count] > 0)
        self.btnViewImages.hidden = false;
    else
        self.btnViewImages.hidden = true;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)CloseClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:Nil];
}



#pragma mark- Segue Methods-

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    @try {
        
        // Make sure your segue name in storyboard is the same as this line
        if ([[segue identifier] isEqualToString:@"showImages"])
        {
            Global *sharedManager = [Global sharedManager];
            [sharedManager gifts:_selectedGift];
            
            // NSLog(@"Selected Item %@", _selectedGift.itemType);
        }
        else
        {
            
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

@end
