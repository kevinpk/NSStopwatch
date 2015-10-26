//
//  ViewController.m
//  stopwatch
//
//  Created by Kevin Kelly on 10/25/15.
//  Copyright © 2015 Kevin Kelly. All rights reserved.
//

#import "ViewController.h"

@interface ViewController (){
    NSTimer *clockTicks;
    NSDate *start_date;
    NSDate *pause_date;
    BOOL isRunning;
    BOOL isPaused;
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
    isRunning = FALSE;
    isPaused = false;
}
- (IBAction)startPressed:(id)sender {
    if(!isRunning){
        isPaused = false;
        start_date = [NSDate date];
        [_startStop setTitle:@"Finish" forState:UIControlStateNormal];
        [_startStop setEnabled:false];
        [_pauseResume setTitle:@"Pause" forState:UIControlStateNormal];
        [_pauseResume setEnabled:true];
        if (clockTicks == nil) {
            clockTicks = [NSTimer scheduledTimerWithTimeInterval:1.0/100.0
                                                         target:self
                                                       selector:@selector(updateTimer)
                                                       userInfo:nil
                                                        repeats:YES];
        }
    }else{
        [self showFinalTime];
        [_startStop setTitle:@"Start" forState:UIControlStateNormal];
        [_startStop setEnabled:true];
        [_pauseResume setTitle:@"Pause" forState:UIControlStateNormal];
        [_pauseResume setEnabled:false];
        [clockTicks invalidate];
        clockTicks = nil;
    }
    
    isRunning = !isRunning;
}
- (IBAction)pausePressed:(id)sender {
    if (!isPaused) {
        [_pauseResume setTitle:@"Resume" forState:UIControlStateNormal];
        [_pauseResume setEnabled:true];
        [_startStop setTitle:@"Finish" forState:UIControlStateNormal];
        [_startStop setEnabled:true];
        [clockTicks invalidate];
        clockTicks = nil;
        pause_date = [NSDate date];
    }
    else{
        NSTimeInterval secondsBetween = [pause_date timeIntervalSinceDate:start_date];
        start_date = [NSDate dateWithTimeIntervalSinceNow:(-1)*secondsBetween];
        
        [_pauseResume setTitle:@"Pause" forState:UIControlStateNormal];
        [_pauseResume setEnabled:true];
        [_startStop setTitle:@"Finish" forState:UIControlStateNormal];
        [_startStop setEnabled:false];
        if (clockTicks == nil) {
            clockTicks = [NSTimer scheduledTimerWithTimeInterval:1.0/100.0
                                                         target:self
                                                       selector:@selector(updateTimer)
                                                       userInfo:nil
                                                        repeats:YES];
        }
    }
    
    isPaused = !isPaused;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)updateTimer{
    NSDate *currentDate = [NSDate date];
    NSTimeInterval timeInterval = [currentDate timeIntervalSinceDate:start_date];
    NSDate *timerDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss:SS"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
    NSString *timeString=[dateFormatter stringFromDate:timerDate];
    _secondsLabel.text = timeString;
}

-(void)showFinalTime{
    NSString *finalTime = _secondsLabel.text;
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Stopwatch Done"
                                                                               message: finalTime
                                                                        preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [alertController dismissViewControllerAnimated:YES completion:nil];
                             _secondsLabel.text = @"00:00:00.00";
                         }];
    
    [alertController addAction: ok];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
