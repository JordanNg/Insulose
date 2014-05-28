//
//  AAViewController.m
//  HBP Monitor
//
//  Created by Jordan Ng on 4/3/14.
//  Copyright (c) 2014 Agency Agency. All rights reserved.
//

#import "AAViewController.h"
#import "BloodSugar+Create.h"
#import "AAAppDelegate.h"
#import "AADataEntryVC.h"
#import "AALineGraphView.h"

@interface AAViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *readings;
@property (weak, nonatomic) IBOutlet UIButton *addMeasurementButton;
@property (weak, nonatomic) IBOutlet UIButton *editMeasurementButton;
@property (strong, nonatomic) BloodSugar *currentlyDisplayedReading;
@property (weak, nonatomic) IBOutlet AALineGraphView *lineGraphView;

@end

@implementation AAViewController

-(void)reloadData
{
    self.readings = [BloodSugar allReadingsInManagedObjectContext:self.context];
    [self.tableView reloadData];
    [self.lineGraphView reloadGraph];
}

- (void)recordCurrentSelectionAtIndexPath:(NSIndexPath *)indexPath
{
    [self setEditButtonEnabled:NO];
    
    if ([self.readings count] && indexPath.row < [self.readings count]) {
        self.currentlyDisplayedReading = self.readings[indexPath.row];
        if (self.currentlyDisplayedReading) {
            [self setEditButtonEnabled:YES];
        }
    }
}

- (void)setEditButtonEnabled:(BOOL)enabled
{
    [UIView animateWithDuration:0.25f delay:0.0f
                        options:UIViewAnimationCurveEaseInOut | UIViewAnimationOptionAllowAnimatedContent | UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         if (enabled) {
                             self.editMeasurementButton.enabled = YES;
                             self.editMeasurementButton.alpha = 1.0;
                         } else {
                             self.editMeasurementButton.enabled = NO;
                             self.editMeasurementButton.alpha = 0.5;
                         }
                        }
                     completion:nil];
}

- (void)setContext:(NSManagedObjectContext *)context
{
    _context = context;
    [self reloadData];
}

-(NSString *)formattedReadingDate:(NSDate *)date
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateStyle:NSDateFormatterMediumStyle];
    NSString *dateString = [format stringFromDate:date];

    return dateString;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setEditButtonEnabled:NO];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self reloadData];
}

- (void)setReadings:(NSArray *)readings{
    _readings = readings;
    NSInteger numReadings = MIN([self.lineGraphView numberOfLinePoints], [readings count]);
    NSArray *smallArray = [readings subarrayWithRange:NSMakeRange(0, numReadings)];
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:[smallArray count]];
    NSEnumerator *enumerator = [smallArray reverseObjectEnumerator];
    for (id element in enumerator) {
        [array addObject:element];
    }
    self.lineGraphView.lineGraphReadings = array;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Reading Cell" forIndexPath:indexPath];
    BloodSugar *reading = (BloodSugar *)self.readings[indexPath.row];
    
    cell.textLabel.text = [[reading bloodReading] description];
    cell.textLabel.text = [NSString stringWithFormat:@"%@   %@", [[reading bloodReading] description],
                           [self formattedReadingDate:reading.readingTime]];
    cell.detailTextLabel.text = [reading.notes description];
    return cell;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.readings count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self recordCurrentSelectionAtIndexPath:indexPath];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"edit measurement"]) {
        AADataEntryVC *vc = segue.destinationViewController;
        vc.currentlyDisplayedReading = self.currentlyDisplayedReading;
    }
}

- (IBAction)unwindHistoryVC:(UIStoryboardSegue *)unwindSegue
{
}



@end