//
//  LATokenField.m
//  LauggaKit
//
//  Created by Luis Laugga on 9/18/12.
//  Copyright (c) 2012 Luis Laugga. All rights reserved.
//

#import "LATokenField.h"
#import "LATokenField_Internal.h"
#import "LATextField+UITextInput.h"

@implementation LATokenField

@synthesize tokenizingCharacterSet = _tokenizingCharacterSet;
@synthesize tokenStyle = _tokenStyle;
@synthesize tokenFieldCells = _tokenFieldCells;
@dynamic representedObjects;
@synthesize completionDelay = _completionDelay;
@synthesize completionTimer = _completionTimer;
@synthesize completionArray = _completionArray;
@synthesize completionListView = _completionListView;
@synthesize completionSuperview = _completionSuperview;
@synthesize selectedTokenFieldCell = _selectedTokenFieldCell;
@dynamic delegate;

#define kLATokenFieldDefaultInset CGSizeMake(4,6)
#define kLATokenFieldDefaultPadding CGSizeMake(4,16)
#define kLATokenFieldDefaultTokenizers [NSCharacterSet characterSetWithCharactersInString:@"\n"]
#define kLATokenFieldDefaultCompletionDelay 0.25
#define kLATokenFieldDefaultCompletionAnimationDuration 0.4

#define kLATokenFieldCompletionCellLabelTag 394932

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
        _inset = kLATokenFieldDefaultInset;
        _padding = kLATokenFieldDefaultPadding;
        
        // Set up default tokenizing character set
        self.tokenizingCharacterSet = kLATokenFieldDefaultTokenizers;
        
        // Set up token fields
        self.tokenFieldCells = [NSMutableArray array];
        _selectedTokenFieldCell = nil;
        
        // Set up completion view
        self.completionTimer = nil;
        self.completionDelay = kLATokenFieldDefaultCompletionDelay;
        self.completionSuperview = nil;
        UITableView * completionListView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        completionListView.autoresizingMask = (UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleBottomMargin);
        completionListView.delegate = self;
        completionListView.dataSource = self;
        self.completionListView = completionListView;
        [completionListView release];
        
        // Set up long press gesture recognizer
        _longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
        [self addGestureRecognizer:_longPressGestureRecognizer];
        
        // Register for keyboard notifications (needed to get keyboard's frame)
        [self registerForKeyboardNotifications];
    }
    return self;
}

- (void)dealloc
{
    PrettyLog;
    
    // Unregister for keyboard notifications
    [self unregisterForKeyboardNotifications];
    
    // Release long press gesture recognizer
    [_longPressGestureRecognizer release];
    
    // Release objects
    self.tokenizingCharacterSet = nil;
    self.tokenFieldCells = nil;
    self.completionListView = nil;
    self.completionTimer = nil;

    [super dealloc];
}

#pragma mark -
#pragma mark Properties

- (NSArray *)representedObjects
{
    // Collect all token field cell's represented objects
    NSMutableArray * mutableRepresentedObjects = [[NSMutableArray alloc] init];
    for(LATokenFieldCell * tokenFieldCell in self.tokenFieldCells)
    {
        if(tokenFieldCell.representedObject)
        {
            [mutableRepresentedObjects addObject:tokenFieldCell.representedObject];
        }
    }
    
    return [mutableRepresentedObjects autorelease];
}

- (void)setRepresentedObjects:(NSArray *)representedObjects
{
    // Remove any token field cells
    for(LATokenFieldCell * tokenFieldCell in self.tokenFieldCells)
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
    return kLATokenFieldDefaultTokenizers;
}

+ (NSTimeInterval)defaultCompletionDelay
{
    return kLATokenFieldDefaultCompletionDelay;
}

- (void)setSelectedTokenFieldCell:(LATokenFieldCell *)selectedTokenFieldCell
{
    if(_selectedTokenFieldCell)
        _selectedTokenFieldCell.selected = NO;
    
    _selectedTokenFieldCell = selectedTokenFieldCell;
    
    if(_selectedTokenFieldCell)
        _selectedTokenFieldCell.selected = YES;
}

