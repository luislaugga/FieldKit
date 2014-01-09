/*
 
 ViewController.m
 FieldKit ColorTokens Example
 
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

#import "ViewController.h"

#import "UIColorTokenFieldCell.h"

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"FieldKit ColorTokens";

    _tokenField = [[FKTokenField alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _tokenField.autoresizingMask = (UIViewAutoresizingFlexibleWidth);
    _tokenField.font = [UIFont systemFontOfSize:15.0f];
    _tokenField.completionSuperview = self.view;
    _tokenField.delegate = self;
    _tokenField.representedObjects = [NSArray arrayWithObjects:[UIColor yellowColor], [UIColor greenColor], nil];
    [_scrollView addSubview:_tokenField];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark FKTokenField delegate

- (id)tokenField:(FKTokenField *)tokenField representedObjectForEditingString:(NSString *)editingString
{
    SEL colorMethod = NSSelectorFromString([NSString stringWithFormat:@"%@Color", editingString]);
    
    if([UIColor respondsToSelector:colorMethod])
        return [UIColor performSelector:colorMethod];
    
    return [UIColor clearColor];
}

- (FKTokenFieldCell *)tokenField:(FKTokenField *)tokenField cellForRepresentedObject:(id)representedObject
{
    return [[UIColorTokenFieldCell alloc] init];
}

@end
