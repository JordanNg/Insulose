//
//  AALineGraphView.m
//  HBP Monitor
//
//  Created by Kyle Oba on 5/28/14.
//  Copyright (c) 2014 Agency Agency. All rights reserved.
//

#import "AALineGraphView.h"
#import "BloodSugar.h"

static const NSInteger kNumLinePoints = 7;

@interface AALineGraphView () <BEMSimpleLineGraphDelegate>

@end

@implementation AALineGraphView

- (NSInteger)numberOfLinePoints
{
    return kNumLinePoints;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.delegate = self;
        self.enableBezierCurve = NO;
        self.widthLine = 4;
        
        self.colorTop = [UIColor colorWithRed:255.0/255.0 green:223.0/255.0 blue:0.0/255.0 alpha:1.0];
        self.colorBottom = [UIColor colorWithRed:255.0/255.0 green:223.0/255.0 blue:0.0/255.0 alpha:1.0];
        self.colorXaxisLabel = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0];
    }
    return self;
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

@end
