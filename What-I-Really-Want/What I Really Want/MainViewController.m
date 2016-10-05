//
//  FirstViewController.m
//  What I Really Want
//
//  Created by Roland Thomas on 6/5/15.
//  Copyright (c) 2015 Jedisware, LLC. All rights reserved.
//

#import "MainViewController.h"
#import "DataBase.h"
#import "People.h"
#import "PeopleController.h"
#import "Utilities.h"
#import "AddEditPeopleViewController.h"
#import "Device.h"
#import "GiftListViewController.h"
#import "Global.h"
#import "GiftController.h"
#import "MobileCoreServices/MobileCoreServices.h"


@interface MainViewController ()

@end

@implementation MainViewController

static bool reloadFlag = false;
People *thisPerson;
BOOL isThisViewPortrait;
NSLayoutConstraint *constraint6;
BOOL blockDelete = false;


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    Global *sharedManager = [Global sharedManager];
    [sharedManager lastTabIndex:0];
    
    if (_sortedArray.count > 0)
    {
        reloadFlag = true;
        [self LoadPicker];
    }
    else
    {
        [self loadInitialView];
    }
    
  
    
    self.tabBarController.delegate = self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)loadInitialView
{
    [_PeoplePickerView setBackgroundColor:[UIColor blueColor]];
    
    self.PeoplePickerView.layer.cornerRadius = 10;
    self.PeoplePickerView.layer.borderWidth = 2;
    self.PeoplePickerView.layer.borderColor = [UIColor whiteColor].CGColor;
    
    self.btnAddPerson.layer.cornerRadius = 10;
    self.btnAddPerson.layer.borderWidth = 2;
    self.btnAddPerson.layer.borderColor = [UIColor whiteColor].CGColor;
    
    self.btnEditPerson.layer.cornerRadius = 10;
    self.btnEditPerson.layer.borderWidth = 2;
    self.btnEditPerson.layer.borderColor = [UIColor whiteColor].CGColor;
    
    self.btnRemovePerson.layer.cornerRadius = 10;
    self.btnRemovePerson.layer.borderWidth = 2;
    self.btnRemovePerson.layer.borderColor = [UIColor whiteColor].CGColor;
    
    
    DataBase *prep = [[DataBase alloc]init];
    [prep checkForDatabase];
    
    [self LoadPicker];
}




-(void)LoadPicker
{
    PeopleController *peopleControl = [[PeopleController alloc]init];
    _recDict = [peopleControl getPeople];
    _sortedArray = nil;
    
    Utilities *util = [[Utilities alloc]init];
    _sortedArray = [(NSArray*)[util convertDict_To_Array:_recDict sortArray:true descriptor:@"fName"] mutableCopy];

    if (reloadFlag)
    {
        reloadFlag = false;
        [_PeoplePickerView reloadAllComponents];
    }
}


#pragma mark - PickerView Delegate Methods

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)picker
{
    return 1; // For one column
}

-(NSInteger)pickerView:(UIPickerView *)picker numberOfRowsInComponent:(NSInteger)component
{
    return [_sortedArray count]; // Numbers of rows
}

-(NSString *)pickerView:(UIPickerView *)picker titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    People *thisPerson = [_sortedArray objectAtIndex:row];
    
    NSMutableString *theName = [[NSMutableString alloc]init];
    [theName setString:thisPerson.fName];
    [theName appendString:@" "];
    [theName appendString:thisPerson.lName];
                               
    return [NSString stringWithString: theName];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor whiteColor];
    label.textColor = [UIColor blackColor];
    label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18];
    label.textAlignment = NSTextAlignmentCenter;
    
    //WithFrame:CGRectMake(0, 0, pickerView.frame.size.width, 60)];
    
    if(component == 0)
    {
        People *thisPerson = [_sortedArray objectAtIndex:row];
        NSMutableString *theName = [[NSMutableString alloc]init];
        [theName setString:thisPerson.fName];
        [theName appendString:@" "];
        [theName appendString:thisPerson.lName];

        label.text = [NSString stringWithString: theName];
    }
    
    return label;
}

