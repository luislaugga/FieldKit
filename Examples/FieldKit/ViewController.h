//
//  ViewController.h
//  LauggaKit
//
//  Created by Luis Laugga on 9/18/12.
//  Copyright (c) 2012 Luis Laugga. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LATextField.h"
#import "LATokenField.h"

@interface ViewController : UIViewController <LATextFieldDelegate, LATokenFieldDelegate>
{
    LATextField * _textField;
    UITextView * _textView;
    LATokenField * _tokenField;
    
    
    // Sample of names for token field
    NSArray * _tokenFieldCompletions;
}

@end
