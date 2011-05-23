//
//  CoreDataTableViewController.m
//  Breadcrumbs
//
//  Created by Adam Rothman on 5/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CoreDataTableViewController.h"

@interface CoreDataTableViewController()

@property (nonatomic, retain) UISearchDisplayController *searchController;
@property (nonatomic, copy) NSString *currentSearch;
@property (nonatomic, retain) NSPredicate *normalPredicate;

@end

@implementation CoreDataTableViewController

@synthesize fetchedResultsController, searchController;
@synthesize searchKey, currentSearch;
@synthesize normalPredicate;
@synthesize sectionIndexTitlesEnabled;

- (void)dealloc {
    fetchedResultsController.delegate = nil;
    [fetchedResultsController release];
    searchController.delegate = nil;
    searchController.searchResultsDelegate = nil;
    searchController.searchResultsDataSource = nil;
    [searchController release];
    [searchKey release];
    [currentSearch release];
    [normalPredicate release];
    [super dealloc];
}

#pragma mark - Fetching

- (void)performFetchForTableView:(UITableView *)tableView {
    NSError *error = nil;
    [self.fetchedResultsController performFetch:&error];
    if (error) {
        NSLog(@"error in [CoreDataTableViewController performFetchForTableView:%@] %@ (%@)", [tableView description], [error localizedDescription], [error localizedFailureReason]);
    }
    [tableView reloadData];
}

- (NSFetchedResultsController *)fetchedResultsControllerForTableView:(UITableView *)tableView {
	if (tableView == self.tableView) {
		if (self.fetchedResultsController.fetchRequest.predicate != self.normalPredicate) {
			[NSFetchedResultsController deleteCacheWithName:self.fetchedResultsController.cacheName];
			self.fetchedResultsController.fetchRequest.predicate = self.normalPredicate;
			[self performFetchForTableView:tableView];
		}
        self.currentSearch = nil;
	} else if ((tableView == self.searchDisplayController.searchResultsTableView) &&
               self.searchKey &&
               ![self.currentSearch isEqualToString:self.searchDisplayController.searchBar.text]) {
		self.currentSearch = self.searchDisplayController.searchBar.text;
        NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@ contains[c] %@", self.searchKey, self.searchDisplayController.searchBar.text]];
        [NSFetchedResultsController deleteCacheWithName:self.fetchedResultsController.cacheName];
		self.fetchedResultsController.fetchRequest.predicate = [NSCompoundPredicate andPredicateWithSubpredicates:[NSArray arrayWithObjects:searchPredicate, self.normalPredicate , nil]];
		[self performFetchForTableView:tableView];
	}
	return self.fetchedResultsController;
}

#pragma mark - Properties

- (void)setSearchController:(UISearchDisplayController *)newSearchController {
    [searchController release];
    searchController = [newSearchController retain];
    
    searchController.searchResultsDelegate = self;
    searchController.searchResultsDataSource = self;
    searchController.delegate = self;
}

- (void)setUpSearchBar {
    if (self.searchKey.length) {
        if (self.tableView && !self.tableView.tableHeaderView) {
            UISearchBar *searchBar = [[[UISearchBar alloc] init] autorelease];
            self.searchController = [[[UISearchDisplayController alloc] initWithSearchBar:searchBar
                                                                       contentsController:self] autorelease];
            [searchBar sizeToFit];
            self.tableView.tableHeaderView = searchBar;
        }
    } else {
        self.tableView.tableHeaderView = nil;
    }
}

- (void)setSearchKey:(NSString *)newKey {
    if (newKey != searchKey) {
        [searchKey release];
        searchKey = [newKey copy];
        [self setUpSearchBar];
    }
}

- (void)setFetchedResultsController:(NSFetchedResultsController *)newFetchedResultsController {
    fetchedResultsController.delegate = nil;
    [fetchedResultsController release];
    fetchedResultsController = [newFetchedResultsController retain];
    fetchedResultsController.delegate = self;
    self.normalPredicate = newFetchedResultsController.fetchRequest.predicate;
    if (!self.title) self.title = newFetchedResultsController.fetchRequest.entity.name;
    if (self.view.window) [self performFetchForTableView:self.tableView];
}

#pragma mark - UISearchDisplayController delegate

- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller {
    [self fetchedResultsControllerForTableView:self.tableView];
}

#pragma mark - Overridable API

/**
 * Configure the cell for each object.
 */
- (UITableViewCell *)tableView:(UITableView *)tableView
          cellForManagedObject:(NSManagedObject *)managedObject { return nil; }

/**
 * Called when an object's cell is selected.
 */
- (void)didSelectManagedObject:(NSManagedObject *)managedObject {}

/**
 * Allow removal of an object's cell from the table?
 */
- (BOOL)canRemoveManagedObject:(NSManagedObject *)managedObject { return NO; }

/**
 * Called when a cell is removed from the table view.
 */
- (void)didRemoveManagedObject:(NSManagedObject *)managedObject {}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self tableView:tableView cellForManagedObject:[[self fetchedResultsControllerForTableView:tableView] objectAtIndexPath:indexPath]];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[[self fetchedResultsControllerForTableView:tableView] sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return [[[[self fetchedResultsControllerForTableView:tableView] sections] objectAtIndex:section] numberOfObjects];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if (self.sectionIndexTitlesEnabled && (tableView == self.tableView)) {
        return [[self fetchedResultsControllerForTableView:tableView] sectionIndexTitles];
    } else return nil;
}

- (NSInteger)tableView:(UITableView *)tableView
sectionForSectionIndexTitle:(NSString *)title
               atIndex:(NSInteger)index {
    return [[self fetchedResultsControllerForTableView:tableView] sectionForSectionIndexTitle:title
                                                                                      atIndex:index];
}

- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section {
    return [[[[self fetchedResultsControllerForTableView:tableView] sections] objectAtIndex:section] name];
}

- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObject *managedObject = [[self fetchedResultsControllerForTableView:tableView] objectAtIndexPath:indexPath];
        [self didRemoveManagedObject:managedObject];
    }
}

- (BOOL)tableView:(UITableView *)tableView
canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.tableView) {  // can not delete from search results table view
        NSManagedObject *managedObject = [[self fetchedResultsControllerForTableView:tableView] objectAtIndexPath:indexPath];
        return [self canRemoveManagedObject:managedObject];
    } else return NO;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self didSelectManagedObject:[[self fetchedResultsControllerForTableView:tableView] objectAtIndexPath:indexPath]];
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                                  withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                                  withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeUpdate:
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                                  withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeMove:
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                                  withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                                  withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex
     forChangeType:(NSFetchedResultsChangeType)type {
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
    if (self.sectionIndexTitlesEnabled) {
        // iOS bug workaround (indexes don't update properly with Core Data changes)
        [self.tableView reloadData];
    }
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpSearchBar];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!self.fetchedResultsController.fetchedObjects) {
        [self performFetchForTableView:self.tableView];
    }
}

@end
