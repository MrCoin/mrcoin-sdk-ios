//
//  MRCTextViewController.h
//  MrCoin iOS SDK
//
//  Created by Gabor Nagy on 08/10/15.
//  Copyright © 2015 MrCoin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MRCFormPageViewController.h"
#import "MRCFormViewController.h"

typedef enum : NSUInteger {
    MRCTermsUserNeedsAcceptForm = 1,
    MRCTermsUserNeedsAccept = 2,
    MRCShowDocuments = 3
} MRCDocumentViewMode;

typedef enum : NSUInteger {
    MrCoinDocumentTerms = 1,
    MrCoinDocumentShortTerms = 2,
    MrCoinDocumentSupport = 3
} MrCoinDocumentType;


@interface MRCTextViewController : MRCFormPageViewController

@property (weak, nonatomic) IBOutlet MRCFormViewOverlay *overlayView;
@property (weak, nonatomic) IBInspectable NSString *sourceURL;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (nonatomic,readwrite) MRCDocumentViewMode mode;

- (IBAction)close:(id)sender;
- (IBAction)accept:(id)sender;
- (IBAction)decline:(id)sender;

- (void)parseHTML:(NSString*)htmlCode;
- (void)loadHTML:(NSString*)url;

@end
