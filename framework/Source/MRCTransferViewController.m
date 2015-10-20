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
    NSAssert([[MrCoin sharedController] delegate],@"MrCoin Delegate isn't configured. See the README.");
    NSAssert([[[MrCoin sharedController] delegate] respondsToSelector:@selector(requestPublicKey)],@"MrCoin Delegate method (requestPublicKey:) isn't configured. See the README.");
    
    NSString *publicKey = [[[MrCoin sharedController] delegate] requestPublicKey];
    
    [[MrCoin api] quickTransfers:publicKey currency:[[MrCoin settings]destinationCurrency] resellerID:[[MrCoin settings]resellerKey] success:^(NSDictionary *dictionary) {
        [self setupView:dictionary currency:[[MrCoin settings]sourceCurrency]]; //HUF
    } error:nil];
    
    [super viewWillAppear:animated];
}

-(void)setupView:(NSDictionary*)dictionary currency:(NSString*)currency
{
    NSLog(@"dictionary %@",dictionary);

    NSString *keyPath = [NSString stringWithFormat:@"attributes.payment_methods.bank_transfer.%@.basic_info",currency];
    NSDictionary *d = [dictionary valueForKeyPath:keyPath];
    NSString *name = [d valueForKey:@"beneficiary_name"];
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
                    copyTitle:[NSString stringWithFormat:copyTxt,ibanTxt,iban]
                    copyLabel:[NSString stringWithFormat:copyClipTxt,ibanTxt]
                        value:[[iban componentsSeparatedByString:@" "] componentsJoinedByString:@""]
     ];
    [self.swiftButton setLabel:swift
                     copyTitle:[NSString stringWithFormat:copyTxt,swiftTxt,swift]
                     copyLabel:[NSString stringWithFormat:copyClipTxt,swiftTxt]
                        value:swift
     ];
    [self.messageButton setLabel:reference
                       copyTitle:[NSString stringWithFormat:copyTxt,messageTxt,reference]
                       copyLabel:[NSString stringWithFormat:copyClipTxt,messageTxt]
                        value:reference
     ];
    
    // Setup documents
    [[MrCoin settings] setSupportEmail:[dictionary valueForKeyPath:@"attributes.support.email"]];
    [[MrCoin settings] setSupportURL:[dictionary valueForKeyPath:@"attributes.support.web"]];
    [[MrCoin settings] setTermsURL:[dictionary valueForKeyPath:@"attributes.terms.full_terms"]];
    [[MrCoin settings] setShortTermsURL:[dictionary valueForKeyPath:@"attributes.terms.short_terms"]];

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
