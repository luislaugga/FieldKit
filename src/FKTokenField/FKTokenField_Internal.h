//
//  FKTokenField_Internal.h
//  FieldKit
//
//  Created by Luis Laugga on 9/21/12.
//  Copyright (c) 2012 Luis Laugga. All rights reserved.
//

#import "FKTokenField.h"

@interface FKTokenField () <UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource>
{
    CGRect _frame; // used to save state before displaying completion view
    UIView * _superview; // used to save state before displaying completion view
    CGRect _keyboardFrame;
    CGSize _inset;
    CGSize _padding;

    NSTimer * _completionTimer;
    NSArray * _completionArray;
    UITableView * _completionListView;
    
    FKTokenFieldCell * _selectedTokenFieldCell;
    
    UILongPressGestureRecognizer * _longPressGestureRecognizer;
    CGPoint _longPressGestureHitOffset;
    
    BOOL _needsLayoutAnimated;
}

@property(nonatomic, retain) NSMutableArray * tokenFieldCells;
@property(nonatomic, assign) FKTokenFieldCell * selectedTokenFieldCell;
@property(nonatomic, retain) NSTimer * completionTimer;
@property(nonatomic, retain) NSArray * completionArray;
@property(nonatomic, retain) UITableView * completionListView;

/*!
 Will set _needsLayoutAnimated flag and wrap the layoutSubviews with UIView animation block
 @discussion
 Used for layout changes while dragging tokens
 */
@property(nonatomic, assign) BOOL needsLayoutAnimated;

- (FKTokenFieldCell *)tokenizeEditingString:(NSString *)editingString;
- (FKTokenFieldCell *)tokenizeEditingDictionary:(NSDictionary *)editingDictionary;

- (FKTokenFieldCell *)createTokenWithEditingString:(NSString *)editingString forRepresentedObject:(id)representedObject;

- (void)addTokenFieldCell:(FKTokenFieldCell *)tokenFieldCell;
- (void)removeTokenFieldCell:(FKTokenFieldCell *)tokenFieldCell;

- (void)updateCompletionViewIfNeeded;
- (void)showCompletionView;
- (void)animateCompletionView;
- (void)hideCompletionView;

- (void)keyboardWillShow:(NSNotification *)notification;
- (void)registerForKeyboardNotifications;
- (void)unregisterForKeyboardNotifications;

@end
