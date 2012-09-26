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
@dynamic delegate;

#define kLATokenFieldDefaultInset CGSizeMake(4,6)
#define kLATokenFieldDefaultPadding CGSizeMake(4,4)
#define kLATokenFieldDefaultTokenizers [NSCharacterSet characterSetWithCharactersInString:@"\n"]
#define kLATokenFieldDefaultCompletionDelay 0.25
#define kLATokenFieldDefaultCompletionAnimationDuration 0.4

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
        
        // Register for keyboard notifications (needed to get keyboard's frame)
        [self registerForKeyboardNotifications];
    }
    return self;
}

- (void)dealloc
{
    // Unregister for keyboard notifications
    [self unregisterForKeyboardNotifications];
    
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
    NSMutableArray * representedObjects = [[NSMutableArray alloc] initWithCapacity:[_tokenFieldCells count]];
    for(LATokenFieldCell * tokenFieldCell in _tokenFieldCells)
        [representedObjects addObject:tokenFieldCell.representedObject];
    
    return [representedObjects autorelease];
}

- (void)setRepresentedObjects:(NSArray *)representedObjects
{
    // Remove any token field cells
    for(LATokenFieldCell * tokenFieldCell in _tokenFieldCells)
        [tokenFieldCell removeFromSuperview];
    
    // Clean up
    _selectedTokenFieldCell = nil;
    [self.tokenFieldCells removeAllObjects];
    
    for(id representedObject in representedObjects)
    {
        if([representedObject isKindOfClass:[NSString class]])
        {
            LATokenFieldCell * tokenFieldCell = [[self tokenFieldCellWithText:representedObject] retain];
            tokenFieldCell.representedObject = representedObject;
            [self addTokenFieldCell:tokenFieldCell];
            [tokenFieldCell release];
        }
        else
        {
            if(_delegate && [_delegate respondsToSelector:@selector(tokenField:displayStringForRepresentedObject:)])
            {
                NSString * displayString = [self.delegate tokenField:self displayStringForRepresentedObject:representedObject];
                LATokenFieldCell * tokenFieldCell = [[self tokenFieldCellWithText:displayString] retain];
                tokenFieldCell.representedObject = representedObject;
                [self addTokenFieldCell:tokenFieldCell];
                [tokenFieldCell release];
            }
        }
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

#pragma mark -
#pragma mark Layout

- (void)layoutSubviews
{
    PrettyLog;
    
    // Layout token field cells
    const CGFloat offsetTolerance = _contentView.font.lineHeight*2;
    CGPoint offset = CGPointMake(_inset.width, _inset.height); // start off with inset
    CGFloat width = self.bounds.size.width;
    for(LATokenFieldCell * tokenFieldCell in _tokenFieldCells)
    {
        CGRect tokenFieldCellFrame = tokenFieldCell.frame;
        
        if(offset.x + tokenFieldCellFrame.size.width + offsetTolerance > width)
        {
            offset.x = _inset.width; // reset left inset
            offset.y += _contentView.font.lineHeight + _padding.height; // y padding
        }

        tokenFieldCellFrame.origin.x = offset.x;
        tokenFieldCellFrame.origin.y = offset.y;
        tokenFieldCell.frame = tokenFieldCellFrame;
        
        offset.x += tokenFieldCellFrame.size.width + _padding.width; // x padding
    }
    
    // Calculate content view frame
    CGRect contentViewFrame = _contentView.frame;
    contentViewFrame.origin.x = offset.x;
    contentViewFrame.origin.y = offset.y + 2; // check with cell for insets...

    NSLog(@"content view frame %f %f %f %f", contentViewFrame.origin.x, contentViewFrame.origin.y, contentViewFrame.size.width, contentViewFrame.size.height);
    
    // Update content view
    _contentView.frame = contentViewFrame;
    [_contentView updateContentIfNeeded];
    
    // Update selection view
    _selectionView.frame = _contentView.frame;
    [_selectionView updateSelectionIfNeeded];
}

#pragma mark -
#pragma mark LATextField (UIKeyInput)

- (void)insertText:(NSString *)text
{    
    // Check if the inserted character (text) belongs to tokenizing character set
    if([_tokenizingCharacterSet characterIsMember:[text characterAtIndex:0]]) 
    {
        // Check if text is not empty, and creates a new token
        if([self.text length] > 1)
        {
            NSString * token = [self.text substringToIndex:[self.text length]];
            LATokenFieldCell * tokenFieldCell = [[self tokenFieldCellWithText:token] retain];
            [self addTokenFieldCell:tokenFieldCell];
            [tokenFieldCell release];
            self.text = @"";
        }
    }
    else
    {
        if(_selectedTokenFieldCell)
        {
            // If there's a selected token field cell, remove it first
            [self removeSelectedTokenFieldCell];
        }
        
        // Insert text as normal
        [super insertText:text];
    }
    
    // Show/Hide completion view if it's the case
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
            [self removeSelectedTokenFieldCell];
        }
        else if([_tokenFieldCells count] > 0)
        {
            [self selectTokenFieldCell:[_tokenFieldCells lastObject]];
        }
    }
    else
    {
        // Delete text as normal
        [super deleteBackward];
    }
    
    // Show/Hide completion view if it's the case
    [self updateCompletionViewIfNeeded];
}

