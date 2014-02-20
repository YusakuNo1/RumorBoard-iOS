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

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[DlAPIManager sharedManager] getRumors:^(NSArray *jsonArray, NSError *error) {
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
        
        self.rumorList = rumorList;
        
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
    
//    // Configure the cell...
//    CGRect frame = cell.frame;
//    frame.size.height = (rand() % 100) + 30;
//    cell.frame = frame;
    cell.rumor = [self.rumorList objectAtIndex:indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return [(DlRumor *)[self.rumorList objectAtIndex:indexPath.row] cellHeight];
    return 300;
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
    // Testing
    [[DlAPIManager sharedManager] getRumors:^(NSArray *jsonArray, NSError *error) {
        int a = 0;
    }];
}

@end
