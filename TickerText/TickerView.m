//
//  TickerView.m
//  TickerText
//
//  Created by Justin C. Beck on 11/16/12.
//  Copyright (c) 2012 WillowTree Apps. All rights reserved.
//

#import "TickerView.h"
#import <QuartzCore/QuartzCore.h>

#define kLabelWidth 300.0f

@interface TickerView ()
{
    UILabel *_textLabel;
    CATransform3D _transform;
}

@end

@implementation TickerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.borderColor = [UIColor blackColor].CGColor;
        self.layer.borderWidth = 1.0f;
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)setupTickerWithText:(NSString *)text andFont:(UIFont *)font
{
    CGSize size = [text sizeWithFont:font];
    
    _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width, 0.0f, size.width, size.height)];
    _textLabel.font = font;
    _textLabel.backgroundColor = [UIColor clearColor];
    _textLabel.textColor = [UIColor blackColor];
    _textLabel.text = text;
    
    float translation = _textLabel.frame.size.width + self.frame.size.width;
    _transform = CATransform3DMakeTranslation(0.0f - translation, 0.0f, 0.0f);
    
    [self startAnimation];
    [self pauseLayer:_textLabel.layer];
    
    [self addSubview:_textLabel];
}

- (void)updateTickerWithText:(NSString *)text
{
    [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
        _textLabel.alpha = 0.0f;
    } completion:^(BOOL finished) {
        _textLabel.text = text;
        
        UIFont *font = _textLabel.font;
        CGSize size = [text sizeWithFont:font];
        
        [self updateLabelBoundsWithSize:size];
        
        [UIView animateWithDuration:0.2f animations:^{
            _textLabel.alpha = 1.0f;
        }];
    }];
}

- (void)updateLabelBoundsWithSize:(CGSize)size
{
    _textLabel.layer.bounds = CGRectMake(0.0f, 0.0f, size.width, size.height);
}

- (void)setTickerTextFont:(UIFont *)font
{
    [self setupTickerWithText:_textLabel.text andFont:font];
}

- (void)startAnimation
{
    [UIView animateWithDuration:5.0f delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
        _textLabel.layer.transform = _transform;
    } completion:^(BOOL finished) {
        _textLabel.transform = CGAffineTransformIdentity;
        [self startAnimation];
    }];
}

- (void)toggleAnimation
{
    if ([self isPaused])
    {
        [self resumeLayer:_textLabel.layer];
    }
    else
    {
        [self pauseLayer:_textLabel.layer];
    }
}

- (void)pauseLayer:(CALayer*)layer
{
    CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
    layer.speed = 0.0;
    layer.timeOffset = pausedTime;
}

- (void)resumeLayer:(CALayer*)layer
{
    CFTimeInterval pausedTime = [layer timeOffset];
    layer.speed = 1.0;
    layer.timeOffset = 0.0;
    layer.beginTime = 0.0;
    CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    layer.beginTime = timeSincePause;
}

- (BOOL)isPaused
{
    return _textLabel.layer.speed == 0.0f;
}

@end