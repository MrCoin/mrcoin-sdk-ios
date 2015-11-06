#import <Foundation/Foundation.h>

@interface NSData (SLIP_0013)

#pragma mark - SLIP-0013 (http://doc.satoshilabs.com/slips/slip-0013.html#hd-structure)
+ (NSData*) slip0013HashForIndex:(UInt32)index uri:(NSString*)URI;
+ (NSData*) slip0013:(NSData*)hash;
+ (NSData*) slip0013ForIndex:(UInt32)index uri:(NSString*)URI;

@end

@interface NSString (SLIP_0013)

+ (NSString*) slip0013ForIndex:(UInt32)index uri:(NSString*)URI;

@end
