/*
 
 FKTextField_Internal.h
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

#import "FKTextField.h"
#import "FKTextSelecting.h"
#import "FKTextContentView.h"
#import "FKTextSelectionView.h"
#import "FKTextInteractionAssistant.h"

#import "FKTextSelectionView.h"
#import "FKTextInteractionAssistant.h"

#pragma mark -
#pragma mark FKTextField internal class extension

/*!
 @category FKTextField internal extension
 */
@interface FKTextField () <FKTextSelectingContainer>
{
    @protected
    FKTextContentView * _contentView;
    FKTextSelectionView * _selectionView;
    FKTextInteractionAssistant * _interactionAssistant;    
}

@property(nonatomic, readwrite) BOOL editing;

- (void)showSelectionView:(BOOL)visible;

@end