#pragma mark -
#pragma mark Token Cells

- (LATokenFieldCell *)tokenFieldCellWithText:(NSString *)text
{
    LATokenFieldCell * tokenFieldCell = [[LATokenFieldCell alloc] initWithString:text andFont:_contentView.font];
    return [tokenFieldCell autorelease];
}

- (void)addTokenFieldCell:(LATokenFieldCell *)tokenFieldCell
{
    id representedObject = nil;
    if(_delegate && [_delegate respondsToSelector:@selector(tokenField:representedObjectForEditingString:)])
        representedObject = [self.delegate tokenField:self representedObjectForEditingString:tokenFieldCell.string];
    
    tokenFieldCell.representedObject = representedObject;
    [_tokenFieldCells addObject:tokenFieldCell];
    [self addSubview:tokenFieldCell];
    [self setNeedsLayout];
}

- (void)removeTokenFieldCell:(LATokenFieldCell *)tokenFieldCell
{
    [tokenFieldCell removeFromSuperview];
    [_tokenFieldCells removeObject:tokenFieldCell];
    [self setNeedsLayout];
}

#pragma mark -
#pragma mark Token Selection

- (void)selectTokenFieldCell:(LATokenFieldCell *)tokenFieldCell
{
    _selectedTokenFieldCell = tokenFieldCell;
    tokenFieldCell.selected = YES;
}

- (void)unselectTokenFieldCell:(LATokenFieldCell *)tokenFieldCell
{
    _selectedTokenFieldCell = nil;
    tokenFieldCell.selected = NO;
}

- (void)removeSelectedTokenFieldCell
{
    if(_selectedTokenFieldCell)
    {
        [self removeTokenFieldCell:_selectedTokenFieldCell];
        _selectedTokenFieldCell = nil;
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
        NSInteger index; // not supported
        
        // Get completions
        if(_delegate && [_delegate respondsToSelector:@selector(tokenField:completionsForSubstring:indexOfToken:indexOfSelectedItem:)])
        {
            self.completionArray = [self.delegate tokenField:self completionsForSubstring:self.text indexOfToken:[_tokenFieldCells count] indexOfSelectedItem:&index];
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
       PrettyLog;
       
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
        PrettyLog;
        
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
    static NSString *CellIdentifier = @"LATokenFieldCompletionListCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
	cell.textLabel.text = [_completionArray objectAtIndex:indexPath.row];
    
	return cell;
    
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * token = [_completionArray objectAtIndex:indexPath.row];
    LATokenFieldCell * tokenFieldCell = [[self tokenFieldCellWithText:token] retain];
    [self addTokenFieldCell:tokenFieldCell];
    [tokenFieldCell release];
    self.text = @"";
    
    // Show/Hide completion view if it's the case
    [self updateCompletionViewIfNeeded];
    
    // Deselect
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark UIKeyboard notifications

- (void)keyboardWillShow:(NSNotification*)notification
{
    PrettyLog;
    
    NSDictionary * info = [notification userInfo];
    
    _keyboardFrame = [self convertRect:[[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue] fromView:[[UIApplication sharedApplication] keyWindow]];
}

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];    
}

- (void)unregisterForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

@end
