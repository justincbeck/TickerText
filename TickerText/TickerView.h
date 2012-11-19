//
//  TickerView.h
//  TickerText
//
//  Created by Justin C. Beck on 11/16/12.
//  Copyright (c) 2012 WillowTree Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TickerView : UIView

@property (nonatomic, assign) CGFloat segmentGap;

- (void)setupTickerWithText:(NSString *)text andFont:(UIFont *)font;
- (void)updateTickerWithText:(NSString *)text;

@end
