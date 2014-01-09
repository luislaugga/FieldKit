/*
 
 ViewController.m
 FieldKit MessageComposer Example
 
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

@interface ViewController ()

@end

@implementation ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self)
    {
        _tokenFieldCompletions = [ViewController tokenFieldCompletions];
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Configuring UINavigationItem
    UIBarButtonItem * cancelButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:nil action:nil];
    UIBarButtonItem * sendButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Send" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    self.navigationItem.leftBarButtonItem = cancelButtonItem;
    self.navigationItem.rightBarButtonItem = sendButtonItem;
    self.navigationItem.title = @"New Message";
    
    
    // Configure
    self.navigationItem.rightBarButtonItem.enabled = NO; // disable send until user fills-in required fields
    
    // To
    _toTokenField = [[FKTokenField alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 50)];
    _toTokenField.autoresizingMask = (UIViewAutoresizingFlexibleWidth);
    _toTokenField.font = [UIFont systemFontOfSize:15.0f];
    _toTokenField.completionSuperview = self.view;
    _toTokenField.delegate = self;
    _toTokenField.representedObjects = [NSArray arrayWithObjects:@"Luis Laugga", nil];
    [_scrollView addSubview:_toTokenField];
    
    // CC
    _ccTokenField = [[FKTokenField alloc] initWithFrame:CGRectMake(0, 50, self.view.bounds.size.width, 50)];
    _ccTokenField.autoresizingMask = (UIViewAutoresizingFlexibleWidth);
    _ccTokenField.font = [UIFont systemFontOfSize:15.0f];
    _ccTokenField.completionSuperview = self.view;
    _ccTokenField.delegate = self;
    _ccTokenField.representedObjects = [NSArray arrayWithObjects:@"", nil];
    [_scrollView addSubview:_ccTokenField];
    
    // BCC
    // TODO
    
    // Subject
    _subjectTextField = [[FKTextField alloc] initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, 50)];
    _subjectTextField.autoresizingMask = (UIViewAutoresizingFlexibleWidth);
    _subjectTextField.font = [UIFont systemFontOfSize:15.0f];
    [_scrollView addSubview:_subjectTextField];
    
    // Body
    _bodyTextField = [[FKTextField alloc] initWithFrame:CGRectMake(0, 150, self.view.bounds.size.width, 350)];
    _bodyTextField.autoresizingMask = (UIViewAutoresizingFlexibleWidth);
    _bodyTextField.font = [UIFont systemFontOfSize:15.0f];
    [_scrollView addSubview:_bodyTextField];
    
    [_scrollView setContentSize:CGSizeMake(_scrollView.frame.size.width, 500)];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    //[_bccTokenField release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    PrettyLog;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    PrettyLog;
    
//    NSArray * representedObjects = [_tokenField.representedObjects retain];
//    NSLog(@"there are %d represented objects", [representedObjects count]);
//    [representedObjects release];
    
}

#pragma mark -
#pragma mark FKTextFieldDelegate

#pragma mark -
#pragma mark FKTokenFieldDelegate

- (NSArray *)tokenField:(FKTokenField *)tokenField completionsForSubstring:(NSString *)substring indexOfToken:(NSInteger)tokenIndex
{
    NSMutableArray * completionsForSubstring = [[NSMutableArray alloc] init];
    
    for(NSString * completion in _tokenFieldCompletions)
    {
        NSRange substringRange = [completion rangeOfString:substring options:(NSCaseInsensitiveSearch)];
        if(substringRange.location != NSNotFound)
        {
            BOOL useDictionary = rand()%2;
            
            if(useDictionary)
            {
                NSString * name = completion;
                NSString * label = @"label";
                NSString * value = @"value";
                NSDictionary * completionDictionary = [NSDictionary dictionaryWithObjectsAndKeys:name, FKTokenFieldCompletionDictionaryText, label, FKTokenFieldCompletionDictionaryDetailDescription, value, FKTokenFieldCompletionDictionaryDetailText, nil];
                [completionsForSubstring addObject:completionDictionary];
            }
            else
            {
                [completionsForSubstring addObject:completion];
            }
        }
    }
    
    return completionsForSubstring;
}



- (id)tokenField:(FKTokenField *)tokenField representedObjectForEditingString:(NSString *)editingString
{
    return editingString;
}

- (id)tokenField:(FKTokenField *)tokenField representedObjectForEditingDictionary:(NSDictionary *)editingDictionary
{
    return [editingDictionary objectForKey:FKTokenFieldCompletionDictionaryText];
}

+ (NSArray *)tokenFieldCompletions
{
	// Generated with http://www.kleimo.com/random/name.cfm	
	return [NSArray arrayWithObjects:
			@"Samuel Prescott",
			@"Grace Mcburney", 
			@"Rosemary Sells",
			@"Janet Canady",
			@"Gregory Leech",
			@"Geneva Mcguinness",
			@"Billy Shin",
			@"Douglass Fostlick",
			@"Roberta Pedersen",
			@"Earl Rashid",
			@"Matthew Hooks",
			@"Regina Toombs",
			@"Victor Sisneros",
			@"Beverly Covington",
			@"Steve Crews",
			@"Carlos Trejo",
			@"Victoria Delgadillo",
			@"Leah Greenberg",
			@"Deborah Depew",
			@"Jeffery Khoury",
			@"Kathryn Worsham",
			@"Olivia Brownell",
			@"Gary Pritchard",
			@"Susan Cervantes",
			@"Olvera Nipplehead",
			@"Debra Graves",
			@"Albert Deltoro",
			@"Carole Flatt",
			@"Philip Vo",
			@"Phillip Wagstaff",
			@"Xiao Jacquay",
			@"Cleotilde Vondrak",
			@"Carter Redepenning",
			@"Kaycee Wintersmith",
			@"Collin Tick",
			@"Peg Yore",
			@"Cruz Buziak",
			@"Ardath Osle",
			@"Frederic Manusyants",
			@"Collin Politowski",
			@"Hunter Wollyung",
			@"Cruz Gurke",
			@"Sulema Sholette",
			@"Denver Goetter",
			@"Chantay Phothirath",
			@"Arlean Must",
			@"Carlo Henggeler",
			@"Daughrity Maichle",
			@"Zada Wintermantel",
			@"Denver Kubu",
			@"Carlo Guzma",
			@"Emory Swires",
			@"Kirby Manas",
			@"Tobie Spirito",
			@"Lane Defaber",
			@"Sparkle Mousa",
			@"Chantay Palczynski",
			@"Denver Perfater",
			@"Tom Irving",
			nil];
}


@end
