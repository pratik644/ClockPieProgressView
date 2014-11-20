//
//  WCPieProgressView.m
//  Wickr
//
//  Created by Pratik P. on 11/10/14.
//
//

#import "WCPieProgressView.h"

@interface WCPieProgressView()
@property (nonatomic, assign) CGFloat progress;
- (CAShapeLayer *) createPieSliceForRadian:(CGFloat)angle;

@end

@implementation WCPieProgressView

- (instancetype)init {
    self = [super init];
    if(self) {
        self.fillColor = [UIColor clearColor];
        self.strokeColor = self.tintColor;
        self.strokeWidth = 1.0f;
        self.opaque = NO;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, rect);
    [self updateViewForSelectedPercentage:self.progress];
}

#pragma mark - Public methods

- (void)updateViewForSelectedPercentage:(CGFloat)selectedPercentage {
    self.progress = selectedPercentage;
    //bring percentage in range 0 to 100
    if(selectedPercentage < 0) {
        selectedPercentage = 0.0;
    }
    
    if(selectedPercentage > 100) {
        selectedPercentage = 100;
    }
    
    CGFloat angle = (selectedPercentage * 2*M_PI)/100;
    
    //remove prevoius shape layer
    [mShapeLayer removeFromSuperlayer];
    
    //create and add new shape layer drwan according to percentage
    mShapeLayer = [self createPieSliceForRadian:angle];
    [self.layer addSublayer:mShapeLayer];
}

#pragma mark - Private method

- (UIBezierPath *) drawTickAtAngle:(float)angle {
    
    CAShapeLayer *slice = [CAShapeLayer layer];
    slice.fillColor = self.fillColor.CGColor;
    slice.strokeColor = self.strokeColor.CGColor;
    slice.lineWidth = self.strokeWidth;
    
    CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    CGFloat radius = self.bounds.size.width/2;
    
    UIBezierPath *piePath = [UIBezierPath bezierPath];
    [piePath moveToPoint:CGPointMake(center.x + (radius-((radius*37.5f)/100)) * cosf(angle), center.y + (radius-((radius*37.5f)/100)) * sinf(angle))];
    [piePath addLineToPoint:CGPointMake(center.x + (radius-((radius*15)/100)) * cosf(angle), center.y + (radius-((radius*15)/100)) * sinf(angle))];
    [piePath closePath]; // this will automatically add a straight line to the center
    
    return piePath;
}


- (CAShapeLayer *)createPieSliceForRadian:(CGFloat)angle {
    
    CAShapeLayer *slice = [CAShapeLayer layer];
    slice.fillColor = self.fillColor.CGColor;
    slice.strokeColor = self.strokeColor.CGColor;
    slice.lineWidth = self.strokeWidth;
    [slice setPosition:CGPointMake(0.5f, 0.5f)];
    CGFloat startAngle = -M_PI_2;
    
    CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    CGFloat radius = self.bounds.size.width/2;
    
    UIBezierPath *piePath = [UIBezierPath bezierPath];
    [piePath moveToPoint:center];
    [piePath addLineToPoint:CGPointMake(center.x + radius * cosf(startAngle), center.y + radius * sinf(startAngle))];
    [piePath addArcWithCenter:center radius:radius startAngle:startAngle endAngle:(angle - M_PI_2) clockwise:YES];
    [piePath closePath]; // this will automatically add a straight line to the center
    
    CGMutablePathRef combinedPath = CGPathCreateMutableCopy(piePath.CGPath);
    for(float i = 0; i < 360.0f; i = i + 45.0f) {
        if(radius > 0) {
            CGPathAddPath(combinedPath, NULL, [self drawTickAtAngle:((i) / 180.0 * M_PI)].CGPath);
        }
    }
    
    slice.path = combinedPath;
    
    if (angle > ((2 * M_PI) - 0.000001)) {
        UIBezierPath *bPath = [UIBezierPath bezierPathWithArcCenter:center
                                                             radius:radius
                                                         startAngle:0
                                                           endAngle:2 * M_PI
                                                          clockwise:YES];
        
        CGMutablePathRef combinedPath = CGPathCreateMutableCopy(bPath.CGPath);
        for(float i = 0; i < 360.0f; i = i + 45.0f) {
            if(radius > 0) {
                CGPathAddPath(combinedPath, NULL, [self drawTickAtAngle:((i) / 180.0 * M_PI)].CGPath);
            }
        }
        slice.path = combinedPath;
    }
    
    if (angle <= 0) {
        UIBezierPath *aPath = [[UIBezierPath alloc] init];
        CGMutablePathRef combinedPath = CGPathCreateMutableCopy(aPath.CGPath);
        for(float i = 0; i < 360.0f; i = i + 45.0f) {
            CGPathAddPath(combinedPath, NULL, [self drawTickAtAngle:((i) / 180.0 * M_PI)].CGPath);
        }
        slice.path = combinedPath;
    }
    
    if(self.isReversed) {
        slice.transform = CATransform3DTranslate(CATransform3DRotate(CATransform3DMakeTranslation(self.frame.size.width/2, 0, 0), M_PI, 0, 1, 0), -self.frame.size.width/2, 0, 0);
    }
    
    return slice;
}

@end
