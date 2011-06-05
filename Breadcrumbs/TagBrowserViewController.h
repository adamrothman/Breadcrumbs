//
//  TagBrowserViewController.h
//  Breadcrumbs
//
//  Created by Adam Rothman on 6/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataTableViewController.h"

@interface TagBrowserViewController : CoreDataTableViewController
- (id)initWithStyle:(UITableViewStyle)style
inManagedObjectContext:(NSManagedObjectContext *)context;
@end
