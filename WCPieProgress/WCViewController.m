//
//  WCPieView.m
//  WCSinglePie
//
//  Created by Pratik on 07/11/14.
//  Copyright (c) 2014 Wickr Inc. All rights reserved.
//

#import "WCViewController.h"
#import "WCPieProgressView.h"

@interface WCViewController ()

@property (nonatomic) BOOL isTimerValid;
@property (nonatomic, strong) IBOutlet WCPieProgressView *pieView;
@property (nonatomic, strong) NSTimer *animationTimer;
@property (nonatomic, strong) IBOutlet UIButton *timerButton;
@property (nonatomic, strong) IBOutlet UISlider *radiusSlider;
@property (nonatomic, strong) IBOutlet UISlider *progressSlider;

@end

static int progress = 0;

@implementation WCViewController

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void) viewDidLoad {
    [super viewDidLoad];
    self.height.constant = 15;
    self.pieView.strokeWidth = 1.0f;
    self.pieView.strokeColor = [UIColor redColor];
    [self.radiusSlider setValue:self.height.constant];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    progress = self.progressSlider.value;
    [self.pieView updateViewForSelectedPercentage:progress];
}

- (IBAction)reset {
    [self.animationTimer invalidate];
    self.isTimerValid = NO;
    [self.timerButton setTitle:@"Start" forState:UIControlStateNormal];
    if(self.pieView.isReversed) {
        progress = 100;
    } else {
        progress = 0;
    }
    [self.progressSlider setValue:progress];
    [self.pieView updateViewForSelectedPercentage:progress];
}

- (IBAction) updateTimer {
    if (!self.isTimerValid) {
        self.animationTimer = [NSTimer scheduledTimerWithTimeInterval: 0.1 target:self
                                                             selector:@selector(updateProgressView) userInfo:nil repeats:YES];
        self.isTimerValid = YES;
        [self.animationTimer fire];
        [self.timerButton setTitle:@"Stop" forState:UIControlStateNormal];
    }
    else {
        [self.animationTimer invalidate];
        self.isTimerValid = NO;
        [self.timerButton setTitle:@"Start" forState:UIControlStateNormal];
    }
}

- (IBAction) radiusSliderValueChanged {
    self.height.constant = self.radiusSlider.value;
    [self.pieView layoutIfNeeded];
    [self.pieView updateViewForSelectedPercentage:progress];
}

- (IBAction) flipProgress {
    progress = 100-progress;
    [self.progressSlider setValue:progress];
    self.pieView.isReversed = !self.pieView.isReversed;
    [self.pieView layoutIfNeeded];
    [self.pieView updateViewForSelectedPercentage:progress];
}

- (IBAction) progressSliderValuechanged {
    if (self.isTimerValid) {
        [self.animationTimer invalidate];
        self.isTimerValid = NO;
        [self.timerButton setTitle:@"Start" forState:UIControlStateNormal];
    }
    progress = self.progressSlider.value;
    [self.pieView updateViewForSelectedPercentage:progress];
}

- (void) updateProgressView {
    if (progress <= 100 && progress >=0) {
        if(self.pieView.isReversed) {
            progress = progress - 1;
            [self.progressSlider setValue:progress];
        }
        else {
            progress = progress+1;
            [self.progressSlider setValue:progress];
        }
        [self.pieView updateViewForSelectedPercentage:progress];
    }
    else {
        [self reset];
    }
}

@end
