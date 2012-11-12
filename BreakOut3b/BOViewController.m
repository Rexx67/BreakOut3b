//
//  BOViewController.m
//  BreakOut3b
//
//  Created by Carl Tengwall on 2012-11-06.
//  Copyright (c) 2012 Carl Tengwall. All rights reserved.
//

#import "BOViewController.h"

@interface BOViewController () 

@end


@implementation BOViewController

@synthesize users = _users;
@synthesize delegate = _delegate;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initLevel:0];
    
}
-(void) initLevel:(int) lvl {
    gameLevel = lvl;
    int currentPlayer = [[NSUserDefaults standardUserDefaults] integerForKey:@"currentPlayer"];
    //_ NSLog(@"currentPlayer %d", currentPlayer);
    NSArray *currentScores = [[NSUserDefaults standardUserDefaults] objectForKey:@"scores"];
    NSArray *currentColors = [[NSUserDefaults standardUserDefaults] objectForKey:@"colors"];
    color = [[currentColors objectAtIndex:currentPlayer] intValue];
     //_ NSLog(@"color %d", color);
    maxScore = [[currentScores objectAtIndex:currentPlayer] intValue];
         //_ NSLog(@"maxScore %d", maxScore);
    
    // Initialize the model of the game
    gameModel = [[BOModel alloc] initWithLevel: lvl];
    
    // Draw the Moving Object
    mo = [[UIImageView alloc] initWithImage:
          [UIImage imageNamed:@"mo.png"]];
    
    [mo setFrame:gameModel.moSquare];
    [self.view addSubview:mo];
    
    // Draw the Paddel
    paddel = [[UIImageView alloc] initWithImage:
              [UIImage imageNamed:@"paddel.png"]];
    
    [paddel setFrame:gameModel.paddelRect];
    [self.view addSubview:paddel];

    
    // Iterate over the blocks in the model, drawing them
    for (BOBlockView* bobv in gameModel.blocks) {
        //	Add the block to the array
        [self.view addSubview:bobv];
    }
    
    switch (color)
    
    {
        case WHITE_BKGCOLOR:
            realColor = [UIColor whiteColor];
            break;
        case LIGHTGRAY_BKGCOLOR:
            realColor = [UIColor lightGrayColor];
            break;
        case GRAY_BKGCOLOR:
            realColor = [UIColor grayColor];
            break;
        case YELLOW_BKGCOLOR:
            realColor = [UIColor yellowColor];
            break;
        default:
            realColor = [UIColor whiteColor];
        break;
    }

     [self.view setBackgroundColor:realColor];  // Set user specific background color
    
    
       
    
    
    // Set up the CADisplayLink for the animation
    gameTimer = [CADisplayLink displayLinkWithTarget:self
                                            selector:@selector(gameLoop:)];
    
    
    // Add the display link to the current run loop
    [gameTimer addToRunLoop:[NSRunLoop currentRunLoop]
                    forMode:NSDefaultRunLoopMode];
    
    
}

-(void) gameLoop:(CADisplayLink*)sender
{
    // This method is called by the gameTimer each time the display should
    // update
    
    // Update the model
    [gameModel updateModelWithTime:sender.timestamp];
    
    // Update the display
    [mo setFrame:gameModel.moSquare];
    [paddel setFrame:gameModel.paddelRect];
    
    if ([gameModel.blocks count] == 0)
    {
        // No more blocks, end the game on the current level
        // Remove the last blocks from view
        [gameModel clearScreen];
        
        // [The model should return a score and update the top ten list]
        
        NSString *scoreString =[NSString stringWithFormat:@"Score = %d", gameModel.netScore];
        //_ NSLog(@"scoreString=%@", scoreString);
        if (gameLevel<1) [self levelOver:scoreString];
        else [self gameOver:scoreString];
        
    }
    
    
}

-(void) levelOver:(NSString *)message
{
    //_ NSLog(@"BOViewController levelOver");
    // Call this method to end the game
    // Invalidate the timer
    [gameTimer invalidate];
    
    // Show an alert with the results
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Level Over"
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles: nil];
    [alert show];
    for (UIView *view in self.view.subviews) {
        [view removeFromSuperview];
    }
    //[NSThread sleepForTimeInterval:1.0];
    [gameModel resetModel:0 color:1];
    [self initLevel:1];
    
}
-(void) gameOver:(NSString *)message
{
    //_ NSLog(@"BOViewController gameOver");
    // Call this method to end the game
    // Invalidate the timer
    [gameTimer invalidate];
    
    // Show an alert with the results
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Game Over"
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles: nil];
    [alert show];
    for (UIView *view in self.view.subviews) {
        [view removeFromSuperview];
    }
    [gameModel resetModel:0 color:1];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    for (UIView *view in self.view.subviews) {
        [view removeFromSuperview];
    }
    //_ NSLog(@"BOViewController viewDidUmload");
   [gameTimer invalidate];
   [gameModel resetModel:0 color:1];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	 //_ NSLog(@"BOViewController viewWillDisappear");
    [super viewWillDisappear:animated];
    [gameTimer invalidate];
    [gameModel resetModel:0 color:1];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Iterate over all touches
    for (UITouch* t in touches)
    {
        CGFloat delta = [t locationInView:self.view].x -
        [t previousLocationInView:self.view].x;
        
        CGRect newPaddelRect = gameModel.paddelRect;
        newPaddelRect.origin.x += delta;
        gameModel.paddelRect = newPaddelRect;
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
