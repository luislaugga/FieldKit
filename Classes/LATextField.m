//
//  LATextField.m
//  LauggaKit
//
//  Created by Luis Laugga on 9/18/12.
//  Copyright (c) 2012 Luis Laugga. All rights reserved.
//

#import "LATextField.h"
#import "LATextField_Internal.h"
#import "LATextField+UITextInput.h"

#import "LATextAppearance.h"

@implementation LATextField

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
        self.backgroundColor = [LATextAppearance defaultBackgroundColor];
        _editing = NO;
        _editable = YES; // default
        
        // Set up content view
        _contentView = [[LATextContentView alloc] initWithFrame:self.bounds];
        _contentView.autoresizingMask = (UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin); // autoresizing handled in layoutSubviews
        _contentView.contentMode = UIViewContentModeBottomLeft; // don't scale text content view
        [self addSubview:_contentView];
        
        // Set up selection view
        _selectionView = [[LATextSelectionView alloc] initWithSelectingContainer:self];
        _selectionView.autoresizingMask = (UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight);
        
        // Set up interaction assistant
        _interactionAssistant = [[LATextInteractionAssistant alloc] initWithSelectingContainer:self];
    }
    return self;
}

- (void)dealloc
{
    PrettyLog;
    
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
    PrettyLog;
    
    if(_editing != editing)
    {    
        _editing = editing;
        [self showSelectionView:YES];
    }
}

- (void)setEditable:(BOOL)editable
{
    PrettyLog;
    
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
    PrettyLog;
    
    self.editing = NO;
    
	return [super resignFirstResponder];
        
}

- (BOOL)becomeFirstResponder
{
    PrettyLog;
    
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
    PrettyLog;
    
    // Update content view
    [_contentView setFrame:self.bounds];
    [_contentView updateContentIfNeeded];
    
    // Update selection view
    [_selectionView updateSelectionIfNeeded];
}


@end