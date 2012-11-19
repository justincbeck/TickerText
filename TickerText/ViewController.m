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
   
    updateTextField.delegate = self;
    
    tickerView.layer.borderColor = [UIColor blackColor].CGColor;
    tickerView.layer.borderWidth = 1.0f;
    [tickerView setupTickerWithText:@"WNRN - Streaming Radio" andFont:[UIFont fontWithName:@"Futura-Medium" size:16.0f]];
    [tickerView startAnimation];
}

- (IBAction)updateTicker:(id)sender {
    if (updateTextField.text.length > 0)
    {
        [tickerView updateTickerWithText:updateTextField.text];
    }
    [updateTextField resignFirstResponder];
}

- (IBAction)startAnimation:(id)sender {
    [tickerView startAnimation];
}

- (IBAction)stopAnimation:(id)sender {
    [tickerView stopAnimation];
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [tickerView stopAnimation];
}

- (IBAction)rewindToMe:(UIStoryboardSegue *)sender
{
    [tickerView startAnimation];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [self updateTicker:nil];
    return YES;
}

@end