#pragma mark -
#pragma mark Layout

- (void)layoutSubviews
{
    PrettyLog;
    
    // Layout token field cells
    const CGFloat offsetTolerance = _contentView.font.lineHeight*2;
    CGPoint offset = CGPointMake(_inset.width, _inset.height); // start off with inset
    CGFloat width = self.bounds.size.width;
    for(LATokenFieldCell * tokenFieldCell in self.tokenFieldCells)
    {
        CGRect tokenFieldCellFrame = tokenFieldCell.frame;
        CGRect tokenFieldCellBounds = tokenFieldCell.unscaledBounds;
        
        if(offset.x + tokenFieldCellBounds.size.width + offsetTolerance > width)
        {
            offset.x = _inset.width; // reset left inset
            offset.y += _contentView.font.lineHeight + _padding.height; // y padding
        }

        tokenFieldCellFrame.origin.x = offset.x;
        tokenFieldCellFrame.origin.y = offset.y;
        
        if(tokenFieldCell != _longPressTokenFieldCell)
            tokenFieldCell.frame = tokenFieldCellFrame;
        
        offset.x += tokenFieldCellBounds.size.width + _padding.width; // x padding
    }
    
    // Calculate content view frame
    CGRect contentViewFrame = _contentView.frame;
    contentViewFrame.origin.x = offset.x;
    contentViewFrame.origin.y = offset.y + 2; // check with cell for insets...
 
    // Update content view
    _contentView.frame = contentViewFrame;
    [_contentView updateContentIfNeeded];
    
    // Update selection view
    _selectionView.frame = _contentView.frame;
    [_selectionView updateSelectionIfNeeded];
}

#pragma mark -
#pragma mark LATextField (Properties)

- (void)setEditing:(BOOL)editing
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
    
    // Unselect any selected token field cell
    self.selectedTokenFieldCell = nil;
    
    // Super
    super.editing = editing;
}

#pragma mark -
#pragma mark LATextField (UIKeyInput)

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

- (LATokenFieldCell *)tokenizeEditingString:(NSString *)editingString
{
    id representedObject = nil;
    
    // Ask delegate for editing string's represented object
    if(_delegate && [_delegate respondsToSelector:@selector(tokenField:representedObjectForEditingString:)])
        representedObject = [self.delegate tokenField:self representedObjectForEditingString:editingString];
    
    return [self createTokenWithEditingString:editingString forRepresentedObject:representedObject];
}

- (LATokenFieldCell *)tokenizeEditingDictionary:(NSDictionary *)editingDictionary
{
    id representedObject = nil;
    
    // Ask delegate for editing dictionary's represented object
    if(_delegate && [_delegate respondsToSelector:@selector(tokenField:representedObjectForEditingDictionary:)])
        representedObject = [self.delegate tokenField:self representedObjectForEditingDictionary:editingDictionary];
    
    NSString * editingString = [editingDictionary objectForKey:LATokenFieldCompletionDictionaryText];
        
    return [self createTokenWithEditingString:editingString forRepresentedObject:representedObject];;
}

#pragma mark -
#pragma mark Token Cells

