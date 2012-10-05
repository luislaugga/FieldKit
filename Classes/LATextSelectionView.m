//
//  LATextSelectionView.m
//  LauggaKit
//
//  Created by Luis Laugga on 9/18/12.
//  Copyright (c) 2012 Luis Laugga. All rights reserved.
//

#import "LATextSelectionView.h"
#import "LATextSelectionView_Internal.h"

#import "LATextAppearance.h"

static const NSTimeInterval LATextSelectionCaretBlinkDelay = 0.7;
static const NSTimeInterval LATextSelectionCaretBlinkRate = 0.5;

@implementation LATextSelectionView

@synthesize selectionRange = _selectionRange;
@synthesize selectingContainer = _selectingContainer;
@synthesize caretView = _caretView;

#pragma mark -
#pragma mark Initialization

- (id)initWithSelectingContainer:(UIView<LATextSelectingContainer> *)selectingContainer
{
    self = [super initWithFrame:selectingContainer.textContentView.frame];
    if(self)
    {
        // Assign the LATextSelectingContainer conforming UIView
        self.selectingContainer = selectingContainer;
        
        // Set up view
        self.backgroundColor = [UIColor clearColor];
        
        // Set up caret view
        _caretTimer = nil;
        self.caretView = [LATextSelectionView defaultCaretView];
        _selectionRange = NSMakeRange(0, 0);
    }
    return self;
}

- (void)dealloc
{
    // Clean up
    self.selectingContainer = nil;
    self.caretView = nil;
    
    [super dealloc];
}

#pragma mark -
#pragma mark Layout (observing changes)

- (void)willMoveToSuperview:(UIView *)superview
{
    PrettyLog;
    
    [self showCaret];
    [self startCaretBlinkIfNeeded];
    
    _visible = YES;
}

- (void)removeFromSuperview
{
    [super removeFromSuperview];
    
    [self hideRange];
    [self clearCaretBlinkTimer];
    [self hideCaret];
    
    _visible = NO;
}


#pragma mark -
#pragma mark Properties

- (void)setSelectionRange:(NSRange)selectionRange
{
    PrettyLog;
    
    // Update if different
    if(_selectionRange.location != selectionRange.location || _selectionRange.length != selectionRange.length)
    {
        if(selectionRange.location != NSNotFound)
        {
            // Notify selection will change to container's responder input delegate
            [_selectingContainer.responder.inputDelegate selectionWillChange:_selectingContainer.responder];
            
            // Assign selection range
            _selectionRange = selectionRange;
            
            // Update selection if it's the case
            [self updateSelectionIfNeeded];
            
            // Notify selection did change to container's responder input delegate
            [_selectingContainer.responder.inputDelegate selectionDidChange:_selectingContainer.responder];
        }
    }
}

#pragma mark -
#pragma mark Update

- (void)updateSelectionIfNeeded
{
    if(_selectionRange.length > 0) // going into range
    {
        if(_rangeView == nil) // previous was caret
        {
            [self hideCaret];
            [self clearCaretBlinkTimer];
            [self showRange];
        }

        [self updateRange];
    }
    else // going into caret
    {
        if(_rangeView != nil) // previous was range
        {
            [self hideRange];
            [self showCaret];
            [self startCaretBlinkIfNeeded];
        }
        else
        {
            [self touchCaretBlinkTimer];
        }

        [self updateCaret];
    }
}

#pragma mark -
#pragma mark Selection Modifiers

- (void)setCaretSelectionForPoint:(CGPoint)point
{
    PrettyLog;
    
    // Set selection location based on index closest to point
    NSUInteger index = [_selectingContainer.textContentView textClosestIndexForPoint:point]; // closest index
    self.selectionRange = NSMakeRange(index, 0); // set location
}

- (void)setWordSelectionForPoint:(CGPoint)point
{
    PrettyLog;
    
    // Set selection location+length based on word that contains index closest to point
    NSUInteger index = [_selectingContainer.textContentView textClosestIndexForPoint:point]; // closest index
    NSRange range = [_selectingContainer.textContentView textWordRangeForIndex:index]; // word range for closest index
    self.selectionRange = range; // set word range
}

#pragma mark -
#pragma mark Text Modifiers

