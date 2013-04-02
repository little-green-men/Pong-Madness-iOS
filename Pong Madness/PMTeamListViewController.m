//
//  PMTeamListViewController.m
//  Pong Madness
//
//  Created by Ludovic Landry on 4/1/13.
//  Copyright (c) 2013 MirageTeam. All rights reserved.
//

#import "PMTeamListViewController.h"
#import "PMTeamCreateViewController.h"
#import "PMTeamTableViewCell.h"
#import "PMDocumentManager.h"
#import "PMTeam.h"

@interface PMTeamListViewController () <NSFetchedResultsControllerDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@property (nonatomic, assign) BOOL isInEditMode;

@end

@implementation PMTeamListViewController

static NSString *cellIdentifier = @"TeamCell";

@synthesize tableView;
@synthesize fetchedResultsController;

@synthesize delegate;
@synthesize isInEditMode;

- (id)init {
    self = [super init];
    if (self) {
        self.isInEditMode = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Edit", nil)
                                                                              style:UIBarButtonItemStyleBordered
                                                                             target:self action:@selector(edit:)];
    
    NSError *error;
	if (![self.fetchedResultsController performFetch:&error]) {
		// Update to handle the error appropriately.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	}
    
    UINib *teamTableViewCellNib = [UINib nibWithNibName:@"PMTeamTableViewCell" bundle:nil];
    [self.tableView registerNib:teamTableViewCellNib forCellReuseIdentifier:cellIdentifier];
}

- (void)edit:(id)sender {
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Add", nil)
                                                                             style:UIBarButtonItemStyleBordered
                                                                            target:self action:@selector(add:)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", nil)
                                                                              style:UIBarButtonItemStyleBordered
                                                                             target:self action:@selector(done:)];
    
    self.isInEditMode = YES;
    [self.tableView reloadData];
}

- (void)done:(id)sender {
    
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Edit", nil)
                                                                              style:UIBarButtonItemStyleBordered
                                                                             target:self action:@selector(edit:)];
    
    self.isInEditMode = YES;
    [self.tableView reloadData];
}

- (void)add:(id)sender {
    PMTeamCreateViewController *teamCreateViewController = [[PMTeamCreateViewController alloc] init];
    [teamCreateViewController setContentSizeForViewInPopover:CGSizeMake(320, 240)];
    [self.navigationController pushViewController:teamCreateViewController animated:YES];
}

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (!fetchedResultsController) {
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSManagedObjectContext *managedObjectContext = [PMDocumentManager sharedDocument].managedObjectContext;
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Team" inManagedObjectContext:managedObjectContext];
        [fetchRequest setEntity:entity];
        
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)];
        [fetchRequest setSortDescriptors:@[sortDescriptor]];
        
        //[fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"active == YES"]];
        [fetchRequest setFetchBatchSize:20];
        
        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                            managedObjectContext:managedObjectContext sectionNameKeyPath:nil
                                                                                       cacheName:@"Root"];
        fetchedResultsController.delegate = self;
    }
    return fetchedResultsController;
}

#pragma mark table view delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id<NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PMTeamTableViewCell *teamCell = [aTableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    [self configureCell:teamCell atIndexPath:indexPath];
    return teamCell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    PMTeam *team = [fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = team.name;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PMTeam *team = [fetchedResultsController objectAtIndexPath:indexPath];
    
    if (self.delegate && [delegate respondsToSelector:@selector(teamListViewController:didSelectTeam:)]) {
        [self.delegate teamListViewController:self didSelectTeam:team];
    }
}

#pragma mark fetched results controller delegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
