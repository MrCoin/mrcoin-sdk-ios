//
//  MRCProgressView.m
//  MrCoin iOS SDK
//
//  Created by Gabor Nagy on 04/10/15.
//  Copyright © 2015 MrCoin. All rights reserved.
//

#import "MRCProgressView.h"
#import "MrCoin.h"

#define TOP_MARGIN 60.0f
#define GRAY_COLOR          [UIColor colorWithWhite:0.5 alpha:1.0]
#define LIGHTGRAY_COLOR     [UIColor colorWithWhite:0.5 alpha:0.3]

@interface MRCProgressItemView : UIView

@property (nonatomic, getter=isSelected) BOOL selected;
@property (nonatomic, readwrite) NSInteger itemIndex;

@property (nonatomic) NSString  *title;
@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UIButton *closeImage;

- (instancetype)initWithFrame:(CGRect)frame index:(NSInteger)anIndex title:(NSString*)aTitle selected:(BOOL)isSelected closeTarget:(id)target;

@end


@implementation MRCProgressView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = YES;
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
-(void)setStepLabels:(NSArray *)steps
{
    [self setActiveStep:0];
    _stepLabels = steps;
    if(self.showCloseButton){
        MRCProgressItemView *item = [[MRCProgressItemView alloc] initWithFrame:CGRectMake(0, 0, 20, 20) index:NSIntegerMax title:nil selected:true closeTarget:self];
        item.tintColor = self.tintColor;
        [self addSubview:item];
    }
    for (int i=0; i<_stepLabels.count; i++) {
        MRCProgressItemView *item = [[MRCProgressItemView alloc] initWithFrame:CGRectMake(0, 0, 20, 20) index:i title:_stepLabels[i] selected:(i==_activeStep-1) closeTarget:nil];
        item.tintColor = self.tintColor;
        [self addSubview:item];
    }
}
- (IBAction) closePressed:(id)sender
{
    if(self.delegate){
        [self.delegate progressViewClosed:self];
    }
}
- (NSInteger) maxSteps
{
    if(self.showCloseButton) return _stepLabels.count+1;
    return _stepLabels.count;
}

- (void)setActiveStep:(NSInteger)activeStep
{
    _activeStep = activeStep;
    for (UIView *view in self.subviews) {
        MRCProgressItemView *v = (MRCProgressItemView*)view;
        if(v.itemIndex >= 0){
            if(v) v.selected = (v.itemIndex == activeStep-1);
            [v setNeedsDisplay];
        }
    }
    [self layoutSubviews];
}
- (void)setActiveStepByName:(NSString*)name
{
    NSInteger activeStep = 0;
    for (int i=0; i<_stepLabels.count; i++) {
        if([name isEqualToString:(NSString*)_stepLabels[i]])
        {
            activeStep = i+1;
            break;
        }
    }
    [self setActiveStep:activeStep];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    CGContextSetStrokeColorWithColor(context, [LIGHTGRAY_COLOR CGColor]);
    
//    CGFloat h = 100.0f;
//    CGFloat y = TOP_MARGIN+(2.5f);
    CGFloat h = 5.0f;
    CGFloat y = TOP_MARGIN-(2.5f);
    
    CGContextSetLineWidth(context, h);
    CGContextMoveToPoint(context, 0, y);
    CGContextAddLineToPoint(context, rect.size.width, y);
    CGContextDrawPath(context, kCGPathStroke);
    
    CGContextRestoreGState(context);
}
- (void)layoutSubviews
{
    CGRect rect = CGRectInset(self.bounds, 40, 0);
    CGRect itemSize = CGRectZero;
    CGFloat h = rect.size.height*0.5f;//rect.size.width/self.maxSteps;
    //    h *= 0.5f;
    if(h > rect.size.height) h = rect.size.height;
    CGFloat w = rect.size.width/self.maxSteps;
    int i = 0;
    CGFloat diff = 0;
    if(self.activeStep > 0){
        diff = -8;
    }
    for (UIView *view in self.subviews) {
        MRCProgressItemView *itemView = (MRCProgressItemView*)view;
        itemSize.size = CGSizeMake(h, h);
        if(itemView.selected){
            diff = 0;
        }
        itemSize.origin.x = (w*i)+rect.origin.x+((w-h)*.5f)+diff;
        itemSize.origin.y = TOP_MARGIN-(h*.5f);
        if(itemView.selected){
            diff = 8;
        }
        view.frame = itemSize;
        [view setNeedsDisplay];
        i++;
    }
}

@end

