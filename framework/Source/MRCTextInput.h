//
//  MRCTextInput.h
//  MrCoin iOS SDK
//
//  Created by Gabor Nagy on 05/10/15.
//  Copyright © 2015 MrCoin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MRCTextInput;
@class MRCInputDataType;

@protocol MRCTextInputDelegate <NSObject>

-(void) textInputStartEditing:(MRCTextInput*)textInput;
-(void) textInputEndEditing:(MRCTextInput*)textInput;
-(void) textInputFinishedEditing:(MRCTextInput*)textInput;
-(void) textInputDone:(MRCTextInput*)textInput;

@optional
-(BOOL) textInput:(MRCTextInput*)textInput changeText:(NSString *)string inRange:(NSRange)range;
-(BOOL) textInputIsValid:(MRCTextInput *)textInput;
-(BOOL) textInputWillEndEditing:(MRCTextInput*)textInput;
-(void) textInput:(MRCTextInput *)textInput isValid:(BOOL)valid;

@end

@interface MRCTextInput : UITextField <UITextFieldDelegate>

@property (nonatomic,readwrite) IBInspectable BOOL cursor;
@property (nonatomic,readwrite) IBInspectable BOOL hasPasteButton;
@property (nonatomic) id <MRCTextInputDelegate> textInputDelegate;
@property (nonatomic) MRCInputDataType *dataType;

- (IBAction)doneEditing:(id)sender;
- (IBAction)cancelEditing:(id)sender;

-(void)showError:(NSString*)errorMessage;
-(void)hideError;

@end
