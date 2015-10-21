//
//  MRCAPI.m
//  MrCoin iOS SDK
//
//  Created by Gabor Nagy on 05/10/15.
//  Copyright © 2015 MrCoin. All rights reserved.
//

#import "MRCAPI.h"
#import "MrCoin.h"
#import "NSData+NSHash.h"
#import "NSString+NSHash.h"
/*
 api:
 errors:
 invalid_signature:
 title: Invalid signature
 detail: The provided signature is invalid
 invalid_nonce:
 title: Invalid nonce
 detail: The provided nonce is invalid
 nonce_out_of_range:
 title: Nonce out of range
 detail: The provided nonce is out of the allowed range
 verify_phone_first:
 title: No verified phone
 detail: You must verify your phone number and try again
 invalid_country_code:
 title: Invalid country code
 detail: The provided country is not supported
 invalid_verification_code:
 title: Invalid verification code
 detail: The provided verification code is invalid
 phone_already_verified:
 title: Phone already verified
 detail: Phone already verified with this verification code
 verification_code_expired:
 title: Verification code expired
 detail: The provided verification code expired
 invalid_reseller:
 title: Invalid reseller id
 detail: The provided reseller id is invalid
 add_email_first:
 title: Add email first
 detail: An email address was not found, please add it first
 */
//#define API_TEST 1
#define API_URL         @"http://sandbox.mrcoin.eu/api/v1"

@implementation MRCAPI

- (NSData*) slip13Hash:(UInt32)index uri:(NSString*)URI
{
    // 1. Let’s concatenate the little endian representation of index with the URI.
    UInt32 little =  CFSwapInt32HostToLittle(index);
    NSMutableData *path = [NSMutableData data];
    [path appendBytes:&little length:4];
    [path appendData:[URI dataUsingEncoding:NSUTF8StringEncoding]];
    
    // 2. Compute the SHA256 hash of the result.
    return [path SHA256];
}
- (NSString*) slip13Path:(UInt32)index uri:(NSString*)URI
{
    NSData *hash = [self slip13Hash:index uri:URI];
    return [self slip13Path:hash];
}
- (NSString*) slip13Path:(NSData*)hash
{
    // 3. Let’s take first 128 bits of the hash and split it into four 32-bit numbers A, B, C, D.
    NSData *hashFirst128Bits = [hash subdataWithRange:NSMakeRange(0, 16)]; // first 16bytes (16*8 = 128)
    
    int32_t A,B,C,D;
    [hashFirst128Bits getBytes:&A range:NSMakeRange(0, 4)];
    [hashFirst128Bits getBytes:&B range:NSMakeRange(4, 4)];
    [hashFirst128Bits getBytes:&C range:NSMakeRange(8, 4)];
    [hashFirst128Bits getBytes:&D range:NSMakeRange(12, 4)];
    
    // 4. Set highest bits of numbers A, B, C, D to 1.
//    A = A | 0b00000010;
//    B = B | 0b00000010;
//    C = C | 0b00000010;
//    D = D | 0b00000010;
    
    NSString *a = [NSString stringWithFormat:@"m/%u/%u/%u/%u/%u",
            0x80000000 | 13,
            0x80000000 | A,
            0x80000000 | B,
            0x80000000 | C,
            0x80000000 | D];
    
    return a;
}

