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
- (void)testSLIP13_Hash {
    MRCAPI *api = [[MRCAPI alloc] init];
    
    XCTAssertEqualObjects(@"d0e2389d4c8394a9f3e32de01104bf6e8db2d9e2bb0905d60fffa5a18fd696db", fromHEX([api slip13Hash:0 uri:@"https://satoshi@bitcoin.org/login"]));
    XCTAssertEqualObjects(@"79a6b53831c6ff224fb283587adc4ebae8fb0d734734a46c876838f52dff53f3", fromHEX([api slip13Hash:3 uri:@"ftp://satoshi@bitcoin.org:2323/pub"]));
    XCTAssertEqualObjects(@"5fa612f558a1a3b1fb7f010b2ea0a25cb02520a0ffa202ce74a92fc6145da5f3", fromHEX([api slip13Hash:47 uri:@"ssh://satoshi@bitcoin.org"]));
}
- (void)testSLIP13_Path {
    MRCAPI *api = [[MRCAPI alloc] init];
    
    XCTAssertEqualObjects(@"m/2147483661/2637750992/2845082444/3761103859/4005495825",
                          [api slip13Path:0 uri:@"https://satoshi@bitcoin.org/login"]);
    XCTAssertEqualObjects(@"m/2147483661/3098912377/2734671409/3632509519/3125730426", [api slip13Path:3 uri:@"ftp://satoshi@bitcoin.org:2323/pub"]);
    XCTAssertEqualObjects(@"m/2147483661/4111640159/2980290904/2332131323/3701645358", [api slip13Path:47 uri:@"ssh://satoshi@bitcoin.org"]);
}
- (void)testAPIRequest {
    [[MrCoin sharedController] setDelegate:self];
    MRCAPI *api = [[MRCAPI alloc] init];
//
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
    
    r = [api requestMethod:@"authenticate" parameters:nil HTTPMethod:@"POST"];
}
-(NSString *)requestPrivateKey
{
    return @"PRIVATE";
}
-(NSString *)requestPublicKey
{
    return @"PUBLIC";
}
-(NSString *)requestDestinationAddress
{
    return @"ADDRESS";
}
-(NSString *)requestMessageSignature:(NSString *)message privateKey:(NSString *)privateKey
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
NSString* fromHEX(NSData* data)
{
    const char* format = "%02x";
    if (!data) return nil;
    
    NSUInteger length = data.length;
    if (length == 0) return @"";
    
    NSMutableData* resultdata = [NSMutableData dataWithLength:length * 2];
    char *dest = resultdata.mutableBytes;
    unsigned const char *src = data.bytes;
    for (int i = 0; i < length; ++i)
    {
        sprintf(dest + i*2, format, (unsigned int)(src[i]));
    }
    return [[NSString alloc] initWithData:resultdata encoding:NSASCIIStringEncoding];
}
@end
