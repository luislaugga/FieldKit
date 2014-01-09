/*
 
 FKTokenField_Internal.h
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
    
    FKTokenFieldCell * __unsafe_unretained _selectedTokenFieldCell;
    
    UILongPressGestureRecognizer * _longPressGestureRecognizer;
    CGPoint _longPressGestureHitOffset;
    
    BOOL _needsLayoutAnimated;
}

@property(nonatomic, strong) NSMutableArray * tokenFieldCells;
@property(nonatomic, unsafe_unretained) FKTokenFieldCell * selectedTokenFieldCell;
@property(nonatomic, strong) NSTimer * completionTimer;
@property(nonatomic, strong) NSArray * completionArray;
@property(nonatomic, strong) UITableView * completionListView;

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
