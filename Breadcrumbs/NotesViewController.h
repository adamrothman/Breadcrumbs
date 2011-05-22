//
//  NotesViewController.h
//  Breadcrumbs
//
//  Created by Adam Rothman on 5/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreDataTableViewController.h"

@interface NotesViewController : CoreDataTableViewController

@property (nonatomic, assign) IBOutlet UITableViewCell *noteCell;

- (id)initWithStyle:(UITableViewStyle)style
inManagedObjectContext:(NSManagedObjectContext *)context;

@end
