//
//  NoteTagsViewController.h
//  Breadcrumbs
//
//  Created by Adam Rothman on 6/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataTableViewController.h"
#import "NoteEditorController.h"

@interface NoteTagsViewController : CoreDataTableViewController
@property (nonatomic, assign) id <NoteEditorDelegate> delegate;

- (id)initWithNote:(Note *)aNote;
@end
