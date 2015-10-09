//
//  MRCAPI.h
//  MrCoin iOS SDK
//
//  Created by Gabor Nagy on 05/10/15.
//  Copyright © 2015 MrCoin. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    MRCAPIGenericErrorType,         //
    MRCAPIMissingDataErrorType,     //
    MRCAPIMissingWalletErrorType,   //
    MRCAPInternalErrorType          // 
} MRCAPIErrorType;

typedef void (^APIResponse)(NSDictionary* dictionary);
typedef void (^APIResponseError)(NSError* error, MRCAPIErrorType errorType);

@interface MRCAPI : NSObject

-(void) getWallet:(APIResponse)response error:(APIResponseError)error;
-(void) getCountries:(APIResponse)response error:(APIResponseError)error;
-(void) getAddress:(NSString*)address response:(APIResponse)response error:(APIResponseError)error;

-(void) patchWallet:(NSDictionary*)patch response:(APIResponse)response error:(APIResponseError)error;

-(void) requestVerificationCodeForCountry:(NSString*)country phone:(NSString*)phone response:(APIResponse)response error:(APIResponseError)error;
-(void) verifyPhone:(NSString*)phone code:(NSString*)code response:(APIResponse)response error:(APIResponseError)error;


@end