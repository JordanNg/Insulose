//
//  AADataEntryVC.m
//  HBP Monitor
//
//  Created by Jordan Ng on 4/21/14.
//  Copyright (c) 2014 Agency Agency. All rights reserved.
//

#import "AADataEntryVC.h"
#import "BloodSugar.h"

@interface AADataEntryVC () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UITextField *readingTextField;
@property (weak, nonatomic) IBOutlet UITextView *notesTextView;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inputVerticalConstraint;

@property (weak, nonatomic) IBOutlet UILabel *bloodReadingLabel;
@property (weak, nonatomic) IBOutlet UILabel *notesLabel;
@property (strong, nonatomic) id activeInput;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *markerXConstraint;
@property (weak, nonatomic) IBOutlet UIView *scaleFrameView;

@end

@implementation AADataEntryVC

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self registerForKeyboardNotifications];
    
    [self.readingTextField addTarget:self action:@selector(readingTextFieldChanged) forControlEvents:UIControlEventEditingChanged];
    
    [self displayReading:self.currentlyDisplayedReading];
}

- (void)displayReading:(BloodSugar *)reading
{
    if (!reading) return;
    
    self.readingTextField.text = [reading.bloodReading description];
    self.notesTextView.text = [reading.notes description];
    [self.datePicker setDate:reading.readingTime animated:YES];

    [self animateMarker];
}

- (IBAction)cancelMeasurementPressed:(UIButton *)sender {
    
    //swithces back to the Add Measurement Button when cancel button is pressed
    
    //Resets data
//    [self reloadData];
    
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//    [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
    
//    BloodSugar *reading = self.readings[indexPath.row];
//    [self displayReading:reading];
}

- (IBAction)saveButtonPressed:(UIButton *)sender {
    
    [self saveReading];
}

- (void)saveReading {
    
//    if (!self.currentlyDisplayedReading) {
//        self.currentlyDisplayedReading = [BloodSugar createReading:@([self.readingTextField.text intValue])
//                                                       readingTime:self.datePicker.date
//                                                             notes:self.notesTextView.text
//                                              managedObjectContext:self.context];
//    }
//    self.currentlyDisplayedReading.bloodReading = @([self.readingTextField.text intValue]);
//    self.currentlyDisplayedReading.readingTime =self.datePicker.date;
//    self.currentlyDisplayedReading.notes = self.notesTextView.text;
//    
//    [self reloadData];
    
    //Resets data
//    [self reloadData];
    
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//    [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
    
//    BloodSugar *reading = self.readings[indexPath.row];
//    [self displayReading:reading];
    
}

// Call this method somewhere in your view controller setup code.
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    if (self.activeInput == self.notesTextView) {
        self.inputVerticalConstraint.constant = 350.0;
        
        [UIView animateWithDuration:0.25
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             [self.view layoutIfNeeded];
                         }
                         completion:^(BOOL finished) {
                         }];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    if (self.activeInput == self.notesTextView) {
        self.inputVerticalConstraint.constant = 20.0;
        
        
        [UIView animateWithDuration:0.25
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             [self.view layoutIfNeeded];
                         }
                         completion:^(BOOL finished) {
                         }];
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    self.activeInput = textView;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    self.activeInput = nil;
}

-(CGFloat) markerXPosition
{
    
    CGFloat reading = [self.readingTextField.text floatValue];
    
    CGFloat bgMin = 0.0;
    CGFloat bgMax = 208.0;
    CGFloat r = MAX(bgMin, MIN(bgMax, reading));
    
    CGFloat bgRange = bgMax - bgMin;
    CGFloat x = r * self.scaleFrameView.bounds.size.width / bgRange;
    return x;
}

- (void) animateMarker
{
    self.markerXConstraint.constant = [self markerXPosition];
    [UIView animateWithDuration:2.0 delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionAllowAnimatedContent
                     animations:^{
                         [self.scaleFrameView.superview layoutIfNeeded];
                     }
                     completion:nil];
    
}
- (void) readingTextFieldChanged
{
    [self animateMarker];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"])
    {
        [self saveReading];
        
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}


@end
