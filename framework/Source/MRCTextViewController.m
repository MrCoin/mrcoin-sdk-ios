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

@interface MRCTextViewController ()

@property (weak, nonatomic) IBOutlet MRCFormViewOverlay *overlayView;
@property (weak, nonatomic) IBOutlet MRCButton *declineButton;
@property (weak, nonatomic) IBOutlet MRCButton *acceptButton;

@end

@implementation MRCTextViewController

#pragma mark - Initialization
- (void)viewDidLoad {
    [super viewDidLoad];
//    _declineButton.hidden = YES;
//    _acceptButton.hidden = YES;
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
        case MRCTermsUserNeedsAcceptForm:
            _overlayView.backgroundColor = self.view.backgroundColor;
            _overlayView.documentMode = YES;
            _overlayView.topGradientSize = 20;
            _overlayView.bottomGradientSize = 120;
            _overlayView.hidden = NO;
            _declineButton.hidden = NO;
            _acceptButton.hidden = NO;
            break;
        case MRCTermsUserNeedsAccept:
            _overlayView.backgroundColor = self.view.backgroundColor;
            _overlayView.documentMode = YES;
            _overlayView.topGradientSize = 20;
            _overlayView.bottomGradientSize = 100;
            _overlayView.hidden = NO;
            _declineButton.hidden = NO;
            _acceptButton.hidden = NO;
            [_acceptButton setTitle:@"Accept" forState:UIControlStateNormal];
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
    NSString *htmlString = @"<html><h1>Terms of Usage</h1><p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis non ligula urna. Integer a metus malesuada, elementum diam sit amet, faucibus tortor. Donec justo massa, tempus at magna vel, fringilla dictum sem. Sed ac tincidunt augue. Aliquam erat volutpat. Nunc ac nulla sed augue condimentum cursus. Curabitur finibus pharetra lacus, ac venenatis erat sagittis sed. Etiam sagittis ex ullamcorper velit convallis, sed consequat nibh placerat. Sed nulla mi, tempor viverra venenatis vel, pellentesque vitae ligula. Maecenas ut purus vitae enim suscipit tristique. Aliquam semper arcu eget tincidunt ultricies. Nulla id vestibulum velit. Pellentesque sem lacus, tempor in malesuada sit amet, tincidunt in ipsum. Pellentesque faucibus odio eu ipsum tincidunt, at vulputate nibh malesuada. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae;</p><p>Sed in fringilla nisl. Ut ac lacus eget mi pellentesque auctor. Pellentesque fermentum lorem sapien, sit amet fringilla sapien feugiat eu. Vestibulum quam lacus, suscipit ut interdum vel, vulputate eget metus. In eget est eu ligula euismod venenatis. Fusce sit amet nisi id erat rhoncus venenatis eget feugiat dui. Quisque ut ullamcorper lacus, non placerat nisi. Morbi vel ligula magna. Praesent nec sagittis turpis. Etiam posuere ipsum nibh, sit amet sodales lectus sodales in. Ut luctus sem orci, nec auctor diam viverra sit amet. Donec lobortis, elit ut tincidunt iaculis, nisi purus porta turpis, quis sodales libero urna eu est.</p></html>";

    // TODO: Implement loader
    [self parseHTML:htmlString];
}
- (void)parseHTML:(NSString*)htmlString
{
    htmlString = [htmlString stringByAppendingString:[NSString stringWithFormat:@"<style>body{font-family: '%@'; font-size:%fpx;}</style>",
                                                      @"HelveticaNeue",
                                                      14.0f]];
    
    NSMutableAttributedString *txt = [[NSMutableAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUTF8StringEncoding]
                                                                             options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                                                       NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)}
                                                                  documentAttributes:nil
                                                                               error:nil];
    _textView.attributedText = txt;
}
-(void)viewDidLayoutSubviews
{
    switch (_mode) {
        default:
        case MRCTermsUserNeedsAcceptForm:
        case MRCTermsUserNeedsAccept:
            _textView.textContainerInset = UIEdgeInsetsMake(20, 10, 80, 10);
            _textView.scrollIndicatorInsets = UIEdgeInsetsMake(20, 0, 100, 0);
            break;
        case MRCShowDocuments:
            _textView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
            _textView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, 0);
            break;
    }
    [_textView setContentOffset:CGPointZero animated:NO];
}
- (void)viewWillLayoutSubviews
{
}
@end
