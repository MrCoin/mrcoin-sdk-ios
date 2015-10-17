//
//  MRCPopUpViewController.m
//  MrCoin iOS SDK
//
//  Created by Gabor Nagy on 10/10/15.
//  Copyright © 2015 MrCoin. All rights reserved.
//

#import "MRCPopUpViewController.h"
#import "MrCoin.h"

#define COPIED  @"Copied."

@interface MRCPopUpViewController ()
@property (weak, nonatomic) IBOutlet UIView *messageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UIButton *okButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@property (weak, nonatomic) IBOutlet UIView *loadingView;
@property (weak, nonatomic) IBOutlet UILabel *loadingTitleLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;

@property (nonatomic) BOOL isPresenting;

- (void)_presentInViewController:(UIViewController *)viewController;

@end

@implementation MRCPopUpViewController
{
    BOOL present;
}
static MRCPopUpViewController *popup;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.loadingView.layer.cornerRadius = 8.0f;
    self.loadingView.layer.masksToBounds = YES;
    self.messageView.layer.cornerRadius = 8.0f;
    self.messageView.layer.masksToBounds = YES;
    //
    if(_okButton)        _okButton.hidden = YES;
    if(_cancelButton)    _cancelButton.hidden = YES;
}

@synthesize style = _style;
-(void)setStyle:(MRCPopupStyle)style
{
    _style = style;
    if(style == MRCPopupLightStyle){
        self.view.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
        
        self.loadingView.backgroundColor = [UIColor whiteColor];
        self.loadingIndicator.color = [UIColor darkGrayColor];
        self.loadingTitleLabel.textColor = [UIColor darkGrayColor];
        
        self.messageView.backgroundColor = [UIColor whiteColor];
        self.titleLabel.textColor = [UIColor darkGrayColor];
        self.messageLabel.textColor = [UIColor darkGrayColor];
    }else{
        self.view.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.0f];
        
        self.loadingView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.8f];
        self.loadingIndicator.color = [UIColor whiteColor];
        self.loadingTitleLabel.textColor = [UIColor whiteColor];
        
        self.messageView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.8f];
        self.titleLabel.textColor = [UIColor whiteColor];
        self.messageLabel.textColor = [UIColor whiteColor];
    }
}
-(MRCPopupStyle)style
{
    return _style;
}
@synthesize mode = _mode;
-(void)setMode:(MRCPopupMode)mode
{
    _mode = mode;
    if(mode == MRCPopupActivityIndicator){
        self.loadingView.hidden = NO;
        self.messageView.hidden = YES;
    }else{
        self.loadingView.hidden = YES;
        self.messageView.hidden = NO;
    }
}
-(MRCPopupMode)mode
{
    return _mode;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

+ (void) copiedFeedback:(UIViewController*)parentController
{
    MRCPopUpViewController *popup = [MRCPopUpViewController sharedPopup];
    [popup setStyle:MRCPopupDarkStyle];
    [popup setMode:MRCPopupActivityIndicator];
    [popup setTitle:COPIED];
    [popup presentInViewController:parentController hideAfterDelay:2.0f];
}

+ (instancetype) sharedPopup
{
    if(!popup)  popup = (MRCPopUpViewController*)[MrCoin viewController:@"Popup"];
    return popup;
}

- (void)presentInViewController:(UIViewController *)viewController
{
    [self presentInViewController:viewController hideAfterDelay:0.0];
}
-(void)presentInViewController:(UIViewController *)viewController hideAfterDelay:(NSTimeInterval)delay
{
    if(present) return;
    NSTimeInterval t = 0.0f;
    if(self.mode == MRCPopupActivityIndicator){
        t = 1.0f;
    }
    present = YES;
    if(delay == 0.0){
        //        [self _presentInViewController:viewController];
        [self performSelector:@selector(_presentInViewController:) withObject:viewController afterDelay:t];
    }else{
//        [self _presentInViewController:viewController];
        [self performSelector:@selector(_presentInViewController:) withObject:viewController afterDelay:t];
        [self performSelector:@selector(dismissViewController) withObject:nil afterDelay:delay+t];
    }
}
- (void)_presentInViewController:(UIViewController *)viewController
{
    if(!present) return;
    if(self.mode == MRCPopupActivityIndicator){
        self.loadingTitleLabel.text = self.title;
    }else{
        self.titleLabel.text = self.title;
        self.messageLabel.text = _message;
        [_okButton setTitle:_okLabel forState:UIControlStateNormal];
        if(_okLabel){
            _okButton.hidden = NO;
        }else{
            _okButton.hidden = YES;
        }
        [[self view] setNeedsLayout];

    }
    [self.view layoutIfNeeded];
    self.view.alpha = 0;
    self.view.transform = CGAffineTransformMakeScale(1.2f, 1.2f);
    if(viewController){
        self.view.bounds = viewController.view.bounds;
        [[[viewController view] window] addSubview:[self view]];
    }else{
        self.view.bounds = [[UIScreen mainScreen] bounds];
        [[[[UIApplication sharedApplication]delegate]window] addSubview:[self view]];
    }
    [UIView animateWithDuration:0.3f animations:^{
        self.view.transform = CGAffineTransformIdentity;
        self.view.alpha = 1;
    } completion:^(BOOL finished) {
        if(finished){
            if(viewController) [viewController addChildViewController:self];
        }
    }];
}
-(void)dismissViewController
{
    if(!present) return;
    present = NO;
    [UIView animateWithDuration:0.3f animations:^{
        self.view.alpha = 0;
        self.view.transform = CGAffineTransformMakeScale(1.2f, 1.2f);
    } completion:^(BOOL finished) {
        if(finished){
            [[self view] removeFromSuperview];
            [self removeFromParentViewController];
        }
    }];
}
- (void) hide
{
    [self dismissViewController];
}
#pragma mark - Navigation

- (IBAction)ok:(id)sender {
    [self dismissViewController];
}
- (IBAction)cancel:(id)sender {
    [self dismissViewController];
}
@end
