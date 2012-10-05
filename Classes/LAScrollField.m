//
//  LAScrollField.m
//  FieldKit
//
//  Created by Luis Laugga on 9/11/12.
//  Copyright (c) 2012 Luis Laugga. All rights reserved.
//

#import "LAScrollField.h"
#import "LAScrollField_Internal.h"

@implementation LAScrollField

@dynamic text, textColor, font, textAlignment, borderStyle, placeholder, minimumFontSize;
@synthesize background, disabledBackground;
@synthesize clearsOnBeginEditing, adjustsFontSizeToFitWidth, editing = _editing;
@synthesize delegate;

#pragma mark -
#pragma mark Initialization

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        // Set up self
        self.clipsToBounds = NO;
        
        // Set up subviews
        _textView = nil;
        _textField = [[UITextField alloc] init];
        _textField.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        //_textField.clipsToBounds = NO;
        [_textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        _textField.delegate = self;
        [self addSubview:_textField];    
        
        // Add self key-value observing
        [self addObserver:self forKeyPath:@"editing" options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld) context:nil];
    }
    return self;
}

- (void)dealloc
{
    [_textField release];
    if(_textView != nil)
        [_textView release];
    
    // Remove self key-value observing
    [self removeObserver:self forKeyPath:@"editing"];
    
    [super dealloc];
}

#pragma mark -
#pragma mark Key-Value Observing

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"editing"])
    {
        BOOL oldValue = [[change objectForKey:NSKeyValueChangeOldKey] boolValue];
        BOOL newValue = [[change objectForKey:NSKeyValueChangeNewKey] boolValue];
        if(oldValue != newValue)
        {
            if(newValue == YES) // isEditing = YES
            {
                if(delegate && [delegate respondsToSelector:@selector(scrollFieldDidBeginEditing:)])
                    [delegate scrollFieldDidBeginEditing:self];
            }
            else // isEditing = NO
            {
                if(delegate && [delegate respondsToSelector:@selector(scrollFieldDidEndEditing:)])
                    [delegate scrollFieldDidEndEditing:self];
            }
        }
    }
}

#pragma mark -
#pragma mark Properties

- (void)setText:(NSString *)text
{
    if(_textField.isHidden == NO)
        _textField.text = text;
    else
        _textView.text = text;
}

- (NSString *)text
{
    if(_textField.isHidden == NO)
        return _textField.text;

    return _textView.text;
}

- (void)setTextColor:(UIColor *)textColor
{
    _textField.textColor = textColor;
    if(_textView)
        _textView.textColor = textColor;
}

- (UIColor *)textColor
{
    return _textField.textColor;
}

- (void)setFont:(UIFont *)font
{
    _textField.font = font;
    if(_textView)
        _textView.font = font;
}

- (UIFont *)font
{
    return _textField.font;
}

- (void)setTextAlignment:(UITextAlignment)textAlignment
{
    _textField.textAlignment = textAlignment;
    if(_textView)
        _textView.textAlignment = textAlignment;
}

- (UITextAlignment)textAlignment
{
    return _textField.textAlignment;
}

- (void)setBorderStyle:(UITextBorderStyle)borderStyle
{
    // Needs to be custom for text view ...
}

- (void)setPlaceholder:(NSString *)placeholder
{
    _textField.placeholder = placeholder;
}

- (NSString *)placeholder
{
    return _textField.placeholder;
}

- (void)setMinimumFontSize:(CGFloat)minimumFontSize
{

}

- (void)setBackground:(UIImage *)background
{

}

- (void)setDisabledBackground:(UIImage *)disabledBackground
{

}

- (void)setClearsOnBeginEditing:(BOOL)clearsOnBeginEditing
{

}

- (void)setAdjustsFontSizeToFitWidth:(BOOL)adjustsFontSizeToFitWidth
{

}

#pragma mark -
#pragma mark Subviews 

- (void)showTextView:(NSString *)text
{
    if(_textView == nil)
    {
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)]; // new height?
        _textView.delegate = self;
        _textView.font = _textField.font;
        _textView.textAlignment = _textField.textAlignment;
        _textView.textColor = _textField.textColor;
        _textView.backgroundColor = _textField.backgroundColor;
        _textView.contentInset = UIEdgeInsetsMake(-8.0f, -8.0f, 0, 0);
        [self addSubview:_textView];
    }
    
    _textView.text = text;
    [_textView setHidden:NO];
    [_textField setHidden:YES];
    [_textView becomeFirstResponder];
}

- (void)showTextField:(NSString *)text
{
    _textField.text = text;
    [_textField setHidden:NO];
    [_textView setHidden:YES];
    [_textField becomeFirstResponder];
}

#pragma mark -
#pragma mark Resize

- (void)changeHeight:(CGFloat)height
{
    // Check height resize with delegate
    if(delegate && [delegate respondsToSelector:@selector(scrollField:shouldChangeHeight:)])
        if([delegate scrollField:self shouldChangeHeight:height])
        {
            // Notify delegate
            if(delegate && [delegate respondsToSelector:@selector(scrollField:willChangeHeight:)])
                [delegate scrollField:self willChangeHeight:height];
            
            // Set up animation
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationBeginsFromCurrentState:YES];
            [UIView setAnimationDuration:LAScrollFieldChangeHeightAnimationDuration];
            [UIView setAnimationCurve:LAScrollFieldChangeHeightAnimationCurve];
            [UIView setAnimationDidStopSelector:@selector(didChangeHeight:)];
            
            // Update frame
            CGRect viewResizeFrame = self.frame;
            viewResizeFrame.size.height = height;
            CGRect textViewResizeFrame = _textView.frame;
            textViewResizeFrame.size.height = height;
            _textView.frame = textViewResizeFrame;
            self.frame = viewResizeFrame;
            
            // Commit animation
            [UIView commitAnimations];
        }
}

- (void)didChangeHeight:(CGFloat)height
{
    // Notify delegate
    if(delegate && [delegate respondsToSelector:@selector(scrollField:didChangeHeight:)])
        [delegate scrollField:self didChangeHeight:self.frame.size.height];
}

#pragma mark -
#pragma mark UITextField events

- (void)textFieldDidChange:(UITextField *)textField
{
    CGSize textSize = [[textField text] sizeWithFont:textField.font];
    if(textSize.width > self.frame.size.width-20)
    {
        [self showTextView:_textField.text];
    }
}

#pragma mark -
#pragma mark UITextField delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.editing = YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if([_textField isHidden] == NO)
        self.editing = NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self showTextView:[_textField.text stringByAppendingString:@"\n"]];
    [self textViewDidChange:_textView];
    
    return NO;
}

#pragma mark -
#pragma mark UITextView delegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    self.editing = YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if([_textView isHidden] == NO)
        self.editing = NO;
}

- (void)textViewDidChange:(UITextView *)textView
{
    CGSize textSize = [[_textView text] sizeWithFont:_textView.font constrainedToSize:CGSizeMake(self.frame.size.width, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap];
    NSInteger lineCount = textSize.height/_textView.font.lineHeight;
 
    if(lineCount > 0 && textView.contentSize.height > _textField.frame.size.height)
    {
        [self changeHeight:textView.contentSize.height];
    }
    else
    {
        [self changeHeight:_textField.frame.size.height];
        
        if(lineCount == 0)
        {
            [self showTextField:_textView.text]; 
        }
        else if(lineCount == 1)
        {
            if([[_textView.text substringFromIndex:_textView.text.length-1] isEqualToString:@"\n"] == NO) // single line without newline character
                [self showTextField:_textView.text];
        }
    }
}

@end
