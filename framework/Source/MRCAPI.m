//
//  MRCAPI.m
//  MrCoin iOS SDK
//
//  Created by Gabor Nagy on 05/10/15.
//  Copyright © 2015 MrCoin. All rights reserved.
//

#import "MRCAPI.h"
#import "MrCoin.h"

#define API_PUBKEY      @"020087a4a177da43687cfa02d1b9b5579282b3dd560a12f4f719932fd78b1be162"
#define API_SIGNATURE   @"3045022100c948e62ecfe7c1b38dbbac923de14fb7196863e76b187d1ff5b88a7f5d1a80e402202314170cb0e7be5c784f79079e4d595f71acbfb4ee465594a8de296edd98c111"
#define API_NONCE       @"1444516672"
#define API_URL         @"https://www.mrcoin.eu/api/v1"

@implementation MRCAPI

#pragma mark - API methods 0.1
//-(void) getMe:(APIResponse)response error:(APIResponseError)error
//{
//    
//}
//-(void) getCountries:(APIResponse)response error:(APIResponseError)error
//{
//    
//}
//-(void) getAddress:(NSString*)address response:(APIResponse)response error:(APIResponseError)error
//{
//    NSString *phone = [[MrCoin settings] userPhone];
//    NSString *email = [[MrCoin settings] userEmail];
//    //
//    NSString *reseller = [[MrCoin settings] resellerKey];
//    NSString *btcAddress = [[MrCoin settings] bitcoinAddress];
//    NSString *timezone = [[NSTimeZone systemTimeZone] name];
//    NSString *locale = [[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode];
//    NSString *destinationCurrency = [[MrCoin settings] destinationCurrency];
//    
//    NSDictionary *parameters = [self quickTransferDictionaryForAddress:btcAddress phone:phone email:email currencyCode:destinationCurrency locale:locale timezone:timezone reseller:reseller];
//    [self call:parameters response:response error:error];
//}
//
//-(void) patchWallet:(NSDictionary*)patch response:(APIResponse)response error:(APIResponseError)error
//{
//    response(nil);
//}
//-(void) requestVerificationCodeForCountry:(NSString*)country phone:(NSString*)phone response:(APIResponse)response error:(APIResponseError)error
//{
//    response(nil);
//}
//-(void) verifyPhone:(NSString*)phone code:(NSString*)code response:(APIResponse)response error:(APIResponseError)error
//{
//    response(nil);
////    error([NSError errorWithDomain:@"MrCoin" code:0 userInfo:nil],MRCAPIGenericErrorType);
//}
- (void) checkConfiguration
{
    NSAssert([[MrCoin settings] walletPublicKey],@"Public wallet key isn't configured. See the README.");
    NSAssert([[MrCoin settings] walletPrivateKey],@"Private wallet key isn't configured. See the README.");
    NSAssert([[MrCoin sharedController] delegate],@"MrCoin Delegate isn't configured. See the README.");
    NSAssert([[[MrCoin sharedController] delegate] respondsToSelector:@selector(requestSignatureFor:privateKey:)],@"MrCoin Delegate method (requestSignatureFor:privateKey:) isn't configured. See the README.");
}
- (void) authenticate:(APIResponse)responseBlock error:(APIResponseError)errorBlock
{
    [self callMethod:@"authenticate" parameters:nil HTTPMethod:@"GET" response:responseBlock error:errorBlock];
}
- (void) getCountries:(APIResponse)responseBlock error:(APIResponseError)errorBlock
{
    NSString *dummyURL = @"http://sandbox.mrcoin.eu/api/v1/docs/simulate/country/get_supported_countries";
    [self _dummyURL:dummyURL success:^(id result) {
        self.countries = (NSArray*)result;
        responseBlock(self.countries);
    } error:errorBlock];
    // TODO: Implement!
//    [self callMethod:@"countries" parameters:nil HTTPMethod:@"GET" response:responseBlock error:errorBlock];
}
- (void) getEmail:(APIResponse)responseBlock error:(APIResponseError)errorBlock
{
    // TODO: Implement!
    [self callMethod:@"email" parameters:nil HTTPMethod:@"GET" response:responseBlock error:errorBlock];
}
- (void) email:(NSString*)emailAddress success:(APIResponse)responseBlock error:(APIResponseError)errorBlock
{
    NSString *dummyURL = @"http://sandbox.mrcoin.eu/api/v1/docs/simulate/email/assign_a_new_email_address";
    [self _dummyURL:dummyURL success:^(NSDictionary *dictionary) {
        _countries = [dictionary objectForKey:@"data"];
        responseBlock(dictionary);
    } error:errorBlock];

    // TODO: Implement!
//    NSDictionary *parameters = [self dictionaryForMethod:@"email" parameters:@{@"email":emailAddress}];
//    [self callMethod:@"email" parameters:parameters HTTPMethod:@"POST" response:responseBlock error:errorBlock];
}
- (void) getUserDetails:(APIResponse)responseBlock error:(APIResponseError)errorBlock
{
    // TODO: Implement!
    [self callMethod:@"me" parameters:nil HTTPMethod:@"GET" response:responseBlock error:errorBlock];
}
- (void) updateUserDetails:(NSString*)currency success:(APIResponse)responseBlock error:(APIResponseError)errorBlock
{
    // TODO: Implement!
    [self updateUserDetails:currency timezone:[NSTimeZone systemTimeZone] locale:[NSLocale currentLocale] success:responseBlock error:errorBlock];
}
- (void) updateUserDetails:(NSString*)currency timezone:(NSTimeZone*)timezone  locale:(NSLocale*)locale success:(APIResponse)responseBlock error:(APIResponseError)errorBlock
{
    // TODO: Implement!
    NSDictionary *parameters = [self dictionaryForMethod:@"me" parameters:@{@"locale":[locale objectForKey:NSLocaleLanguageCode],@"timezone":[timezone name],@"currency":currency}];
    [self callMethod:@"me" parameters:parameters HTTPMethod:@"PATCH" response:responseBlock error:errorBlock];
}
- (void) phone:(NSString*)number country:(NSString*)countryCode success:(APIResponse)responseBlock error:(APIResponseError)errorBlock
{
    //    NSString *dummyURL = @"http://sandbox.mrcoin.eu/api/v1/docs/simulate/phonenumber/get_user's_phone_number";
    NSString *dummyURL = @"http://sandbox.mrcoin.eu/api/v1/docs/simulate/phonenumber/invalid_phone_number";
    [self _dummyURL:dummyURL success:^(NSDictionary *dictionary) {
        _countries = [dictionary objectForKey:@"data"];
        responseBlock(dictionary);
    } error:errorBlock];
    // TODO: Implement!
//    NSDictionary *parameters = [self dictionaryForMethod:@"phone" parameters:@{@"number":number,@"country":countryCode}];
//    [self callMethod:@"phone" parameters:parameters HTTPMethod:@"POST" response:responseBlock error:errorBlock];
}
- (void) getPhone:(APIResponse)responseBlock error:(APIResponseError)errorBlock
{
    // TODO: Implement!
  [self callMethod:@"phone" parameters:nil HTTPMethod:@"GET" response:responseBlock error:errorBlock];
}
- (void) verifyPhone:(NSString*)verificationCode success:(APIResponse)responseBlock error:(APIResponseError)errorBlock
{
    NSString *dummyURL = @"http://sandbox.mrcoin.eu/api/v1/docs/simulate/phonenumber/verify_a_phone_number";
    [self _dummyURL:dummyURL success:^(NSDictionary *dictionary) {
        _countries = [dictionary objectForKey:@"data"];
        responseBlock(dictionary);
    } error:errorBlock];

    // TODO: Implement!
//    NSDictionary *parameters = [self dictionaryForMethod:@"phone" parameters:@{@"verification_code":verificationCode}];
//    [self callMethod:@"phone" parameters:parameters HTTPMethod:@"PATCH" response:responseBlock error:errorBlock];
}
- (void) getPriceTicker:(APIResponse)responseBlock error:(APIResponseError)errorBlock
{
    // TODO: Implement!
    [self callMethod:@"price_ticker" parameters:nil HTTPMethod:@"GET" response:responseBlock error:errorBlock];
}
- (void) quickTransfers:(NSString*)destAddress currency:(NSString*)currency resellerID:(NSString*)resellerID success:(APIResponse)responseBlock error:(APIResponseError)errorBlock
{
    

    NSString *dummyURL = @"http://sandbox.mrcoin.eu/api/v1/docs/simulate/quicktransfer/setup_a_quicktransfer";
    [self _dummyURL:dummyURL success:^(NSDictionary *dictionary) {
        _countries = [dictionary objectForKey:@"data"];
        responseBlock(dictionary);
    } error:errorBlock];
    
    // TODO: Implement!
//    NSDictionary *parameters = [self dictionaryForMethod:@"quick_transfers" parameters:@{@"destination_address":destAddress,@"currency":currency,@"reseller_id":resellerID}];
//    [self callMethod:@"quick_transfers" parameters:parameters HTTPMethod:@"POST" response:responseBlock error:errorBlock];
}

