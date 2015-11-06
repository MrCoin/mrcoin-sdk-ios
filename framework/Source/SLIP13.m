#import "SLIP13.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSData (SLIP_0013)

+ (NSData*) slip0013HashForIndex:(UInt32)index uri:(NSString*)URI
{
    // 1. Let’s concatenate the little endian representation of index with the URI.
    UInt32 little =  CFSwapInt32HostToLittle(index);
    NSMutableData *path = [NSMutableData data];
    [path appendBytes:&little length:4];
    [path appendData:[URI dataUsingEncoding:NSUTF8StringEncoding]];
    
    // 2. Compute the SHA256 hash of the result.
    return [path mrc_SHA256];
}
+ (NSData*) slip0013:(NSData*)hash
{
    // 3. Let’s take first 128 bits of the hash and split it into four 32-bit numbers A, B, C, D.
    NSData *hashFirst128Bits = [hash subdataWithRange:NSMakeRange(0, 16)]; // first 16bytes (16*8 = 128)
    
    int32_t I,A,B,C,D;
    [hashFirst128Bits getBytes:&A range:NSMakeRange(0, 4)];
    [hashFirst128Bits getBytes:&B range:NSMakeRange(4, 4)];
    [hashFirst128Bits getBytes:&C range:NSMakeRange(8, 4)];
    [hashFirst128Bits getBytes:&D range:NSMakeRange(12, 4)];
    
    // 4. Set highest bits of numbers A, B, C, D to 1.
    I = 0x80000000 | 13;
    A = 0x80000000 | A;
    B = 0x80000000 | B;
    C = 0x80000000 | C;
    D = 0x80000000 | D;
    
    NSMutableData *data = [NSMutableData data];
    [data appendBytes:&I length:4];
    [data appendBytes:&A length:4];
    [data appendBytes:&B length:4];
    [data appendBytes:&C length:4];
    [data appendBytes:&D length:4];
    
    return data;
}
+ (NSData*) slip0013ForIndex:(UInt32)index uri:(NSString*)URI
{
    return [self slip0013:[self slip0013HashForIndex:index uri:URI]];
}
- (NSData*) mrc_SHA256 {
    unsigned int outputLength = CC_SHA256_DIGEST_LENGTH;
    unsigned char output[outputLength];
    
    CC_SHA256(self.bytes, (unsigned int) self.length, output);
    return [NSMutableData dataWithBytes:output length:outputLength];
}

@end

@implementation NSString (SLIP_0013)

+ (NSString*) slip0013ForIndex:(UInt32)index uri:(NSString*)URI
{
    int32_t I,A,B,C,D;
    NSData *slip13 = [NSData slip0013HashForIndex:index uri:URI];
    [slip13 getBytes:&I range:NSMakeRange(0, 4)];
    [slip13 getBytes:&A range:NSMakeRange(4, 4)];
    [slip13 getBytes:&B range:NSMakeRange(8, 4)];
    [slip13 getBytes:&C range:NSMakeRange(12, 4)];
    [slip13 getBytes:&D range:NSMakeRange(16, 4)];
    
    return [NSString stringWithFormat:@"m/%u/%u/%u/%u/%u",I,A,B,C,D];
}

@end
