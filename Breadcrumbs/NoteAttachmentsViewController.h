//
//  NoteAttachmentsViewController.h
//  Breadcrumbs
//
//  Created by Adam Rothman on 5/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataTableViewController.h"
#import "Note.h"

@interface NoteAttachmentsViewController : CoreDataTableViewController
- (id)initWithStyle:(UITableViewStyle)style
            andNote:(Note *)note;
@end
