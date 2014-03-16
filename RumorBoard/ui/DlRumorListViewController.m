//
//  DlRumorListViewController.m
//  RumorBoard
//
//  Created by David Wu on 19/02/2014.
//  Copyright (c) 2014 David Wu. All rights reserved.
//

#import "DlRumorListViewController.h"
#import "DlRumorCell.h"
#import "DlRumor.h"
#import "DlAPIManager.h"
#import "DlConfig.h"
#import "DlLoginViewController.h"
#import "RNBlurModalView.h"
#import "SVProgressHUD.h"



@interface DlRumorListViewController ()

@property (nonatomic, strong) NSArray *rumorList;

@end

@implementation DlRumorListViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Generate fake rumors
    NSMutableArray *rumorList = [[NSMutableArray alloc] init];
//    for (int i=0; i<20; ++i) {
//        DlRumor *rumor = [[DlRumor alloc] init];
//        rumor.title = [@"Name " stringByAppendingFormat:@"%02d", i];
////        rumor.cellHeight = (rand() % 300) + 160;
//        [rumorList addObject:rumor];
//    }
    self.rumorList = rumorList;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([DlConfig sharedConfig].authToken.length == 0) {
//        DlLoginViewController *vc = [[DlLoginViewController alloc] init];
        DlLoginViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"DlLoginViewController"];
        [self.navigationController pushViewController:vc animated:YES];
    }
//    else {
//        [SVProgressHUD show];
//        
//        [DlAPIManager sharedManager]
//    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self refresh];
}

- (void)refresh {
    [[DlAPIManager sharedManager] getRumors:^(NSObject *payload, NSError *error) {
        if (![payload isKindOfClass:[NSArray class]]) {
            return;
        }
        
        NSArray *jsonArray = (NSArray *)payload;
        NSMutableArray *rumorList = [[NSMutableArray alloc] init];
        
        for (NSDictionary *dict in jsonArray) {
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict
                                                               options:NSJSONWritingPrettyPrinted
                                                                 error:nil];
            
            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            
            DlRumor *rumor = [[DlRumor alloc] initWithString:jsonString error:nil];
            if (rumor != nil) {
                [rumorList addObject:rumor];
            }
        }
        
        self.rumorList = [rumorList sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            DlRumor *rumor1 = obj1;
            DlRumor *rumor2 = obj2;
            return [rumor2.updated_at compare:rumor1.updated_at];
        }];
        
        [self.tableView reloadData];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 0;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.rumorList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"DlRumorCell";
    DlRumorCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.rumor = [self.rumorList objectAtIndex:indexPath.row];
//    [cell.commentsButton bk_addEventHandler:^(id sender) {
//        cell.rumor.expended = !cell.rumor.expended;
//        
//        [self.tableView beginUpdates];
//        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
//        [self.tableView endUpdates];
//                            }
//                           forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return [(DlRumor *)[self.rumorList objectAtIndex:indexPath.row] cellHeight];
    DlRumor *rumor = [self.rumorList objectAtIndex:indexPath.row];
//    DlRumorCell *cell = (DlRumorCell *)[tableView cellForRowAtIndexPath:indexPath];
//    return [rumor cellHeightWithFont:cell.rumorFont maxLines:cell.maxRumorLines width:cell.rumorWidth];
    return [rumor cellHeight];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

- (IBAction)onSettings:(id)sender {
//    // Testing
//    [[DlAPIManager sharedManager] getRumors:^(NSArray *jsonArray, NSError *error) {
//        int a = 0;
//    }];
    [self refresh];
}

- (IBAction)onAddRumor:(id)sender {
//    self.tableView.scrollEnabled = FALSE;
//    RNBlurModalView *modal = [[RNBlurModalView alloc] initWithViewController:self title:@"Hello world!" message:@"Pur your message here."];
//    [modal show];
}

@end
