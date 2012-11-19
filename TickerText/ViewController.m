//
//  ViewController.m
//  TickerText
//
//  Created by Justin C. Beck on 11/16/12.
//  Copyright (c) 2012 WillowTree Apps. All rights reserved.
//

#import "ViewController.h"
#import "TickerView.h"
#import <QuartzCore/QuartzCore.h>

@interface ViewController () <UITextFieldDelegate>
{
    __weak IBOutlet TickerView *tickerView;
    __weak IBOutlet UITextField *updateTextField;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    tickerView.layer.borderColor = [UIColor blackColor].CGColor;
    tickerView.layer.borderWidth = 1.0f;
    [tickerView setupTickerWithText:@"WNRN - Streaming Radio" andFont:[UIFont fontWithName:@"Futura-Medium" size:16.0f]];
    [tickerView toggleAnimation];
    
    updateTextField.delegate = self;
}

- (IBAction)updateTicker:(id)sender {
    if (updateTextField.text.length > 0)
    {
        [tickerView updateTickerWithText:updateTextField.text];
    }
    [updateTextField resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showOtherController:(id)sender
{
    // Nothing to see here
}

- (IBAction)toggleAnimation:(id)sender
{
    [tickerView toggleAnimation];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if (![tickerView isPaused])
    {
        [tickerView toggleAnimation];
    }
}

- (IBAction)rewindToMe:(UIStoryboardSegue *)sender
{
    if ([tickerView isPaused])
    {
        [tickerView toggleAnimation];
    }
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [self updateTicker:nil];
    return YES;
}

@end