//
//  AALineGraphView.h
//  HBP Monitor
//
//  Created by Kyle Oba on 5/28/14.
//  Copyright (c) 2014 Agency Agency. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BEMSimpleLineGraphView.h"

@interface AALineGraphView : BEMSimpleLineGraphView
@property (strong, nonatomic) NSArray *readings;
@property (nonatomic, assign) NSInteger numberOfLinePoints;
@end
