//
//  NoteAttachmentsController.h
//  Breadcrumbs
//
//  Created by Adam Rothman on 5/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Note.h"

@protocol NoteAttachmentsDelegate
- (void)modalDisplay:(UIViewController *)viewController animated:(BOOL)animated;
- (void)modalDismiss:(BOOL)animated;
@end

@interface NoteAttachmentsController : NSObject
@property (nonatomic, assign) id <NoteAttachmentsDelegate> delegate;
@property (nonatomic, readonly) UIView *view;
@property (nonatomic, retain) IBOutlet UIView *attachmentsView;
@property (nonatomic, retain) IBOutlet UILabel *attachmentsCount;
@property (nonatomic, retain) IBOutlet UITableView *tableView;

- (id)initWithNote:(Note *)aNote;
@end
