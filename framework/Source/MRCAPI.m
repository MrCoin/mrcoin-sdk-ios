//
//  MRCAPI.m
//  MrCoin iOS SDK
//
//  Created by Gabor Nagy on 05/10/15.
//  Copyright © 2015 MrCoin. All rights reserved.
//

#import "MRCAPI.h"
#import "MrCoin.h"
//#import "NSString+NSHash.h"

#define API_URL         @"https://sandbox.mrcoin.eu/api/v1"
//#define API_URL         @"https://www.mrcoin.eu/api/v1"

@implementation MRCAPI


- (void) authenticate:(APIResponse)responseBlock error:(APIResponseError)errorBlock
{
    [self callMethod:@"authenticate" parameters:nil HTTPMethod:@"GET" response:responseBlock error:errorBlock];
}
- (void) getCountries:(APIResponse)responseBlock error:(APIResponseError)errorBlock
{
    [self callMethod:@"countries" parameters:nil HTTPMethod:@"GET" response:^(id result) {
        self.countries = (NSArray*)result;
        responseBlock(self.countries);
    } error:errorBlock];
}
- (void) getEmail:(APIResponse)responseBlock error:(APIResponseError)errorBlock
{
    NSString *n = [[MrCoin settings] userEmail];
    if(n){
        responseBlock(n);
        return;
    }
    [self callMethod:@"email" parameters:nil HTTPMethod:@"GET" response:^(id result) {
        NSString *n = [result valueForKeyPath:@"attributes.email"];
        [[MrCoin settings] setUserEmail:n];
        responseBlock(n);
    } error:errorBlock];
}
- (void) email:(NSString*)emailAddress success:(APIResponse)responseBlock error:(APIResponseError)errorBlock
{
    [[MrCoin sharedController] showActivityIndicator:NSLocalizedString(@"Sending data to MrCoin...",nil)];
    NSDictionary *parameters = [self dictionaryForMethod:@"email" parameters:@{@"email":emailAddress}];
    [self callMethod:@"email" parameters:parameters HTTPMethod:@"POST" response:responseBlock error:errorBlock];
}
- (void) getUserDetails:(APIResponse)responseBlock error:(APIResponseError)errorBlock
{
    [self callMethod:@"me" parameters:nil HTTPMethod:@"GET" response:responseBlock error:errorBlock];
}
- (void) updateUserDetails:(NSString*)currency success:(APIResponse)responseBlock error:(APIResponseError)errorBlock
{
    [self updateUserDetails:currency timezone:[NSTimeZone systemTimeZone] locale:[NSLocale currentLocale] success:responseBlock error:errorBlock];
}
- (void) updateUserDetails:(NSString*)currency timezone:(NSTimeZone*)timezone  locale:(NSLocale*)locale success:(APIResponse)responseBlock error:(APIResponseError)errorBlock
{
    NSDictionary *parameters = [self dictionaryForMethod:@"me" parameters:@{@"locale":[locale objectForKey:NSLocaleLanguageCode],@"timezone":[timezone name],@"currency":currency}];
    [self callMethod:@"me" parameters:parameters HTTPMethod:@"PATCH" response:responseBlock error:errorBlock];
}
- (void) phone:(NSString*)number country:(NSString*)countryCode success:(APIResponse)responseBlock error:(APIResponseError)errorBlock
{
    [[MrCoin sharedController] showActivityIndicator:NSLocalizedString(@"Sending data to MrCoin...",nil)];
    NSDictionary *parameters = [self dictionaryForMethod:@"phone" parameters:@{@"number":number,@"country":countryCode}];
    [self callMethod:@"phone" parameters:parameters HTTPMethod:@"POST" response:responseBlock error:errorBlock];
}
- (void) getPhone:(APIResponse)responseBlock error:(APIResponseError)errorBlock
{
    NSString *n = [[MrCoin settings] userPhone];
    if(n){
        responseBlock(n);
        return;
    }
    [self callMethod:@"phone" parameters:nil HTTPMethod:@"GET" response:^(id result) {
        NSString *n = [result valueForKeyPath:@"attributes.number"];
        [[MrCoin settings] setUserPhone:n];
        responseBlock(n);
    } error:errorBlock];
}
- (void) verifyPhone:(NSString*)verificationCode success:(APIResponse)responseBlock error:(APIResponseError)errorBlock
{
    NSDictionary *parameters = [self dictionaryForMethod:@"phone" parameters:@{@"verification_code":verificationCode}];
    [self callMethod:@"phone" parameters:parameters HTTPMethod:@"PATCH" response:responseBlock error:errorBlock];
}
- (void) getPriceTicker:(APIResponse)responseBlock error:(APIResponseError)errorBlock
{
    [self callMethod:@"price_ticker" parameters:nil HTTPMethod:@"GET" response:responseBlock error:errorBlock];
}
- (void) getTerms:(APIResponse)responseBlock error:(APIResponseError)errorBlock
{
    [self callMethod:@"terms" parameters:nil HTTPMethod:@"GET" response:^(id result) {
        NSString *n = [result valueForKeyPath:@"attributes.terms_html"];
        responseBlock(n);
    } error:errorBlock];
}