- (void) authenticate:(APIResponse)responseBlock error:(APIResponseError)errorBlock
{
#ifdef API_TEST
#else
    [self callMethod:@"authenticate" parameters:nil HTTPMethod:@"GET" response:responseBlock error:errorBlock];
#endif
}
- (void) getCountries:(APIResponse)responseBlock error:(APIResponseError)errorBlock
{
#ifdef API_TEST
    NSString *dummyURL = @"http://sandbox.mrcoin.eu/api/v1/docs/simulate/country/get_supported_countries";
    [self _dummyURL:dummyURL success:^(id result) {
        self.countries = (NSArray*)result;
        responseBlock(self.countries);
    } error:errorBlock];
#else
    [self callMethod:@"countries" parameters:nil HTTPMethod:@"GET" response:responseBlock error:errorBlock];
#endif
}
- (void) getEmail:(APIResponse)responseBlock error:(APIResponseError)errorBlock
{
#ifdef API_TEST
#else
    [self callMethod:@"email" parameters:nil HTTPMethod:@"GET" response:responseBlock error:errorBlock];
#endif
}
- (void) email:(NSString*)emailAddress success:(APIResponse)responseBlock error:(APIResponseError)errorBlock
{
    [[MrCoin sharedController] showActivityIndicator:NSLocalizedString(@"Sending data to MrCoin...",nil)];
#ifdef API_TEST
    NSString *dummyURL = @"http://sandbox.mrcoin.eu/api/v1/docs/simulate/email/assign_a_new_email_address";
    [self _dummyURL:dummyURL success:^(NSDictionary *dictionary) {
        responseBlock([dictionary objectForKey:@"data"]);
    } error:errorBlock];
#else
    NSDictionary *parameters = [self dictionaryForMethod:@"email" parameters:@{@"email":emailAddress}];
    [self callMethod:@"email" parameters:parameters HTTPMethod:@"POST" response:responseBlock error:errorBlock];
#endif
}
- (void) getUserDetails:(APIResponse)responseBlock error:(APIResponseError)errorBlock
{
#ifdef API_TEST
    responseBlock(nil);
#else
    [self callMethod:@"me" parameters:nil HTTPMethod:@"GET" response:responseBlock error:errorBlock];
#endif
}
- (void) updateUserDetails:(NSString*)currency success:(APIResponse)responseBlock error:(APIResponseError)errorBlock
{
    [self updateUserDetails:currency timezone:[NSTimeZone systemTimeZone] locale:[NSLocale currentLocale] success:responseBlock error:errorBlock];
}
- (void) updateUserDetails:(NSString*)currency timezone:(NSTimeZone*)timezone  locale:(NSLocale*)locale success:(APIResponse)responseBlock error:(APIResponseError)errorBlock
{
#ifdef API_TEST
    responseBlock(nil);
#else
    NSDictionary *parameters = [self dictionaryForMethod:@"me" parameters:@{@"locale":[locale objectForKey:NSLocaleLanguageCode],@"timezone":[timezone name],@"currency":currency}];
    [self callMethod:@"me" parameters:parameters HTTPMethod:@"PATCH" response:responseBlock error:errorBlock];
#endif
}
- (void) phone:(NSString*)number country:(NSString*)countryCode success:(APIResponse)responseBlock error:(APIResponseError)errorBlock
{
    [[MrCoin sharedController] showActivityIndicator:NSLocalizedString(@"Sending data to MrCoin...",nil)];
#ifdef API_TEST
//    NSString *dummyURL = @"http://sandbox.mrcoin.eu/api/v1/docs/simulate/phonenumber/invalid_phone_number";
    NSString *dummyURL = @"http://sandbox.mrcoin.eu/api/v1/docs/simulate/phonenumber/get_user's_phone_number";
    [self _dummyURL:dummyURL success:^(NSDictionary *dictionary) {
        responseBlock([dictionary objectForKey:@"data"]);
    } error:errorBlock];
#else
    NSDictionary *parameters = [self dictionaryForMethod:@"phone" parameters:@{@"number":number,@"country":countryCode}];
    [self callMethod:@"phone" parameters:parameters HTTPMethod:@"POST" response:responseBlock error:errorBlock];
#endif
}
- (void) getPhone:(APIResponse)responseBlock error:(APIResponseError)errorBlock
{
#ifdef API_TEST
    responseBlock(nil);
#else
    [self callMethod:@"phone" parameters:nil HTTPMethod:@"GET" response:responseBlock error:errorBlock];
#endif
}
- (void) verifyPhone:(NSString*)verificationCode success:(APIResponse)responseBlock error:(APIResponseError)errorBlock
{
    [[MrCoin sharedController] showActivityIndicator:NSLocalizedString(@"Sending data to MrCoin...",nil)];
#ifdef API_TEST
    NSString *dummyURL = @"http://sandbox.mrcoin.eu/api/v1/docs/simulate/phonenumber/verify_a_phone_number";
    [self _dummyURL:dummyURL success:^(NSDictionary *dictionary) {
        responseBlock([dictionary objectForKey:@"data"]);
    } error:errorBlock];
#else
    NSDictionary *parameters = [self dictionaryForMethod:@"phone" parameters:@{@"verification_code":verificationCode}];
    [self callMethod:@"phone" parameters:parameters HTTPMethod:@"PATCH" response:responseBlock error:errorBlock];
#endif
}
- (void) getPriceTicker:(APIResponse)responseBlock error:(APIResponseError)errorBlock
{
#ifdef API_TEST
    responseBlock(nil);
#else
    [self callMethod:@"price_ticker" parameters:nil HTTPMethod:@"GET" response:responseBlock error:errorBlock];
#endif
}
- (void) quickTransfers:(NSString*)destAddress currency:(NSString*)currency resellerID:(NSString*)resellerID success:(APIResponse)responseBlock error:(APIResponseError)errorBlock
{
#ifdef API_TEST
    NSString *dummyURL = @"http://sandbox.mrcoin.eu/api/v1/docs/simulate/quicktransfer/setup_a_quicktransfer";
    [self _dummyURL:dummyURL success:^(id result) {
        responseBlock((NSDictionary*)result);
    } error:errorBlock];

#else
    NSString *address = [[[MrCoin sharedController] delegate] requestDestinationAddress];
    if(!address){
        errorBlock(@[[NSError errorWithDomain:@"MrCoin" code:404 userInfo:nil]],MRCAPIMissingDataErrorType);
        return;
    }
    NSDictionary *parameters;
    if(resellerID){
        parameters = [self dictionaryForMethod:@"quick_transfers" parameters:@{@"destination_address":address,@"currency":currency,@"reseller_id":resellerID}];
    }else{
        parameters = [self dictionaryForMethod:@"quick_transfers" parameters:@{@"destination_address":address,@"currency":currency}];
    }
    [self callMethod:@"quick_transfers" parameters:parameters HTTPMethod:@"POST" response:responseBlock error:errorBlock];
#endif
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
//        NSLog(@"%@",result);
        [self _handleResult:result statusCode:statusCode success:responseBlock error:errorBlock];
    } error:errorBlock];
}
-(NSDictionary*) responseFromJSON:(NSData*)jsonResponse error:(APIResponseError)errorBlock
{
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
    NSLog(@"Request for URL: %@ (method:%@)",url,HTTPMethod);
    NSLog(@"----------------------------------------------------------");
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:HTTPMethod];
    
    // Nonce
    CGFloat nonce = ([[NSDate date] timeIntervalSince1970]*1000.0f);
    [request setValue:[NSString stringWithFormat:@"%.f",nonce] forHTTPHeaderField:@"X-Mrcoin-Api-Nonce"];
