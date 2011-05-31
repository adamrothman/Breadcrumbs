//
//  NoteEditorViewController.m
//  Breadcrumbs
//
//  Created by Adam Rothman on 5/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NoteEditorViewController.h"

#define SECONDS_PER_DAY     86400

@interface NoteEditorViewController()
@property (nonatomic, retain) Note *note;
@property (nonatomic, retain) NSDateFormatter *dateFormatter;
@end

@implementation NoteEditorViewController

@synthesize delegate;
@synthesize daysAgoLabel, dateLabel, timeLabel;
@synthesize titleTextField, bodyTextView;
@synthesize note, dateFormatter;

- (id)initWithNote:(Note *)aNote {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.note = aNote;
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - Properties

- (NSDateFormatter *)dateFormatter {
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
    }
    return dateFormatter;
}

#pragma mark - Button actions

- (IBAction)deleteButtonPressed:(UIButton *)sender {
    [self.delegate deleteNote];
}

- (IBAction)mapButtonPressed:(UIButton *)sender {
    [self.delegate showOnMap];
}

- (IBAction)tagsButtonPressed:(UIButton *)sender {
    [self.delegate manageTags];
}

- (IBAction)attachmentsButtonPressed:(UIButton *)sender {
    [self.delegate showAttachments];
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
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
    
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // set right bar button item back to nothing
    self.navigationItem.rightBarButtonItem = nil;
}

- (void)viewWillDisappear:(BOOL)animated {
    // save state of note
}

- (void)viewDidUnload {
    self.daysAgoLabel = nil;
    self.dateLabel = nil;
    self.timeLabel = nil;
    self.titleTextField = nil;
    self.bodyTextView = nil;
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Memory management

- (void)dealloc {
    [daysAgoLabel release];
    [dateLabel release];
    [timeLabel release];
    [titleTextField release];
    [bodyTextView release];
    [dateFormatter release];
    [note release];
    [super dealloc];
}

@end