- (void)insertTextIntoSelection:(NSString *)insertedText
{
    // Create mutable copy
    NSMutableString * mutableText = [_selectingContainer.textContentView.text mutableCopy];
    
    // Create selection change copy
    NSRange updatedSelectionRange = _selectionRange;
    
    // Apply changes
    if (_selectionRange.length > 0)
    {
		// Replace selected text with user-entered text
        [mutableText replaceCharactersInRange:updatedSelectionRange withString:insertedText];
        updatedSelectionRange.length = 0;
        updatedSelectionRange.location += insertedText.length;
    } 
    else 
    {
        // Insert user-entered text at current insertion point
        [mutableText insertString:insertedText atIndex:updatedSelectionRange.location];        
        updatedSelectionRange.location += insertedText.length;
    }
    
    // Notify text will change to container's responder input delegate
    [_selectingContainer.responder.inputDelegate textWillChange:_selectingContainer.responder];
    
    // Update content
    _selectingContainer.textContentView.text = mutableText;
    
    // Update selection
    self.selectionRange = updatedSelectionRange;
    
    // Notify text did change to container's responder input delegate
    [_selectingContainer.responder.inputDelegate textDidChange:_selectingContainer.responder];
    
    // Clean up
    [mutableText release];
}

- (void)deleteTextFromSelection
{
    if(_selectionRange.location == 0 && _selectionRange.length == 0)
        return; // nothing to delete
    
    // Create mutable copy
    NSMutableString * mutableText = [_selectingContainer.textContentView.text mutableCopy];
    
    // Create selection change copy
    NSRange updatedSelectionRange = _selectionRange;
    
    // Apply changes
    if (updatedSelectionRange.length > 0) 
    {
		// Delete the selected text
        [mutableText deleteCharactersInRange:updatedSelectionRange];
        updatedSelectionRange.length = 0;
    } 
    else if (updatedSelectionRange.location > 0) 
    {
		// Delete one char of text at the current insertion point
        updatedSelectionRange.location--;
        updatedSelectionRange.length = 1;
        [mutableText deleteCharactersInRange:updatedSelectionRange];
        updatedSelectionRange.length = 0;
    }
    
    // Notify text will change to container's responder input delegate
    [_selectingContainer.responder.inputDelegate textWillChange:_selectingContainer.responder];
    
    // Update content
    _selectingContainer.textContentView.text = mutableText;
    
    // Update selection
    self.selectionRange = updatedSelectionRange;
    
    // Notify text did change to container's responder input delegate
    [_selectingContainer.responder.inputDelegate textDidChange:_selectingContainer.responder];
    
    // Clean up
    [mutableText release];
}

- (void)replaceTextInRange:(NSRange)replacementRange withText:(NSString *)replacementText
{
    PrettyLog;
    
    // Create mutable copy
    NSMutableString * mutableText = [_selectingContainer.textContentView.text mutableCopy];
 
    // Create selection change copy
    NSRange updatedSelectionRange = _selectionRange;
    
    // Check replacementRange location against text boundaries
    if (replacementRange.location > [mutableText length])
        return;
    
    // Check replacementRange length against text boundaries
    if ((replacementRange.location+replacementRange.length) > [mutableText length])
    {
        replacementRange.length = [mutableText length] - replacementRange.location; // range can't extend past text boundaries
    }

    // Determine if replaced range intersects current selection range
	// and update selection range if so.
    if ((replacementRange.location + replacementRange.length) <= updatedSelectionRange.location) // before selection, no overlapping
    {  
        updatedSelectionRange.location -= (replacementRange.length - replacementText.length); // move back _selectionRange location
    } 
    else if (replacementRange.location >= (updatedSelectionRange.location + updatedSelectionRange.length)) // after selection, no overlapping
    {   
        // no need to change _selectionRange, just replace characters as pretended
    }
    else // overlaps selection
    {
        updatedSelectionRange.location = replacementRange.location + replacementText.length; // move forward _selectionRange location just after replacement
        updatedSelectionRange.length = 0; // length = 0
    }
    
    // Now replace characters in text storage
    [mutableText replaceCharactersInRange:replacementRange withString:replacementText];    
    
    // Notify text will change to container's responder input delegate
    [_selectingContainer.responder.inputDelegate textWillChange:_selectingContainer.responder];
    
    // Update content
    _selectingContainer.textContentView.text = mutableText;
    
    // Update selection
    self.selectionRange = updatedSelectionRange;
    
    // Notify text did change to container's responder input delegate
    [_selectingContainer.responder.inputDelegate textDidChange:_selectingContainer.responder];
    
    // Clean up
    [mutableText release];
}

#pragma mark -
#pragma mark Caret view

+ (UIView *)defaultCaretView
{
    // Create and set caret view using default values
    UIView * caretView = [[UIView alloc] initWithFrame:CGRectZero];
    caretView.backgroundColor = [LATextAppearance defaultSelectionCaretColor];
    return [caretView autorelease];
}

- (void)showCaret
{
    // Add caret view
    if (!_caretView.superview)
    {
        [self addSubview:_caretView];
        [self setNeedsDisplay];            
    }
    
    // Set caret view visible
    _caretView.hidden = NO;
}

