//
//  MRCFormViewController.h
//  MrCoin iOS SDK
//
//  Created by Gabor Nagy on 05/10/15.
//  Copyright © 2015 MrCoin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MRCProgressView.h"
#import "MRCAPI.h"

//typedef void (^MRCFormComplete)();
//typedef void (^MRCFormCancel)();
//
@interface MRCFormViewController : UIViewController <MRCProgressViewDelegate>

@property (nonatomic,copy) void (^onComplete)(void);
@property (nonatomic,copy) void (^onCancel)(void);

@property (strong, nonatomic) NSArray *pages;

- (void) nextPage;
- (void) previousPage;

- (void) nextPageWithObject:(id)object;
- (void) previousPageWithObject:(id)object;

- (void) showOverlay:(BOOL)show;

- (IBAction)done:(id)sender;
- (IBAction)cancel:(id)sender;

@end

@interface MRCFormViewOverlay : UIView

@property BOOL documentMode;
@property CGFloat topGradientSize;
@property CGFloat bottomGradientSize;

@end