//
//  CoreDataTableViewController.h
//  Breadcrumbs
//
//  Created by Adam Rothman on 5/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CoreDataTableViewController : UITableViewController <NSFetchedResultsControllerDelegate, UISearchDisplayDelegate>

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, copy) NSString *searchKey;
@property (nonatomic) BOOL sectionIndexTitlesEnabled;

// Configure the cell for each object.
- (UITableViewCell *)tableView:(UITableView *)tableView
          cellForManagedObject:(NSManagedObject *)managedObject;

// Called when an object's cell is selected.
- (void)didSelectManagedObject:(NSManagedObject *)managedObject;
// Allow removal of an object's cell from the table view?
- (BOOL)canRemoveManagedObject:(NSManagedObject *)managedObject;
// Called when an object's cell is removed.
- (void)didRemoveManagedObject:(NSManagedObject *)managedObject;

@end