#pragma mark - Generic internal methods
-(void) callMethod:(NSString*)methodName parameters:(NSDictionary*)parameters HTTPMethod:(NSString*)HTTPMethod response:(APIResponse)responseBlock error:(APIResponseError)errorBlock
{
    [self checkConfiguration];
    // Parametes
    NSString *jsonParams = [self parametersToJSON:parameters error:errorBlock];
    NSURLRequest *request = [self requestMethod:methodName parameters:jsonParams HTTPMethod:@"POST"];
    
    // Response
    [self sendRequest:request response:^(NSData *response,NSInteger statusCode) {
        NSDictionary *result = [self responseFromJSON:response error:errorBlock];
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
        if(connectionError){
            if(errorBlock) errorBlock(@[connectionError],MRCAPInternalErrorType);
//            return;
        }else{
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            NSInteger statusCode = [(NSHTTPURLResponse*)response statusCode];
            responseBlock(data,statusCode);
        }
    }];
    
//    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
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
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:HTTPMethod];
    
    // Public wallet key
    [request setValue:[[MrCoin settings] walletPublicKey] forHTTPHeaderField:@"X-Mrcoin-Api-Pubkey"];

    // Nonce
    NSInteger nonce = [[NSNumber numberWithFloat:[[NSDate date] timeIntervalSince1970]] integerValue];
    [request setValue:[NSString stringWithFormat:@"%lx",nonce] forHTTPHeaderField:@"X-Mrcoin-Api-Nonce"];
  
    NSString *message;
    //(nonce + request method + request path + post data)
    if(jsonString){
        message = [NSString stringWithFormat:@"%lx%@/api/v1/%@%@",nonce,HTTPMethod,methodName,jsonString];
    }else{
        message = [NSString stringWithFormat:@"%lx%@/api/v1/%@",nonce,HTTPMethod,methodName];
    }
    NSString *sign = [[[MrCoin sharedController] delegate] requestSignatureFor:message privateKey:[[MrCoin settings] walletPrivateKey]];
    [request setValue:sign forHTTPHeaderField:@"X-Mrcoin-Api-Signature"];
    if(!self.language) self.language = @"en";
    [request setValue:self.language forHTTPHeaderField:@"HTTP_ACCEPT_LANGUAGE"];
    [request setValue:@"application/vnd.api+json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/vnd.api+json" forHTTPHeaderField:@"Content-Type"];
    if(jsonString)  [request setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
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
#pragma mark - Temporary
- (void) _dummyURL:(NSString*)dummyURL success:(APIResponse)responseBlock error:(APIResponseError)errorBlock
{
    [self checkConfiguration];
    
    NSURL *url = [[NSURL alloc] initWithString:dummyURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    // Response
    [self sendRequest:request response:^(NSData *response,NSInteger statusCode) {
        NSDictionary *result = [self responseFromJSON:response error:errorBlock];
        [self _handleResult:result statusCode:statusCode success:responseBlock error:errorBlock];
    } error:errorBlock];
}

@end
