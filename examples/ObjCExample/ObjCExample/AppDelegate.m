//
//  AppDelegate.m
//  ObjCExample
//
//  Created by Gabor Nagy on 05/10/15.
//  Copyright © 2015 MrCoin. All rights reserved.
//

#import "AppDelegate.h"
#import <CoreBitcoin/CoreBitcoin.h>
#import <CoreBitcoin/NS+BTCBase58.h>
#import <CoreBitcoin/NSData+BTCData.h>

@interface AppDelegate ()

@end

@implementation AppDelegate
{
    BTCKey *key;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    key = [[BTCKey alloc] initWithWIF:@"5HpkEX6HKihoxMCwPTkWQmV4fDZPvjZr4zcXC5dZj5jwc539m9P"];
    
    MRCSettings *settings = [MrCoin settings];
    
    [settings setShowErrorOnTextField:YES];
    [settings setShowPopupOnError:NO];
    [settings setResellerKey:@"9b85a53c-88fb-4a56-b4b0-4088153e4b7e"];
    
    [[MrCoin sharedController] setNeedsAcceptTerms:NO];
    [[MrCoin sharedController] setDelegate:self];
    
    [[MrCoin api] authenticate:^(id result) {
        NSLog(@"result: %@",result);
    } error:^(NSArray *errors, MRCAPIErrorType errorType) {
        NSLog(@"errors: %@",errors);
    }];
    return YES;
}

#pragma mark - MrCoin Delegate
-(NSString *)requestPublicKey
{
    return [key.compressedPublicKey hex];
}
-(NSString *)requestPrivateKey
{
    return BTCBase58CheckStringWithData(key.privateKey);
}
-(NSString *)requestMessageSignature:(NSString *)message privateKey:(NSString *)privateKey
{
    NSData *hashedMessage = BTCSHA256([message dataUsingEncoding:NSUTF8StringEncoding]);
    NSData *sign = [key signatureForHash:hashedMessage];
    return BTCHexFromData(sign);
}
-(NSString *)requestDestinationAddress
{
    return [key.address base58String];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
