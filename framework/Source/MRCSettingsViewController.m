//
//  MRCSettingsViewController.m
//  MrCoin iOS SDK
//
//  Created by Gabor Nagy on 12/10/15.
//  Copyright © 2015 MrCoin. All rights reserved.
//

#import "MRCSettingsViewController.h"
#import "MrCoin.h"

@interface MRCSettingsViewController ()

@end

@implementation MRCSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0) return 4;
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *_id = @"SettingsLink";
    if(indexPath.section == 0){
        _id = @"SettingsValue";
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:_id forIndexPath:indexPath];
    
    UILabel *label;
    
    // Settings Value
    if(indexPath.section == 0){
        label = (UILabel*)[cell viewWithTag:201];
        if(label)
        {
            if(indexPath.row == 0){
                label.text = NSLocalizedString(@"Phone",nil);
            }else if(indexPath.row == 1){
                label.text = NSLocalizedString(@"Email",nil);
            }else if(indexPath.row == 2){
                label.text = NSLocalizedString(@"Currency",nil);
            }else if(indexPath.row == 3){
                label.text = NSLocalizedString(@"Reset settings",nil);
            }
        }
        label = (UILabel*)[cell viewWithTag:202];
        if(label)
        {
            if(indexPath.row == 0){
                label.text = [[MrCoin settings] userPhone];
            }else if(indexPath.row == 1){
                label.text = [[MrCoin settings] userEmail];
            }else if(indexPath.row == 2){
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                label.text = [[MrCoin settings] sourceCurrency];
            }else if(indexPath.row == 3){
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                label.text = @"";
            }
        }
    }else{
        // Links
        label = (UILabel*)[cell viewWithTag:101];
        if(label)
        {
            if(indexPath.row == 0){
                label.text = NSLocalizedString(@"Support",nil);
            }else if(indexPath.row == 1){
                label.text = NSLocalizedString(@"Terms of Service",nil);
            }else if(indexPath.row == 2){
                label.text = NSLocalizedString(@"Terms of Service (short)",nil);
            }
        }
    }

    
    // Configure the cell...
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 1 && self.navigationController)
    {
        if(indexPath.row == 0){
            [self.navigationController pushViewController:[MrCoin documentViewController:MrCoinDocumentSupport] animated:YES];
        }else if(indexPath.row == 1){
            [self.navigationController pushViewController:[MrCoin documentViewController:MrCoinDocumentTerms] animated:YES];
        }else if(indexPath.row == 2){
            [self.navigationController pushViewController:[MrCoin documentViewController:MrCoinDocumentShortTerms] animated:YES];
        }
    }else if(indexPath.section == 0 && self.navigationController){
        if(indexPath.row == 2){
            [self.navigationController pushViewController:[MrCoin viewController:@"CurrencySettings"] animated:YES];
        }
        if(indexPath.row == 3){
            [[MrCoin settings] resetSettings];
            [[MrCoin rootController] showForm:self];
        }
    }
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section
{
    return 60.0f;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section == 0){
        return NSLocalizedString(@"Settings",nil);
    }
    return NSLocalizedString(@"Documents",nil);

}

- (void)viewWillAppear:(BOOL)animated
{
    [[self tableView] reloadData];
}



@end
