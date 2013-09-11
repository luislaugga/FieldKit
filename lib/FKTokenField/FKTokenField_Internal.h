/*
 
 FKTokenField_Internal.h
 FieldKit
 
 Copyright (cc) 2012 Luis Laugga.
 Some rights reserved, all wrongs deserved.
 
 Licensed under a Creative Commons Attribution-ShareAlike 3.0 License;
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://creativecommons.org/licenses/by-sa/3.0/
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" basis,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 
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
