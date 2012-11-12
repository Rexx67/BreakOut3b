//
//  BOSettingsTableViewController.m
//  BreakOut3b
//
//  Created by Carl Tengwall on 2012-11-09.
//  Copyright (c) 2012 Carl Tengwall. All rights reserved.
//

#import "BOSettingsTableViewController.h"

@interface BOSettingsTableViewController ()

@end

@implementation BOSettingsTableViewController

@synthesize boNewUserViewController = _boNewUserViewController;
@synthesize users = _users;
@synthesize player = _player;


- (void)setUsers:(NSMutableArray *)users {
    if (!users) NSLog(@"Who is trying to kill users?");
    else _users = users;
}

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
    //_ NSLog(@"viewDidLoad");
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    
    int noOfUsers = [[NSUserDefaults standardUserDefaults] integerForKey:@"noOfUsers"];
    int currentPlayer = [[NSUserDefaults standardUserDefaults] integerForKey:@"currentPlayer"];

    
    //_ NSLog(@"In BOSettingsTableViewController viewDidLoad (1) with noOfUsers=%d and currentPlayer=%d", noOfUsers, currentPlayer);
    if(currentPlayer==-1)
    {
        NSLog(@"This is a cold start");

        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"noOfUsers"];
         noOfUsers = [[NSUserDefaults standardUserDefaults] integerForKey:@"noOfUsers"];
        //_ NSLog(@"In BOSettingsTableViewController viewDidLoad (2) with noOfUsers=%d", noOfUsers);
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self tableView] reloadData];
    
  //  [self.userIdTextField becomeFirstResponder];
  //  self.userIdTextField.delegate = self;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //_ NSLog(@"In BOSettingsTableViewController prepareForSegue:");
    if ([[segue identifier] isEqualToString:@"pushPlay"]) {
         //_ NSLog(@"pushPlay");
         BOViewController *bovc = segue.destinationViewController;
         bovc.users = self.users;
         //Send the user to the Play view
         NSIndexPath *selectedRowIndex = [self.tableView indexPathForSelectedRow];
        
        // Set the selected user 
        [[NSUserDefaults standardUserDefaults] setInteger:selectedRowIndex.row forKey:@"currentPlayer"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
    if ([segue.identifier isEqualToString:@"linkModal"]) {
        //_ NSLog(@"linkModal");
        UINavigationController *navc = segue.destinationViewController;
        
        BONewUserViewController *bonuvc = (BONewUserViewController *)navc.topViewController;
        bonuvc.delegate = self;
        //_ NSLog(@"bonuvc.delegate = %@", bonuvc.delegate);
    }
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //_ NSLog(@"In BOSettingsTableViewController numberOfSectionsInTableView:");
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //_ NSLog(@"In BOSettingsTableViewController numberOfRowsInSection:");
    // Return the number of rows in the section.
    return self.users.count;
}
/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}*/

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //_ NSLog(@"In BOSettingsTableViewController cellForRowAtIndexPath:");
    // Hämta cell
    static NSString *reuseIdentifier = @"BOUserCell";
    BOUserCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    if (!cell) // Lazy allocation
        cell = [[BOUserCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"BOUserCell"];
    
    //_ NSLog(@"cell = %@",cell);
    
    // Hämta data
    BOUser *user = [self.users objectAtIndex:indexPath.row];
    //_ NSLog(@"user = %@, uid = %@, difficulty = %@, score = %@, background = %@",user,user.userId,user.difficulty,user.score, user.backgroundColor);
    
    // Konfigurera cellen
    cell.userIdLabel.text = user.userId;
    cell.scoreLabel.text = [NSString stringWithFormat:@"%@", user.score];
    return cell;
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

- (void)tableView:(UITableView *)tableView commitEditingStyle:
(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //_ NSLog(@"commitEditingStyle:");
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        //[self.links removeObjectAtIndex:indexPath.row];
        NSMutableArray *su = [[NSMutableArray alloc] initWithArray:self.users];
        [su removeObjectAtIndex:indexPath.row];
        self.users = su;
        
        int noOfUsers = [[NSUserDefaults standardUserDefaults] integerForKey:@"noOfUsers"];
        int currentPlayer = [[NSUserDefaults standardUserDefaults] integerForKey:@"currentPlayer"];
        NSArray *oldUsers = [[NSUserDefaults standardUserDefaults] objectForKey:@"users"];
        NSArray *oldDiffs = [[NSUserDefaults standardUserDefaults] objectForKey:@"diffs"];
        NSArray *oldScores = [[NSUserDefaults standardUserDefaults] objectForKey:@"scores"];
        NSArray *oldColors = [[NSUserDefaults standardUserDefaults] objectForKey:@"colors"];
        
        NSMutableArray *tempUsers = [[NSMutableArray alloc] initWithArray:oldUsers];
        NSMutableArray *tempDiffs = [[NSMutableArray alloc] initWithArray:oldDiffs];
        NSMutableArray *tempScores = [[NSMutableArray alloc] initWithArray:oldScores];
        NSMutableArray *tempColors = [[NSMutableArray alloc] initWithArray:oldColors];
        
        
        [tempUsers removeObjectAtIndex:indexPath.row];
        [tempDiffs removeObjectAtIndex:indexPath.row];
        [tempScores removeObjectAtIndex:indexPath.row];
        [tempColors removeObjectAtIndex:indexPath.row];
        
        [[NSUserDefaults standardUserDefaults] setObject:tempUsers forKey:@"users"];
        [[NSUserDefaults standardUserDefaults] setObject:tempDiffs forKey:@"diffs"];
        [[NSUserDefaults standardUserDefaults] setObject:tempScores forKey:@"scores"];
        [[NSUserDefaults standardUserDefaults] setObject:tempColors forKey:@"colors"];
        
        [[NSUserDefaults standardUserDefaults] setInteger:noOfUsers-1 forKey:@"noOfUsers"];
        if (currentPlayer == indexPath.row) {
            currentPlayer = 0;
        } else if (currentPlayer > indexPath.row) {
            currentPlayer = currentPlayer - 1;
        }
        [[NSUserDefaults standardUserDefaults] setInteger:currentPlayer forKey:@"currentPlayer"];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                         withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //_ NSLog(@"didSelectRowAtIndexPath:");
    // Push in in BOViewController
    //[self performSegueWithIdentifier:@"pushPlay" sender:self];

}
- (void)boNewUserViewController:(BONewUserViewController *) sender
                      gotUserId:(NSString *) uid
                  gotDifficulty:(NSNumber *) diff
                          score:(NSNumber *) score
          andGotBackgroundColor:(NSNumber *) bkg 
{
    //_ NSLog(@"In BOSettingsTableViewController boNewUserViewController:");

    NSMutableArray *userArray = [[NSMutableArray alloc] init];
    
    BOUser *newUser = [[BOUser alloc] initWithId:uid difficulty:diff score: score
                           andBackground:bkg];
    [self.users arrayByAddingObject:newUser];
    
    // Save new user for the future
    if (newUser) {
        //_ NSLog(@"newUser");
        NSArray *newUsers = [[[NSUserDefaults standardUserDefaults] objectForKey:@"users"] arrayByAddingObject:uid];
        NSArray *newDiffs = [[[NSUserDefaults standardUserDefaults] objectForKey:@"diffs"] arrayByAddingObject:diff];
        NSArray *newScores = [[[NSUserDefaults standardUserDefaults] objectForKey:@"scores"] arrayByAddingObject:[NSNumber numberWithInt:0]];
        NSArray *newColors = [[[NSUserDefaults standardUserDefaults] objectForKey:@"colors"] arrayByAddingObject:bkg];
        
        int noOfUsers = 1 + [[NSUserDefaults standardUserDefaults] integerForKey:@"noOfUsers"];
    
        NSDictionary *appSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                       [NSNumber numberWithInt:noOfUsers-1], @"currentPlayer"
                                     , [NSNumber numberWithInt:noOfUsers], @"noOfUsers"
                                     , newUsers , @"users"
                                     , newDiffs , @"diffs"
                                     , newScores , @"scores"
                                     , newColors, @"colors"
                                     , nil];
        // Register the new settings
        [[NSUserDefaults standardUserDefaults] registerDefaults:appSettings];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        for (NSInteger i=0; i<newUsers.count;i++) {
            
            NSString *myUid = (NSString *)[newUsers objectAtIndex:i];
            NSNumber *myDiff = (NSNumber *)[newDiffs objectAtIndex:i];
            NSNumber *myScore = (NSNumber *)[newScores objectAtIndex:i];
            NSNumber *myColor = (NSNumber *)[newColors objectAtIndex:i];
            
        
            BOUser *aUser = [[BOUser alloc] initWithId:myUid difficulty:myDiff score: myScore
                                           andBackground:myColor];
            [userArray addObject:aUser];
        }
        
        self.users = [NSArray arrayWithArray:userArray];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    [[self tableView] reloadData];
}

- (void)newScore:(BOViewController *) sender
       withScore: (int) myScore {
       self.users = sender.users;
    NSLog(@"Score=%d",myScore);
    [self dismissViewControllerAnimated:YES completion:nil];
    [[self tableView] reloadData];

    
}

@end
