//
//  MRCDropDown.m
//  MrCoin iOS SDK
//
//  Created by Gabor Nagy on 06/10/15.
//  Copyright © 2015 MrCoin. All rights reserved.
//

#import "MRCDropDown.h"
#import "MrCoin.h"

//#define FETCHING       @"Fetching data..."
//#define PLEASE_WAIT    @"Please Wait..."
//#define TAP_TO_CHOOSE  @"Tap to choose"

@implementation MRCDropDown
{
    NSString *_originalPlaceholder;
    
    UIPickerView *picker;
    BOOL isLoading;
}

#pragma mark - Initialization
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        if(self.placeholder){
            _originalPlaceholder = self.placeholder;
        }else{
            _originalPlaceholder = NSLocalizedString(@"Tap to choose", nil);
        }
        self.placeholder = _originalPlaceholder;
        self.hasPasteButton = NO;
        self.selectedRow = -1;
        
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
    picker.backgroundColor = [UIColor whiteColor];
    self.inputView = picker;
    if(_selectedItem){
        [picker selectRow:_selectedRow inComponent:0 animated:NO];
    }else{
        [self pickerView:picker didSelectRow:0 inComponent:0];
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
        self.placeholder = _originalPlaceholder;
        if(_iconItems && self.leftView && [self.leftView isKindOfClass:[UIImageView class]]){
            self.leftView = nil;
        }
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
    self.placeholder = NSLocalizedString(@"Fetching...", nil);
    picker.showsSelectionIndicator = NO;
}
- (void) hideLoading
{
    if(self.leftView){
        if(![self.leftView isKindOfClass:[UIImageView class]]){
            UIActivityIndicatorView *loading = (UIActivityIndicatorView*)self.leftView;
            [loading stopAnimating];
            self.placeholder = _originalPlaceholder;
            self.leftViewMode = UITextFieldViewModeNever;
        }
    }
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
    return NSLocalizedString(@"Please wait...", nil);
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view
{
    if (!view)
    {
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 30)];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(35, 3, 245, 24)];
        label.backgroundColor = [UIColor clearColor];
        label.tag = 1;
        if(_iconItems){
            UIImageView *flagView = [[UIImageView alloc] initWithFrame:CGRectMake(3, 3, 24, 24)];
            flagView.contentMode = UIViewContentModeScaleAspectFit;
            flagView.tag = 2;
            [view addSubview:flagView];
        }else{
            label.frame = CGRectMake(3, 3, 277, 24);
        }
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [view addSubview:label];
    }
    
    //        ((UILabel *)[view viewWithTag:1]).text = [[self class] countryNames][(NSUInteger)row];
    if(_items){
        ((UILabel *)[view viewWithTag:1]).text = _items[row];
    }
    if(_iconItems){
        ((UIImageView *)[view viewWithTag:2]).image = [MrCoin imageNamed:_iconItems[row]];
    }
    return view;
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.text = _items[row];
    UIImageView *v;
    UIImage *img = [MrCoin imageNamed:_iconItems[row]];
    if(_iconItems){
        if(!self.leftView){
            v = [[UIImageView alloc] initWithImage:img];
        }else{
            if(![self.leftView isKindOfClass:[UIImageView class]]){
                [self.leftView removeFromSuperview];
                v = [[UIImageView alloc] initWithImage:img];
            }else{
                v = (UIImageView*)self.leftView;
            }
            [v setImage:[MrCoin imageNamed:_iconItems[row]]];
        }
        v.layer.shouldRasterize = YES;
        v.layer.rasterizationScale = 2;
        v.frame = CGRectMake(0, 0, 24, 24);
        v.contentMode = UIViewContentModeScaleAspectFit;
        self.leftViewMode = UITextFieldViewModeAlways;
        self.leftView = v;
    }else{
        self.leftView = nil;
    }
}
- (CGRect)leftViewRectForBounds:(CGRect)bounds
{
    if(self.leftView){
        CGRect r = self.leftView.bounds;
        r.origin.x = 10.0f;
        r.origin.y = (bounds.size.height-r.size.height)*0.5f;
        return r;
    }
    return CGRectZero;
}

#pragma mark - Textfield delegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    self.cursor = NO;
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
