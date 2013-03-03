//
//  PMDoubleGameViewController.m
//  Pong Madness
//
//  Created by Ludovic Landry on 3/2/13.
//  Copyright (c) 2013 MirageTeam. All rights reserved.
//

#import "PMDoubleGameViewController.h"

@interface PMDoubleGameViewController ()

@end

@implementation PMDoubleGameViewController

@synthesize playerList;

- (id)init {
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithPlayers:(NSArray *)aPlayerList {
    self = [self init];
    if (self) {
        self.playerList = aPlayerList;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", nil)
                                                                             style:UIBarButtonItemStyleBordered
                                                                            target:self action:@selector(close:)];
}

- (IBAction)close:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
