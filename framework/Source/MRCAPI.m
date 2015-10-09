//
//  MRCAPI.m
//  MrCoin iOS SDK
//
//  Created by Gabor Nagy on 05/10/15.
//  Copyright © 2015 MrCoin. All rights reserved.
//

#import "MRCAPI.h"

#define API_URL @"https://www.mrcoin.eu/api/v0/quick-transfer"

@implementation MRCAPI

#pragma mark - API methods 0.1
-(void) getWallet:(APIResponse)response error:(APIResponseError)error
{
    
}
-(void) getCountries:(APIResponse)response error:(APIResponseError)error
{
    
}
-(void) getAddress:(NSString*)address response:(APIResponse)response error:(APIResponseError)error
{
    NSDictionary *parameters = [self quickTransferDictionaryForAddress:@"1Fo2NXefxfEUayB3zFEMf4gHHAzMHWokBJ" phone:@"+442071234567" email:@"user@example.com" currencyCode:@"BTC" locale:@"en" timezone:@"Europe/London" reseller:@"Breadwallet"];
    [self call:parameters response:response error:error];
}

-(void) patchWallet:(NSDictionary*)patch response:(APIResponse)response error:(APIResponseError)error
{
    
}
-(void) requestVerificationCodeForCountry:(NSString*)country phone:(NSString*)phone response:(APIResponse)response error:(APIResponseError)error
{
    
}
-(void) verifyPhone:(NSString*)phone code:(NSString*)code response:(APIResponse)response error:(APIResponseError)error
{
    
}

#pragma mark - Generic methods
-(NSDictionary*) quickTransferDictionaryForAddress:(NSString*)address phone:(NSString*)phone email:(NSString*)email currencyCode:(NSString*)currencyCode
{
    return [self quickTransferDictionaryForAddress:address phone:phone email:email currencyCode:currencyCode locale:nil timezone:nil reseller:nil];
}
-(NSDictionary*) quickTransferDictionaryForAddress:(NSString*)address phone:(NSString*)phone email:(NSString*)email currencyCode:(NSString*)currencyCode locale:(NSString*)locale timezone:(NSString*)timezone reseller:(NSString*)reseller
{
    NSDictionary *parameters = @{
                                 @"data":@{
                                         @"type":@"quick_transfers",
                                         @"attributes":@{
                                                 @"destination-address":address,
                                                 @"currency-code":currencyCode,
                                                 @"email":email,
                                                 @"phone-number":phone,
                                                 @"locale":locale,
                                                 @"timezone":timezone,
                                                 @"reseller":reseller
                                                 }
                                         }
                                 };
    return parameters;
}
-(void) call:(NSDictionary*)parameters response:(APIResponse)responseBlock error:(APIResponseError)errorBlock
{
    NSURL *url = [[NSURL alloc] initWithString:API_URL];
    
    // Request
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&error];
    if(error){
        if(errorBlock) errorBlock(error,MRCAPInternalErrorType);
        return;
    }
    NSString *json;
    if ( jsonData) {
        json =  [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/vnd.api+json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/vnd.api+json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:[json dataUsingEncoding:NSUTF8StringEncoding]];

    // Response
    NSURLResponse *response;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if(error){
        if(errorBlock) errorBlock(error,MRCAPInternalErrorType);
        return;
    }
    if(responseBlock){
        NSDictionary *o = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&error];
        if(error){
            if(errorBlock) errorBlock(error,MRCAPInternalErrorType);
            return;
        }
        responseBlock(o);
    }
}
@end
