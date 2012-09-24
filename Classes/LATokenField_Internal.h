//
//  LATokenField_Internal.h
//  LauggaKit
//
//  Created by Luis Laugga on 9/21/12.
//  Copyright (c) 2012 Luis Laugga. All rights reserved.
//

#import "LATokenField.h"

@interface LATokenField () <UITableViewDelegate, UITableViewDataSource>
{
    CGRect _frame; // used to save state before displaying completion view
    UIView * _superview; // used to save state before displaying completion view
    CGRect _keyboardFrame;
    CGSize _inset;
    CGSize _padding;

    NSTimer * _completionTimer;
    NSArray * _completionArray;
    UITableView * _completionListView;
}

@property(nonatomic, retain) NSMutableArray * tokenFieldCells;
@property(nonatomic, retain) NSTimer * completionTimer;
@property(nonatomic, retain) NSArray * completionArray;
@property(nonatomic, retain) UITableView * completionListView;

- (LATokenFieldCell *)tokenFieldCellWithText:(NSString *)text;

- (void)addTokenFieldCell:(LATokenFieldCell *)tokenFieldCell;
- (void)removeTokenFieldCell:(LATokenFieldCell *)tokenFieldCell;

- (void)selectTokenFieldCell:(LATokenFieldCell *)tokenFieldCell;
- (void)unselectTokenFieldCell:(LATokenFieldCell *)tokenFieldCell;
- (void)removeSelectedTokenFieldCell;

- (void)updateCompletionViewIfNeeded;
- (void)showCompletionView;
- (void)animateCompletionView;
- (void)hideCompletionView;

- (void)keyboardWillShow:(NSNotification *)notification;
- (void)registerForKeyboardNotifications;
- (void)unregisterForKeyboardNotifications;

@end
