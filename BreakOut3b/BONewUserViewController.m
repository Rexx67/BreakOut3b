//
//  BONewUserViewController.m
//  BreakOut3b
//
//  Created by Carl Tengwall on 2012-11-09.
//  Copyright (c) 2012 Carl Tengwall. All rights reserved.
//

#import "BONewUserViewController.h"

@interface BONewUserViewController () <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *userIdTextField;
@property (strong, nonatomic) IBOutlet UITextField *difficultyTextField;
@property (strong, nonatomic) IBOutlet UITextField *backgroundColorTextField;

@end

@implementation BONewUserViewController

@synthesize userIdTextField = _userIdTextField;
@synthesize difficultyTextField = _difficultyTextField;
@synthesize backgroundColorTextField = _backgroundColorTextField;
@synthesize theUserId = _theUserId;
@synthesize theDifficulty = _theDifficulty;
@synthesize theBackgroundColor = _theBackgroundColor;
@synthesize delegate = _delegate;


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
    //_ NSLog(@"viewWillAppear");
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.userIdTextField becomeFirstResponder];
    self.userIdTextField.delegate = self;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
     //_ NSLog(@"textFieldDidEndEditing:");
    if (self.editing) {
        // UserId entered, continue with Difficulty and Background Color
        if ([textField.placeholder isEqualToString:@"Enter a digit between 1 and 3."]) {
            // Difficulty
            //_ NSLog(@"Difficulty");
            self.theDifficulty = [NSNumber numberWithInt:[textField.text integerValue]];
            
            self.backgroundColorTextField.returnKeyType = UIReturnKeyDone;
            [self.backgroundColorTextField becomeFirstResponder];
            self.backgroundColorTextField.delegate = self;
        }
        else {
            // Background Color
            //_ NSLog(@"Background Color");
            self.theBackgroundColor = [NSNumber numberWithInt:[textField.text integerValue]];
            
            self.editing = NO;
            if (![textField.text length]) {
                //_ NSLog(@"dismissModalViewC");
               [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
            } else {
                //_ NSLog(@"self.delegate newUserViewController: gotUserId: %@ diff: %@ score: %d color: %@",
                //      self.theUserId, self.theDifficulty, 0, self.theBackgroundColor);
                 //_ NSLog(@"self.delegate = %@", self.delegate);
                [self.delegate boNewUserViewController:self
                                         gotUserId:self.theUserId
                                     gotDifficulty:self.theDifficulty
                                             score:[NSNumber numberWithInt:0]
                             andGotBackgroundColor:self.theBackgroundColor];
            }
        }
        
    } else {
        // Handle entry of UserId first
        //_ NSLog(@"UserId");
        self.theUserId = textField.text;
        self.editing = YES;
        
        self.difficultyTextField.returnKeyType = UIReturnKeyDone;
        [self.difficultyTextField becomeFirstResponder];
        self.difficultyTextField.delegate = self;
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //_ NSLog(@"textFieldShouldReturn:");
    if ([textField.text length]) {
        [textField resignFirstResponder];
        return YES;
    } else {
        return NO;
    }
}


@end
