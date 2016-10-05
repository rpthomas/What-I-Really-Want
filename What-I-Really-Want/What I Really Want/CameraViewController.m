//
//  CameraViewController.m
//  What I Really Want
//
//  Created by Roland Thomas on 6/15/15.
//  Copyright (c) 2015 Jedisware, LLC. All rights reserved.
//

#import "CameraViewController.h"
#import "Device.h"
#import "Utilities.h"
#import "ImageObject.h"
#import "Global.h"

@interface CameraViewController ()

@end

@implementation CameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.btnNewPhoto.layer.cornerRadius = 10;
    self.btnNewPhoto.layer.borderWidth = 2;
    self.btnNewPhoto.layer.borderColor = [UIColor blackColor].CGColor;
    
    self.btnFromLibrary.layer.cornerRadius = 10;
    self.btnFromLibrary.layer.borderWidth = 2;
    self.btnFromLibrary.layer.borderColor = [UIColor blackColor].CGColor;
    
    self.btnAttach.layer.cornerRadius = 10;
    self.btnAttach.layer.borderWidth = 2;
    self.btnAttach.layer.borderColor = [UIColor blackColor].CGColor;
    
    self.btnCancel.layer.cornerRadius = 10;
    self.btnCancel.layer.borderWidth = 2;
    self.btnCancel.layer.borderColor = [UIColor blackColor].CGColor;
    
    
    [self updateDisplay];
    
    if (self.image == nil)
    {
        self.btnAttach.enabled = false;
        self.btnAttach.backgroundColor = [UIColor lightGrayColor];
    }
}




- (IBAction)newPhotoClick:(id)sender {
    self.btnAttach.enabled = true;
    self.btnAttach.backgroundColor = [UIColor blueColor];

    [self pickMediaFromSource:UIImagePickerControllerSourceTypeCamera];
}

- (IBAction)fromLibraryClick:(id)sender {
    self.btnAttach.enabled = true;
    self.btnAttach.backgroundColor = [UIColor blueColor];
    
    [self pickMediaFromSource:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (IBAction)attachClick:(id)sender
{
    [self saveFile];
}


-(void)saveFile
{
    Utilities  *util = [[Utilities alloc]init];
    NSString *fileName = [util createFileName];
    
    ImageObject *img = [[ImageObject alloc]init];
    [img saveImage:self.image fileName:fileName];
    
    //Add file name to NSMutableArray
     Global *sharedManager = [Global sharedManager];
    [sharedManager imageFileNames:fileName];
    [self dismissViewControllerAnimated:YES completion:Nil];
}

- (IBAction)cancelClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:Nil];
}


#pragma mark - Image Picker Controller delegate methods
- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.lastChosenMediaType = info[UIImagePickerControllerMediaType];
    if ([self.lastChosenMediaType isEqual:(NSString *)kUTTypeImage])
    {
        UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
        //UIImage *shrunkenImage = [self shrinkImage:chosenImage
        //                                    toSize:self.imageView.bounds.size];
        //Image saved to class variable
        self.image = chosenImage;
        
        
        //Save the Image to Camera Roll
        UIImageWriteToSavedPhotosAlbum(self.image, nil, nil, nil);

    }
    else if ([self.lastChosenMediaType isEqual:(NSString *)kUTTypeMovie])
    {
        self.movieURL = info[UIImagePickerControllerMediaURL];
        
        NSString *movie = [self.movieURL absoluteString];
        
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:movie]];
        NSString *tempPath = [NSString stringWithFormat:@"%@/%@", NSTemporaryDirectory(), movie];
        [imageData writeToFile:movie atomically:NO];
        UISaveVideoAtPathToSavedPhotosAlbum (tempPath, self, @selector(video:didFinishSavingWithError: contextInfo:), nil);
        
        
        //Save the Video to Camera Roll
        //UISaveVideoAtPathToSavedPhotosAlbum(movie, nil, nil, nil);
        
        //UISaveVideoAtPathToSavedPhotosAlbum (movie, self, @selector(video:didFinishSavingWithError: contextInfo:), nil);
    }
    
    
    
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}



/*
 -(void) downloadVideo
 {
 NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://www.xyz.com/image.mp4"]];
 NSString *tempPath = [NSString stringWithFormat:@"%@/%@", NSTemporaryDirectory(), temp.mp4];
 [imageData writeToFile:tempPath atomically:NO];
 UISaveVideoAtPathToSavedPhotosAlbum (@ tempPath, self, @selector(video:didFinishSavingWithError: contextInfo:), nil);
 };
 */
- (void) video: (NSString *) videoPath didFinishSavingWithError: (NSError *) error
   contextInfo: (void *) contextInfo
{
    //NSLog(@"Finished saving video with error: %@", error);
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}


#pragma mark - Orientation - Locked in Portrait Mode



- (void)pickMediaFromSource:(UIImagePickerControllerSourceType)sourceType
{
    NSArray *media = [[NSArray alloc]initWithObjects:@"public.image", nil];
    
    //THE FOLLOWING LINE COMMENTED OUT, WE ONLY WANT IMAGES ALLOWED, NO VIDEO
    
    //NSArray *mediaTypes = [UIImagePickerController
    //availableMediaTypesForSourceType:sourceType];
    
    
    
    
    if ([UIImagePickerController isSourceTypeAvailable:
         sourceType] && [media count] > 0) {
        //NSArray *mediaTypes = [UIImagePickerController
        //availableMediaTypesForSourceType:sourceType];
        UIImagePickerController *picker =
        [[UIImagePickerController alloc] init];
        picker.mediaTypes =  media;           //mediaTypes;
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:NULL];
        picker.delegate = self;
    }else {
        
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Error accessing media"
                                      message:@"Device doesn’t support that media source."
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


- (UIImage *)shrinkImage:(UIImage *)original toSize:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, YES, 0);
    [original drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *final = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return final;
}


- (void)updateDisplay
{

    if ([self.lastChosenMediaType isEqual:(NSString *)kUTTypeImage]) {
        self.imageView.image = self.image;
        self.imageView.hidden = NO;
        //self.moviePlayerController.view.hidden = YES;
    }
    
    /*
    else if ([self.lastChosenMediaType isEqual:(NSString *)kUTTypeMovie]) {
        [self.moviePlayerController.view removeFromSuperview];
        self.moviePlayerController = [[MPMoviePlayerController alloc]
                                      initWithContentURL:self.movieURL];
        [self.moviePlayerController play];
        UIView *movieView = self.moviePlayerController.view;
        movieView.frame = self.imageView.frame;
        movieView.clipsToBounds = YES;
        [self.view addSubview:movieView];
        self.imageView.hidden = YES;
    }
     
     */
}


@end
