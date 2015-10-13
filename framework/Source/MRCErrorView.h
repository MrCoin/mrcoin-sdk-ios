//
//  MRCErrorView.h
//  MrCoin iOS SDK
//
//  Created by Gabor Nagy on 11/10/15.
//  Copyright © 2015 MrCoin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MRCErrorView : UIView

+ (instancetype) error:(NSString*)error inView:(UIView*)view frame:(CGRect)rect backgroundColor:(UIColor*)color;

- (void) dismiss:(void (^)(void))complete;

@end
