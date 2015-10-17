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
    [[MrCoin api] quickTransfers:[[MrCoin settings] walletPublicKey] currency:[[MrCoin settings]destinationCurrency] resellerID:[[MrCoin settings]resellerKey] success:^(NSDictionary *dictionary) {
        NSLog(@"dictionary %@",dictionary);
        [self setupView:dictionary currency:[[MrCoin settings]sourceCurrency]]; //HUF
    } error:^(NSArray *errors, MRCAPIErrorType errorType) {
        NSLog(@"%@",errors);
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
    
    
    NSString *copyTxt = NSLocalizedString(@"Copy %@ (%@)",nil);
    NSString *copyClipTxt = NSLocalizedString(@"Copy %@ to clipboard",nil);
    NSString *nameTxt = NSLocalizedString(@"name",nil);
    NSString *ibanTxt = NSLocalizedString(@"IBAN",nil);
    NSString *swiftTxt = NSLocalizedString(@"SWIFT",nil);
    NSString *messageTxt = NSLocalizedString(@"message",nil);
    
    [self.nameButton setLabel:name
                    copyTitle:[NSString stringWithFormat:copyTxt,nameTxt,name]
                    copyLabel:[NSString stringWithFormat:copyClipTxt,nameTxt]
                        value:name
     ];
    [self.ibanButton setLabel:iban
                    copyTitle:[NSString stringWithFormat:copyTxt,ibanTxt,name]
                    copyLabel:[NSString stringWithFormat:copyClipTxt,ibanTxt]
                        value:[[iban componentsSeparatedByString:@" "] componentsJoinedByString:@""]
     ];
    [self.swiftButton setLabel:swift
                     copyTitle:[NSString stringWithFormat:copyTxt,swiftTxt,name]
                     copyLabel:[NSString stringWithFormat:copyClipTxt,swiftTxt,name]
                        value:swift
     ];
    [self.messageButton setLabel:reference
                       copyTitle:[NSString stringWithFormat:copyTxt,messageTxt,name]
                       copyLabel:[NSString stringWithFormat:copyClipTxt,messageTxt,name]
                        value:reference
     ];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Button Actions
- (IBAction)help:(id)sender {
    NSString *to = MRCOIN_SUPPORT;
    NSString *subject = [NSString stringWithFormat:@"Help me with QuickTransfer"];
    [[MrCoin sharedController] sendMail:to subject:subject];
}
- (IBAction)serviceProvider:(id)sender {
    [[MrCoin sharedController] openURL:[NSURL URLWithString:MRCOIN_URL]];
}

@end
