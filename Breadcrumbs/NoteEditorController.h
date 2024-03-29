//
//  NoteEditorController.h
//  Breadcrumbs
//
//  Created by Adam Rothman on 5/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Note.h"

@protocol NoteEditorDelegate
- (void)dismissNoteViewAnimated:(BOOL)animated;
- (void)showAttachments;
@end

@interface NoteEditorController : NSObject
@property (nonatomic, assign) UIViewController <NoteEditorDelegate> *delegate;
@property (nonatomic, readonly) UIView *view;
@property (nonatomic, retain) IBOutlet UIView *editorView;
@property (nonatomic, retain) IBOutlet UILabel *daysAgoLabel;
@property (nonatomic, retain) IBOutlet UILabel *dateLabel;
@property (nonatomic, retain) IBOutlet UILabel *timeLabel;
@property (nonatomic, retain) IBOutlet UITextField *titleTextField;
@property (nonatomic, retain) IBOutlet UITextView *bodyTextView;

- (id)initWithNote:(Note *)aNote;
@end
