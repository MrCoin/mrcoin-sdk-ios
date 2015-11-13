//
//  MRCTextViewController.m
//  MrCoin iOS SDK
//
//  Created by Gabor Nagy on 08/10/15.
//  Copyright © 2015 MrCoin. All rights reserved.
//

#import "MRCTextViewController.h"
#import "MRCFormViewController.h"
#import "MrCoin.h"
#import "MRCButton.h"

@interface MRCTextViewController ()

@property (weak, nonatomic) IBOutlet MRCButton *declineButton;
@property (weak, nonatomic) IBOutlet MRCButton *acceptButton;

@end

@implementation MRCTextViewController

#pragma mark - Initialization
- (void)viewDidLoad {
    [super viewDidLoad];
    self.textView.dataDetectorTypes = UIDataDetectorTypeLink;
    self.textView.delegate = self;
    self.textView.scrollsToTop = YES;
    _declineButton.hidden = YES;
    _acceptButton.hidden = YES;
}
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange
{
    [[UIApplication sharedApplication] openURL:URL];
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@synthesize mode = _mode;
-(void)setMode:(MRCDocumentViewMode)mode
{
    _mode = mode;
    switch (mode) {
        default:
        case MRCTermsUserNeedsAccept:
            [_acceptButton setTitle:NSLocalizedString(@"Accept",nil) forState:UIControlStateNormal];
        case MRCTermsUserNeedsAcceptForm:
            _overlayView.documentMode = YES;
            _overlayView.topGradientSize = 20;
            _overlayView.bottomGradientSize = 95;
            _overlayView.hidden = NO;
            _declineButton.hidden = NO;
            _acceptButton.hidden = NO;
            break;
        case MRCShowDocuments:
//            _textView.backgroundColor = [UIColor redColor];
            _overlayView.backgroundColor = [UIColor clearColor];
            _overlayView.bottomGradientSize = 0;
            _overlayView.topGradientSize = 0;
            _overlayView.hidden = YES;
            _declineButton.hidden = YES;
            _acceptButton.hidden = YES;
            break;
    }
    [self.view sendSubviewToBack:_overlayView];
    [self.view sendSubviewToBack:_textView];
    [_overlayView setNeedsDisplay];
    [[self view] setNeedsDisplay];
}
-(MRCDocumentViewMode)mode
{
    return _mode;
}

#pragma mark - Actions
- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (IBAction)accept:(id)sender {
    if(self.parentViewController && [self.parentViewController isKindOfClass:[MRCFormViewController class]]){
        [[MrCoin sharedController] setNeedsAcceptTerms:NO];
        [[MrCoin settings] saveSettings];
        [self nextPage:sender];
    }
}
- (IBAction)decline:(id)sender {
    if(self.parentViewController && [self.parentViewController isKindOfClass:[MRCFormViewController class]]){
        [self previousPage:sender];
    }
}


#pragma mark - HTML
- (void)loadHTML:(NSString*)url
{
    [self performSelectorInBackground:@selector(_loadHTML:) withObject:url];
}
- (void)_loadHTML:(NSString*)url
{
    NSString *s = [NSString stringWithContentsOfURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding error:nil];
    [self performSelectorOnMainThread:@selector(parseHTML:) withObject:s waitUntilDone:YES];
}

- (void)parseHTML:(NSString*)htmlString
{
    htmlString = [htmlString stringByAppendingString:@"<style>body{font-family: 'HelveticaNeue-Light'; font-size:14px;} h1{font-weight:normal;font-size:22px;} h2{font-size:18px;font-weight:normal;}</style>"];
//
    NSMutableAttributedString *txt = [[NSMutableAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUTF8StringEncoding]
                                                                             options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                                                       NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)}
                                                                  documentAttributes:nil
                                                                               error:nil];
    switch (_mode) {
        default:
        case MRCTermsUserNeedsAcceptForm:
        case MRCTermsUserNeedsAccept:
            _textView.textContainerInset = UIEdgeInsetsMake(25, 20, 100, 20);
            _textView.scrollIndicatorInsets = UIEdgeInsetsMake(10, 0, 90, 4);
            break;
        case MRCShowDocuments:
            _textView.textContainerInset = UIEdgeInsetsMake(10, 20, 10, 20);
            _textView.scrollIndicatorInsets = UIEdgeInsetsMake(10, 0, 10, 4);
            break;
    }
    _textView.attributedText = txt;
    [_textView setContentOffset:CGPointZero animated:NO];

}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}
@end
