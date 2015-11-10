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


@property (weak, nonatomic) IBOutlet MRCCopiableButton *nameButton;
@property (weak, nonatomic) IBOutlet MRCCopiableButton *ibanButton;
@property (weak, nonatomic) IBOutlet MRCCopiableButton *swiftButton;
@property (weak, nonatomic) IBOutlet MRCCopiableButton *messageButton;
@property (weak, nonatomic) IBOutlet MRCButton *helpButton;
@property (weak, nonatomic) IBOutlet UIButton *serviceButton;
@property (weak, nonatomic) IBOutlet UIButton *tickerButton;

@property NSDictionary *tickerData;
@property NSArray *tickerDataArray;

- (IBAction)serviceProvider:(id)sender;
- (IBAction)help:(id)sender;
- (IBAction)changeTickerCurrency:(id)sender;

@end

#define View Controller related
@implementation MRCTransferViewController
{
    NSInteger _currencyIndex;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _currencyIndex = -1;
}
- (void)viewWillAppear:(BOOL)animated
{
    NSAssert([[MrCoin sharedController] delegate],@"MrCoin Delegate isn't configured. See the README.");
    NSAssert([[[MrCoin sharedController] delegate] respondsToSelector:@selector(requestPublicKey)],@"MrCoin Delegate method (requestPublicKey:) isn't configured. See the README.");
    
    
    [self _loadTicker];
    [self _loadQuicktransfer];
    [super viewWillAppear:animated];
}

#define Ticker
-(void) _loadTicker
{
    [[MrCoin api] getPriceTicker:^(id result) {
        NSDictionary *d = [result valueForKey:@"attributes"];
        NSMutableArray *a = [[NSMutableArray alloc] init];
        [d enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
           [a addObject:obj];
        }];
        self.tickerDataArray = [NSArray arrayWithArray:a];
        self.tickerData = [result valueForKey:@"attributes"];
        [self _updateTicker];
    } error:nil];
}
-(void) _updateTicker
{
    NSUInteger length = [self.tickerData count];
    if(length <= 0) return;
    if(_currencyIndex == -1){
        NSString *currency = [[MrCoin settings] sourceCurrency];
        __block NSInteger index = -1;
        __block NSUInteger indexCounter = 0;
        [self.tickerData enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            if([key isEqualToString:[NSString stringWithFormat:@"btc%@",[currency lowercaseString]]]){
                index = indexCounter;
            }
            indexCounter++;
        }];
        //        [self.tickerData enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //        }];
        if(index > -1 && index < length){
            _currencyIndex = index;
        }
    }
    if(_currencyIndex >= 0 && _currencyIndex < length){
        _currencyIndex++;
        if(_currencyIndex >= length){
            _currencyIndex = 0;
        }
        [self.tickerButton setTitle:[self _tickerString:_currencyIndex] forState:UIControlStateNormal];
    }
    
}
-(NSString*) _tickerString:(NSInteger)index
{
    NSString *priceString;
    if(self.tickerData){
        NSDictionary *currency = [self.tickerDataArray objectAtIndex:index];
        NSString *price = [currency valueForKey:@"ask_localized"];
        priceString = [NSString stringWithFormat:NSLocalizedString(@"We sell at: %@", NULL),price];
    }
    return priceString;
}



-(void) _loadQuicktransfer
{
    NSString *publicKey = [[[MrCoin sharedController] delegate] requestPublicKey];
    
    [[MrCoin api] quickDeposits:publicKey currency:[[MrCoin settings]destinationCurrency] resellerID:[[MrCoin settings]resellerKey] success:^(NSDictionary *dictionary) {
        [self setupView:dictionary currency:[[MrCoin settings]sourceCurrency]]; //HUF
    } error:nil];
}

-(void)setupView:(NSDictionary*)dictionary currency:(NSString*)currency
{

    NSString *keyPath = [NSString stringWithFormat:@"attributes.payment_methods.bank_transfer.%@.basic_info",currency];
    NSDictionary *d = [dictionary valueForKeyPath:keyPath];
    NSLog(@"dictionary %@",d);
    NSString *name = [d valueForKey:@"beneficiary_name"];
    NSString *iban = [d valueForKey:@"iban"];
    NSString *swift = [d valueForKey:@"bic"];
    NSString *reference = [d valueForKey:@"reference"];
    
    NSString *copyTxt = NSLocalizedString(@"Copy %@ (%@)",nil);
    NSString *copyClipTxt = NSLocalizedString(@"Copy %@ to clipboard",nil);
    NSString *nameTxt = NSLocalizedString(@"name",nil);
    
//    Barnabas DebreczeniToday at 1:56pm
//    HUF eseten pl. Account nr. van asszem (2x8 szamjegy), es nincs BIC Code... EUR eseten BIC + IBAN van.
    NSString *ibanTxt = NSLocalizedString(@"IBAN",nil);
    NSString *swiftTxt = NSLocalizedString(@"BIC",nil);
    if([currency isEqualToString:@"HUF"]){
        iban = [d valueForKey:@"iban"];
        ibanTxt = NSLocalizedString(@"Account nr.",nil);
        swift = @"";
        swiftTxt = @"";
    }
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
//    [[MrCoin settings] setTermsURL:[dictionary valueForKeyPath:@"attributes.terms.full_terms"]];
//    [[MrCoin settings] setShortTermsURL:[dictionary valueForKeyPath:@"attributes.terms.short_terms"]];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Button Actions
- (IBAction)help:(id)sender {
    [[MrCoin sharedController] sendMail:[[MrCoin settings] supportEmail] subject:NSLocalizedString(@"Help me with QuickTransfer",nil)];
}

- (IBAction)changeTickerCurrency:(id)sender {
    [self _updateTicker];
}
- (IBAction)serviceProvider:(id)sender {
    [[MrCoin sharedController] openURL:[NSURL URLWithString:[[MrCoin settings] websiteURL]]];
}

@end
