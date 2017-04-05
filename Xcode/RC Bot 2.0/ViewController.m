//
//  ViewController.m
//  RC Bot 2.0
//
//  Created by Rakshith on 20/07/16.
//  Copyright © 2016 Rakshith. All rights reserved.
//

#import "ViewController.h"
#import <AudioToolbox/AudioServices.h>
#import "L3SDKIPCamViewer.h"
#import "L3SDKIPCam.h"


@interface ViewController ()

@end

@implementation ViewController

@synthesize streamView;



- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNetworkCommunication];
    self.turning.delegate = self;
    self.speed.delegate = self;
    self.back.image = [UIImage imageNamed:@"Black_background.jpg"];
    
    //tap gesture
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    tapGesture.numberOfTapsRequired = 2;
    [[self view] addGestureRecognizer:tapGesture];
    
    //swip gesture
    UISwipeGestureRecognizer *Dswipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleDownSwipe:)];
    [Dswipe setDirection:UISwipeGestureRecognizerDirectionDown];
    [Dswipe setDelaysTouchesBegan:YES];
    [[self sense] addGestureRecognizer:Dswipe];
    [Dswipe setNumberOfTouchesRequired:2];
    UISwipeGestureRecognizer *Uswipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleUpSwipe:)];
    [Uswipe setDirection:UISwipeGestureRecognizerDirectionUp];
    [Uswipe setDelaysTouchesBegan:YES];
    [[self sense] addGestureRecognizer:Uswipe];
    [Uswipe setNumberOfTouchesRequired:2];
   
    //IP Camera Stream
    L3SDKIPCam*ipCam1= [[L3SDKIPCam alloc]init];
    ipCam1.url=@"192.168.1.113:8080/?action=stream"; //change IP Address accordingly
    ipCam1.port=8080;
    
    self.streamView.delegate=self;
    self.streamView.ipCam=ipCam1;

    
   }

- (void)handleTapGesture:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateRecognized) {
        NSLog(@"tap detected");
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        [self initNetworkCommunication];
       // UIImage *IM = [self.streamView takePicture];
      //  UIImageWriteToSavedPhotosAlbum(IM, nil, nil, nil);
        
    }
}

- (void)handleDownSwipe:(UISwipeGestureRecognizer *)sender {
         if (sender.state == UIGestureRecognizerStateRecognized) {
          NSLog(@"Down swipe detected");
             [self alignDownControls];
             self.back.hidden = true;
             self.up.hidden = true;
             self.down.hidden = true;
             self.right.hidden = true;
             self.left.hidden = true;
             NSString   *number = [[NSString alloc] initWithFormat:@"st"];
             NSData *data = [[NSData alloc] initWithData:[number dataUsingEncoding:NSASCIIStringEncoding]];
             [_outputStream write:[data bytes] maxLength:[data length]];
             double delayInSeconds = 0.5;
             dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
             dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self.streamView play];
             });

             
         }
}

- (void)handleUpSwipe:(UISwipeGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateRecognized) {
        NSLog(@"Up swipe detected");
        self.back.hidden = false;
        self.up.hidden = false;
        self.down.hidden = false;
        self.right.hidden = false;
        self.left.hidden = false;
        [self alignUpControls];
        NSString   *number = [[NSString alloc] initWithFormat:@"sp"];
        NSData *data = [[NSData alloc] initWithData:[number dataUsingEncoding:NSASCIIStringEncoding]];
        [_outputStream write:[data bytes] maxLength:[data length]];
        double delayInSeconds = 0.5;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
             [self.streamView stop];
        });
    }
}

- (void)applicationEnteredForeground:(NSNotification *)notification {
    [self initNetworkCommunication];
}

- (BOOL)shouldAutorotate{
    return YES;
}
#if __IPHONE_OS_VERSION_MAX_ALLOWED < 90000
- (NSUInteger)supportedInterfaceOrientations
#else
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
#endif
{
    return UIInterfaceOrientationMaskLandscapeLeft;
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationLandscapeLeft;
}

-(void)alignDownControls {
    _rightcentre.constant = 55;
    _leftcentre.constant = 75;
    _righttrail.constant = 9;
    _lefttrail.constant = 39;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.speed setNeedsUpdateConstraints];
        [self.turning setNeedsUpdateConstraints];
        [UIView animateWithDuration:0.2f animations:^{[self.speed layoutIfNeeded];[self.turning layoutIfNeeded];}];});
    [self makeTransparent];
}

-(void)alignUpControls {
    _rightcentre.constant = 0;
    _leftcentre.constant = 0;
    _righttrail.constant = 59;
    _lefttrail.constant = 59;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.speed setNeedsUpdateConstraints];
        [self.turning setNeedsUpdateConstraints];
        [UIView animateWithDuration:0.2f animations:^{
            [self.speed layoutIfNeeded];
            [self.turning layoutIfNeeded];
        }];
    });
    [self makeOriginal];
}

-(void)makeTransparent {
    self.speed.handleImageView.image = [UIImage imageNamed:@"transparent_handle"];
    self.speed.backgroundImageView.image = nil;
    self.turning.handleImageView.image = [UIImage imageNamed:@"transparent_handle"];
    self.turning.backgroundImageView.image = nil;
}

