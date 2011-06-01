//
//  NoteEditorController.m
//  Breadcrumbs
//
//  Created by Adam Rothman on 5/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NoteEditorController.h"
#import "NSManagedObjectContext_Autosave.h"
#import "NoteMapViewController.h"

#define SECONDS_PER_DAY 86400

@interface NoteEditorController() <UIActionSheetDelegate>
@property (nonatomic, retain) Note *note;
@property (nonatomic, retain) NSDateFormatter *dateFormatter;
@property (nonatomic, retain) UIActionSheet *deletionActionSheet;
@end

@implementation NoteEditorController

@synthesize delegate;
@synthesize view;

@synthesize editorView;
@synthesize daysAgoLabel, dateLabel, timeLabel;
@synthesize titleTextField, bodyTextView;

@synthesize note;
@synthesize dateFormatter;
@synthesize deletionActionSheet;

/** in view controller
 MyController = [alloc init]
 UIView frontView = controller.view;
 */

#pragma mark - Designated initializer

- (id)initWithNote:(Note *)aNote {
    self = [super init];
    if (self) {
        self.note = aNote;
    }
    return self;
}

#pragma mark - Properties

- (UIView *)view {
    if (!view) {
        [[NSBundle mainBundle] loadNibNamed:@"NoteEditor" owner:self options:nil];
        view = self.editorView;
    }
    return view;
}

- (void)setEditorView:(UIView *)newEditorView {
    [editorView release];
    editorView = [newEditorView retain];
    
    // set up days ago label
    NSString *daysAgo = nil;
    NSInteger daysSinceModified = -1 * [self.note.modified timeIntervalSinceNow] / SECONDS_PER_DAY;
    if (daysSinceModified == 0) {
        daysAgo = @"Today";
    } else if (daysSinceModified == 1) {
        daysAgo = @"Yesterday";
    } else {
        daysAgo = [NSString stringWithFormat:@"%d days ago", daysSinceModified];
    }
    self.daysAgoLabel.text = daysAgo;
    
    // set up date label
    NSString *formatString = [NSDateFormatter dateFormatFromTemplate:@"MMMMd"
                                                             options:0
                                                              locale:[NSLocale currentLocale]];
    [self.dateFormatter setDateFormat:formatString];
    self.dateLabel.text = [self.dateFormatter stringFromDate:self.note.modified];
    
    // set up time label
    formatString = [NSDateFormatter dateFormatFromTemplate:@"h:mma"
                                                   options:0
                                                    locale:[NSLocale currentLocale]];
    [self.dateFormatter setDateFormat:formatString];
    self.timeLabel.text = [self.dateFormatter stringFromDate:self.note.modified];
    
    // fill in note info
    self.titleTextField.text = self.note.title;
    self.bodyTextView.text = self.note.text;
}

- (NSDateFormatter *)dateFormatter {
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
    }
    return dateFormatter;
}

- (UIActionSheet *)deletionActionSheet {
    if (!deletionActionSheet) {
        deletionActionSheet = [[UIActionSheet alloc] initWithTitle:@"Are you sure?"
                                                          delegate:self
                                                 cancelButtonTitle:@"Cancel"
                                            destructiveButtonTitle:@"Delete"
                                                 otherButtonTitles:nil];
    }
    return deletionActionSheet;
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet
clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet == self.deletionActionSheet && buttonIndex == 0) { // delete note
        [self.delegate dismissNoteViewAnimated:YES];
        NSManagedObjectContext *context = [self.note managedObjectContext];
        [context deleteObject:self.note];
        [NSManagedObjectContext autosave:context];
    }
}

#pragma mark - Bottom button actions

- (IBAction)deleteNote:(UIButton *)sender {
    [self.deletionActionSheet showInView:self.view];
}

- (IBAction)showOnMap:(UIButton *)sender {
    NoteMapViewController *nmvc = [[[NoteMapViewController alloc] initWithNote:self.note] autorelease];
    nmvc.delegate = self.delegate;
    [self.delegate displayModally:nmvc animated:YES];
}

- (IBAction)manageTags:(UIButton *)sender {
    NSLog(@"NYE: modal presentation of tag manager");
}

- (IBAction)showAttachments:(UIButton *)sender {
    NSLog(@"NYE: card flip animation to show attachments");
}

#pragma mark - Memory management

- (void)dealloc {
    [view release];
    [editorView release];
    [daysAgoLabel release];
    [dateLabel release];
    [timeLabel release];
    [titleTextField release];
    [bodyTextView release];
    [note release];
    [dateFormatter release];
    [deletionActionSheet release];
    [super dealloc];
}


@end
