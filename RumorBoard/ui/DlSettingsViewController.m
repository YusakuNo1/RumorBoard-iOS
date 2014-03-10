//
//  DlLogoutViewController.m
//  RumorBoard
//
//  Created by David Wu on 5/03/2014.
//  Copyright (c) 2014 David Wu. All rights reserved.
//

#import "DlSettingsViewController.h"
#import "DlAPIManager.h"
#import "DlConfig.h"


@interface DlSettingsViewController ()

@end

@implementation DlSettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)onLogout:(id)sender {
    [[DlAPIManager sharedManager] logoutWithCallback:^(NSObject *payload, NSError *error) {
        if (!error) {
            [DlConfig sharedConfig].authToken = @"";
            [self onBack:nil];
        }
    }];
}


- (IBAction)onBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)onCreateTestRumors:(id)sender {
    const int LOOP = 1;
    
    NSNumber *mutexLock = [NSNumber numberWithBool:YES];
    __block int counter = LOOP;
    for (int i=0; i<LOOP; ++i) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"title"] = [NSString stringWithFormat:@"rumor %02d", i+10];
        dict[@"content"] = [NSString stringWithFormat:@"rumor %02d content", i+10];
        dict[@"anonymous"] = (rand() % 2) == 0 ? [NSNumber numberWithBool:TRUE] : [NSNumber numberWithBool:FALSE];
        
        [[DlAPIManager sharedManager] createRumor:dict
                                         callback:^(NSObject *payload, NSError *error) {
                                             @synchronized(mutexLock) {
                                                 counter--;
                                                 
                                                 if (counter <= 0) {
                                                     [[[UIAlertView alloc] initWithTitle:nil
                                                                                 message:!error ? @"Rumors created" : @"Failed to create rumor"
                                                                                delegate:nil
                                                                       cancelButtonTitle:@"OK"
                                                                       otherButtonTitles:nil] show];
                                                 }
                                             }
                                         }];
    }
}

@end
