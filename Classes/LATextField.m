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

- (void)setEditing:(BOOL)editing
{
    _editing = editing;
    
    if(_editing)
        [self insertSubview:_selectionView aboveSubview:_contentView];
    else
        [_selectionView removeFromSuperview];
}

#pragma mark -
#pragma mark Responder

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

#pragma mark -
#pragma mark LATextSelectingContainer protocol

- (UIResponder<UITextInput> *)responder
{
    return self;
}

@end