/*
 
 FKTextField.m
 FieldKit
 
 Copyright (cc) 2012 Luis Laugga.
 Some rights reserved, all wrongs deserved.
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of
 this software and associated documentation files (the "Software"), to deal in
 the Software without restriction, including without limitation the rights to
 use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
 the Software, and to permit persons to whom the Software is furnished to do so,
 subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
 FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
 COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
 IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
*/

#import "FKTextField.h"
#import "FKTextField_Internal.h"
#import "FKTextField+UITextInput.h"
#import "FKTextField+Spelling.h"

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
    [_selectionView removeFromSuperview];
    [_contentView removeFromSuperview];
    self.textChecker = nil;
    
#if !__has_feature(objc_arc)
    [_interactionAssistant release];
    [_selectionView release];
    [_contentView release];
    
    [super dealloc];
#endif
    
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