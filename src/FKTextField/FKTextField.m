/*
 
 FKTextField.m
 FieldKit
 
 Copyright (cc) 2012 Luis Laugga.
 Some rights reserved, all wrongs deserved.
 
 Licensed under a Creative Commons Attribution-ShareAlike 3.0 License;
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://creativecommons.org/licenses/by-sa/3.0/
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" basis,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 
*/

#import "FKTextField.h"
#import "FKTextField_Internal.h"
#import "FKTextField+UITextInput.h"

#import "FKTextAppearance.h"

@implementation FKTextField

@synthesize textContentView = _contentView;
@synthesize textSelectionView = _selectionView;
@synthesize textInteractionAssistant = _interactionAssistant;

@synthesize editing = _editing;
@synthesize editable = _editable;

@synthesize delegate = _delegate;

#pragma mark -
#pragma mark Initialization

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        // Set up view
        self.backgroundColor = [FKTextAppearance defaultBackgroundColor];
        _editing = NO;
        _editable = YES; // default
        
        // Set up content view
        _contentView = [[FKTextContentView alloc] initWithFrame:self.bounds];
        _contentView.autoresizingMask = (UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin); // autoresizing handled in layoutSubviews
        _contentView.contentMode = UIViewContentModeBottomLeft; // don't scale text content view
        [self addSubview:_contentView];
        
        // Set up selection view
        _selectionView = [[FKTextSelectionView alloc] initWithSelectingContainer:self];
        _selectionView.autoresizingMask = (UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight);
        
        // Set up interaction assistant
        _interactionAssistant = [[FKTextInteractionAssistant alloc] initWithSelectingContainer:self];
    }
    return self;
}

- (void)dealloc
{
    
    
    // Clean up
    [_interactionAssistant release];
    [_selectionView removeFromSuperview];
    [_selectionView release];
    [_contentView removeFromSuperview];
    [_contentView release];
    
    [super dealloc];
}

#pragma mark -
#pragma mark Properties

- (NSString *)text 
{
    return _contentView.text;
}

- (void)setText:(NSString *)text
{
    // Update text content view via selection view
    [_selectionView replaceTextInRange:NSMakeRange(0, _contentView.text.length) withText:text];
}

- (UIColor *)textColor
{
    return _contentView.textColor;
}

- (void)setTextColor:(UIColor *)textColor
{
    _contentView.textColor = textColor;
}

- (UIFont *)font
{
    return _contentView.font;
}

- (void)setFont:(UIFont *)font
{
    _contentView.font = font;
}

- (void)showSelectionView:(BOOL)visible
{
    if(visible)
    {
        [self insertSubview:_selectionView aboveSubview:_contentView];
        [_selectionView updateSelectionIfNeeded];
    }
    else
        [_selectionView removeFromSuperview];
}

- (void)setEditing:(BOOL)editing
{
    if(_editing != editing)
    {    
        _editing = editing;
        [self showSelectionView:_editing];
    }
}

- (void)setEditable:(BOOL)editable
{
    _editable = editable;
    
    if(self.isEditing && self.isEditable == NO)
    {
        [self resignFirstResponder];
    }
}

#pragma mark -
#pragma mark UIResponder

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (BOOL)resignFirstResponder
{
    
    
    self.editing = NO;
    
	return [super resignFirstResponder];
        
}

- (BOOL)becomeFirstResponder
{
    
    
    self.editing = YES;
    
    return [super becomeFirstResponder];
}

- (UIView *)inputAccessoryView
{
    return nil; // unsupported
}

- (UIView *)inputView // needed, to prevent cascading up in the responder chain (possibly with unexpected results)
{
    return nil; // Use system-supplied keyboard 
}

- (UIResponder<UITextInput> *)responder
{
    return self;
}

#pragma mark -
#pragma mark Layout

- (void)layoutSubviews
{
    
    
    // Update content view
    [_contentView setFrame:self.bounds];
    [_contentView updateContentIfNeeded];
    
    // Update selection view
    [_selectionView updateSelectionIfNeeded];
}


@end