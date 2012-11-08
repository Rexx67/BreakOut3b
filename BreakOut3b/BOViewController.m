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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Initialize the model of the game
    gameModel = [[BOModel alloc] init];
    
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
        // No more blocks, end the game
        // Remove the last blocks from view
        [gameModel clearScreen];
        // [The model should return a score and update the top ten list]
        int netScore = (int)0.5+gameModel.score/gameModel.timeElapsed;
        NSString *scoreString =[NSString stringWithFormat:@"Score = %d", netScore];
        [self gameOver:scoreString];
        
    }
    
    
}
-(void) gameOver:(NSString *)message
{
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
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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
	[super viewWillDisappear:animated];
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
