//
//  ViewController.m
//  Colors
//
//  Created by luis on 10/22/12.
//  Copyright (c) 2012 luis laugga. All rights reserved.
//

#import "ViewController.h"

#import "UIColorTokenFieldCell.h"

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    tokenField = [[LATokenField alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    tokenField.autoresizingMask = (UIViewAutoresizingFlexibleWidth);
    tokenField.font = [UIFont systemFontOfSize:15.0f];
    tokenField.completionSuperview = self.view;
    tokenField.delegate = self;
    tokenField.representedObjects = [NSArray arrayWithObjects:[UIColor yellowColor], [UIColor greenColor], nil];
    [self.view addSubview:tokenField];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark LATokenField delegate

- (id)tokenField:(LATokenField *)tokenField representedObjectForEditingString:(NSString *)editingString
{
    SEL colorMethod = NSSelectorFromString([NSString stringWithFormat:@"%@Color", editingString]);
    
    if([UIColor respondsToSelector:colorMethod])
        return [UIColor performSelector:colorMethod];
    
    return [UIColor clearColor];
}

- (LATokenFieldCell *)tokenField:(LATokenField *)tokenField cellForRepresentedObject:(id)representedObject
{
    return [[UIColorTokenFieldCell alloc] init];
}

@end
