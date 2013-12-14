//
//  ViewController.m
//  LauggaKit
//
//  Created by Luis Laugga on 9/18/12.
//  Copyright (c) 2012 Luis Laugga. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self)
    {
        _tokenFieldCompletions = [[ViewController tokenFieldCompletions] retain];
    }
    return self;
}

- (void)dealloc
{
    [_tokenFieldCompletions release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString * text = @"Classes that adopt the UITextInput protocol (and conform with inherited protocols) interact with the text input system and thus acquire features such as autocorrection and multistage text input for their documents. (Multistage text input is required when the language is ideographic and the keyboard is phonetic.)";
    
    _textField = [[FKTextField alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height/2-1)];
    _textField.autoresizingMask = (UIViewAutoresizingFlexibleWidth);
    [_scrollView addSubview:_textField];
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height/2 + 1, self.view.bounds.size.width+10, self.view.bounds.size.height/2-1)];
    _textView.autoresizingMask = (UIViewAutoresizingFlexibleWidth);
    _textView.contentInset = UIEdgeInsetsMake(0, -8, 0, 0);
    [_scrollView addSubview:_textView];
    
    _tokenField = [[FKTokenField alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height+1, self.view.bounds.size.width, self.view.bounds.size.height/2-1)];
    _tokenField.autoresizingMask = (UIViewAutoresizingFlexibleWidth);
    _tokenField.font = [UIFont systemFontOfSize:15.0f];
    _tokenField.completionSuperview = self.view;
    _tokenField.delegate = self;
    _tokenField.representedObjects = [NSArray arrayWithObjects:@"Janet Canady", @"Albert Deltoro", @"Luis Laugga", @"Maria", @"Yellow", @"Super Store", @"Very Looonngg Name", nil];
    [_scrollView addSubview:_tokenField];
    
    [_scrollView setContentSize:CGSizeMake(_scrollView.frame.size.width, self.view.bounds.size.height*2)];
    
    _textField.text = text;
    _textView.text = text;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [_textField release];
    [_textView release];
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
    
    NSArray * representedObjects = [_tokenField.representedObjects retain];
    NSLog(@"there are %d represented objects", [representedObjects count]);
    [representedObjects release];
    
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
    
    return [completionsForSubstring autorelease];
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
