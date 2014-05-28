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

static const NSInteger kNumLinePoints = 7;

@interface AAViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *readings;
@property (weak, nonatomic) IBOutlet UIButton *addMeasurementButton;
@property (strong, nonatomic) BloodSugar *currentlyDisplayedReading;
@property (strong, nonatomic) NSArray *lineGraphReadings;

@end

@implementation AAViewController

-(void)reloadData
{
    self.readings = [BloodSugar allReadingsInManagedObjectContext:self.context];
    [self.tableView reloadData];
    [self.myGraph reloadGraph];
}

- (void)recordCurrentSelectionAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"record...");
    if ([self.readings count] && indexPath.row < [self.readings count]) {
        NSLog(@"reading at: %@", self.readings[indexPath.row]);
        self.currentlyDisplayedReading = self.readings[indexPath.row];
    }
}

- (void)setContext:(NSManagedObjectContext *)context
{
    _context = context;
    [self reloadData];
//    if ([self.readings count]) {
//        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//        [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
//        [self recordCurrentSelectionAtIndexPath:indexPath];
//    }
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
    
    self.myGraph.enableBezierCurve = NO;
    self.myGraph.widthLine = 4;
    
    self.myGraph.colorTop = [UIColor colorWithRed:255.0/255.0 green:223.0/255.0 blue:0.0/255.0 alpha:1.0];
    self.myGraph.colorBottom = [UIColor colorWithRed:255.0/255.0 green:223.0/255.0 blue:0.0/255.0 alpha:1.0];
    self.myGraph.colorXaxisLabel = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0];
}

- (NSInteger)numberOfPointsInLineGraph:(BEMSimpleLineGraphView *)graph {
    if (![self.lineGraphReadings count]) return 0;
    return MIN(kNumLinePoints, [self.lineGraphReadings count]); // Number of points in the graph.
}

- (CGFloat)lineGraph:(BEMSimpleLineGraphView *)graph valueForPointAtIndex:(NSInteger)index {
    if (![self.lineGraphReadings count]) return 0;
    BloodSugar *reading = [self.lineGraphReadings objectAtIndex:index];
    return [reading.bloodReading floatValue]; // The value of the point on the Y-Axis for the index.
}

- (NSInteger)numberOfGapsBetweenLabelsOnLineGraph:(BEMSimpleLineGraphView *)graph {
    return 0; // The number of hidden labels between each displayed label.
}

- (UIColor *)lineGraph:(BEMSimpleLineGraphView *)graph lineColorForIndex:(NSInteger)index {
    return [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0];
}

- (NSString *)lineGraph:(BEMSimpleLineGraphView *)graph labelOnXAxisForIndex:(NSInteger)index {
    if (![self.lineGraphReadings count]) return @"";
    BloodSugar *reading = [self.lineGraphReadings objectAtIndex:index];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"MMM/dd"];
    NSString *dateString = [format stringFromDate:reading.readingTime];
    return [NSString stringWithFormat:@"%@", dateString];
}

- (void)setReadings:(NSArray *)readings{
    _readings = readings;
    NSInteger numReadings = MIN(kNumLinePoints, [readings count]);
    NSArray *smallArray = [readings subarrayWithRange:NSMakeRange(0, numReadings)];
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:[smallArray count]];
    NSEnumerator *enumerator = [smallArray reverseObjectEnumerator];
    for (id element in enumerator) {
        [array addObject:element];
    }
    self.lineGraphReadings = array;
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
        NSLog(@"showing: %@", self.currentlyDisplayedReading);
    }
}



@end