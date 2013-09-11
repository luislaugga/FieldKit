//
//  ViewController.h
//  LauggaKit
//
//  Created by Luis Laugga on 9/18/12.
//  Copyright (c) 2012 Luis Laugga. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <FieldKit/FieldKit.h>

@interface ViewController : UIViewController <FKTextFieldDelegate, FKTokenFieldDelegate>
{
    FKTextField * _textField;
    UITextView * _textView;
    FKTokenField * _tokenField;
    
    
    // Sample of names for token field
    NSArray * _tokenFieldCompletions;
}

@end
