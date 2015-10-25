//
//  AppDelegate.swift
//  SwiftExample
//
//  Created by Gabor Nagy on 05/10/15.
//  Copyright © 2015 MrCoin. All rights reserved.
//

import UIKit
import MrCoinFramework

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, MrCoinDelegate {

    var window: UIWindow?
    let key = BTCKey(WIF: "5HpkEX6HKihoxMCwPTkWQmV4fDZPvjZr4zcXC5dZj5jwc539m9P");

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        window?.backgroundColor = UIColor.grayColor()

        let settings = MrCoin.settings()

        // Framework Settings
        settings.showErrorOnTextField = true
//        settings.showPopupOnError = false
        
        // Setup your reseller key
        settings.resellerKey = "9b85a53c-88fb-4a56-b4b0-4088153e4b7e"
        
        MrCoin.sharedController().delegate = self;
        MrCoin.sharedController().needsAcceptTerms = false;
//        MrCoin.api().authenticate({ (result) -> Void in
//            print(result);
//            }) { (errors, type) -> Void in
//                print(errors);
//        }

        return true
    }
    
    // MARK: MrCoin Delegate
    func requestPublicKey() -> String! {
        return key.compressedPublicKey.hex()
    }
    func requestPrivateKey() -> String! {
        return BTCBase58CheckStringWithData(key.privateKey)
    }
    func requestMessageSignature(message: String!, privateKey: String!) -> String! {
        let hash = BTCSHA256(message.dataUsingEncoding(NSUTF8StringEncoding))
        let sign = key.signatureForHash(hash)
        return BTCHexFromData(sign);
    }
    func requestDestinationAddress() -> String! {
        return key.address.base58String;
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

