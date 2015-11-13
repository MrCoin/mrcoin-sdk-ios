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
    [super viewWillAppear:animated];
    NSInteger index = -1;
    NSInteger i = 0;
    for (NSString *_currency in _currencies) {
        if([_currency isEqualToString:[[MrCoin settings] sourceCurrency]]){
            index = i;
        }
        i++;
    }
    if(index < _currencies.count && index >= 0){
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]
                         withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = -1;
    NSInteger i = 0;
    for (NSString *_currency in _currencies) {
        if([_currency isEqualToString:[[MrCoin settings] sourceCurrency]]){
            index = i;
        }
        i++;
    }
    [[MrCoin settings] setSourceCurrency:_currencies[indexPath.row]];
    [[MrCoin settings] saveSettings];

    if(index > -1){
        [tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0],indexPath]
                         withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MRCCurrencyCell" forIndexPath:indexPath];
    [[cell textLabel] setText:[NSString stringWithFormat:@"%@ - %@",_currencies[indexPath.row],_currencyNames[indexPath.row]]];
    [[cell textLabel] setTextColor:[UIColor darkGrayColor]];
    if([[[MrCoin settings] sourceCurrency] isEqualToString:_currencies[indexPath.row]]){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    // Background color
    view.tintColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.2];
    
    // Text Color
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor darkGrayColor]];
    [header.textLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:20.0f]];
    
    // Another way to set the background color
    // Note: does not preserve gradient effect of original header
    // header.contentView.backgroundColor = [UIColor blackColor];
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5];
}

@end
