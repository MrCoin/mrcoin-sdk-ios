//
//  MRCTextInput.m
//  MrCoin iOS SDK
//
//  Created by Gabor Nagy on 05/10/15.
//  Copyright © 2015 MrCoin. All rights reserved.
//

#import "MRCTextInput.h"
#import "MRCErrorView.h"
#import "MrCoin.h"
#import "MRCInputDataType.h"

#define ERROR_COLOR     [UIColor colorWithRed:217.0f/256.0f green:40.0f/256.0f blue:49.0f/256.0f alpha:1.0f]
#define ERROR_FILLCOLOR [UIColor colorWithRed:217.0f/256.0f green:40.0f/256.0f blue:49.0f/256.0f alpha:0.5f]

@implementation MRCTextInput
{
    CGRect _originalFrame;
    UIBarButtonItem *doneBarButton;
    
    UITextBorderStyle _originalBorder;
    UIColor *_originalColor;
    
    BOOL _hasError;
    MRCErrorView *_errorView;
}

#pragma mark - Initialization
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        _hasPasteButton = YES;
        self.delegate = self;
    }
    return self;
}

#pragma mark - Functions
- (IBAction)doneEditing:(id)sender
{
    if(self.textInputDelegate){
        [self.textInputDelegate textInputDone:self];
    }
    [self endEditing:YES];
}
- (IBAction)cancelEditing:(id)sender
{
    self.text = @"";
    BOOL isValid = [self _validateText:@""];
    if(isValid){
        doneBarButton.enabled = YES;
    }else{
        doneBarButton.enabled = NO;
    }
    [self endEditing:YES];
}
- (IBAction)pasteClipboard:(id)sender
{
    self.text = [UIPasteboard generalPasteboard].string;
}
-(void)hideError
{
    if(!_hasError) return;
    self.rightViewMode = UITextFieldViewModeNever;
    self.rightView = nil;
    _hasError = NO;
    if(_errorView){
        [_errorView dismiss:^{
            if(!_hasError) _errorView = nil;
            
        }];
    }
}
-(void)showError:(NSString*)errorMessage
{
    _hasError = YES;
        UIImage* img = [MrCoin imageNamed:@"error"];
        if(img){
            self.rightView = [[UIImageView alloc] initWithImage:img];
            self.rightView.contentMode = UIViewContentModeScaleAspectFit;
            self.rightView.clipsToBounds = YES;
            self.rightViewMode = UITextFieldViewModeAlways;
        }
    _errorView = [MRCErrorView error:errorMessage inView:self.superview frame:self.frame backgroundColor:ERROR_COLOR];
}
-(void)show
{
    if(self.superview)
    {
        _originalFrame = self.superview.frame;
        CGPoint p = [self.window convertPoint:CGPointZero fromView:self];
        CGFloat bottomY = p.y+self.intrinsicContentSize.height;
        CGFloat contentH = self.window.bounds.size.height-280.f;//
        CGFloat yDiff = contentH-bottomY;

        if(yDiff > 0) return;
        CGRect f = _originalFrame;
        f.origin.y += yDiff;
        [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.superview.frame = f;
        } completion:^(BOOL finished) {
            
        }];
    }
}
-(void)hide
{
    if(self.superview)
    {
        if(!CGRectEqualToRect(CGRectZero, _originalFrame)){
            [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.superview.frame = _originalFrame;
            } completion:^(BOOL finished) {
                
            }];
        }
    }
}

#pragma mark - TextField Delegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self hideError];
    [self addButtons];
    BOOL isValid = [self _validateText:self.text];
    
    if(doneBarButton){
        if(isValid){
            doneBarButton.enabled = YES;
        }else{
            doneBarButton.enabled = NO;
        }
    }
    if(self.textInputDelegate){
        [self.textInputDelegate textInputStartEditing:self];
    }
    [self show];
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if(self.textInputDelegate){
        [self.textInputDelegate textInputEndEditing:self];
    }
    [self hide];
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    BOOL isChanged = YES;
    if(self.dataType){
        NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        newString = [self.dataType unformat:newString];
        self.text = [self.dataType format:newString];
        isChanged = NO;
    }else{
        if(self.textInputDelegate){
            if([self.textInputDelegate respondsToSelector:@selector(textInput:changeText:inRange:)])
            {
                isChanged = [self.textInputDelegate textInput:self changeText:string inRange:range];
            }
        }
    }
    //
    BOOL isValid = [self _validateText:self.text];
    if(isValid){
        doneBarButton.enabled = YES;
    }else{
        doneBarButton.enabled = NO;
    }
    return isChanged;
}
-(BOOL)_validateText:(NSString*)newText
{
    BOOL isValid = YES;
    if(self.dataType){
        isValid = [self.dataType isValid:newText];
        if(self.dataType.maximumLength == -1){
            if((self.dataType.minimumLength > newText.length)){
                isValid = NO;
            }
        }else{
            if((self.dataType.minimumLength > newText.length) || (self.dataType.maximumLength < newText.length)){
                isValid = NO;
            }
        }
        if(self.textInputDelegate){
            if([self.textInputDelegate respondsToSelector:@selector(textInput:isValid:)])
            {
                [self.textInputDelegate textInput:self isValid:isValid];
            }
        }
    }else{
        if(self.textInputDelegate){
            if([self.textInputDelegate respondsToSelector:@selector(textInputIsValid:)])
            {
                isValid = [self.textInputDelegate textInputIsValid:self];
            }
        }
    }
    return isValid;
}
#pragma mark - Toolbar
- (void)addButtons {
    if(self.inputAccessoryView) return;
    //
    UIToolbar* keyboardToolbar = [[UIToolbar alloc] init];
    [keyboardToolbar sizeToFit];
    UIBarButtonItem *flexBarButton = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                      target:nil action:nil];
    doneBarButton = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                      target:self action:@selector(doneEditing:)];
    UIBarButtonItem *cancelBarButton = [[UIBarButtonItem alloc]
                                        initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                        target:self action:@selector(cancelEditing:)];
    if(_hasPasteButton){
        UIBarButtonItem *pasteBarButton = [[UIBarButtonItem alloc]
                                           initWithTitle:@"Paste" style:UIBarButtonItemStyleDone
                                           target:self action:@selector(pasteClipboard:)];
        keyboardToolbar.items = @[cancelBarButton, flexBarButton, pasteBarButton, flexBarButton, doneBarButton];
    }else{
        keyboardToolbar.items = @[cancelBarButton, flexBarButton, doneBarButton];
    }
    self.inputAccessoryView = keyboardToolbar;
}
@end
