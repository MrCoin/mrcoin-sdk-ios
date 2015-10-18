# MrCoin iOS SDK #

## Working implementations##

###Swift Project Example###
###Obj-C Project Example###
###Our Wallet App###

## Adding this as a framework (module) to your iOS project ##

Xcode 6 and iOS 8 support the use of full frameworks, as does the Mac, which simplifies the process of adding this to your application. 

![image](docs/add_fw_1.png)

- To add this to your application, I recommend dragging the **MrCoin iOS SDK.xcodeproj** project file from framework folder into your application's project 

For your application, go to its **target build settings** and choose the **Build Phases** tab. 

![image](docs/add_fw_2.png)

- Under the **Target Dependencies** grouping, add **MrCoin Agregate** Agregate to the list (not MrCoinFramework).

![image](docs/add_fw_3.png)

- Under the **Link binary with Libraries** grouping, add **MrCoinFramework.framework** to the list (not MrCoin, which builds the static library).

![image](docs/add_fw_4.png)

Finally, under the **Copy bundle Resources** grouping, drag **MrCoin.bundle** to the list from the SDK build folder **MrCoin iOS SDK.xcodeproj/Products**.

This should cause MrCoin to build as a framework. To use the MrCoin classes within your application, simply include the core framework header using the following:

    #import <MrCoinFramework/MrCoinFramework.h>

Under Xcode 6+, this will also build as a module, which will allow you to use this in Swift projects. When set up as above, you should just need to use 

    import MrCoinFramework

to pull it in.


##### Alternatively: Adding the static library to your iOS project

Note: if you want to use this in a Swift project, you need to use the steps in the "Adding this as a framework" section instead of the following. Swift needs modules for third-party code.

Once you have the latest source code for the framework, it's fairly straightforward to add it to your application. Start by dragging the **MrCoin iOS SDK.xcodeproj** file into your application's Xcode project to embed the framework in your project. Next, go to your application's target and add **MrCoin** as a Target Dependency. Finally, you'll want to drag the **libMrCoin.a** library from the MrCoin SDK framework's Products folder to the Link Binary With Libraries build phase in your application's target.

To use the MrCoin classes within your application, simply include the core framework header using the following:

    #import "MrCoin.h"

Additionally, this is an ARC-enabled framework, so if you want to use this within a manual reference counted application targeting iOS 4.x, you'll need to add -fobjc-arc to your Other Linker Flags as well.

## Setup your MrCoin Delegate Class##

You need to implement the **MrCoinDelegate** protocol to provide some necessary information to the API. 

#### API HTTP Headers
Authentication is successful if the following headers are present:

**X-Mrcoin-Api-Pubkey** 
Public key used for signing. For HD wallet derivation path please see below.

**X-Mrcoin-Api-Signature** 
Bitcoin message signature of (nonce + request method + request path + post data)

**X-Mrcoin-Api-Nonce** 
Unsigned 63 bit integer

[Read more about API Header Structure & HD Wallet Derivation Path](http://sandbox.mrcoin.eu/api/v1/docs#authentication-dummy-endpoint)

    [[MrCoin sharedController] setDelegate:self];
    
    [[MrCoin api] authenticate:^(id result) {
        NSLog(@"result %@",result);
    } error:^(NSArray *errors, MRCAPIErrorType errorType) {
        NSLog(@"errors %@",errors);
    }];

#### Public key ####

Example implementation from our iOS Wallet App:

	- (NSString*) requestPublicKey
	{
	}

#### Private key ####

Example implementation from our iOS Wallet App:

	- (NSString*) requestPrivateKey
	{
	}
#### Signature ####
We need a bitcoin message signature of provided message (nonce + request method + request path + post data). The SDK provides a message string for example:

	1444560003GET/api/v1/authenticate?any=thing

We need to send back a valid signature to the API as you see in the following example from our iOS Wallet App:

	- (NSString*) requestMessageSignature:(NSString*)message privateKey:(NSString*)privateKey;
	{
	}

Example of a generated signature:
	


#### Optional delegate methods ####



## Technical requirements ##

- iOS 7.0 as a deployment target
- minimum iOS 8.0 SDK to build
- The framework uses automatic reference counting (ARC).

## License ##
Licensed under the Apache License, Version 2.0

[read more...](./LICENSE)

