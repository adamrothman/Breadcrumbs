//
//  NoteBrowserViewController.h
//  Breadcrumbs
//
//  Created by Adam Rothman on 5/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreDataTableViewController.h"

@interface NoteBrowserViewController : CoreDataTableViewController
- (id)initWithStyle:(UITableViewStyle)style
inManagedObjectContext:(NSManagedObjectContext *)context;
@end
