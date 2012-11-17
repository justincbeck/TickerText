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
    CGAffineTransform _transform;
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
    text = [self trimText:text forFont:font];
    _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width, 0.0f, kLabelWidth, 22.0f)];
    _textLabel.font = font;
    _textLabel.backgroundColor = [UIColor clearColor];
    _textLabel.textColor = [UIColor blackColor];
    _textLabel.text = text;
    
    float translation = _textLabel.frame.size.width + self.frame.size.width;
    _transform = CGAffineTransformTranslate(_textLabel.transform, 0.0f - translation, 0.0f);
    
    [self startAnimation];
    [self pauseLayer:_textLabel.layer];
    
    [self addSubview:_textLabel];
}

- (void)updateTickerWithText:(NSString *)text
{
    UIFont *font = _textLabel.font;
    text = [self trimText:text forFont:font];
    _textLabel.text = text;
}

- (NSString *)trimText:(NSString *)text forFont:(UIFont *)font
{
    CGSize size = [text sizeWithFont:font];
    
    if (size.width > 295.0f)
    {
        while (size.width > 295.0f)
        {
            text = [text substringWithRange:NSMakeRange(0, [text length] - 1)];
            size = [text sizeWithFont:font];
        }
        
        text = [text stringByAppendingString:@"..."];
    }
    
    return text;
}

- (void)setTickerTextFont:(UIFont *)font
{
    [self setupTickerWithText:_textLabel.text andFont:font];
}

- (void)startAnimation
{
    [UIView animateWithDuration:5.0f delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
        _textLabel.transform = _transform;
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