- (void)hideCaret
{
    // Remove caret view
    [_caretView removeFromSuperview];
    [self setNeedsDisplay];
}

- (void)updateCaret
{
    // Update caret view frame
    CGRect textRect = [_selectingContainer.textContentView textOffsetRectForIndex:_selectionRange.location];
    _caretView.frame = [LATextAppearance selectionCaretFrameForTextRect:textRect];
}

- (void)startCaretBlinkIfNeeded // setup caret timer
{
    // Set up caret timer
    if(_caretTimer == nil)
        _caretTimer = [[NSTimer scheduledTimerWithTimeInterval:LATextSelectionCaretBlinkRate target:self selector:@selector(caretBlinkTimerFired:) userInfo:nil repeats:YES] retain];
    
    // Set caret view visible
    _caretView.hidden = NO;
    
    // Set caret blinks flag
    _caretBlinks = YES;
}

- (void)touchCaretBlinkTimer // reset caret timer fire date
{
    // Update caret timer
    [_caretTimer setFireDate:[NSDate dateWithTimeIntervalSinceNow:LATextSelectionCaretBlinkDelay]];   
    
    // Set caret view visible
    _caretView.hidden = NO;
}

- (void)clearCaretBlinkTimer // invalidate caret timer
{
    // Release caret timer
    [_caretTimer invalidate];
    [_caretTimer release];
    _caretTimer = nil; 
    
    // Set caret view visible
    _caretView.hidden = NO;
    
    // Mark caret blinks flag
    _caretBlinks = NO;
}

- (void)caretBlinkTimerFired:(id)info // caret timer action
{
    // Toggle caret view visibility
    _caretView.hidden = !_caretView.hidden;
}

#pragma mark -
#pragma mark Range view

- (void)showRange
{
    if(_rangeView == nil)
    {
        _rangeView = [[LATextRangeView alloc] initWithFrame:self.bounds];
        [self addSubview:_rangeView];
        [self setNeedsDisplay];
    }
}

- (void)hideRange
{
    if(_rangeView != nil)
    {
        [_rangeView removeFromSuperview];
        [_rangeView release];
        _rangeView = nil;
        [self setNeedsDisplay];
    }
}

- (void)updateRange
{
    if(_rangeView != nil)
    {
        _rangeView.rects = [_selectingContainer.textContentView textRectsForRange:_selectionRange];
    }
}

@end

#pragma mark -
#pragma mark LATextRangeView implementation

@implementation LATextRangeView

@synthesize rects = _rects;
@synthesize rectViews = _rectViews;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        _rects = nil;
        _rectViews = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc
{
    self.rects = nil;
    self.rectViews = nil;
    
    [super dealloc];
}

- (void)setRects:(NSArray *)rects
{
    if(_rects != nil)
    {
        for(UIView * rectView in _rectViews)
            [rectView removeFromSuperview];
        
        [_rectViews removeAllObjects];
        [_rects release];
        _rects = nil;
    }
    
    _rects = [rects copy];
    
    if(_rects != nil)
    {    
        if([_rects count] == 1) // one rect only, draw according to its origin and size
        {
            CGRect rect = [[_rects objectAtIndex:0] CGRectValue];
            [_rectViews addObject:[LATextRangeView defaultRangeViewForRect:rect]];
        }
        else if([_rects count] > 1) // 2 or more rects, draw first, last and middle rect but align to content view boundaries
        {
            CGRect firstRect = [[_rects objectAtIndex:0] CGRectValue];
            firstRect.size.width = self.bounds.size.width - firstRect.origin.x; // match right edge
            [_rectViews addObject:[LATextRangeView defaultRangeViewForRect:firstRect]];
            
            CGRect lastRect = [[_rects lastObject] CGRectValue];
            lastRect.size.width += lastRect.origin.x; // match left edge
            lastRect.origin.x = 0; // match left edge
            [_rectViews addObject:[LATextRangeView defaultRangeViewForRect:lastRect]];
            
            if([_rects count] > 2) // there a middle
            {
                CGRect middleRect = CGRectMake(0, firstRect.origin.y + firstRect.size.height, self.bounds.size.width, lastRect.origin.y - (firstRect.origin.y + firstRect.size.height));
                [_rectViews addObject:[LATextRangeView defaultRangeViewForRect:middleRect]];
            }
        }
        
        // Add subviews
        for(UIView * rangeView in _rectViews)
        {
            [self addSubview:rangeView];
        }
    }
}

+ (UIView *)defaultRangeViewForRect:(CGRect)rect
{
    UIView * rangeView = [[UIView alloc] initWithFrame:rect];
    [rangeView setBackgroundColor:[LATextAppearance defaultSelectionRangeColor]];
    return [rangeView autorelease];
}

@end