-(void)makeOriginal {
    self.speed.handleImageView.image = [UIImage imageNamed:@"analogue_handle"];
    self.speed.backgroundImageView.image = [UIImage imageNamed:@"analogue_bg"];
    self.turning.handleImageView.image = [UIImage imageNamed:@"analogue_handle"];
    self.turning.backgroundImageView.image = [UIImage imageNamed:@"analogue_bg"];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - JSAnalogueStickDelegate

- (void)analogueStickDidChangeValue:(JSAnalogueStick *)analogueStick
{
    [self processAnalogControls];
}

-(void)processAnalogControls{
    int ScaledY = fabsf(floorf((float)self.speed.yValue*(255)));
    int ScaledX = fabsf(floorf((float)self.turning.xValue*(-30))+30);
   
    if(self.speed.yValue >= 0 && self.turning.xValue <= 0 )
    {//forward right
        if (ScaledY<10)
        {
          NSString   *number = [[NSString alloc] initWithFormat:@"FR00%d%d", ScaledY ,ScaledX];
            NSData *data = [[NSData alloc] initWithData:[number dataUsingEncoding:NSASCIIStringEncoding]];
            [_outputStream write:[data bytes] maxLength:[data length]];
        }
        else if(ScaledY<100)
        {
            NSString   *number = [[NSString alloc] initWithFormat:@"FR0%d%d", ScaledY ,ScaledX];
            NSData *data = [[NSData alloc] initWithData:[number dataUsingEncoding:NSASCIIStringEncoding]];
            [_outputStream write:[data bytes] maxLength:[data length]];
        }
        else{
           NSString   *number = [[NSString alloc] initWithFormat:@"FR%d%d", ScaledY ,ScaledX];
            NSData *data = [[NSData alloc] initWithData:[number dataUsingEncoding:NSASCIIStringEncoding]];
            [_outputStream write:[data bytes] maxLength:[data length]];

        }
   
    }
    else if (self.speed.yValue >= 0 && self.turning.xValue >= 0)
    {//forward left
        if (ScaledY<10)
        {
            NSString   *number = [[NSString alloc] initWithFormat:@"FL00%d%d", ScaledY ,ScaledX];
            NSData *data = [[NSData alloc] initWithData:[number dataUsingEncoding:NSASCIIStringEncoding]];
            [_outputStream write:[data bytes] maxLength:[data length]];
        }
        else if(ScaledY<100)
        {
            NSString   *number = [[NSString alloc] initWithFormat:@"FL0%d%d", ScaledY ,ScaledX];
            NSData *data = [[NSData alloc] initWithData:[number dataUsingEncoding:NSASCIIStringEncoding]];
            [_outputStream write:[data bytes] maxLength:[data length]];
        }
        else{
            NSString   *number = [[NSString alloc] initWithFormat:@"FL%d%d", ScaledY ,ScaledX];
            NSData *data = [[NSData alloc] initWithData:[number dataUsingEncoding:NSASCIIStringEncoding]];
            [_outputStream write:[data bytes] maxLength:[data length]];
            
        }

    }
    else if(self.speed.yValue <= 0 && self.turning.xValue <= 0)
    {//backward right
        if (ScaledY<10)
        {
            NSString   *number = [[NSString alloc] initWithFormat:@"BR00%d%d", ScaledY ,ScaledX];
            NSData *data = [[NSData alloc] initWithData:[number dataUsingEncoding:NSASCIIStringEncoding]];
            [_outputStream write:[data bytes] maxLength:[data length]];
        }
        else if(ScaledY<100)
        {
            NSString   *number = [[NSString alloc] initWithFormat:@"BR0%d%d", ScaledY ,ScaledX];
            NSData *data = [[NSData alloc] initWithData:[number dataUsingEncoding:NSASCIIStringEncoding]];
            [_outputStream write:[data bytes] maxLength:[data length]];
        }
        else{
            NSString   *number = [[NSString alloc] initWithFormat:@"BR%d%d", ScaledY ,ScaledX];
            NSData *data = [[NSData alloc] initWithData:[number dataUsingEncoding:NSASCIIStringEncoding]];
            [_outputStream write:[data bytes] maxLength:[data length]];
            
        }

    }
    else if(self.speed.yValue <= 0 && self.turning.xValue >= 0)
    {//backward left
        if (ScaledY<10)
        {
            NSString   *number = [[NSString alloc] initWithFormat:@"BL00%d%d", ScaledY ,ScaledX];
            NSData *data = [[NSData alloc] initWithData:[number dataUsingEncoding:NSASCIIStringEncoding]];
            [_outputStream write:[data bytes] maxLength:[data length]];
        }
        else if(ScaledY<100)
        {
            NSString   *number = [[NSString alloc] initWithFormat:@"BL0%d%d", ScaledY ,ScaledX];
            NSData *data = [[NSData alloc] initWithData:[number dataUsingEncoding:NSASCIIStringEncoding]];
            [_outputStream write:[data bytes] maxLength:[data length]];
        }
        else{
            NSString   *number = [[NSString alloc] initWithFormat:@"BL%d%d", ScaledY ,ScaledX];
            NSData *data = [[NSData alloc] initWithData:[number dataUsingEncoding:NSASCIIStringEncoding]];
            [_outputStream write:[data bytes] maxLength:[data length]];
        }
    }
}

#pragma mark - L3SDKIPCamViewerDelegate Delegate Methods
- (void)L3SDKIPCamViewer_ConnectionError:(NSError *)error{
    UIAlertView*alert=[[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

- (void)L3SDKIPCamViewer_AuthenticationRequired:(L3SDKIPCam*)ipCam sender:(L3SDKIPCamViewer*)sender {
    //do something, for instance you can set ipCam.username and ipCam.password and call again play on sender instance
}




- (void)initNetworkCommunication {
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    CFStreamCreatePairWithSocketToHost(NULL, (CFStringRef)@"192.168.1.113", 7777, &readStream, &writeStream); //change ip address accordingly.
    _inputStream = (NSInputStream *)CFBridgingRelease(readStream);
    _outputStream = (NSOutputStream *)CFBridgingRelease(writeStream);
    
    [_inputStream setDelegate:self];
    [_outputStream setDelegate:self];
    
    [_inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [_outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
    [_inputStream open];
    [_outputStream open];
    
}

@end