#pragma mark- Segue Methods-

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    @try {
        
        // Make sure your segue name in storyboard is the same as this line
        if ([[segue identifier] isEqualToString:@"AddPerson"])
        {
            
            // Get reference to the destination view controller
            AddEditPeopleViewController *add = [segue destinationViewController];
            add.shouldUpdatePerson = FALSE;
            
        }
        else if ([[segue identifier] isEqualToString:@"EditPerson"])
        {
            //Get the ID of the person being updated
            NSInteger row;
            row = [_PeoplePickerView selectedRowInComponent:0];
            People *thisPerson = [_sortedArray objectAtIndex:row];
            
            // Get reference to the destination view controller
            AddEditPeopleViewController *edit = [segue destinationViewController];
            edit.shouldUpdatePerson = TRUE;
            edit.personToUpdate = thisPerson;
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


- (IBAction)AddPersonClick:(id)sender {
}

- (IBAction)EditPersonClick:(id)sender {
}
- (IBAction)RemovePersonClick:(id)sender {
    if ([_sortedArray count] == 1)
    {
        blockDelete = true;
        [self showCannotDeleteAlert];
    }
    else
    {
        [self showConfirmAlert];
    }
}

- (void)showConfirmAlert
{
    
    NSInteger row;
    row = [_PeoplePickerView selectedRowInComponent:0];
    People *thisPerson = [_sortedArray objectAtIndex:row];
    
    
    NSMutableString *msg = [[NSMutableString alloc]init];
    [msg setString:@"Are you sure you want to deleted "];
    [msg appendString:thisPerson.fName];
    [msg appendString:@" "];
    [msg appendString:thisPerson.lName];
    [msg appendString:@"?"];
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Confirm"
                                  message:[NSString stringWithString: msg]
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    
    UIAlertAction* yes = [UIAlertAction
                         actionWithTitle:@"Yes"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             
                             if (blockDelete == false)
                             {

                                 NSInteger row;
                                 row = [_PeoplePickerView selectedRowInComponent:0];
                                 People *thisPerson = [_sortedArray objectAtIndex:row];
                                 
                                 PeopleController *personConrol = [[PeopleController alloc]init];
                                 if ([personConrol DeleteThisPerson:thisPerson])
                                 {
                                     reloadFlag = true;
                                     [self LoadPicker];
                                 }

                             }
                             else
                             {
                                 blockDelete = false;
                             }

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

- (void)showCannotDeleteAlert
{
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Unable to Delete"
                                  message:@"You cannot delete the last person in the Picker"
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

/*
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (blockDelete == false)
    {
        if (buttonIndex == 0)
        {
            
            NSInteger row;
            row = [_PeoplePickerView selectedRowInComponent:0];
            People *thisPerson = [_sortedArray objectAtIndex:row];
            
             //NSLog(@"This Person %@", thisPerson.fName);
            //NSLog(@"Person ID %@", thisPerson.people_id);
            
            PeopleController *personConrol = [[PeopleController alloc]init];
            if ([personConrol DeleteThisPerson:thisPerson])
            {
                reloadFlag = true;
                [self LoadPicker];
            }

        }
    }
    else
    {
        blockDelete = false;
    }
    
}
    */

/*
- (void)tabBarController:(UITabBarController *)tabBarController
 didSelectViewController:(UIViewController *)viewController
{
    NSLog(@"controller class: %@", NSStringFromClass([viewController class]));
    NSString *theClass = NSStringFromClass([viewController class]);
    
    if ([theClass isEqualToString:@"GiftListViewController"]) {
        NSInteger row;
        row = [_PeoplePickerView selectedRowInComponent:0];
        People *thisPerson = [_sortedArray objectAtIndex:row];

        Global *sharedManager = [Global sharedManager];
        [sharedManager activePerson:thisPerson];
        NSLog(@"Person: %@", thisPerson.fName);
    }
    
    
   }
*/


- (BOOL)tabBarController:(UITabBarController *)tabBarController
shouldSelectViewController:(UIViewController *)viewController
{
    //NSLog(@"controller class: %@", NSStringFromClass([viewController class]));
    NSString *theClass = NSStringFromClass([viewController class]);
    
    if ([theClass isEqualToString:@"GiftListViewController"]) {
        @try
        {
        NSInteger row;
            row = [_PeoplePickerView selectedRowInComponent:0];
            thisPerson = [_sortedArray objectAtIndex:row];
            
            Global *sharedManager = [Global sharedManager];
            [sharedManager activePerson:thisPerson];
            return true;
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
 
            return false;
        }
    }
    else if ([theClass isEqualToString:@"SendRequestViewController"]) {
        @try
        {
            NSInteger row;
            row = [_PeoplePickerView selectedRowInComponent:0];
            thisPerson = [_sortedArray objectAtIndex:row];
            
            Global *sharedManager = [Global sharedManager];
            [sharedManager activePerson:thisPerson];
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

            return false;
        }
        
        if([MFMessageComposeViewController respondsToSelector:@selector(canSendAttachments)] &&[MFMessageComposeViewController canSendAttachments] &&
           [MFMessageComposeViewController canSendText])
        {
            return true;
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
            
            return false;
        }
    }
    else if ([theClass isEqualToString:@"MainViewController"])
    {
        return true;
    }
    else
    {
        return false;
    }

}





@end
