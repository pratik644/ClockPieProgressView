//
//  WCPieView.m
//  WCSinglePie
//
//  Created by Pratik on 07/11/14.
//  Copyright (c) 2014 Wickr Inc. All rights reserved.
//

#import "WCViewController.h"
#import "WCPieProgressView.h"
#import <CoreGraphics/CoreGraphics.h>
#import <QuartzCore/QuartzCore.h>

@interface WCViewController ()

@property (nonatomic, strong) NSTimer *animationTimer;
@property (nonatomic) BOOL isTimerValid;
@property (nonatomic, strong) IBOutlet WCPieProgressView *pieView;
@property (nonatomic, strong) IBOutlet UIButton *timerButton;
@property (nonatomic, strong) IBOutlet UISlider *radiusSlider;
@property (nonatomic, strong) IBOutlet UISlider *progressSlider;
@property (nonatomic, strong) IBOutlet UISlider *strokeWidthSlider;
@property (nonatomic, strong) IBOutletCollection(UIButton) NSArray *strokeColorButtons;
@property (nonatomic, strong) IBOutletCollection(UIButton) NSArray *fillColorButtons;
@property (nonatomic, strong) IBOutlet UISwitch *ticks;

@end

static int progress = 0;

@implementation WCViewController

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void) viewDidLoad {
    [super viewDidLoad];
    self.height.constant = 30;
    self.pieView.strokeWidth = 1.0f;
    self.pieView.strokeColor = [UIColor redColor];
    [self.radiusSlider setValue:self.height.constant];
    [self.strokeWidthSlider setValue:self.pieView.strokeWidth];
    [self.pieView setShowTicks:NO];
    
    for(UIButton *button in self.strokeColorButtons) {
        button.layer.cornerRadius = 20;
        button.layer.shadowOffset = CGSizeMake(3, 3);
        button.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        button.layer.shadowOpacity = 1.0f;
    }
    
    for(UIButton *button in self.fillColorButtons) {
        button.layer.cornerRadius = 20;
        button.layer.shadowOffset = CGSizeMake(3, 3);
        button.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        button.layer.shadowOpacity = 1.0f;
    }
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
    progress = 100 - progress;
    [self.progressSlider setValue:progress];
    self.pieView.isReversed = !self.pieView.isReversed;
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

- (IBAction) strokeWidthSliderValueChanged {
    self.pieView.strokeWidth = self.strokeWidthSlider.value;
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

- (IBAction)setDefaults {
    self.pieView.fillColor = [UIColor clearColor];
    self.pieView.strokeColor = [UIColor redColor];
    [self.pieView updateViewForSelectedPercentage:progress];
}

- (IBAction) setTint:(id)sender {
    self.pieView.strokeColor = ((UIButton*)sender).backgroundColor;
    [self.pieView updateViewForSelectedPercentage:progress];
}

- (IBAction) setFill:(id)sender {
    self.pieView.fillColor = ((UIButton*)sender).backgroundColor;
    [self.pieView updateViewForSelectedPercentage:progress];
}

- (IBAction)showTicks:(id)sender {
    [self.pieView setShowTicks:!self.pieView.showTicks];
    [self.pieView updateViewForSelectedPercentage:progress];
}

- (IBAction)showShadow:(id)sender {
    [self.pieView setShowShadow:!self.pieView.showShadow];
    [self.pieView updateViewForSelectedPercentage:progress];
}

@end
