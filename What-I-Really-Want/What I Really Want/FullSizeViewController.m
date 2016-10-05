//
//  FullSizeViewController.m
//  What I Really Want
//
//  Created by Roland Thomas on 6/18/15.
//  Copyright (c) 2015 Jedisware, LLC. All rights reserved.
//

#import "FullSizeViewController.h"

@interface FullSizeViewController ()

@end

@implementation FullSizeViewController

CGFloat scale, previousScale;
CGFloat rotation, previousRotation;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    previousScale = 1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.title = @"Full Size";
    [self loadImage];
}

- (void)loadImage
{
    
    _fullSizeImageView.image = _chosenImage;
    
    //    NSString *deviceType = [sharedGlobals deviceModel];
    
    @try {
        
        UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(doPinch:)];
        
        pinchGesture.delegate = self;
        [self.fullSizeImageView addGestureRecognizer:pinchGesture];
        
        UIRotationGestureRecognizer *rotationGesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(doRotate:)];
        rotationGesture.delegate = self;
        [self.fullSizeImageView addGestureRecognizer:rotationGesture];
        
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

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSmultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}


- (void)transformImageView
{
    CGAffineTransform t = CGAffineTransformMakeScale(scale * previousScale, scale * previousScale);
    t = CGAffineTransformRotate(t, rotation + previousRotation);
    self.fullSizeImageView.transform = t;
}


- (void)doPinch:(UIPinchGestureRecognizer *)gesture
{
    scale = gesture.scale;
    [self transformImageView];
    if (gesture.state == UIGestureRecognizerStateEnded) {
        previousScale = scale * previousScale;
        scale = 1;
    }
}


- (void)doRotate:(UIRotationGestureRecognizer *)gesture
{
    rotation = gesture.rotation;
    [self transformImageView];
    if (gesture.state == UIGestureRecognizerStateEnded) {
        previousRotation = rotation + previousRotation;
        rotation = 0;
    }
    
}


@end
