//
//  ViewController.h
//  RC Bot 2.0
//
//  Created by Rakshith on 20/07/16.
//  Copyright © 2016 Rakshith. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioServices.h>
#import "JSAnalogueStick.h"
#import "L3SDKIPCamViewer.h"


@interface ViewController : UIViewController<JSAnalogueStickDelegate,NSStreamDelegate,UIGestureRecognizerDelegate,L3SDKIPCamViewerDelegate>

// Joystick Details
@property (weak, nonatomic) IBOutlet JSAnalogueStick *turning;
@property (weak, nonatomic) IBOutlet JSAnalogueStick *speed;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *turningheight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *turningwidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lefttrail;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftcentre;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *righttrail;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightcentre;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *speedheight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *speedwidth;

//camera stream
@property (weak, nonatomic) IBOutlet L3SDKIPCamViewer *streamView;

//gesture region
@property (weak, nonatomic) IBOutlet UIView *sense;

// Networking Details
@property (nonatomic, retain) NSInputStream *inputStream;
@property (nonatomic, retain) NSOutputStream *outputStream;

//imageviews
@property (weak, nonatomic) IBOutlet UIImageView *back;
@property (weak, nonatomic) IBOutlet UIImageView *right;
@property (weak, nonatomic) IBOutlet UIImageView *left;
@property (weak, nonatomic) IBOutlet UIImageView *up;
@property (weak, nonatomic) IBOutlet UIImageView *down;


@end

