//
//  NoteViewController.m
//  Breadcrumbs
//
//  Created by Adam Rothman on 5/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "NoteViewController.h"
#import "NoteMapViewController.h"
#import "NSManagedObjectContext_Autosave.h"

// This are magic numbers, but since the app currently only supports one
// orientation it's OK for now. Future versions will determine these
// values procedurally.
#define TEXTVIEW_EDITING_HEIGHT 119
#define TEXTVIEW_NORMAL_HEIGHT  295

#define SECONDS_PER_DAY         86400

@interface NoteViewController()
@property (nonatomic, retain) Note *note;
@property (nonatomic, retain) NoteEditorController *editor;
@property (nonatomic, retain) NoteAttachmentsController *attachments;
@end

@implementation NoteViewController

@synthesize note;
@synthesize editor, attachments;

- (id)initWithNote:(Note *)aNote {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.note = aNote;
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - Convenience

- (void)registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
}

- (void)saveChanges {
    BOOL needsSave = NO;
    
    if (![self.editor.titleTextField.text isEqualToString:self.note.title]) {
        self.note.title = self.editor.titleTextField.text;
        needsSave = YES;
    }
    if (![self.editor.bodyTextView.text isEqualToString:self.note.text]) {
        self.note.text = self.editor.bodyTextView.text;
        needsSave = YES;
    }
    
    if (needsSave) {
        self.note.modified = [NSDate date];
        [NSManagedObjectContext autosave:[self.note managedObjectContext]];
    }
}

- (void)keyboardWillShow:(NSNotification *)notification {
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                            target:self
                                                                                            action:@selector(doneEditing:)] autorelease];
    
    if (!self.editor.view.isHidden) {
        CGRect newFrame = self.editor.bodyTextView.frame;
        newFrame.size.height = TEXTVIEW_EDITING_HEIGHT;
        
        [UIView animateWithDuration:0.5 animations:^{
            self.editor.bodyTextView.frame = newFrame;
        }];
    }
}

- (void)keyboardDidHide:(NSNotification *)notification {
    [self saveChanges];
    
    self.navigationItem.rightBarButtonItem = nil;
    
    if (!self.editor.view.isHidden) {
        CGRect newFrame = self.editor.bodyTextView.frame;
        newFrame.size.height = TEXTVIEW_NORMAL_HEIGHT;
        
        [UIView animateWithDuration:0.5 animations:^{
            self.editor.bodyTextView.frame = newFrame;
        }];
    }
}

- (void)doneEditing:(UIBarButtonItem *)sender {
    if ([self.editor.titleTextField isFirstResponder]) {
        [self.editor.titleTextField resignFirstResponder];
    } else if ([self.editor.bodyTextView isFirstResponder]) {
        [self.editor.bodyTextView resignFirstResponder];
    }
}

#pragma mark - Properties

- (NoteEditorController *)editor {
    if (!editor) {
        editor = [[NoteEditorController alloc] initWithNote:self.note];
        editor.delegate = self;
    }
    return editor;
}

- (NoteAttachmentsController *)attachments {
    if (!attachments) {
        attachments = [[NoteAttachmentsController alloc] initWithNote:self.note];
        attachments.delegate = self;
    }
    return attachments;
}

#pragma mark - Gesture actions

- (void)swipe:(UISwipeGestureRecognizer *)gesture {
    [self saveChanges];
    
    UIViewAnimationOptions options;
    if (gesture.direction == UISwipeGestureRecognizerDirectionLeft) {
        options = UIViewAnimationOptionTransitionFlipFromRight;
    } else {
        options = UIViewAnimationOptionTransitionFlipFromLeft;
    }
    
    [UIView transitionWithView:self.view
                      duration:0.5
                       options:options
                    animations:^{
                        self.editor.view.hidden = !self.editor.view.hidden;
                        self.attachments.view.hidden = !self.attachments.view.hidden;
                    }
                    completion:nil];
}

#pragma mark - NoteEditorDelegate, NoteAttachmentsDelegate

- (void)dismissNoteViewAnimated:(BOOL)animated {
    [self.navigationController popViewControllerAnimated:animated];
}

- (void)showAttachments {
    [self swipe:nil];
}

- (void)modalDisplay:(UIViewController *)viewController animated:(BOOL)animated {
    [self presentModalViewController:viewController animated:animated];
}

- (void)modalDismiss:(BOOL)animated {
    [self dismissModalViewControllerAnimated:animated];
}

#pragma mark - View lifecycle

- (void)loadView {
    [super loadView];
    
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    
    [self.view addSubview:self.editor.view];
    self.editor.view.frame = self.view.bounds;
    
    [self.view addSubview:self.attachments.view];
    self.attachments.view.frame = self.view.bounds;
    self.attachments.view.hidden = YES;
    
    self.navigationItem.title = self.note.title;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UISwipeGestureRecognizer *rightRecognizer = [[[UISwipeGestureRecognizer alloc]
                                                  initWithTarget:self action:@selector(swipe:)] autorelease];
    rightRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:rightRecognizer];
    
    UISwipeGestureRecognizer *leftRecognizer = [[[UISwipeGestureRecognizer alloc]
                                                 initWithTarget:self action:@selector(swipe:)] autorelease];
    leftRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:leftRecognizer];
    
    [self registerForKeyboardNotifications];
}

- (void)viewDidDisappear:(BOOL)animated {
    [self saveChanges];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Memory management

- (void)dealloc {
    [note release];
    [editor release];
    [attachments release];
    [super dealloc];
}

@end
