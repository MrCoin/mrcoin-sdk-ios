//
//  MRCDropDown.m
//  MrCoin iOS SDK
//
//  Created by Gabor Nagy on 06/10/15.
//  Copyright © 2015 MrCoin. All rights reserved.
//

#import "MRCDropDown.h"

#define FETCHING       @"Fetching data..."
#define PLEASE_WAIT    @"Please Wait..."
#define TAP_TO_CHOOSE  @"Tap to choose"

@implementation MRCDropDown
{
    UIPickerView *picker;
    BOOL isLoading;
}

#pragma mark - Initialization
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.hasPasteButton = NO;
        self.selectedRow = -1;
        self.placeholder = TAP_TO_CHOOSE;
        
        // hide the caret and its blinking
        [[self valueForKey:@"textInputTraits"]
         setValue:[UIColor clearColor]
         forKey:@"insertionPointColor"];
        
        // setup the arrow image
        UIImage* img = [UIImage imageNamed:@"downArrow.png"];   // non-CocoaPods
        if (img == nil) img = [UIImage imageNamed:@"MrCoin.bundle/downArrow.png"]; // CocoaPod
        if(img){
            self.rightView = [[UIImageView alloc] initWithImage:img];
            self.rightView.contentMode = UIViewContentModeScaleAspectFit;
            self.rightView.clipsToBounds = YES;
            self.rightViewMode = UITextFieldViewModeAlways;
        }
        
        // setup loading
        UIActivityIndicatorView *loading = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        loading.frame = CGRectMake(0, 0, 40, 20);
        self.leftView = loading;
        self.leftView.contentMode = UIViewContentModeScaleAspectFit;
        
    }
    return self;
}

#pragma mark - Functions
-(void)showPicker
{
    if(!self.items) return;
    if(self.items.count == 0) return;
    picker = [[UIPickerView alloc] init];
    picker.dataSource = self;
    picker.delegate = self;
    self.inputView = picker;
    if(_selectedItem){
        [picker selectRow:_selectedRow inComponent:0 animated:NO];
    }else{
        self.text = _items[0];
    }

}
- (IBAction)doneEditing:(id)sender
{
    _selectedRow = [picker selectedRowInComponent:0];
    _selectedItem = _items[_selectedRow];

    [super doneEditing:sender];
}
- (IBAction)cancelEditing:(id)sender
{
    [super cancelEditing:sender];
    if(_selectedItem)
    {
        self.text = _selectedItem;
    }else{
        self.placeholder = TAP_TO_CHOOSE;
    }
}


#pragma mark - Loading view
@synthesize fetching = _fetching;
-(void)setFetching:(BOOL)fetching
{
    if(fetching == YES){
        [self showLoading];
    }else{
        [self hideLoading];
    }
    _fetching = fetching;
}
-(BOOL)isFetching
{
    return _fetching;
}
- (void) showLoading
{
    UIActivityIndicatorView *loading = (UIActivityIndicatorView*)self.leftView;
    [loading startAnimating];
    self.leftViewMode = UITextFieldViewModeAlways;
    self.placeholder = FETCHING;
    picker.showsSelectionIndicator = NO;
}
- (void) hideLoading
{
    UIActivityIndicatorView *loading = (UIActivityIndicatorView*)self.leftView;
    [loading stopAnimating];
    self.placeholder = TAP_TO_CHOOSE;
    self.leftViewMode = UITextFieldViewModeNever;
}

#pragma mark - Picker View
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(_items){
        return _items.count;
    }
    return 1;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(_items){
        return _items[row];
    }
    return PLEASE_WAIT;
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.text = _items[row];
}


#pragma mark - Textfield delegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if(!self.items || self.items.count == 0){
        [self showPicker];
        [super textFieldDidBeginEditing:textField];
        return NO;
    }
    self.userInteractionEnabled = NO;
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self showPicker];
    [super textFieldDidBeginEditing:textField];
//    //
//    BOOL isValid;
//    if(self.textInputDelegate){
//        if(![self.textInputDelegate respondsToSelector:@selector(textInputIsValid:)])
//        {
//            if(doneBarButton && _selectedRow >= 0){
//                doneBarButton.enabled = YES;
//             }else{
//                doneBarButton.enabled = NO;
//             }
//        }
//    }

}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [self hideLoading];
    [self endEditing:YES];

    self.userInteractionEnabled = YES;
    [super textFieldDidEndEditing:textField];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return NO;
}


@end
