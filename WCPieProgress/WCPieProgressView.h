//
//  WCPieProgressView.h
//  Wickr
//
//  Created by Pratik P. on 11/10/14.
//
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface WCPieProgressView : UIView {
    CAShapeLayer *mShapeLayer;
}

@property (nonatomic, strong) UIColor *fillColor;
@property (nonatomic, strong) UIColor *strokeColor;
@property (nonatomic) float strokeWidth;
@property (nonatomic) BOOL isReversed;

- (void)updateViewForSelectedPercentage:(CGFloat)selectedPercentage;

@end
