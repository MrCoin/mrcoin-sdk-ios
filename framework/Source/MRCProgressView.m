//
//  MRCProgressView.m
//  MrCoin iOS SDK
//
//  Created by Gabor Nagy on 04/10/15.
//  Copyright © 2015 MrCoin. All rights reserved.
//

#import "MRCProgressView.h"

#define TOP_MARGIN 60.0f
#define GRAY_COLOR          [UIColor colorWithWhite:0.5 alpha:1.0]
#define LIGHTGRAY_COLOR     [UIColor colorWithWhite:0.5 alpha:0.3]

@interface MRCProgressItemView : UIView

@property (nonatomic, getter=isSelected) BOOL selected;
@property (nonatomic) NSString  *title;
@property (nonatomic, readwrite) NSInteger itemIndex;

@property (nonatomic) UILabel *titleLabel;

- (instancetype)initWithFrame:(CGRect)frame index:(NSInteger)anIndex title:(NSString*)aTitle selected:(BOOL)isSelected;

@end


@implementation MRCProgressView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
//        UIColor *globalTint = [[[UIApplication sharedApplication] delegate] window].tintColor;
//        self.tintColor = globalTint;
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
//        UIColor *globalTint = [[[UIApplication sharedApplication] delegate] window].tintColor;
    }
    return self;
}
-(void)setSteps:(NSArray *)steps
{
    _steps = steps;
    for (int i=0; i<self.maxSteps; i++) {
        MRCProgressItemView *item = [[MRCProgressItemView alloc] initWithFrame:CGRectMake(0, 0, 20, 20) index:i title:_steps[i] selected:(i==_activeStep-1)];
        item.tintColor = self.tintColor;
        [self addSubview:item];
    }
}
- (NSInteger) maxSteps
{
    return _steps.count;
}

- (void)setActiveStep:(NSInteger)activeStep
{
    _activeStep = activeStep;
    for (UIView *view in self.subviews) {
        MRCProgressItemView *v = (MRCProgressItemView*)view;
        if(v) v.selected = (v.itemIndex == activeStep-1);
        [v setNeedsDisplay];
    }
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Create a gradient
    CGFloat colors [] = {
        1.0, 1.0, 1.0, 1.0,
        1.0, 1.0, 1.0, 0.0
    };
    CGFloat locations [] = {
        0.5, 1.0
    };
    
    CGColorSpaceRef baseSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(baseSpace, colors, locations, 2);
    CGColorSpaceRelease(baseSpace), baseSpace = NULL;
    
    CGContextSaveGState(context);
    
    // Gradient
    CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
    
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGGradientRelease(gradient), gradient = NULL;
    
    // Line
//    rect.size.height -= 25;
    CGContextSetStrokeColorWithColor(context, [LIGHTGRAY_COLOR CGColor]);
    CGContextSetLineWidth(context, 5.0);
    CGContextMoveToPoint(context, 0, TOP_MARGIN);
    CGContextAddLineToPoint(context, rect.size.width, TOP_MARGIN);
    CGContextDrawPath(context, kCGPathStroke);
    
    CGContextRestoreGState(context);
}
- (void)layoutSubviews
{
    CGRect rect = CGRectInset(self.bounds, 40, 0);
    CGRect itemSize = CGRectZero;
    CGFloat h = rect.size.height*0.33f;//rect.size.width/self.maxSteps;
//    h *= 0.5f;
    if(h > rect.size.height) h = rect.size.height;
    CGFloat w = rect.size.width/self.maxSteps;
    int i = 0;
    for (UIView *view in self.subviews) {
        itemSize.size = CGSizeMake(h, h);
        itemSize.origin.x = (w*i)+rect.origin.x+((w-h)*.5f);
        itemSize.origin.y = TOP_MARGIN-(h*.5f);
        view.frame = itemSize;
        [view setNeedsDisplay];
        i++;
    }
}

@end

@implementation MRCProgressItemView
- (instancetype)initWithFrame:(CGRect)frame index:(NSInteger)anIndex title:(NSString*)aTitle selected:(BOOL)isSelected
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selected = isSelected;
        self.title = aTitle;
        self.itemIndex = anIndex;
        //
        UIFont *titleFont = [UIFont fontWithName:@"HelveticaNeue" size:11.0f];
        UIColor *textColor = self.tintColor;
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = titleFont;
        _titleLabel.textColor = textColor;
        [self addSubview:_titleLabel];
    }
    return self;
}
- (void)drawRect:(CGRect)rect {
    CGFloat fontSize = 24.0f;
    if(_selected){
        rect = CGRectInset(rect, 3, 3);
    }else{
        rect = CGRectInset(rect, 15, 15);
        fontSize = 12.0f;
    }
    CGFloat h = rect.size.height;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextAddEllipseInRect(context, rect);
    CGContextSetLineWidth(context, 2.0);

    // Selected
    UIColor *textColor;
    if(_selected){
        CGContextSetFillColorWithColor(context, [self.tintColor CGColor]);
        CGContextDrawPath(context, kCGPathFill);
        textColor = [UIColor whiteColor];
    }else{
        CGContextSetStrokeColorWithColor(context, [GRAY_COLOR CGColor]);
        CGContextSetFillColorWithColor(context, [[UIColor whiteColor] CGColor]);
        CGContextDrawPath(context, kCGPathFillStroke);
        textColor = GRAY_COLOR;
    }
    
    // Number
    NSString *stepString = [NSString stringWithFormat:@"%@",[NSNumber numberWithInteger:_itemIndex+1]];
    UIFont *stepFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:fontSize];
    NSDictionary *stepAttributes = [[NSDictionary alloc] initWithObjectsAndKeys: stepFont, NSFontAttributeName,
                                     textColor,NSForegroundColorAttributeName,nil];
    CGSize stepStringSize = [stepString sizeWithAttributes:stepAttributes];
    CGRect stepItemSize = rect;
    stepItemSize.origin.x += (rect.size.width-stepStringSize.width)*0.5f;
    stepItemSize.origin.y += (rect.size.height-stepStringSize.height)*0.5f;
    stepItemSize.origin.y -= 1.0f;
    stepItemSize.size = stepStringSize;
    [stepString drawInRect:stepItemSize withAttributes:stepAttributes];
    
    // Title
    if(_selected){
        _titleLabel.textColor = self.tintColor;
        _titleLabel.alpha = 1.0f;
    }else{
        _titleLabel.alpha = 0.0f;
    }
    _titleLabel.text = _title;
    [_titleLabel sizeToFit];
    _titleLabel.center = CGPointMake(rect.origin.x+(rect.size.width*0.5f), 60.0f);

}

@end
