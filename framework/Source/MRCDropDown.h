//
//  MRCDropDown.h
//  MrCoin iOS SDK
//
//  Created by Gabor Nagy on 06/10/15.
//  Copyright © 2015 MrCoin. All rights reserved.
//

#import "MRCTextInput.h"

@interface MRCDropDown : MRCTextInput <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic) NSArray *items;
@property (nonatomic) NSInteger selectedRow;
@property (nonatomic) id selectedItem;

@end
