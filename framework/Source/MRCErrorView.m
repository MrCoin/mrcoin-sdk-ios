//
//  MRCErrorView.m
//  MrCoin iOS SDK
//
//  Created by Gabor Nagy on 11/10/15.
//  Copyright © 2015 MrCoin. All rights reserved.
//

#import "MRCErrorView.h"

@interface MRCErrorView ()

@property UILabel *label;
@property UIColor *fillColor;

@end

@implementation MRCErrorView

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextSetFillColorWithColor(context, [self.fillColor CGColor]);
    
    CGFloat midX = rect.size.width-15;
    CGContextMoveToPoint(context, midX, 2);
    CGContextAddLineToPoint(context, midX-7, 10);
    CGContextAddLineToPoint(context, midX+7, 10);
    CGContextDrawPath(context, kCGPathFill);
    
    rect.origin.y += 8;
    rect.size.height -= 8;
    UIBezierPath *p = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:(UIRectCornerAllCorners) cornerRadii:CGSizeMake(5, 5)];
    CGContextAddPath(context, p.CGPath);
    CGContextDrawPath(context, kCGPathFill);

    
    CGContextRestoreGState(context);
}

+ (instancetype) error:(NSString*)error inView:(UIView*)view frame:(CGRect)rect backgroundColor:(UIColor*)color
{
    rect.origin.y += rect.size.height+8;
    
    MRCErrorView *errorView = [[MRCErrorView alloc] initWithFrame:rect];
    errorView.fillColor = color;
    errorView.backgroundColor = [UIColor clearColor];
    errorView.layer.cornerRadius = 5;
    errorView.layer.masksToBounds = YES;
    errorView.label.numberOfLines = 0;
    errorView.label.text = error;
    
    NSDictionary *labelAttributes = [[NSDictionary alloc] initWithObjectsAndKeys: errorView.label.font, NSFontAttributeName,nil];
    CGSize labelSize = [error boundingRectWithSize:CGSizeMake(rect.size.width-20, CGFLOAT_MAX)
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:labelAttributes
                                           context:nil].size;
    errorView.label.frame = CGRectMake(10, 12, labelSize.width, labelSize.height);
    CGRect r = rect;
    r.origin.x += (r.size.width-labelSize.width)-10;
    r.size = labelSize;
    errorView.frame = CGRectInset(r, -10, -8);
    [errorView setNeedsDisplay];

    errorView.alpha = 0.0f;
    [view addSubview:errorView];

    [UIView animateWithDuration:0.5f animations:^{
        errorView.alpha = 1.0f;
    } completion:^(BOOL finished) {
        if(finished){
        }
    }];
    return errorView;
}
- (void) dismiss:(void (^)(void))complete
{
    [UIView animateWithDuration:0.5f animations:^{
        self.alpha = 0.0f;
    } completion:^(BOOL finished) {
        if(finished){
            [self removeFromSuperview];
            self.fillColor = nil;
            self.label = nil;
            if(complete) complete();
        }
    }];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(10, 12, 0, 0)];
        self.label.textColor = [UIColor whiteColor];
        self.label.font = [UIFont boldSystemFontOfSize:12];
        [self.label sizeToFit];
        [self addSubview:self.label];
    }
    return self;
}

@end
