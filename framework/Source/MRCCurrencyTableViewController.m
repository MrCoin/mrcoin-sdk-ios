//
//  MRCCurrencyTableViewController.m
//  MrCoin iOS SDK
//
//  Created by Gabor Nagy on 11/10/15.
//  Copyright © 2015 MrCoin. All rights reserved.
//

#import "MRCCurrencyTableViewController.h"
#import "MRCoin.h"

@interface MRCCurrencyTableViewController ()

@property NSArray *currencies;
@property NSArray *currencyNames;

@end

@implementation MRCCurrencyTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Select currency",nil);
    _currencies = @[@"HUF",@"EUR"];
    _currencyNames = @[@"Hungarian Forint",@"Eurozone Euro"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}
- (void)viewWillAppear:(BOOL)animated
{
    NSInteger index = [_currencies indexOfObject:[[MrCoin settings] sourceCurrency]];
    if(index < _currencies.count && index >= 0){
        [[self tableView] selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
    }
    [super viewWillAppear:animated];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[MrCoin settings] setSourceCurrency:_currencies[indexPath.row]];
    [[MrCoin settings] saveSettings];
    if(self.navigationController){
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MRCCurrencyCell" forIndexPath:indexPath];
    [[cell textLabel] setText:[NSString stringWithFormat:@"%@ - %@",_currencies[indexPath.row],_currencyNames[indexPath.row]]];
    return cell;
}


@end
