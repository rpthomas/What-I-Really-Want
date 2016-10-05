//
//  CameraViewController.h
//  What I Really Want
//
//  Created by Roland Thomas on 6/15/15.
//  Copyright (c) 2015 Jedisware, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
/*#import <MediaPlayer/MediaPlayer.h>*/
#import <MobileCoreServices/UTCoreTypes.h>


@interface CameraViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIButton *btnNewPhoto;
@property (strong, nonatomic) IBOutlet UIButton *btnFromLibrary;
@property (strong, nonatomic) IBOutlet UIButton *btnAttach;
@property (strong, nonatomic) IBOutlet UIButton *btnCancel;

/*@property (strong, nonatomic) AVPlayerViewController *moviePlayerController;*/
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) NSURL *movieURL;
@property (copy, nonatomic) NSString *lastChosenMediaType;

- (IBAction)newPhotoClick:(id)sender;
- (IBAction)fromLibraryClick:(id)sender;
- (IBAction)attachClick:(id)sender;
- (IBAction)cancelClick:(id)sender;


@end
