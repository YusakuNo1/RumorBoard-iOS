//
//  DlLoginViewController.m
//  RumorBoard
//
//  Created by David Wu on 28/02/2014.
//  Copyright (c) 2014 David Wu. All rights reserved.
//

#import "DlLoginViewController.h"
#import "DlAPIManager.h"
#import "DlConfig.h"


@interface DlLoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation DlLoginViewController

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
    self.emailTextField.text = [DlConfig sharedConfig].username;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onLogin:(id)sender {
    [[DlAPIManager sharedManager] loginWithUsername:self.emailTextField.text
                                           password:self.passwordTextField.text
                                           callback:^(NSObject *payload, NSError *error) {
                                               if (error || ![payload isKindOfClass:[NSDictionary class]]) {
                                                   [[[UIAlertView alloc] initWithTitle:@"Error"
                                                                               message:@"Failed to login"
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"OK"
                                                                     otherButtonTitles:nil] show];
                                               }
                                               else {
//                                                   NSDictionary *dict = (NSDictionary *)payload;
//                                                   [DlConfig sharedConfig].username = self.emailTextField.text;
//                                                   [DlConfig sharedConfig].authToken = [dict objectForKey:@"token"];
                                                   [self.navigationController popViewControllerAnimated:YES];
                                               }
                                           }];
}

- (IBAction)onRegister:(id)sender {
    [[DlAPIManager sharedManager] createUserWithUsername:self.emailTextField.text
                                                password:self.passwordTextField.text
                                                callback:^(NSObject *payload, NSError *error) {
                                                    if (error || ![payload isKindOfClass:[NSDictionary class]]) {
                                                        [[[UIAlertView alloc] initWithTitle:@"Error"
                                                                                    message:@"Failed to create user"
                                                                                   delegate:nil
                                                                          cancelButtonTitle:@"OK"
                                                                          otherButtonTitles:nil] show];
                                                    }

                                                    [self.navigationController popViewControllerAnimated:YES];
                                                }];
}

@end
