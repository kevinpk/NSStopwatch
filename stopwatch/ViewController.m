//
//  ViewController.m
//  stopwatch
//
//  Created by Kevin Kelly on 10/25/15.
//  Copyright © 2015 Kevin Kelly. All rights reserved.
//

#import "ViewController.h"

@interface ViewController (){
    NSTimer *stopTimer;
    NSDate *startDate;
    NSDate *pauseDate;
    NSTimeInterval secondsBetween;
    BOOL running;
    BOOL paused;
}
@property (weak, nonatomic) IBOutlet UILabel *secondsLabel;
@property (weak, nonatomic) IBOutlet UIButton *startStop;
@property (weak, nonatomic) IBOutlet UIButton *pauseResume;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [_startStop setTitle:@"Start" forState:UIControlStateNormal];
    [_startStop setEnabled:true];
    [_pauseResume setTitle:@"Pause" forState:UIControlStateNormal];
    [_pauseResume setEnabled:false];
    _secondsLabel.text = @"00:00:00.00";
    running = FALSE;
    paused = false;
}
- (IBAction)startPressed:(id)sender {
    if(!running){
        startDate = [NSDate date];
        running = TRUE;
        paused = false;
        [_startStop setTitle:@"Finish" forState:UIControlStateNormal];
        [_startStop setEnabled:false];
        [_pauseResume setTitle:@"Pause" forState:UIControlStateNormal];
        [_pauseResume setEnabled:true];
        if (stopTimer == nil) {
            stopTimer = [NSTimer scheduledTimerWithTimeInterval:1.0/100.0
                                                         target:self
                                                       selector:@selector(updateTimer)
                                                       userInfo:nil
                                                        repeats:YES];
        }
    }else{
        running = FALSE;
        [_startStop setTitle:@"Start" forState:UIControlStateNormal];
        [_startStop setEnabled:true];
        [_pauseResume setTitle:@"Pause" forState:UIControlStateNormal];
        [_pauseResume setEnabled:false];
        [stopTimer invalidate];
        stopTimer = nil;
    }
}
- (IBAction)pausePressed:(id)sender {
    if (!paused) {
        paused = true;
        [_pauseResume setTitle:@"Resume" forState:UIControlStateNormal];
        [_pauseResume setEnabled:true];
        [_startStop setTitle:@"Finish" forState:UIControlStateNormal];
        [_startStop setEnabled:true];
        [stopTimer invalidate];
        stopTimer = nil;
        pauseDate = [NSDate date];
    }
    else{
        secondsBetween = [pauseDate timeIntervalSinceDate:startDate];
        startDate = [NSDate dateWithTimeIntervalSinceNow:(-1)*secondsBetween];
        
        [_pauseResume setTitle:@"Pause" forState:UIControlStateNormal];
        [_pauseResume setEnabled:true];
        [_startStop setTitle:@"Finish" forState:UIControlStateNormal];
        [_startStop setEnabled:false];
        paused = false;
        if (stopTimer == nil) {
            stopTimer = [NSTimer scheduledTimerWithTimeInterval:1.0/100.0
                                                         target:self
                                                       selector:@selector(updateTimer)
                                                       userInfo:nil
                                                        repeats:YES];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)updateTimer{
    NSDate *currentDate = [NSDate date];
    NSTimeInterval timeInterval = [currentDate timeIntervalSinceDate:startDate];
    NSDate *timerDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss:SS"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
    NSString *timeString=[dateFormatter stringFromDate:timerDate];
    _secondsLabel.text = timeString;
}

@end
