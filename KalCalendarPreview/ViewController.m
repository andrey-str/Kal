//
//  ViewController.m
//  QalendarPreview
//
//  Created by Andrey Streltsov on 23/07/14.
//  Copyright (c) 2014 Gagik. All rights reserved.
//

#import "ViewController.h"
#import "KalViewController.h"
#import "NSDate+Convenience.h"

@interface ViewController ()

@property (nonatomic, strong) KalViewController* kalViewController;

@end

@implementation ViewController

- (void) viewDidAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.kalViewController = [[KalViewController alloc] initWithSelectionMode: KalSelectionModeSingle];
    self.kalViewController.selectedDate = [NSDate dateStartOfDay:[[NSDate date] offsetDay:1]];
    self.kalViewController.beginDate = [NSDate dateFromString:@"2014-07-01"];
    self.kalViewController.endDate = [NSDate dateFromString:@"2014-08-01"];
    
    [self presentViewController:self.kalViewController animated:NO completion:nil];
}
- (void)viewDidLoad
{
    [super viewDidLoad];

    [_kalViewController showAndSelectDate:[NSDate date]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