@implementation MRCProgressItemView
{
    CAShapeLayer  *shapeLayer;
    UILabel       *shapeText;
}
- (instancetype)initWithFrame:(CGRect)frame index:(NSInteger)anIndex title:(NSString*)aTitle selected:(BOOL)isSelected closeTarget:(id)target
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selected = isSelected;
        self.title = aTitle;
        self.itemIndex = anIndex;
        //
        shapeLayer = [CAShapeLayer layer];
        shapeLayer.lineWidth = 2.0;
        shapeLayer.fillRule = kCAFillRuleNonZero;
        [self.layer addSublayer:shapeLayer];
        //

        if(self.title){
            UIFont *shapeFont = [UIFont fontWithName:@"HelveticaNeue" size:24.0f];
            UIColor *textColor = self.tintColor;
            shapeText = [[UILabel alloc] init];
            shapeText.font = shapeFont;
            shapeText.textColor = textColor;
            [self addSubview:shapeText];
            //
            UIFont *titleFont = [UIFont fontWithName:@"HelveticaNeue" size:11.0f];
            _titleLabel = [[UILabel alloc] init];
            _titleLabel.font = titleFont;
            _titleLabel.textColor = textColor;
            [self addSubview:_titleLabel];
        }else{
            shapeLayer.lineWidth = 4.0;
            self.userInteractionEnabled = YES;
            
            _closeImage = [UIButton buttonWithType:UIButtonTypeCustom];
            [_closeImage setImage:[[MrCoin imageNamed:@"close"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
            _closeImage.tintColor = [UIColor whiteColor];
            CGSize s = _closeImage.imageView.image.size;
            _closeImage.frame = CGRectMake(0, 0, s.width, s.height);
            [_closeImage addTarget:target action:@selector(closePressed:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:_closeImage];
        }
    }
    return self;
}


@synthesize selected = _selected;
-(void)setSelected:(BOOL)selected
{
    _selected = selected;
    if(selected){
        shapeLayer.transform = CATransform3DMakeScale(1, 1, 1);
    }else{
        if(self.title){
            shapeLayer.transform = CATransform3DMakeScale(0.75, 0.75, 1);
        }else{
            shapeLayer.transform = CATransform3DMakeScale(0.75, 0.75, 1);
        }
    }
    [self updateView:self.bounds];
}
-(BOOL)isSelected
{
    return _selected;
}
- (void)updateView:(CGRect)rect {
    rect = CGRectInset(rect, 3, 3);
    
    // Selected
    CGRect shapeFrame = rect;
    shapeFrame.origin.x = -rect.size.width*0.5f;
    shapeFrame.origin.y = -rect.size.height*0.5f;
    shapeLayer.path = [UIBezierPath bezierPathWithOvalInRect:shapeFrame].CGPath;
    shapeLayer.frame = CGRectMake(shapeFrame.size.width*0.5f, shapeFrame.size.height*0.5f, shapeFrame.size.width, shapeFrame.size.height);
    if(_selected){
        shapeLayer.fillColor = [self.tintColor CGColor];
        shapeLayer.strokeColor = [[UIColor clearColor] CGColor];
    }else{
        if(self.title){
            shapeLayer.strokeColor = [GRAY_COLOR CGColor];
            shapeLayer.fillColor = [[UIColor whiteColor] CGColor];
        }else{
            shapeLayer.strokeColor = [GRAY_COLOR CGColor];
            shapeLayer.fillColor = [GRAY_COLOR CGColor];
        }
    }
    if(self.title){
        CGFloat fontSize = 18.0f;
        UIColor *textColor;
        if(_selected){
            fontSize = 35.0f;
            textColor = [UIColor whiteColor];
        }else{
            textColor = GRAY_COLOR;
        }
        // Number
        NSString *stepString = [NSString stringWithFormat:@"%@",[NSNumber numberWithInteger:_itemIndex+1]];
        UIFont *stepFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:fontSize];
        [shapeText setFont:stepFont];
        [shapeText setTextColor:textColor];
        [shapeText setText:stepString];
        [shapeText sizeToFit];
        [shapeText setCenter:CGPointMake(rect.size.width*0.5f, rect.size.height*0.5f)];
        
        // Title
        if(_selected){
            _titleLabel.textColor = self.tintColor;
            _titleLabel.alpha = 1.0f;
        }else{
            _titleLabel.alpha = 0.0f;
        }
        _titleLabel.text = _title;
        [_titleLabel sizeToFit];
//        _titleLabel.center = CGPointMake(rect.origin.x+(rect.size.width*0.5f), rect.origin.y+rect.size.height+10);
        _titleLabel.center = CGPointMake((rect.size.width*0.5f), (rect.size.height+10));
    }else{
        _closeImage.center = CGPointMake((rect.size.width*0.5f), (rect.size.height*0.5f));
    }
    
}

@end
