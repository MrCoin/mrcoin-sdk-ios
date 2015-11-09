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
    if(section == 0) return ([[MrCoin settings] userConfiguration] == MRCUserConfigured)? 4:1;
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *_id = @"SettingsLink";
    if(indexPath.section == 0){
        if([[MrCoin settings] userConfiguration] == MRCUserConfigured && indexPath.row < 3){
            _id = @"SettingsValue";
        }
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:_id forIndexPath:indexPath];
    
    UILabel *label;
    
    // Settings Value
    if(indexPath.section == 0){
        label = (UILabel*)[cell viewWithTag:201];
        if(indexPath.row == 0){
            if([[MrCoin settings] userConfiguration] == MRCUserConfigured){
                label.text = NSLocalizedString(@"Phone",nil);
            }else{
                label = (UILabel*)[cell viewWithTag:101];
                label.text = NSLocalizedString(@"Setup quicktransfer",nil);
            }
        }else if(indexPath.row == 1){
            label.text = NSLocalizedString(@"Email",nil);
        }else if(indexPath.row == 2){
            label.text = NSLocalizedString(@"Currency",nil);
        }else if(indexPath.row == 3){
            label = (UILabel*)[cell viewWithTag:101];
            label.text = NSLocalizedString(@"Reset quicktransfer",nil);
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
                label.text = NSLocalizedString(@"Contact",nil);
            }else if(indexPath.row == 2){
                label.text = NSLocalizedString(@"Website",nil);
            }else if(indexPath.row == 3){
                label.text = NSLocalizedString(@"Terms of Service",nil);
            }else if(indexPath.row == 4){
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
        UIViewController *vc;
        if(indexPath.row == 0){
            [[MrCoin sharedController] sendMail:[[MrCoin settings] supportEmail] subject:NSLocalizedString(@"Help me with QuickTransfer",nil)];
        }else if(indexPath.row == 1){
            vc = [MrCoin documentViewController:MrCoinDocumentSupport];
        }else if(indexPath.row == 2){
            [[MrCoin sharedController] openURL:[NSURL URLWithString:[[MrCoin settings] websiteURL]]];
        }else if(indexPath.row == 3){
            vc = [MrCoin documentViewController:MrCoinDocumentTerms];
        }else if(indexPath.row == 4){
            vc = [MrCoin documentViewController:MrCoinDocumentShortTerms];
        }
        if(vc){
            vc.view.backgroundColor = [UIColor whiteColor];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else if(indexPath.section == 0 && self.navigationController){
        if([[MrCoin settings] userConfiguration] == MRCUserConfigured){
            if(indexPath.row == 2){
                UIViewController *vc = [MrCoin viewController:@"CurrencySettings"];
                vc.view.backgroundColor = [UIColor whiteColor];
                [self.navigationController pushViewController:vc animated:YES];
            }else if(indexPath.row == 3){
                [MrCoin resetQuickTransfer];
            }
        }else{
            if(indexPath.row == 0){
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
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section
{
    return 60.0f;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section == 0){
        return NSLocalizedString(@"Quicktransfer",nil);
    }
    return NSLocalizedString(@"Links",nil);

}

- (void)viewWillAppear:(BOOL)animated
{
    [[self tableView] reloadData];
    [super viewWillAppear:animated];
}



@end
