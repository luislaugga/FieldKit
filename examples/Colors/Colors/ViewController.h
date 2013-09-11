//
//  ViewController.h
//  Colors
//
//  Created by luis on 10/22/12.
//  Copyright (c) 2012 luis laugga. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <FieldKit/FieldKit.h>

@interface ViewController : UIViewController <FKTokenFieldDelegate>
{
    FKTokenField * tokenField;
}

@end
