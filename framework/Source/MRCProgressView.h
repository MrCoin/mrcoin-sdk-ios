//
//  MRCProgressView.h
//  MrCoin iOS SDK
//
//  Created by Gabor Nagy on 04/10/15.
//  Copyright © 2015 MrCoin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MRCProgressView;

@protocol MRCProgressViewDelegate <NSObject>

-(void)progressViewClosed:(MRCProgressView*)progressView;

@end

@interface MRCProgressView : UIView

@property (nonatomic) NSArray *stepLabels;
@property (nonatomic) IBInspectable NSInteger activeStep;

@property (nonatomic) BOOL showCloseButton;
@property (nonatomic) id <MRCProgressViewDelegate> delegate;

- (void)setActiveStepByName:(NSString*)name;

@end
