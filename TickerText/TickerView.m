//
//  TickerView.m
//  TickerText
//
//  Created by Justin C. Beck on 11/16/12.
//  Copyright (c) 2012 WillowTree Apps. All rights reserved.
//

#import "TickerView.h"
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#define kAnimationStepSize 1.0f

@interface TickerContentView : UIView

@property (nonatomic, weak) UILabel *label;
@property (nonatomic, readwrite) CGFloat segmentGap;
@property (nonatomic, readwrite) CGFloat resetPoint;

@end

@implementation TickerContentView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = NO;
        self.layer.masksToBounds = NO;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [self.label drawTextInRect:rect];
    
    CGSize size = [self.label.text sizeWithFont:self.label.font];
    CGRect secondRect = CGRectMake(size.width + self.segmentGap, rect.origin.y, rect.size.width, rect.size.height);
    
    [self.label drawTextInRect:secondRect];
}

@end

//------------------------------------------------------------

@interface TickerView ()
{
    UILabel *_textLabel;
    TickerContentView *_contentView;
    __weak CADisplayLink *_displayLink;
}

@end

@implementation TickerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.borderColor = [UIColor blackColor].CGColor;
        self.layer.borderWidth = 1.0f;
    }
    return self;
}

- (void)setupTickerWithText:(NSString *)text andFont:(UIFont *)font
{
    CGSize size = [text sizeWithFont:font];
    
    _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width, 0.0f, size.width, size.height)];
    _textLabel.font = font;
    _textLabel.textColor = [UIColor blackColor];
    _textLabel.text = text;
    
    _contentView = [[TickerContentView alloc] initWithFrame:CGRectZero];
    _contentView.label = _textLabel;
    _contentView.segmentGap = 70.0f;
    _contentView.frame = CGRectMake(self.frame.size.width, 0.0f, (size.width * 2) + _contentView.segmentGap, size.height);
    _contentView.resetPoint = size.width + _contentView.segmentGap + fabs(self.frame.size.width - _contentView.segmentGap);
    
    [self addSubview:_contentView];
}

- (void)updateTickerWithText:(NSString *)text
{
    UIFont *font = _textLabel.font;
    CGSize size = [text sizeWithFont:font];
    
    _textLabel.text = text;
    
    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        _contentView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [self.layer removeAllAnimations];
        
        _contentView.frame = CGRectMake(_contentView.frame.origin.x, 0.0f, (size.width * 2) + _contentView.segmentGap, size.height);
        _contentView.resetPoint = size.width + _contentView.segmentGap + fabs(self.frame.size.width - _contentView.segmentGap);
        
        self.bounds = CGRectMake(0.0f, 0.0f, self.bounds.size.width, self.bounds.size.height);
        _contentView.alpha = 1.0f;
        
        [_contentView setNeedsDisplay];
    }];
}

- (void)setTickerTextFont:(UIFont *)font
{
    [self setupTickerWithText:_textLabel.text andFont:font];
}

- (void)startAnimation
{
    if (_displayLink == nil)
    {
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateContentView:)];
        [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    }
}

- (void)updateContentView:(id)sender
{
    CGPoint point = self.bounds.origin;
    point.x += kAnimationStepSize;
    
    self.bounds = CGRectMake(point.x, point.y, self.bounds.size.width, self.bounds.size.height);
    if (self.bounds.origin.x >= _contentView.resetPoint)
    {
        float deltax = fabs(self.bounds.origin.x - _contentView.resetPoint);
        float x = fabs(self.frame.size.width - _contentView.segmentGap) + deltax;
        
        self.bounds = CGRectMake(x, 0.0f, self.bounds.size.width, self.bounds.size.height);
    }
}

- (void)stopAnimation
{
    [_displayLink invalidate];
}

- (void)setSegmentGap:(CGFloat)segmentGap
{
    _contentView.segmentGap = segmentGap;
    [self updateTickerWithText:_textLabel.text];
}

- (CGFloat)segmentGap
{
    return _contentView.segmentGap;
}

@end