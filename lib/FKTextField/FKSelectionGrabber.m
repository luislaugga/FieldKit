/*
 
 FKSelectionGrabber.m
 FieldKit
 
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

#import "FKSelectionGrabber.h"

#import "FKTextAppearance.h"

@implementation FKSelectionGrabber

#pragma mark -
#pragma mark Initialization

#if !__has_feature(objc_arc)
- (void)dealloc
{
    [super dealloc];
}
#endif

- (id)init
{
    self = [super initWithFrame:CGRectZero];
    if(self)
    {
        self.backgroundColor = [FKTextAppearance defaultSelectionGrabberColor];
        
        _dotView = [[FKSelectionGrabberDot alloc] init];
        [self addSubview:_dotView];

#if !__has_feature(objc_arc)
        [_dotView release];
#endif
    }
    return self;
}

#pragma mark -
#pragma mark User Interaction

- (BOOL)pointCanDrag:(CGPoint)point
{
    CGRect dragRect = CGRectMake(self.frame.origin.x-20, self.frame.origin.y-10, self.frame.size.width+40, self.frame.size.height+20);
    return CGRectContainsPoint(dragRect, point);
}

#pragma mark -
#pragma mark Frame

- (void)setFrame:(CGRect)frame
{
    if(_grabberType == FKSelectionStartGrabber)
    {
        _dotView.frame = CGRectMake(-_dotView.frame.size.width/2+1, -_dotView.frame.size.height/2+1, _dotView.frame.size.width, _dotView.frame.size.height);
    }
    else if(_grabberType == FKSelectionEndGrabber)
    {
        _dotView.frame = CGRectMake(-_dotView.frame.size.width/2+1, frame.size.height-4, _dotView.frame.size.width, _dotView.frame.size.height);
    }
    
    [super setFrame:frame];
}

#pragma mark -
#pragma mark Dot

- (void)setGrabberType:(FKSelectionGrabberType)grabberType
{
    if(grabberType == FKSelectionStartGrabber)
    {
        _dotView.frame = CGRectMake(self.frame.origin.x-_dotView.frame.size.width/2+1, self.frame.origin.y-_dotView.frame.size.height/2+1, _dotView.frame.size.width, _dotView.frame.size.height);
    }
    else if(grabberType == FKSelectionEndGrabber)
    {
        _dotView.frame = CGRectMake(self.frame.origin.x-_dotView.frame.size.width/2, self.frame.origin.y+self.frame.size.height, _dotView.frame.size.width, _dotView.frame.size.height);
    }
    
    _grabberType = grabberType;
}

@end

#pragma mark -
#pragma mark FKSelectionGrabberDot

@implementation FKSelectionGrabberDot

- (id)init
{
    self = [super initWithFrame:[FKTextAppearance selectionGrabberDotFrame]];
    if(self)
    {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGColorRef color = [FKTextAppearance defaultSelectionGrabberColor].CGColor;
    CGContextSetFillColorWithColor(context, color);
    CGContextSetStrokeColorWithColor(context, color);
    CGContextFillEllipseInRect(context, CGRectMake(0, 0, rect.size.width, rect.size.height));
}

@end