- (void) quickDeposits:(NSString*)destAddress currency:(NSString*)currency resellerID:(NSString*)resellerID success:(APIResponse)responseBlock error:(APIResponseError)errorBlock
{
    NSString *address = [[[MrCoin sharedController] delegate] requestDestinationAddress];
    if(!address){
        errorBlock(@[[NSError errorWithDomain:@"MrCoin" code:404 userInfo:nil]],MRCAPIMissingDataErrorType);
        return;
    }
    NSDictionary *parameters;
    if(resellerID){
        parameters = [self dictionaryForMethod:@"quick_deposits" parameters:@{@"destination_address":address,@"currency":currency,@"reseller_id":resellerID}];
    }else{
        parameters = [self dictionaryForMethod:@"quick_deposits" parameters:@{@"destination_address":address,@"currency":currency}];
    }
    [self callMethod:@"quick_deposits" parameters:parameters HTTPMethod:@"POST" response:responseBlock error:errorBlock];
}

#pragma mark - Generic internal methods
-(void) callMethod:(NSString*)methodName parameters:(NSDictionary*)parameters HTTPMethod:(NSString*)HTTPMethod response:(APIResponse)responseBlock error:(APIResponseError)errorBlock
{
    if(!errorBlock){
        errorBlock = ^(NSArray *errors, MRCAPIErrorType errorType) {
            [[MrCoin sharedController] showErrors:errors type:errorType];
        };
    }
    [self checkConfiguration];
    // Parametes
    NSString *jsonParams = [self parametersToJSON:parameters error:errorBlock];
    NSURLRequest *request = [self requestMethod:methodName parameters:jsonParams HTTPMethod:HTTPMethod];

    // Response
    [self sendRequest:request response:^(NSData *response,NSInteger statusCode) {
//        NSLog(@"%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
        NSDictionary *result = [self responseFromJSON:response error:errorBlock];
        [self _handleResult:result statusCode:statusCode success:responseBlock error:errorBlock];
    } error:errorBlock];
}
-(NSDictionary*) responseFromJSON:(NSData*)jsonResponse error:(APIResponseError)errorBlock
{
    NSLog(@"-----------------------------------");
    NSLog(@"Response: %@",[[NSString alloc] initWithData:jsonResponse encoding:NSUTF8StringEncoding]);

    NSError *error;
    NSDictionary *o = [NSJSONSerialization JSONObjectWithData:jsonResponse options:0 error:&error];
    if(error){
        if(errorBlock) errorBlock(@[error],MRCAPInternalErrorType);
        return nil;
    }
    return o;
}
-(NSString*) parametersToJSON:(NSDictionary*)parameters error:(APIResponseError)errorBlock
{
    if(!parameters) return nil;
    // Request
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&error];
    if(error){
        if(errorBlock) errorBlock(@[error],MRCAPInternalErrorType);
        return nil;
    }
    NSString *json;
    if ( jsonData) {
        json =  [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return json;
}
-(void) sendRequest:(NSURLRequest*)request response:(APIResponseData)responseBlock error:(APIResponseError)errorBlock
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        if(data){
            NSInteger statusCode = [(NSHTTPURLResponse*)response statusCode];
            responseBlock(data,statusCode);
        }else{
            if(connectionError){
                if(errorBlock) errorBlock(@[connectionError],MRCAPInternalErrorType);
            }
        }
    }];
}
- (NSError*) errorByStatus:(NSInteger)statusCode
{
    if(statusCode == 404)
    {
        return [NSError errorWithDomain:@"MrCoin" code:404 userInfo:@{NSLocalizedDescriptionKey:NSLocalizedString(@"ERROR_404", nil)}];
    }
    return [NSError errorWithDomain:@"MrCoin" code:statusCode userInfo:@{NSLocalizedDescriptionKey:NSLocalizedString(@"GENERIC_STATUS_ERROR", nil)}];
}
-(NSURLRequest*) requestMethod:(NSString*)methodName parameters:(NSString*)jsonString HTTPMethod:(NSString*)HTTPMethod
{
    NSURL *url = [[NSURL alloc] initWithString:[API_URL stringByAppendingPathComponent:methodName]];
//    NSLog(@"Request for URL: %@ (method:%@)",url,HTTPMethod);
//    NSLog(@"----------------------------------------------------------");
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:HTTPMethod];
    NSLog(@"-- MrCoin API ------------------------------------");
    
    // Nonce
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    double nonce = (now*1000.0);
    [request setValue:[NSString stringWithFormat:@"%.f",nonce] forHTTPHeaderField:@"X-Mrcoin-Api-Nonce"];
    NSLog(@"X-Mrcoin-Api-Nonce          %.f",nonce);
    
    NSString *message;
    //(nonce + request method + request path + post data)
    if(jsonString){
        message = [NSString stringWithFormat:@"%.f%@/api/v1/%@%@",nonce,HTTPMethod,methodName,jsonString];
    }else{
        message = [NSString stringWithFormat:@"%.f%@/api/v1/%@",nonce,HTTPMethod,methodName];
    }
    
    NSString *privateKey = [[[MrCoin sharedController] delegate] requestPrivateKey];
    NSString *sign = [[[MrCoin sharedController] delegate] requestMessageSignature:message privateKey:privateKey];
    NSString *publicKey = [[[MrCoin sharedController] delegate] requestPublicKey];
    
    // Public wallet key
    [request setValue:publicKey forHTTPHeaderField:@"X-Mrcoin-Api-Pubkey"];
    [request setValue:sign forHTTPHeaderField:@"X-Mrcoin-Api-Signature"];
    NSLog(@"X-Mrcoin-Api-Pubkey         %@",[request valueForHTTPHeaderField:@"X-Mrcoin-Api-Pubkey"]);
    NSLog(@"X-Mrcoin-Api-Signature      %@",[request valueForHTTPHeaderField:@"X-Mrcoin-Api-Signature"]);
    NSLocale *locale = [NSLocale currentLocale];
    if([[MrCoin settings] locale]){
        locale = [[MrCoin settings] locale];
    }
    [request setValue:[locale objectForKey:NSLocaleLanguageCode] forHTTPHeaderField:@"HTTP_ACCEPT_LANGUAGE"];
    [request setValue:@"application/vnd.api+json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/vnd.api+json" forHTTPHeaderField:@"Content-Type"];
    NSLog(@"Accept                      application/vnd.api+json");
    NSLog(@"Content-Type                application/vnd.api+json");
    if(jsonString){
        [request setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
        NSLog(@"Body:\n%@",jsonString);
    }
    
    return (NSURLRequest*)request;
}
-(NSDictionary*) dictionaryForMethod:(NSString*)methodName parameters:(NSDictionary*)parameters
{
    return @{
                                 @"data":@{
                                         @"type":methodName,
                                         @"attributes":parameters
                                         }
                                 };
}
- (void) _handleResult:(NSDictionary*)result statusCode:(NSInteger)statusCode success:(APIResponse)responseBlock error:(APIResponseError)errorBlock
{
    NSArray *rawErrors = [result objectForKey:@"errors"];
    if(rawErrors){
        if(errorBlock){
            NSMutableArray *errors = [NSMutableArray array];
            for (NSDictionary *rawError in rawErrors) {
                [errors addObject:[NSError errorWithDomain:@"MrCoin"
                                     code:[rawError[@"code"] integerValue]
                                 userInfo:@{
                                            NSLocalizedDescriptionKey:rawError[@"detail"],
                                            NSLocalizedFailureReasonErrorKey:rawError[@"title"]
                                            }]
                 ];
            }
            errorBlock(errors,MRCAPIGenericErrorType);
        }
    }else if([result objectForKey:@"data"]){
      if(responseBlock) responseBlock([result objectForKey:@"data"]);
    }
}
#pragma mark - Helpers
- (void) checkConfiguration
{
    NSAssert([[MrCoin sharedController] delegate],@"MrCoin Delegate isn't configured. See the README.");
    NSAssert([[[MrCoin sharedController] delegate] respondsToSelector:@selector(requestPublicKey)],@"MrCoin Delegate method (requestPublicKey) isn't configured. See the README.");
    NSAssert([[[MrCoin sharedController] delegate] respondsToSelector:@selector(requestPrivateKey)],@"MrCoin Delegate method (requestPrivateKey) isn't configured. See the README.");
    NSAssert([[[MrCoin sharedController] delegate] respondsToSelector:@selector(requestDestinationAddress)],@"MrCoin Delegate method (requestDestinationAddress) isn't configured. See the README.");
    NSAssert([[[MrCoin sharedController] delegate] respondsToSelector:@selector(requestMessageSignature:privateKey:)],@"MrCoin Delegate method (requestSignatureFor:privateKey:) isn't configured. See the README.");
}

@end


