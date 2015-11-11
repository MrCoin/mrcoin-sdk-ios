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
    BOOL endEditing;
    
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
        self.cursor = YES;
        _hasPasteButton = YES;
        self.delegate = self;
    }
    return self;
}
- (CGSize)intrinsicContentSize
{
    CGRect r = CGRectZero;
    r.size = [super intrinsicContentSize];
    return CGRectInset(r, -(self.font.pointSize*0.5f), -(self.font.pointSize*0.25f)).size;
}
#pragma mark - Layout
-(CGRect)placeholderRectForBounds:(CGRect)bounds
{
    CGRect r = CGRectInset(bounds, 10, 0);
    return r;
}
- (CGRect)textRectForBounds:(CGRect)bounds {
    return [self editingRectForBounds:bounds];
}
- (CGRect)editingRectForBounds:(CGRect)bounds {
    CGRect r = CGRectInset(bounds, 10, 0);
    CGRect lr = [self leftViewRectForBounds:self.bounds];
    r.origin.x = lr.size.width+lr.origin.x+5;
    r.size.width -= lr.size.width+lr.origin.x;
    //
    return r;
}
#pragma mark - Functions


- (IBAction)doneEditing:(id)sender
{
    endEditing = YES;
    [self endEditing:YES];
}
- (IBAction)cancelEditing:(id)sender
{
    endEditing = NO;
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
    endEditing = NO;
    if(self.superview)
    {
        _originalFrame = self.superview.frame;
        CGPoint p = [self.window convertPoint:CGPointZero fromView:self];
        //        CGFloat bottomY = p.y+self.intrinsicContentSize.height;
        CGFloat bottomY = p.y+self.bounds.size.height;
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
                if(self.textInputDelegate){
                    [self.textInputDelegate textInputFinishedEditing:self];
                    if(endEditing){
                        [self.textInputDelegate textInputDone:self];
                        endEditing = NO;
                    }
                }
            }];
        }
    }
}

#pragma mark - TextField Delegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(self.cursor){
        [[self valueForKey:@"textInputTraits"]
         setValue:[UIColor lightGrayColor]
         forKey:@"insertionPointColor"];
    }else{
        [[self valueForKey:@"textInputTraits"]
         setValue:[UIColor clearColor]
         forKey:@"insertionPointColor"];
    }

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
    if(self.dataType.defaultValue){
        self.text = self.dataType.defaultValue;
    }
    [self show];
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if(self.textInputDelegate){
        if([self.textInputDelegate respondsToSelector:@selector(textInputWillEndEditing:)])
        {
            return [self.textInputDelegate textInputWillEndEditing:self];
        }
    }
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self doneEditing:textField];
//    [self hide];
//    [textField resignFirstResponder];
//    if(self.textInputDelegate){
//        [self.textInputDelegate textInputEndEditing:self];
//    }
    return NO;
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [self hide];
    if(self.textInputDelegate){
        [self.textInputDelegate textInputEndEditing:self];
    }
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    BOOL isChanged = YES;
    if(self.dataType){
        NSString *firstString = [textField.text substringWithRange:NSMakeRange(0, range.location+range.length)];
        NSString *unformatedFirstString = [self.dataType unformat:firstString];
        NSString *unformatedString = unformatedFirstString;
        NSInteger diff = firstString.length-unformatedFirstString.length;
        
        range = NSMakeRange(range.location-diff, range.length);
        
        NSString *newString = [unformatedString stringByReplacingCharactersInRange:range withString:string];
        if(self.dataType.defaultValue){
            if(self.dataType.defaultValue.length <= newString.length)
            {
//                newString = ;
                self.text = [self.dataType format:newString];
            }
        }else{
//            newString = [self.dataType unformat:newString];
            self.text = [self.dataType format:newString];
        }
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
    newText = [self.dataType unformat:newText];

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
                                       initWithTitle:NSLocalizedString(@"Next", NULL) style:UIBarButtonItemStyleDone
                                       target:self action:@selector(doneEditing:)];
//    doneBarButton = [[UIBarButtonItem alloc]
//                                      initWithBarButtonSystemItem:UIBarButtonSystemItemDone
//                                      target:self action:@selector(doneEditing:)];
    UIBarButtonItem *cancelBarButton = [[UIBarButtonItem alloc]
                                        initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                        target:self action:@selector(cancelEditing:)];
    if(_hasPasteButton){
        UIBarButtonItem *pasteBarButton = [[UIBarButtonItem alloc]
                                           initWithTitle:NSLocalizedString(@"Paste", NULL) style:UIBarButtonItemStyleDone
                                           target:self action:@selector(pasteClipboard:)];
        keyboardToolbar.items = @[cancelBarButton, flexBarButton, pasteBarButton, flexBarButton, doneBarButton];
    }else{
        keyboardToolbar.items = @[cancelBarButton, flexBarButton, doneBarButton];
    }
    self.inputAccessoryView = keyboardToolbar;
}
@end