//    NSLog(@"X-Mrcoin-Api-Nonce          %.f",nonce);
    
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
//    NSLog(@"X-Mrcoin-Api-Pubkey         %@",[request valueForHTTPHeaderField:@"X-Mrcoin-Api-Pubkey"]);
//    NSLog(@"X-Mrcoin-Api-Signature      %@",[request valueForHTTPHeaderField:@"X-Mrcoin-Api-Signature"]);
    NSLocale *locale = [NSLocale currentLocale];
    if([[MrCoin settings] locale]){
        locale = [[MrCoin settings] locale];
    }
    [request setValue:[locale objectForKey:NSLocaleLanguageCode] forHTTPHeaderField:@"HTTP_ACCEPT_LANGUAGE"];
    [request setValue:@"application/vnd.api+json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/vnd.api+json" forHTTPHeaderField:@"Content-Type"];
//    NSLog(@"Accept                      application/vnd.api+json");
//    NSLog(@"Content-Type                application/vnd.api+json");
    if(jsonString){
        [request setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
        NSLog(@"Body:\n%@",[jsonString dataUsingEncoding:NSUTF8StringEncoding]);
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
                                     code:[rawError[@"status"] integerValue]
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
#ifdef API_TEST
- (void) _dummyURL:(NSString*)dummyURL success:(APIResponse)responseBlock error:(APIResponseError)errorBlock
{
    if(!errorBlock){
        errorBlock = ^(NSArray *errors, MRCAPIErrorType errorType) {
            [[MrCoin sharedController] showErrors:errors type:errorType];
        };
    }
    [self checkConfiguration];
    
    NSURL *url = [[NSURL alloc] initWithString:dummyURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    // Response
    [self sendRequest:request response:^(NSData *response,NSInteger statusCode) {
        NSDictionary *result = [self responseFromJSON:response error:errorBlock];
        [self _handleResult:result statusCode:statusCode success:responseBlock error:errorBlock];
    } error:errorBlock];
}
#endif
- (void) checkConfiguration
{
    NSAssert([[MrCoin sharedController] delegate],@"MrCoin Delegate isn't configured. See the README.");
    NSAssert([[[MrCoin sharedController] delegate] respondsToSelector:@selector(requestPublicKey)],@"MrCoin Delegate method (requestPublicKey) isn't configured. See the README.");
    NSAssert([[[MrCoin sharedController] delegate] respondsToSelector:@selector(requestPrivateKey)],@"MrCoin Delegate method (requestPrivateKey) isn't configured. See the README.");
    NSAssert([[[MrCoin sharedController] delegate] respondsToSelector:@selector(requestDestinationAddress)],@"MrCoin Delegate method (requestDestinationAddress) isn't configured. See the README.");
    NSAssert([[[MrCoin sharedController] delegate] respondsToSelector:@selector(requestMessageSignature:privateKey:)],@"MrCoin Delegate method (requestSignatureFor:privateKey:) isn't configured. See the README.");
}

@end

//
//@interface NSURLRequest (NSURLRequestSSLY)
//+(BOOL)allowsAnyHTTPSCertificateForHost:(NSString*)host;
//
//@end
//
//@implementation NSURLRequest (NSURLRequestSSLY)
//+(BOOL)allowsAnyHTTPSCertificateForHost:(NSString*)host
//{
//    return YES;
//}

//@end


