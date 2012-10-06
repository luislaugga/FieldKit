//
//  Test.m
//  Test
//
//  Created by Luis Laugga on 10/5/12.
//  Copyright (c) 2012 Luis Laugga. All rights reserved.
//

#import "LATokenFieldTest.h"

@implementation Test

- (void)setUp
{
    [super setUp];
    
    tokenField = [[LATokenField alloc] initWithFrame:CGRectZero];
}

- (void)tearDown
{   
    [tokenField release];
    
    [super tearDown];
}

- (void)testSetRepresentedObjects
{
    STFail(@"Unit tests are not implemented yet in Test");
}

@end
