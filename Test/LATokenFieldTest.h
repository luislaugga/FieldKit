//
//  Test.h
//  Test
//
//  Created by Luis Laugga on 10/5/12.
//  Copyright (c) 2012 Luis Laugga. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>

#import "LATokenField.h"

@interface Test : SenTestCase <LATokenFieldDelegate>
{
    LATokenField * tokenField;
}
@end
