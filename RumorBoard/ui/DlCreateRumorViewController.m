//
//  DlCreateRumorViewController.m
//  RumorBoard
//
//  Created by David Wu on 10/03/2014.
//  Copyright (c) 2014 David Wu. All rights reserved.
//

#import "DlCreateRumorViewController.h"
#import "DlAPIManager.h"
#import "DlConfig.h"


@interface DlCreateRumorViewController ()

@property (weak, nonatomic) IBOutlet UITextField *rumorTitleTextField;
@property (weak, nonatomic) IBOutlet UITextView *rumorContentTextView;
@property (weak, nonatomic) IBOutlet UISwitch *isAnonymousSwitch;

@end

@implementation DlCreateRumorViewController

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

- (IBAction)onSubmit:(id)sender {
    if (self.rumorTitleTextField.text.length == 0 || self.rumorTitleTextField.text.length == 0) {
        [[[UIAlertView alloc] initWithTitle:nil message:@"Please input title & content" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        return;
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"title"] = self.rumorTitleTextField.text;
    dict[@"content"] = self.rumorContentTextView.text;
    dict[@"anonymous"] = [NSNumber numberWithBool:self.isAnonymousSwitch.isOn ? YES : NO];
    
    [[DlAPIManager sharedManager] createRumor:dict
                                     callback:^(NSObject *payload, NSError *error) {
                                         NSString *message = !error ? @"Rumors created" : @"Failed to create rumor";
                                         UIAlertView *alert = [UIAlertView bk_alertViewWithTitle:nil message:message];
                                         [alert bk_setCancelButtonWithTitle:@"OK" handler:^{
                                             if (!error) {
                                                 [self.navigationController popViewControllerAnimated:YES];
                                             }
                                         }];
                                         [alert show];
                                     }];
}

@end
