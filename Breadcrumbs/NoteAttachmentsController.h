//
//  NoteAttachmentsController.h
//  Breadcrumbs
//
//  Created by Adam Rothman on 5/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Note.h"

@interface NoteAttachmentsController : NSObject <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate>
@property (nonatomic, assign) UIViewController *delegate;
@property (nonatomic, readonly) UIView *view;
@property (nonatomic, retain) IBOutlet UIView *attachmentsView;
@property (nonatomic, retain) IBOutlet UITableView *attachmentsTableView;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

- (id)initWithNote:(Note *)aNote;
@end
