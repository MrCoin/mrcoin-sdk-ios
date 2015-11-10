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
    self.showTerms = YES;
    self.showHeaders = NO;
    
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
//    if(section == 0) return ([[MrCoin settings] userConfiguration] == MRCUserConfigured)? 4:1;
    return (self.showTerms)?3:2;
}
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    // Background color
    view.tintColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.8];
    
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
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *_id = @"SettingsLink";
    if(indexPath.section == 0){
        if(indexPath.row == 3) _id = @"SettingsLink";
        else _id = @"SettingsValue";
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:_id forIndexPath:indexPath];
    
    UILabel *label;
    
    // Settings Value
    if(indexPath.section == 0){
        label = (UILabel*)[cell viewWithTag:201];
        if(indexPath.row == 0){
            label.text = NSLocalizedString(@"phone",nil);
        }else if(indexPath.row == 1){
            label.text = NSLocalizedString(@"email",nil);
        }else if(indexPath.row == 2){
            label.text = NSLocalizedString(@"currency",nil);
        }else if(indexPath.row == 3){
            label = (UILabel*)[cell viewWithTag:101];
            label.text = NSLocalizedString(@"setup quicktransfer",nil);
        }

        label = (UILabel*)[cell viewWithTag:202];
        if(label)
        {
            if(indexPath.row == 0){
                if(([[MrCoin settings] userConfiguration] == MRCUserPhoneConfigured)){
                    label.text = [[MrCoin settings] userPhone];
                }else{
                    label.text = NSLocalizedString(@"unconfigured", NULL);
                }
                cell.accessoryType = UITableViewCellAccessoryNone;
            }else if(indexPath.row == 1){
                if(([[MrCoin settings] userConfiguration] == MRCUserConfigured)){
                    label.text = [[MrCoin settings] userEmail];
                }else{
                    label.text = NSLocalizedString(@"unconfigured", NULL);
                }
                cell.accessoryType = UITableViewCellAccessoryNone;
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
                label.text = NSLocalizedString(@"website",nil);
            }else if(indexPath.row == 1){
                label.text = NSLocalizedString(@"support",nil);
            }else if(indexPath.row == 2){
                label.text = NSLocalizedString(@"terms",nil);
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
        UIViewController *vc;
        if(indexPath.row == 0){
            [[MrCoin sharedController] openURL:[NSURL URLWithString:[[MrCoin settings] websiteURL]]];
        }else if(indexPath.row == 1){
            vc = [MrCoin documentViewController:MrCoinDocumentSupport];
//            [[MrCoin sharedController] sendMail:[[MrCoin settings] supportEmail] subject:NSLocalizedString(@"Help me with QuickTransfer",nil)];
        }else if(indexPath.row == 2){
            vc = [MrCoin documentViewController:MrCoinDocumentTerms];
//        }else if(indexPath.row == 3){
//        }else if(indexPath.row == 4){
//            vc = [MrCoin documentViewController:MrCoinDocumentShortTerms];
        }
        if(vc){
            vc.view.backgroundColor = [UIColor whiteColor];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else if(indexPath.section == 0 && self.navigationController){
        if(indexPath.row == 2){
            UIViewController *vc = [MrCoin viewController:@"CurrencySettings"];
//                vc.view.backgroundColor = [UIColor whiteColor];
            [self.navigationController pushViewController:vc animated:YES];
        }else if(indexPath.row == 3){
            if([[MrCoin settings] userConfiguration] == MRCUserConfigured){
                [MrCoin resetQuickTransfer];
            }else{
                [MrCoin setupQuickTransfer];
            }
        }
    }
}
-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([[MrCoin settings] userConfiguration] == MRCUserConfigured){
        if(indexPath.section == 0 && indexPath.row < 2) return NO;
    }

    return YES;
}
//-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section
//{
//    return 50.0f;
//}
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    if(!self.showHeaders)   return nil;
//    return [super tableView:tableView viewForHeaderInSection:section];
//}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(!self.showHeaders)   return @" ";
    //
    if(section == 0){
        return NSLocalizedString(@"Quicktransfer",nil);
    }
    return NSLocalizedString(@" ",nil);

}

- (void)viewWillAppear:(BOOL)animated
{
    [[self tableView] reloadData];
    [super viewWillAppear:animated];
}



@end
