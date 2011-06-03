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

- (UITableViewCell *)tableView:(UITableView *)tableView
          cellForManagedObject:(NSManagedObject *)managedObject;
- (void)didSelectManagedObject:(NSManagedObject *)managedObject;
- (BOOL)canRemoveManagedObject:(NSManagedObject *)managedObject;
- (void)didRemoveManagedObject:(NSManagedObject *)managedObject;
@end
