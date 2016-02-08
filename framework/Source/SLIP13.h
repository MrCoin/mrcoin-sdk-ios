#import <Foundation/Foundation.h>

@interface NSData (SLIP_0013)

#pragma mark - SLIP-0013 (https://github.com/satoshilabs/slips/blob/master/slip-0013.md)
+ (NSData*) slip0013HashForIndex:(UInt32)index uri:(NSString*)URI;
+ (NSData*) slip0013:(NSData*)hash;
+ (NSData*) slip0013ForIndex:(UInt32)index uri:(NSString*)URI;

@end

@interface NSString (SLIP_0013)

+ (NSString*) slip0013ForIndex:(UInt32)index uri:(NSString*)URI;

@end
