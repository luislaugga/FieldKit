/*
 
 FKTextField+UIResponderStandardEditActions.m
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

#import "FKTextField+UIResponderStandardEditActions.h"
#import "FKTextField+UITextInput.h"

@implementation FKTextField (UIResponderStandardEditActions)

#pragma mark -
#pragma mark Handling Copy, Cut, Delete, and Paste Commands

/*!
 Copy the selection to the pasteboard.
 */
- (void)copy:(id)sender
{
    // Grab the selected text string
    NSString * selectedText = [self textInRange:[FKTextRange textRangeWithRange:_selectionView.selectionRange]];
    if(selectedText)
    {
        // Set the selected text string to the general UIPasteboard
        [[UIPasteboard generalPasteboard] setString:selectedText];
    }
}

/*!
 Remove the selection from the user interface and write it to the pasteboard.
 */
- (void)cut:(id)sender
{
    // Grab the current selection
    FKTextRange * textSelection = [FKTextRange textRangeWithRange:_selectionView.selectionRange];

#if !__has_feature(objc_arc)
    [textSelection retain];
#endif
    
    // Grab the selected text string
    NSString * selectedText = [self textInRange:textSelection];
    if(selectedText)
    {
        // Set the selected text string to the general UIPasteboard
        [[UIPasteboard generalPasteboard] setString:selectedText];
    }
    
    // Remove the selected text
    //[self replaceRange:textSelection withText:@""];
    [_selectionView deleteTextFromSelection];
    
#if !__has_feature(objc_arc)
    [textSelection release];
#endif
}

/*!
 Read data from the pasteboard and copy into the current text selection.
 */
- (void)paste:(id)sender
{
    // Grab the selected text string from the general UIPasteboard
    NSString * pasteString = [[UIPasteboard generalPasteboard] string];
    if(pasteString)
    {
        // Replace the selected text by the paste string
        //[self replaceRange:[FKTextRange textRangeWithRange:_selectionView.selectionRange] withText:pasteString];
        [_selectionView insertTextIntoSelection:pasteString];
    }
}

#pragma mark -
#pragma mark Handling Selection Commands

/*!
 Select the next object the user taps.
 */
- (void)select:(id)sender
{
    // Find selection range for current selection
    NSRange selectRange = [_contentView textWordRangeForIndex:_selectionView.selectionRange.location];
    
    // Select
    _selectionView.selectionRange = selectRange;
}

/*!
 Select all objects in the current view.
 */
- (void)selectAll:(id)sender
{
    // Select from start to end
    _selectionView.selectionRange = NSMakeRange(0, _contentView.text.length);
}

#pragma mark -
#pragma mark Conditionally Enable Menu Commands

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if(_selectionView.selectionRange.length) // range selection
    {
        if(action == @selector(cut:) || action == @selector(copy:) || action == @selector(paste:))
            return YES;
        else if(action == @selector(select:) || action == @selector(selectAll:)) // disable select and selectAll in range selection
            return NO;
    }
    else // caret selection
    {
        if(action == @selector(select:) || action == @selector(selectAll:))
            return YES;
        else if(action == @selector(copy:) || action == @selector(cut:)) // disable copy and cut in caret selection
            return NO;
    }
    
    return [super canPerformAction:action withSender:sender];
}

@end
