//
//  MRCTransferViewController.m
//  MrCoin iOS SDK
//
//  Created by Gabor Nagy on 07/10/15.
//  Copyright © 2015 MrCoin. All rights reserved.
//

#import "MRCTransferViewController.h"
#import "MRCCopiableButton.h"
#import "MRCButton.h"
//
//#define HELP_URL    @"https://www.mrcoin.eu/contact"
//#define SERVICE_URL @"https://www.mrcoin.eu/"
//
//#define NAME    @"Mr. Coin Ltd."
//#define IBAN    @"HU29 1210 0011 1016 8158 0000 0000"
//#define SWIFT   @"GNBAHUHB"
//#define MESSAGE @"MQ34712371"

#import "MRCAPI.h"
#import "MrCoin.h"


@interface MRCTransferViewController ()


@property (weak, nonatomic) IBOutlet UIImageView *mrCoin;
@property (weak, nonatomic) IBOutlet MRCCopiableButton *nameButton;
@property (weak, nonatomic) IBOutlet MRCCopiableButton *ibanButton;
@property (weak, nonatomic) IBOutlet MRCCopiableButton *swiftButton;
@property (weak, nonatomic) IBOutlet MRCCopiableButton *messageButton;
@property (weak, nonatomic) IBOutlet MRCButton *helpButton;
@property (weak, nonatomic) IBOutlet UIButton *serviceButton;

- (IBAction)serviceProvider:(id)sender;
- (IBAction)help:(id)sender;

@end

#define View Controller related
@implementation MRCTransferViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (void)viewWillAppear:(BOOL)animated
{
    MRCAPI *api = [[MRCAPI alloc] init];
    [api getAddress:@"" response:^(NSDictionary *dictionary) {
        [self setupView:dictionary currency:[[MrCoin settings]sourceCurrency]]; //HUF
    } error:^(NSError *error, MRCAPIErrorType errorType) {
        NSLog(@"ERROR %@",error);
    }];
    [super viewWillAppear:animated];
}

-(void)setupView:(NSDictionary*)dictionary currency:(NSString*)currency
{
    NSString *keyPath = [NSString stringWithFormat:@"data.attributes.payment-methods.bank-transfer.%@.%@",currency,@"basic-info"];
    NSDictionary *d = [dictionary valueForKeyPath:keyPath];
    NSString *name = [d valueForKey:@"beneficiary-name"];
    NSString *iban = [d valueForKey:@"iban"];
    NSString *swift = [d valueForKey:@"bic"];
    NSString *reference = [d valueForKey:@"reference"];
    
    [self.nameButton setLabel:name
                    copyTitle:[NSString stringWithFormat:NSLocalizedString(@"Copy name: %@", nil),name]
                    copyLabel:NSLocalizedString(@"copy name to clipboard", nil)
                        value:name
     ];
    [self.ibanButton setLabel:iban
                    copyTitle:[NSString stringWithFormat:NSLocalizedString(@"Copy IBAN: %@", nil),iban]
                    copyLabel:NSLocalizedString(@"copy IBAN to clipboard", nil)
                        value:[[iban componentsSeparatedByString:@" "] componentsJoinedByString:@""]
     ];
    [self.swiftButton setLabel:swift
                    copyTitle:[NSString stringWithFormat:NSLocalizedString(@"Copy SWIFT(BIC): %@", nil),swift]
                    copyLabel:NSLocalizedString(@"copy SWIFT(BIC) to clipboard", nil)
                        value:swift
     ];
    [self.messageButton setLabel:reference
                    copyTitle:[NSString stringWithFormat:NSLocalizedString(@"Copy message(reference): %@", nil),reference]
                    copyLabel:NSLocalizedString(@"copy message(reference) to clipboard", nil)
                        value:reference
     ];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Button Actions
- (IBAction)help:(id)sender {
    MRCTextViewController *text = [MrCoin documentViewController:MrCoinDocumentSupport];
    [text.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithImage:[MrCoin imageNamed:@"close"] style:UIBarButtonItemStylePlain target:text action:@selector(close:)]];
     //[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:text action:@selector(close:)]];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:text];
    nav.modalPresentationStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:nav animated:YES completion:^{
        
    }];
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:HELP_URL]];
}
- (IBAction)serviceProvider:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.mrcoin.eu"]];
}

@end
