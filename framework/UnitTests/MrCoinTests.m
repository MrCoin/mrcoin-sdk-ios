//
//  MrCoinIOSSDKTests.m
//  MrCoinIOSSDKTests
//
//  Created by Gabor Nagy on 04/10/15.
//  Copyright © 2015 MrCoin. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MRCVerificationCode.h"
#import "MRCPhoneData.h"
#import "MRCEmailData.h"
#import "MRCAPI.h"
#import "MrCoin.h"

@interface MrCoinTests : XCTestCase <MrCoinDelegate>

@end

@implementation MrCoinTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testAPIRequest {
    [[MrCoin sharedController] setDelegate:self];
    MRCAPI *api = [[MRCAPI alloc] init];
    [[MrCoin settings] setWalletPrivateKey:@"PRIVATE"];
    [[MrCoin settings] setWalletPublicKey:@"PUBLIC"];

    NSURLRequest *r = [api requestMethod:@"authenticate" parameters:@"{@\"some\":@\"thing\"}" HTTPMethod:@"POST"];
    NSString *nonce = [r valueForHTTPHeaderField:@"X-Mrcoin-Api-Nonce"];
    NSString *sign = [r valueForHTTPHeaderField:@"X-Mrcoin-Api-Signature"];
    NSString *validString = [NSString stringWithFormat:@"%@POST/api/v1/authenticate{@\"some\":@\"thing\"}",nonce];

    XCTAssertEqualObjects([r valueForHTTPHeaderField:@"X-Mrcoin-Api-Pubkey"],@"PUBLIC");
    XCTAssertEqualObjects(sign,validString);
    XCTAssertEqualObjects([r valueForHTTPHeaderField:@"Accept"],@"application/vnd.api+json");
    XCTAssertEqualObjects([r valueForHTTPHeaderField:@"Content-Type"],@"application/vnd.api+json");
    XCTAssertTrue([r valueForHTTPHeaderField:@"HTTP_ACCEPT_LANGUAGE"]);
    XCTAssertEqualObjects([r valueForHTTPHeaderField:@"HTTP_ACCEPT_LANGUAGE"],@"en");
    
    api.language = @"hu";
    r = [api requestMethod:@"authenticate" parameters:nil HTTPMethod:@"POST"];
    XCTAssertEqualObjects([r valueForHTTPHeaderField:@"HTTP_ACCEPT_LANGUAGE"],@"hu");

}
- (NSString *)requestSignatureFor:(NSString *)message privateKey:(NSString *)privateKey
{
    return message;
}

- (void)testVerificationValidator {
    MRCVerificationCode *formatter = [[MRCVerificationCode alloc] init];
    XCTAssertFalse([formatter isValid:@"∂ß´¥"]); // Invalid chars
    XCTAssertTrue(formatter.minimumLength == 4,@"[MRCVerificationCode minimumLength]");
    XCTAssertTrue(formatter.maximumLength == 4,@"[MRCVerificationCode maximumLength]");
    XCTAssertFalse([formatter isValid:@""]);
    XCTAssertFalse([formatter isValid:@"12345"]);
    XCTAssertFalse([formatter isValid:@"12345"]);
    XCTAssertTrue([formatter isValid:@"1234"]);
}
- (void)testPhoneValidator {
    MRCPhoneData *formatter = [[MRCPhoneData alloc] init];
    [formatter setCountryCode:@"hu"];
    XCTAssertFalse([formatter isValid:@"∂ß´¥ƒ∆˚ç˙@˚∂¨¥ß.¨¥"]); // Invalid chars
    XCTAssertFalse([formatter isValid:@"+36112"]); // TOO SHORT
    XCTAssertFalse([formatter isValid:@"+36"]); // EMPTY
    XCTAssertFalse([formatter isValid:@"+363012345678"]); // TOO LONG
    XCTAssertTrue([formatter isValid:@"+36301234567"]);
    XCTAssertTrue([formatter isValid:@"+3611234567"]);
}
- (void)testPhoneFormatter {
    MRCPhoneData *formatter = [[MRCPhoneData alloc] init];
    [formatter setCountryCode:@"hu"];
    XCTAssertEqualObjects([formatter format:@"+3611234567"], @"+36 1 123 4567");
    XCTAssertEqualObjects([formatter unformat:@"+36 1 123 4567"], @"+3611234567");
    XCTAssertEqualObjects([formatter format:@"+36207654321"], @"+36 20 765 4321");
    XCTAssertEqualObjects([formatter unformat:@"+36 20 765 4321"], @"+36207654321");
}
- (void)testEmailValidator {
    MRCEmailData *formatter = [[MRCEmailData alloc] init];
    XCTAssertFalse([formatter isValid:@"kovacs@jancsi@politikus.hu"]); // Invalid chars
    XCTAssertFalse([formatter isValid:@"∂ß´¥ƒ∆˚ç˙@˚∂¨¥ß.¨¥"]); // Invalid chars
    XCTAssertFalse([formatter isValid:@"k@a.h"]); // Short
    XCTAssertFalse([formatter isValid:@"sergej@oil.r"]); // Invalid domain
    XCTAssertTrue([formatter isValid:@"ivan.ivanovics.gorkij@kiosk.ru"]);
}

@end