- (LATokenFieldCell *)createTokenWithEditingString:(NSString *)editingString forRepresentedObject:(id)representedObject
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
    LATokenFieldCell * tokenFieldCell = [[LATokenFieldCell alloc] initWithText:displayString andFont:_contentView.font];
    tokenFieldCell.representedObject = representedObject;
    
    // Setup token field cell actions
    [tokenFieldCell addTarget:self action:@selector(tokenFieldCellDidTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    
    // Add token field cell
    [self addTokenFieldCell:tokenFieldCell];
    
    return [tokenFieldCell autorelease];
}

- (void)addTokenFieldCell:(LATokenFieldCell *)tokenFieldCell
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

- (void)removeTokenFieldCell:(LATokenFieldCell *)tokenFieldCell
{
    BOOL shouldRemove = YES;
    NSUInteger index = [self.tokenFieldCells count]-1;
    
    if(_delegate && [_delegate respondsToSelector:@selector(tokenField:shouldRemoveRepresentedObject:atIndex:)])
        shouldRemove = [self.delegate tokenField:self shouldRemoveRepresentedObject:tokenFieldCell.representedObject atIndex:index];
    
    if(shouldRemove)
    {
        [tokenFieldCell retain];
        
        [tokenFieldCell removeFromSuperview];
        [self.tokenFieldCells removeObject:tokenFieldCell];
        [self setNeedsLayout];
        
        if(_delegate && [_delegate respondsToSelector:@selector(tokenField:didRemoveRepresentedObject:atIndex:)])
            [self.delegate tokenField:self didRemoveRepresentedObject:tokenFieldCell.representedObject atIndex:index];
        
        [tokenFieldCell release];
    }
}

#pragma mark -
#pragma mark Token Events

- (void)tokenFieldCellDidTouchUpInside:(LATokenFieldCell *)tokenFieldCell
{
    PrettyLog;
    
    if(self.isEditable)
    {
        if(![self isFirstResponder])
            [self becomeFirstResponder];
        
        self.selectedTokenFieldCell = tokenFieldCell;
    }
}

- (void)handleLongPressGesture:(UILongPressGestureRecognizer *)longPressGesture
{
    PrettyLog;
    
    CGPoint longPressLocation = [longPressGesture locationInView:self];
    
    switch (longPressGesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            UIView * longPressView = [self hitTest:longPressLocation withEvent:nil];
            
            if([longPressView isKindOfClass:[LATokenFieldCell class]])
            {
                _longPressTokenFieldCell = (LATokenFieldCell *)longPressView;
                [_longPressTokenFieldCell setScaled:YES animated:YES];
                
                [self bringSubviewToFront:_longPressTokenFieldCell];
                
                _longPressLocationDelta = CGPointMake(floorf(_longPressTokenFieldCell.center.x - longPressLocation.x), floorf(_longPressTokenFieldCell.center.y - longPressLocation.y));
            }
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            CGPoint center = CGPointMake(longPressLocation.x + _longPressLocationDelta.x, longPressLocation.y + _longPressLocationDelta.y);
           
            NSUInteger index = 0;
            
            for(LATokenFieldCell * tokenFieldCell in _tokenFieldCells)
            {
                // Check if _longPressTokenFieldCell is before tokenFieldCell 
                if((center.y < tokenFieldCell.frame.origin.y) || (center.y < (tokenFieldCell.frame.origin.y+tokenFieldCell.frame.size.height) && center.x < tokenFieldCell.center.x))
                    break;
                
                ++index;
            }
            
            NSUInteger currentIndex = [_tokenFieldCells indexOfObject:_longPressTokenFieldCell];
            
            
            if(index < currentIndex || index > currentIndex + 1) // only change when needed
            {
                [_longPressTokenFieldCell retain];
                [_tokenFieldCells removeObject:_longPressTokenFieldCell]; // remove before proceeding
                
                if(index < [_tokenFieldCells count])
                    [_tokenFieldCells insertObject:_longPressTokenFieldCell atIndex:index];
                else
                    [_tokenFieldCells addObject:_longPressTokenFieldCell];
                
                [_longPressTokenFieldCell release];
                
                [UIView animateWithDuration:0.15 animations:^{
                    [self layoutSubviews];
                } completion:^(BOOL finished) {
                    if(finished)
                    {
                    }
                }];
            }
            
            _longPressTokenFieldCell.center = center;
        }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        {
            [_longPressTokenFieldCell setScaled:NO animated:YES];
            _longPressTokenFieldCell = nil;
            
            [UIView animateWithDuration:0.15 animations:^{
                [self layoutSubviews];
            } completion:^(BOOL finished) {
                if(finished)
                {
                }
            }];
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
                self.completionTimer = [NSTimer scheduledTimerWithTimeInterval:kLATokenFieldDefaultCompletionDelay target:self selector:@selector(showCompletionView) userInfo:nil repeats:NO];
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
        _completionListView.frame = completionListViewFrame;
       
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
        CGFloat animationVerticalOffset =  _inset.height + _contentView.font.lineHeight + _inset.height - _completionListView.frame.origin.y;

        // Set up animation
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:kLATokenFieldDefaultCompletionAnimationDuration];
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
        static NSString * StringCompletionCellIdentifier = @"LATokenFieldStringCompletionCell";
        
        cell = [tableView dequeueReusableCellWithIdentifier:StringCompletionCellIdentifier];
        if (cell == nil) 
        {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:StringCompletionCellIdentifier] autorelease];
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        NSString * completionString = (NSString *)completion;
        cell.textLabel.text = completionString;
    }
    else if([completion isKindOfClass:[NSDictionary class]])
    {
        static NSString * DictionaryCompletionCellIdentifier = @"LATokenFieldDictionaryCompletionCell";
        static const NSUInteger SecondDetailTextLabelTag = 58839;
        
        cell = [tableView dequeueReusableCellWithIdentifier:DictionaryCompletionCellIdentifier];
        if (cell == nil) 
        {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:DictionaryCompletionCellIdentifier] autorelease];
            cell.accessoryType = UITableViewCellAccessoryNone;
            
            UILabel * secondDetailTextLabel = [[UILabel alloc] initWithFrame:cell.detailTextLabel.frame];
            secondDetailTextLabel.tag = SecondDetailTextLabelTag;
            secondDetailTextLabel.font = [UIFont systemFontOfSize:14.0f];
            secondDetailTextLabel.adjustsFontSizeToFitWidth = NO;
            secondDetailTextLabel.highlightedTextColor = cell.detailTextLabel.highlightedTextColor;
            secondDetailTextLabel.textColor = cell.detailTextLabel.textColor;
            [cell.contentView addSubview:secondDetailTextLabel];
            [secondDetailTextLabel release];
            
            cell.textLabel.font = [UIFont boldSystemFontOfSize:14.0f];
            cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:14.0f];
        }
        
        NSDictionary * completionDictionary = (NSDictionary *)completion;
        
        cell.textLabel.text = [completionDictionary objectForKey:LATokenFieldCompletionDictionaryText];
        cell.detailTextLabel.text = [completionDictionary objectForKey:LATokenFieldCompletionDictionaryDetailDescription];
        
        UILabel * secondDetailTextLabel = (UILabel *)[cell.contentView viewWithTag:SecondDetailTextLabelTag];
        secondDetailTextLabel.text = [NSString stringWithFormat:@" %@", [completionDictionary objectForKey:LATokenFieldCompletionDictionaryDetailText]];
        
        CGSize cellDetailTextLabelSize = [cell.detailTextLabel.text sizeWithFont:cell.detailTextLabel.font];
        CGSize secondDetailTextLabelSize = [secondDetailTextLabel.text sizeWithFont:secondDetailTextLabel.font];
        secondDetailTextLabel.frame = CGRectMake(cellDetailTextLabelSize.width+12, cell.textLabel.font.lineHeight+4, secondDetailTextLabelSize.width, secondDetailTextLabelSize.height);
    }
    else
    {
        static NSString * InvalidCompletionCellIdentifier = @"LATokenFieldInvalidCompletionCell";
        
        cell = [tableView dequeueReusableCellWithIdentifier:InvalidCompletionCellIdentifier];
        if (cell == nil) 
        {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:InvalidCompletionCellIdentifier] autorelease];
            cell.accessoryType = UITableViewCellAccessoryNone;
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
