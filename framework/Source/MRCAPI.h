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

typedef void (^APIResponseData)(NSData* response);
typedef void (^APIResponse)(NSDictionary* dictionary);
typedef void (^APIResponseError)(NSError* error, MRCAPIErrorType errorType);

@interface MRCAPI : NSObject

@property (nonatomic) NSString* language;
@property (nonatomic) NSDictionary* country;
;

- (void) authenticate:(APIResponse)responseBlock error:(APIResponseError)errorBlock;
- (void) getCountries:(APIResponse)responseBlock error:(APIResponseError)errorBlock;
- (void) email:(NSString*)emailAddress success:(APIResponse)responseBlock error:(APIResponseError)errorBlock;
- (void) getEmail:(APIResponse)responseBlock error:(APIResponseError)errorBlock;
- (void) getUserDetails:(APIResponse)responseBlock error:(APIResponseError)errorBlock;
- (void) updateUserDetails:(NSString*)currency success:(APIResponse)responseBlock error:(APIResponseError)errorBlock;
- (void) updateUserDetails:(NSString*)currency timezone:(NSTimeZone*)timezone  locale:(NSLocale*)locale success:(APIResponse)responseBlock error:(APIResponseError)errorBlock;
- (void) phone:(NSString*)number country:(NSString*)countryCode success:(APIResponse)responseBlock error:(APIResponseError)errorBlock;
- (void) getPhone:(APIResponse)responseBlock error:(APIResponseError)errorBlock;
- (void) verifyPhone:(NSString*)verificationCode success:(APIResponse)responseBlock error:(APIResponseError)errorBlock;
- (void) quickTransfers:(NSString*)destAddress currency:(NSString*)currency resellerID:(NSString*)resellerID success:(APIResponse)responseBlock error:(APIResponseError)errorBlock;

- (void) getPriceTicker:(APIResponse)responseBlock error:(APIResponseError)errorBlock;

- (NSArray*) countries;

@end