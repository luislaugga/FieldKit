/*
 
 FKTokenField.m
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

#import "FKTokenField.h"
#import "FKTokenField_Internal.h"
#import "FKTextField+UITextInput.h"

@implementation FKTokenField

@synthesize tokenizingCharacterSet = _tokenizingCharacterSet;
@synthesize tokenStyle = _tokenStyle;
@synthesize tokenFieldCells = _tokenFieldCells;
@dynamic representedObjects;

@synthesize completionDelay = _completionDelay;
@synthesize completionTimer = _completionTimer;
@synthesize completionArray = _completionArray;
@synthesize completionListView = _completionListView;
@synthesize completionSuperview = _completionSuperview;

@synthesize needsLayoutAnimated = _needsLayoutAnimated;

@synthesize selectedTokenFieldCell = _selectedTokenFieldCell;
@dynamic delegate;

#define kFKTokenFieldDefaultInset CGSizeMake(5,5)
#define kFKTokenFieldDefaultPadding CGSizeMake(7,12)
#define kFKTokenFieldDefaultTokenizers [NSCharacterSet characterSetWithCharactersInString:@"\n"]
#define kFKTokenFieldDefaultCompletionDelay 0.25
#define kFKTokenFieldDefaultCompletionAnimationDuration 0.4

#define kFKTokenFieldLayoutAnimationDuration 0.25

#define kFKTokenFieldCompletionCellLabelTag 394932

#pragma mark -
#pragma mark Initialization

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        // Set up view
        self.backgroundColor = [UIColor whiteColor];
        
        // Set up default geometry properties
        _inset = kFKTokenFieldDefaultInset;
        _padding = kFKTokenFieldDefaultPadding;
        
        // Set up default tokenizing character set
        self.tokenizingCharacterSet = kFKTokenFieldDefaultTokenizers;
        
        // Set up token fields
        self.tokenFieldCells = [NSMutableArray array];
        _selectedTokenFieldCell = nil;
        
        // Set up completion view
        self.completionTimer = nil;
        self.completionDelay = kFKTokenFieldDefaultCompletionDelay;
        self.completionSuperview = nil;
        UITableView * completionListView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        completionListView.autoresizingMask = (UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleBottomMargin);
        completionListView.delegate = self;
        completionListView.dataSource = self;
        self.completionListView = completionListView;
#if !__has_feature(objc_arc)
        [completionListView release];
#endif
        
        // Set up long press gesture recognizer
        _longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
        _longPressGestureRecognizer.delegate = self;
        [self addGestureRecognizer:_longPressGestureRecognizer];
#if !__has_feature(objc_arc)
        [_longPressGestureRecognizer release];
#endif
        
        // Register for keyboard notifications (needed to get keyboard's frame)
        [self registerForKeyboardNotifications];
    }
    return self;
}

- (void)dealloc
{
    
    
    // Unregister for keyboard notifications
    [self unregisterForKeyboardNotifications];
    
    // Release long press gesture recognizer
    [self removeGestureRecognizer:_longPressGestureRecognizer];
    
    // Release objects
#if !__has_feature(objc_arc)
    self.tokenizingCharacterSet = nil;
    self.tokenFieldCells = nil;
    self.completionListView = nil;
    self.completionTimer = nil;
    
    [super dealloc];
#endif
}

#pragma mark -
#pragma mark Properties

- (NSArray *)representedObjects
{
    // Collect all token field cell's represented objects
    NSMutableArray * mutableRepresentedObjects = [[NSMutableArray alloc] init];
    for(FKTokenFieldCell * tokenFieldCell in self.tokenFieldCells)
    {
        if(tokenFieldCell.representedObject)
        {
            [mutableRepresentedObjects addObject:tokenFieldCell.representedObject];
        }
    }
    
#if !__has_feature(objc_arc)
    return [mutableRepresentedObjects autorelease];
#else
    return mutableRepresentedObjects;
#endif
}

- (void)setRepresentedObjects:(NSArray *)representedObjects
{
    // Remove any token field cells
    for(FKTokenFieldCell * tokenFieldCell in self.tokenFieldCells)
        [tokenFieldCell removeFromSuperview];
    
    // Clean up
    [self.tokenFieldCells removeAllObjects];
    _selectedTokenFieldCell = nil;
    
    // Add token field cells for each represented object
    for(id representedObject in representedObjects)
    {
        [self createTokenWithEditingString:@"" forRepresentedObject:representedObject];
    }
}

+ (NSCharacterSet *)defaultTokenizingCharacterSet
{
    return kFKTokenFieldDefaultTokenizers;
}

+ (NSTimeInterval)defaultCompletionDelay
{
    return kFKTokenFieldDefaultCompletionDelay;
}

- (void)setSelectedTokenFieldCell:(FKTokenFieldCell *)selectedTokenFieldCell
{
    // Tokenize whatever is left in the field...    
    if([self.text length] > 0)
    {
        // Tokenize current text
        [self tokenizeEditingString:self.text];
        
        // Clear text
        self.text = @"";
        
        // Update completion view visibility
        [self updateCompletionViewIfNeeded];
    }
    
    if(_selectedTokenFieldCell)
        _selectedTokenFieldCell.selected = NO;
    
    _selectedTokenFieldCell = selectedTokenFieldCell;
    
    if(_selectedTokenFieldCell)
    {
        _selectedTokenFieldCell.selected = YES;
        [self showSelectionView:NO];
    }
    else
    {
        [self showSelectionView:YES];
    }
}

#pragma mark -
#pragma mark Layout

- (void)setNeedsLayoutAnimated:(BOOL)needsLayoutAnimated
{
    // Set needs animated layout flag
    _needsLayoutAnimated = needsLayoutAnimated;
    
    // Set needs layout
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    CGFloat layoutAnimationDuration = 0.0f;
    
    if(_needsLayoutAnimated)
    {
        layoutAnimationDuration = kFKTokenFieldLayoutAnimationDuration;
        self.needsLayoutAnimated = NO;
    }
    
    [UIView animateWithDuration:layoutAnimationDuration animations:^{
        
        // Layout token field cells
        const CGFloat offsetTolerance = _contentView.font.lineHeight*2;
        CGPoint offset = CGPointMake(_inset.width, _inset.height); // start off with inset
        CGFloat width = self.bounds.size.width;
        for(FKTokenFieldCell * tokenFieldCell in self.tokenFieldCells)
        {
            CGRect tokenFieldCellFrame = tokenFieldCell.frame;
            
            if(offset.x + tokenFieldCell.size.width + offsetTolerance > width)
            {
                offset.x = _inset.width; // reset left inset
                offset.y += _contentView.font.lineHeight + _padding.height; // y padding
            }

            tokenFieldCellFrame.origin.x = offset.x;
            tokenFieldCellFrame.origin.y = offset.y;
            
            if(tokenFieldCell.isScaled == NO)
                tokenFieldCell.frame = tokenFieldCellFrame;
            
            offset.x += tokenFieldCell.size.width + _padding.width; // x padding
        }
        
        // Calculate content view frame
        CGRect contentViewFrame = _contentView.frame;
        contentViewFrame.origin.x = offset.x;
        contentViewFrame.origin.y = offset.y + 2; // check with cell for insets...
     
        // Update content view
        _contentView.frame = contentViewFrame;
        
        // Update selection view
        _selectionView.frame = _contentView.frame;
    
    }];
}

#pragma mark -
#pragma mark FKTextField (Properties)

- (void)setEditing:(BOOL)editing
{
    // Unselect any selected token field cell
    self.selectedTokenFieldCell = nil;
    
    // Super
    super.editing = editing;
}

#pragma mark -
#pragma mark FKTextField (UIKeyInput)

- (void)insertText:(NSString *)text
{    
    // Check if the inserted character (text) belongs to tokenizing character set
    if([_tokenizingCharacterSet characterIsMember:[text characterAtIndex:0]]) 
    {
        // Check if text is not empty
        if([self.text length] > 0)
        {
            // Tokenize current string
            [self tokenizeEditingString:self.text];
            
            // Clear text
            self.text = @"";
        }
    }
    else
    {
        if(_selectedTokenFieldCell)
        {
            // If there's a selected token field cell, remove it first
            [self removeTokenFieldCell:_selectedTokenFieldCell];
            self.selectedTokenFieldCell = nil;
        }
        
        // Insert text as normal
        [super insertText:text];
    }
    
    // Update completion view visibility
    [self updateCompletionViewIfNeeded];
}

- (void)deleteBackward
{
    // Check if there's text to delete
    if([self.text length] == 0)
    {
        // Check if there's a selected cell
        if(_selectedTokenFieldCell)
        {
            [self removeTokenFieldCell:_selectedTokenFieldCell];
            self.selectedTokenFieldCell = nil;
        }
        else if([self.tokenFieldCells count] > 0)
        {
            self.selectedTokenFieldCell = [self.tokenFieldCells lastObject];
        }
    }
    else
    {
        // Delete text as normal
        [super deleteBackward];
    }
    
    // Update completion view visibility
    [self updateCompletionViewIfNeeded];
}

#pragma mark -
#pragma mark Tokenization

- (FKTokenFieldCell *)tokenizeEditingString:(NSString *)editingString
{
    id representedObject = nil;
    
    // Ask delegate for editing string's represented object
    if(_delegate && [_delegate respondsToSelector:@selector(tokenField:representedObjectForEditingString:)])
        representedObject = [self.delegate tokenField:self representedObjectForEditingString:editingString];
    
    return [self createTokenWithEditingString:editingString forRepresentedObject:representedObject];
}

- (FKTokenFieldCell *)tokenizeEditingDictionary:(NSDictionary *)editingDictionary
{
    id representedObject = nil;
    
    // Ask delegate for editing dictionary's represented object
    if(_delegate && [_delegate respondsToSelector:@selector(tokenField:representedObjectForEditingDictionary:)])
        representedObject = [self.delegate tokenField:self representedObjectForEditingDictionary:editingDictionary];
    
    NSString * editingString = [editingDictionary objectForKey:FKTokenFieldCompletionDictionaryText];
        
    return [self createTokenWithEditingString:editingString forRepresentedObject:representedObject];;
}

#pragma mark -
#pragma mark Token Cells

- (FKTokenFieldCell *)createTokenWithEditingString:(NSString *)editingString forRepresentedObject:(id)representedObject
{
    // Use editing string as starting point
    NSString * displayString = editingString;
    
    if(representedObject != nil)
    {
        if([representedObject isKindOfClass:[NSString class]])
        {
            // Use represented object directly
            displayString = (NSString *)representedObject;
        }
        else if(_delegate && [_delegate respondsToSelector:@selector(tokenField:displayStringForRepresentedObject:)])
        {
            // Use return string from tokenField:displayStringForRepresentedObject:
            displayString = [self.delegate tokenField:self displayStringForRepresentedObject:representedObject];
        }
    }
    
    // Create token field cell
    FKTokenFieldCell * tokenFieldCell;
    
    if(_delegate && [_delegate respondsToSelector:@selector(tokenField:cellForRepresentedObject:)])
    {
#if !__has_feature(objc_arc)
        tokenFieldCell = [[self.delegate tokenField:self cellForRepresentedObject:representedObject] retain];
#else
        tokenFieldCell = [self.delegate tokenField:self cellForRepresentedObject:representedObject];
#endif
        tokenFieldCell.text = displayString;
        tokenFieldCell.font = _contentView.font;
    }
    else
    {
        tokenFieldCell = [[FKTokenFieldCell alloc] initWithText:displayString andFont:_contentView.font];
    }
    
    // Assign represented object
    tokenFieldCell.representedObject = representedObject;
    
    // Setup token field cell actions
    [tokenFieldCell addTarget:self action:@selector(tokenFieldCellDidTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    
    // Add token field cell
    [self addTokenFieldCell:tokenFieldCell];
    
#if !__has_feature(objc_arc)
    return [tokenFieldCell autorelease];
#else
    return tokenFieldCell;
#endif
}

- (void)addTokenFieldCell:(FKTokenFieldCell *)tokenFieldCell
{
    BOOL shouldAdd = YES;
    NSUInteger index = [self.tokenFieldCells count];
    
    if(_delegate && [_delegate respondsToSelector:@selector(tokenField:shouldAddRepresentedObject:atIndex:)])
        shouldAdd = [self.delegate tokenField:self shouldAddRepresentedObject:tokenFieldCell.representedObject atIndex:index];
    
    if(shouldAdd)
    {
        [self.tokenFieldCells addObject:tokenFieldCell];
        [self addSubview:tokenFieldCell];
        [self setNeedsLayout];            
            
        if(_delegate && [_delegate respondsToSelector:@selector(tokenField:didAddRepresentedObject:atIndex:)])
            [self.delegate tokenField:self didAddRepresentedObject:tokenFieldCell.representedObject atIndex:index];
    }
}

- (void)removeTokenFieldCell:(FKTokenFieldCell *)tokenFieldCell
{
    BOOL shouldRemove = YES;
    NSUInteger index = [self.tokenFieldCells count]-1;
    
    if(_delegate && [_delegate respondsToSelector:@selector(tokenField:shouldRemoveRepresentedObject:atIndex:)])
        shouldRemove = [self.delegate tokenField:self shouldRemoveRepresentedObject:tokenFieldCell.representedObject atIndex:index];
    
    if(shouldRemove)
    {
#if !__has_feature(objc_arc)
        [tokenFieldCell retain];
#endif
        [tokenFieldCell removeFromSuperview];
        [self.tokenFieldCells removeObject:tokenFieldCell];
        [self setNeedsLayout];
        
        if(_delegate && [_delegate respondsToSelector:@selector(tokenField:didRemoveRepresentedObject:atIndex:)])
            [self.delegate tokenField:self didRemoveRepresentedObject:tokenFieldCell.representedObject atIndex:index];
        
#if !__has_feature(objc_arc)
        [tokenFieldCell release];
#endif
    }
}

#pragma mark -
#pragma mark Token Events

- (void)tokenFieldCellDidTouchUpInside:(FKTokenFieldCell *)tokenFieldCell
{
    
    
    if(self.isEditable)
    {
        if(![self isFirstResponder])
            [self becomeFirstResponder];
        
        self.selectedTokenFieldCell = tokenFieldCell;
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    
    
    // Check long press gesture recognizer
    if(gestureRecognizer == _longPressGestureRecognizer)
    {
        CGPoint longPressGestureLocation = [gestureRecognizer locationInView:self];
        UIView * longPressGestureHitView = [self hitTest:longPressGestureLocation withEvent:nil];
        
        if([longPressGestureHitView isKindOfClass:[FKTokenFieldCell class]])
            return YES;
    }
    
    return NO;
}

- (void)handleLongPressGesture:(UILongPressGestureRecognizer *)gestureRecognizer
{
    
    
    CGPoint longPressGestureLocation = [gestureRecognizer locationInView:self];
    
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
        {
            UIView * longPressGestureHitView = [self hitTest:longPressGestureLocation withEvent:nil];
            
            self.selectedTokenFieldCell = (FKTokenFieldCell *)longPressGestureHitView;
                
            [_selectedTokenFieldCell setScaled:YES animated:YES];
            [self bringSubviewToFront:_selectedTokenFieldCell];
                
            _longPressGestureHitOffset = CGPointMake(floorf(_selectedTokenFieldCell.center.x - longPressGestureLocation.x), floorf(_selectedTokenFieldCell.center.y - longPressGestureLocation.y));
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            NSUInteger previousIndex = [_tokenFieldCells indexOfObject:_selectedTokenFieldCell];
            
            CGPoint center = CGPointMake(longPressGestureLocation.x + _longPressGestureHitOffset.x, longPressGestureLocation.y + _longPressGestureHitOffset.y);
            NSUInteger index = 0;
            
            // Find the index where the token field cell with the new 'center' is now
            for(FKTokenFieldCell * tokenFieldCell in _tokenFieldCells)
            {
                // is before tokenFieldCell ?
                if((center.y < tokenFieldCell.frame.origin.y) || (center.y < (tokenFieldCell.frame.origin.y+tokenFieldCell.frame.size.height) && center.x < tokenFieldCell.center.x))
                    break;
                
                ++index;
            }
            
            // Apply changes if the index changed
            // Move from one index to another
            if(index < previousIndex || index > previousIndex + 1)
            {
#if !__has_feature(objc_arc)
                [_selectedTokenFieldCell retain];
#endif
                [_tokenFieldCells removeObject:_selectedTokenFieldCell]; 
                
                if(index < [_tokenFieldCells count])
                    [_tokenFieldCells insertObject:_selectedTokenFieldCell atIndex:index]; // Place in the begining or middle
                else
                    [_tokenFieldCells addObject:_selectedTokenFieldCell]; // Place at the end
                
#if !__has_feature(objc_arc)
                [_selectedTokenFieldCell release];
#endif
                
                [self setNeedsLayoutAnimated:YES];
            }
            
            // Update center of dragged token field cell
            _selectedTokenFieldCell.center = center;
            
            // Prevent half-pixels (setting UIView center with odd size frame)
            _selectedTokenFieldCell.frame = CGRectMake(floorf(_selectedTokenFieldCell.frame.origin.x), floorf(_selectedTokenFieldCell.frame.origin.y), _selectedTokenFieldCell.frame.size.width, _selectedTokenFieldCell.frame.size.height);
        }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        {
            [_selectedTokenFieldCell setScaled:NO animated:YES];
            self.selectedTokenFieldCell = nil;
        }
            break;
        default:
            break;
    }

}

#pragma mark -
#pragma mark Completion View

- (void)updateCompletionViewIfNeeded
{
    // Show if there's text
    // Hide if text is empty
    if([self.text length] > 0)
    {
        // Get completions
        if(_delegate && [_delegate respondsToSelector:@selector(tokenField:completionsForSubstring:indexOfToken:)])
        {
            self.completionArray = [self.delegate tokenField:self completionsForSubstring:self.text indexOfToken:[self.tokenFieldCells count]];
            [_completionListView reloadData];
        }
        
        // There are completions to show
        if([self.completionArray count] > 0)
        {
            // Show (set up timer)
            if(_completionTimer == nil)
            {
                self.completionTimer = [NSTimer scheduledTimerWithTimeInterval:kFKTokenFieldDefaultCompletionDelay target:self selector:@selector(showCompletionView) userInfo:nil repeats:NO];
            }
        }
        else 
        {
            [self hideCompletionView];
        }
    }
    else
    {
        [self hideCompletionView];
    }
}

- (void)showCompletionView
{
    if(_completionSuperview)
    {
       // Save state
       _frame = self.frame;
       _superview = self.superview;
       
        // Update input view frame
        CGRect completionInputViewFrame = [self.superview convertRect:self.frame toView:_completionSuperview];
        self.frame = completionInputViewFrame;
        
        // Update list view frame
        const CGFloat completionInputViewHeight = _inset.height + _contentView.font.lineHeight + _inset.height;
        const CGFloat completionlistViewVerticalOffset = completionInputViewFrame.origin.y + _contentView.frame.origin.y + _contentView.font.lineHeight + _inset.height;
        CGRect completionListViewFrame = CGRectMake(0, completionlistViewVerticalOffset, _completionSuperview.bounds.size.width, _completionSuperview.bounds.size.height - _keyboardFrame.size.height - completionInputViewHeight);
        _completionListView.frame = completionInputViewFrame;
       
        // Add to completion superview
        [_completionSuperview addSubview:self];
        [_completionSuperview addSubview:_completionListView];
        
        // Animate offset
        [self animateCompletionView];
    }  
}

- (void)animateCompletionView
{
    if([_completionListView superview])
    {
        // Animation offset
        CGFloat animationVerticalOffset = -_inset.height + _contentView.font.lineHeight + _inset.height - _completionListView.frame.origin.y;

        // Set up animation
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:kFKTokenFieldDefaultCompletionAnimationDuration];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        
        // Update frames
        CGRect endCompletionInputViewFrame = self.frame;
        CGRect endCompletionListViewFrame = _completionListView.frame; 
        endCompletionInputViewFrame.origin.y += animationVerticalOffset;
        endCompletionListViewFrame.origin.y += animationVerticalOffset;
        self.frame = endCompletionInputViewFrame;
        _completionListView.frame = endCompletionListViewFrame;
        
        // Commit animation
        [UIView commitAnimations];
    }
}

- (void)hideCompletionView
{
    // Clear timer
    if(self.completionTimer)
    {
        [self.completionTimer invalidate];
        self.completionTimer = nil;
    }
    
    // Hide
    if([_completionListView superview])
    {
        // Restore state
        self.frame = _frame; 
        [_superview addSubview:self];
        
        // Remove comletion list
        [_completionListView removeFromSuperview];
    }
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_completionArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = nil;
    
    id completion = [_completionArray objectAtIndex:indexPath.row];
    
    if([completion isKindOfClass:[NSString class]])
    {
        static NSString * StringCompletionCellIdentifier = @"FKTokenFieldStringCompletionCell";
        
        cell = [tableView dequeueReusableCellWithIdentifier:StringCompletionCellIdentifier];
        if (cell == nil) 
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:StringCompletionCellIdentifier];
            cell.accessoryType = UITableViewCellAccessoryNone;

#if !__has_feature(objc_arc)
            [cell autorelease];
#endif
        }
        
        NSString * completionString = (NSString *)completion;
        cell.textLabel.text = completionString;
    }
    else if([completion isKindOfClass:[NSDictionary class]])
    {
        static NSString * DictionaryCompletionCellIdentifier = @"FKTokenFieldDictionaryCompletionCell";
        static const NSUInteger SecondDetailTextLabelTag = 58839;
        
        cell = [tableView dequeueReusableCellWithIdentifier:DictionaryCompletionCellIdentifier];
        if (cell == nil) 
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:DictionaryCompletionCellIdentifier];
            cell.accessoryType = UITableViewCellAccessoryNone;
            
#if !__has_feature(objc_arc)
            [cell autorelease];
#endif
            
            UILabel * secondDetailTextLabel = [[UILabel alloc] initWithFrame:cell.detailTextLabel.frame];
            secondDetailTextLabel.tag = SecondDetailTextLabelTag;
            secondDetailTextLabel.font = [UIFont systemFontOfSize:14.0f];
            secondDetailTextLabel.adjustsFontSizeToFitWidth = NO;
            secondDetailTextLabel.highlightedTextColor = cell.detailTextLabel.highlightedTextColor;
            secondDetailTextLabel.textColor = cell.detailTextLabel.textColor;
            [cell.contentView addSubview:secondDetailTextLabel];
            
#if !__has_feature(objc_arc)
            [secondDetailTextLabel release];
#endif
            
            cell.textLabel.font = [UIFont boldSystemFontOfSize:14.0f];
            cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:14.0f];
        }
        
        NSDictionary * completionDictionary = (NSDictionary *)completion;
        
        cell.textLabel.text = [completionDictionary objectForKey:FKTokenFieldCompletionDictionaryText];
        cell.detailTextLabel.text = [completionDictionary objectForKey:FKTokenFieldCompletionDictionaryDetailDescription];
        
        UILabel * secondDetailTextLabel = (UILabel *)[cell.contentView viewWithTag:SecondDetailTextLabelTag];
        secondDetailTextLabel.text = [NSString stringWithFormat:@" %@", [completionDictionary objectForKey:FKTokenFieldCompletionDictionaryDetailText]];
        
        CGSize cellDetailTextLabelSize = [cell.detailTextLabel.text sizeWithFont:cell.detailTextLabel.font];
        CGSize secondDetailTextLabelSize = [secondDetailTextLabel.text sizeWithFont:secondDetailTextLabel.font];
        secondDetailTextLabel.frame = CGRectMake(cellDetailTextLabelSize.width+12, cell.textLabel.font.lineHeight+4, secondDetailTextLabelSize.width, secondDetailTextLabelSize.height);
    }
    else
    {
        static NSString * InvalidCompletionCellIdentifier = @"FKTokenFieldInvalidCompletionCell";
        
        cell = [tableView dequeueReusableCellWithIdentifier:InvalidCompletionCellIdentifier];
        if (cell == nil) 
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:InvalidCompletionCellIdentifier];
            cell.accessoryType = UITableViewCellAccessoryNone;
            
#if !__has_feature(objc_arc)
            [cell autorelease];
#endif
        }
        
        cell.textLabel.text = @"Invalid Completion Object";
    }
    
	return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Retrieve completion
    id completionAtSelectedIndexPath = [_completionArray objectAtIndex:indexPath.row];
    
    // Tokenize completion
    if([completionAtSelectedIndexPath isKindOfClass:[NSString class]])
    {
        [self tokenizeEditingString:(NSString *)completionAtSelectedIndexPath];
    }
    else if([completionAtSelectedIndexPath isKindOfClass:[NSDictionary class]])
    {
        [self tokenizeEditingDictionary:(NSDictionary *)completionAtSelectedIndexPath];
    }
    
    // Clear text
    self.text = @"";
    
    // Update completion view visibility
    [self hideCompletionView];
    
    // Deselect row
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark UIKeyboard notifications

- (void)keyboardWillShow:(NSNotification*)notification
{
    NSDictionary * info = [notification userInfo];
    
    _keyboardFrame = [self convertRect:[[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue] fromView:[[UIApplication sharedApplication] keyWindow]];
}

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];    
}

- (void)unregisterForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

@end
