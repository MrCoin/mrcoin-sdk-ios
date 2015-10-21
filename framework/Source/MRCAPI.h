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

typedef void (^APIResponseData)(NSData* response,NSInteger statusCode);
typedef void (^APIResponse)(id result);
typedef void (^APIResponseError)(NSArray* errors, MRCAPIErrorType errorType);

@interface MRCAPI : NSObject

@property (nonatomic) NSDictionary* country;
@property (nonatomic) NSArray* countries;


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


#pragma mark - SLIP-0013 (http://doc.satoshilabs.com/slips/slip-0013.html#hd-structure)
- (NSData*) slip13Hash:(UInt32)index uri:(NSString*)URI;
- (NSString*) slip13Path:(NSData*)hash;
- (NSString*) slip13Path:(UInt32)index uri:(NSString*)URI;

#pragma mark - Methods for testing
//-(void) callMethod:(NSString*)methodName parameters:(NSDictionary*)parameters HTTPMethod:(NSString*)HTTPMethod response:(APIResponse)responseBlock error:(APIResponseError)errorBlock;
-(NSURLRequest*) requestMethod:(NSString*)methodName parameters:(NSString*)jsonString HTTPMethod:(NSString*)HTTPMethod;

@end