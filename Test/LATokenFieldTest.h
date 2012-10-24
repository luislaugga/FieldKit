//
//  Test.h
//  Test
//
//  Created by Luis Laugga on 10/5/12.
//  Copyright (c) 2012 Luis Laugga. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>

#import "FKTokenField.h"

@interface Test : SenTestCase <FKTokenFieldDelegate>
{
    FKTokenField * tokenField;
}
@end
