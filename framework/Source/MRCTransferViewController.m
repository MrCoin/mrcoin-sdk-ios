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

@property (weak, nonatomic) IBOutlet UILabel *ibanLabel;
@property (weak, nonatomic) IBOutlet UILabel *swiftLabel;
@property (weak, nonatomic) IBOutlet UILabel *transferInfo;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *messageTopConstraint;

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
    NSAssert([[MrCoin sharedController] delegate],@"MrCoin Delegate isn't configured. See the README.");
    NSAssert([[[MrCoin sharedController] delegate] respondsToSelector:@selector(requestPublicKey)],@"MrCoin Delegate method (requestPublicKey:) isn't configured. See the README.");

    [[MrCoin settings] addObserver:self forKeyPath:@"sourceCurrency" options:(NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
}
-(void)dealloc
{
    [[MrCoin settings] removeObserver:self forKeyPath:@"sourceCurrency"];
}
- (void)didReceiveMemoryWarning {
    [[MrCoin settings] removeObserver:self forKeyPath:@"sourceCurrency"];
    [super didReceiveMemoryWarning];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    [self _loadTicker:change[NSKeyValueChangeNewKey]];
    [self _loadQuicktransfer:change[NSKeyValueChangeNewKey]];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

#define Ticker
-(void) _loadTicker:(NSString*)currency
{
    if([[MrCoin settings] userConfiguration] < MRCUserConfigured) return;
    _currencyIndex = -1;
    [[MrCoin api] getPriceTicker:^(id result) {
        NSDictionary *d = [result valueForKey:@"attributes"];
        NSMutableArray *a = [[NSMutableArray alloc] init];
        [d enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
           [a addObject:obj];
        }];
        self.tickerDataArray = [NSArray arrayWithArray:a];
        self.tickerData = [result valueForKey:@"attributes"];
        [self _updateTicker:currency];
    } error:nil];
}
-(void) _updateNextTicker:(NSString*)currency
{
    NSInteger i = [self _tickerIndex:currency];
    if(i != -1){
        if(_currencyIndex == -1)    _currencyIndex = i;
        _currencyIndex++;
        NSUInteger length = [self.tickerData count];
        if(_currencyIndex >= length){
            _currencyIndex = 0;
        }
        [self.tickerButton setTitle:[self _tickerString:_currencyIndex] forState:UIControlStateNormal];
    }
}
-(void) _updateTicker:(NSString*)currency
{
    NSInteger i = [self _tickerIndex:currency];
    if(i != -1){
        if(_currencyIndex == -1)    _currencyIndex = i;
        [self.tickerButton setTitle:[self _tickerString:_currencyIndex] forState:UIControlStateNormal];
    }
}
-(NSInteger) _tickerIndex:(NSString*)currency
{
    NSUInteger length = [self.tickerData count];
    if(length <= 0) return -1;
    __block NSInteger index = -1;
    __block NSUInteger indexCounter = 0;
    [self.tickerData enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if([key isEqualToString:[NSString stringWithFormat:@"btc%@",[currency lowercaseString]]]){
            index = indexCounter;
        }
        indexCounter++;
    }];
    if(index >= 0 && index < length){
        return index;
    }
    return -1;
    
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

-(void) _loadQuicktransfer:(NSString*)currency
{
    if([[MrCoin settings] userConfiguration] < MRCUserConfigured) return;
    NSString *publicKey = [[[MrCoin sharedController] delegate] requestPublicKey];
    
    [[MrCoin api] quickDeposits:publicKey currency:[[MrCoin settings]destinationCurrency] resellerID:[[MrCoin settings]resellerID] success:^(NSDictionary *dictionary) {
        [self setupView:dictionary currency:currency]; //HUF
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
    
    [MrCoin settings].quickTransferCode = reference;
    
    NSString *copyTxt = NSLocalizedString(@"Copy %@ (%@)",nil);
    NSString *copyClipTxt = NSLocalizedString(@"Copy %@ to clipboard",nil);
    NSString *nameTxt = NSLocalizedString(@"name",nil);
    NSString *ibanTxt = NSLocalizedString(@"IBAN",nil);
    NSString *swiftTxt = NSLocalizedString(@"BIC",nil);
    NSString *transferInfo;
    if([currency isEqualToString:@"HUF"]){
        iban = [iban substringWithRange:NSMakeRange(5, 29)];
        ibanTxt = NSLocalizedString(@"GIRO",nil);
        swift = @"";
        swiftTxt = @"";
        self.swiftLabel.hidden = YES;
        self.messageTopConstraint.constant = -16;
        transferInfo = NSLocalizedString(@"Whatever amount you transfer (up to 300,000 HUF), it will be converted to Bitcoin and sent directly into your wallet.\nPlease allow several banking hours for the transfer to clear in the Plan Old Banking system.",nil);
    }else{
        self.swiftLabel.hidden = NO;
        self.messageTopConstraint.constant = 8;
        transferInfo = NSLocalizedString(@"Whatever amount you transfer (up to 1,000 EUR), it will be converted to Bitcoin and sent directly into your wallet.\nPlease allow 12-48 banking hours for the transfer to clear in the Plan Old Banking system.",nil);
    }
    self.transferInfo.text = transferInfo;
    self.ibanLabel.text = ibanTxt;
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
    [self.view setNeedsLayout];
    
    // Setup documents
    [[MrCoin settings] setSupportEmail:[dictionary valueForKeyPath:@"attributes.support.email"]];
    [[MrCoin settings] setSupportURL:[dictionary valueForKeyPath:@"attributes.support.web"]];

}

#pragma mark - Button Actions
- (IBAction)help:(id)sender {
    [[MrCoin sharedController] sendMail:[[MrCoin settings] supportEmail] subject:NSLocalizedString(@"Help me with QuickTransfer",nil)];
}

- (IBAction)changeTickerCurrency:(id)sender {
    [self _updateNextTicker:[[MrCoin settings] sourceCurrency]];
}
- (IBAction)serviceProvider:(id)sender {
    [[MrCoin sharedController] openURL:[NSURL URLWithString:[[MrCoin settings] websiteURL]]];
}

@end
