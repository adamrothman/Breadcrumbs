//
//  NoteViewController.m
//  Breadcrumbs
//
//  Created by Adam Rothman on 5/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <MobileCoreServices/MobileCoreServices.h>
#import <QuartzCore/QuartzCore.h>
#import "NoteViewController.h"
#import "NoteMapViewController.h"
#import "NoteEditorViewController.h"
#import "NoteAttachmentsViewController.h"
#import "Attachment_Create.h"
#import "NSManagedObjectContext_Autosave.h"

#define SECONDS_PER_DAY 86400

@interface NoteViewController() <UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (nonatomic, retain) Note *note;
@property (nonatomic, retain) NSDateFormatter *dateFormatter;
@property (nonatomic, retain) UIActionSheet *mediaSourceActionSheet;
@property (nonatomic, retain) UIActionSheet *deletionActionSheet;
@property (nonatomic, retain) CATransition *swipeRightTransition;
@property (nonatomic, retain) CATransition *swipeLeftTransition;
@end

@implementation NoteViewController

@synthesize daysAgoLabel, dateLabel, timeLabel, titleTextField, bodyTextView;
@synthesize note, dateFormatter;
@synthesize mediaSourceActionSheet, deletionActionSheet;
@synthesize swipeRightTransition, swipeLeftTransition;

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

#pragma mark - Properties

- (NSDateFormatter *)dateFormatter {
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
    }
    return dateFormatter;
}

- (UIActionSheet *)mediaSourceActionSheet {
    if (!mediaSourceActionSheet) {
        mediaSourceActionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Take Photo or Video", @"Choose Existing", nil];
    }
    return mediaSourceActionSheet;
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

- (CATransition *)swipeRightTransition{
    if (!swipeRightTransition) {
        swipeRightTransition = [[CATransition animation] retain];
        swipeRightTransition.type = kCATransitionPush;
        swipeRightTransition.subtype = kCATransitionFromLeft;
        swipeRightTransition.duration = 0.2;
        swipeRightTransition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    }
    return swipeRightTransition;
}

- (CATransition *)swipeLeftTransition {
    if (!swipeLeftTransition) {
        swipeLeftTransition = [[CATransition animation] retain];
        swipeLeftTransition.type = kCATransitionPush;
        swipeLeftTransition.subtype = kCATransitionFromRight;
        swipeLeftTransition.duration = 0.2;
        swipeLeftTransition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    }
    return swipeLeftTransition;
}

#pragma mark - Gesture actions

- (void)swipeRight:(UIGestureRecognizer *)gesture {
//    if (self.currentIndex >= 1) {
//        UIViewController *currentController = [self.viewControllers objectAtIndex:self.currentIndex];
//        UIViewController *newController = [self.viewControllers objectAtIndex:self.currentIndex - 1];
//        
//        [self.content.layer addAnimation:self.swipeRightTransition forKey:nil];
//        
//        [currentController.view removeFromSuperview];
//        [self.content insertSubview:newController.view atIndex:0];
//        
//        self.currentIndex -= 1;
//    }
}

- (void)swipeLeft:(UIGestureRecognizer *)gesture {
//    if (self.currentIndex < [self.viewControllers count] - 1) {
//        UIViewController *currentController = [self.viewControllers objectAtIndex:self.currentIndex];
//        UIViewController *newController = [self.viewControllers objectAtIndex:self.currentIndex + 1];
//        
//        [self.content.layer addAnimation:self.swipeLeftTransition forKey:nil];
//        
//        [currentController.view removeFromSuperview];
//        [self.content insertSubview:newController.view atIndex:0];
//        
//        self.currentIndex += 1;
//    }
}

#pragma mark - NoteManagerDelegate

- (void)addCameraAttachment {
    [self.mediaSourceActionSheet showInView:self.view];
}

- (void)addAudioAttachment {
    NSLog(@"NYE: recorded audio attachments");
}

#pragma mark - NoteMapDelegate

- (void)dismissMap:(BOOL)animated {
    [self dismissModalViewControllerAnimated:animated];
}

#pragma mark - Bottom button actions

- (IBAction)deleteNote:(UIButton *)sender {
    [self.deletionActionSheet showInView:self.view];
}

- (IBAction)showOnMap:(UIButton *)sender {
    NoteMapViewController *nmvc = [[[NoteMapViewController alloc] initWithNote:self.note] autorelease];
    nmvc.delegate = self;
    [self presentModalViewController:nmvc animated:YES];
}

- (IBAction)manageTags:(UIButton *)sender {
    NSLog(@"NYE: modal presentation of tag manager");
}

- (IBAction)showAttachments:(UIButton *)sender {
    NSLog(@"NYE: card flip animation to show attachments");
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet
clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet == self.mediaSourceActionSheet && buttonIndex != 2) {
        UIImagePickerController *picker = [[[UIImagePickerController alloc] init] autorelease];
        picker.delegate = self;
        if (buttonIndex == 0 &&
            [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        } else {
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        
        NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:picker.sourceType];
        NSLog(@"%@", [availableMediaTypes description]);
        NSMutableArray *mediaTypes = [NSMutableArray arrayWithCapacity:[availableMediaTypes count]];
        if ([availableMediaTypes containsObject:(NSString *)kUTTypeImage]) {
            [mediaTypes addObject:(NSString *)kUTTypeImage];
        }
        if ([availableMediaTypes containsObject:(NSString *)kUTTypeMovie]) {
            [mediaTypes addObject:(NSString *)kUTTypeMovie];
        }
        if ([mediaTypes count]) {
            picker.mediaTypes = mediaTypes;
            [self presentModalViewController:picker animated:YES];
        }
    } else if (actionSheet == self.deletionActionSheet && buttonIndex == 0) {
        [self.navigationController popViewControllerAnimated:YES];
        NSManagedObjectContext *context = [self.note managedObjectContext];
        [context deleteObject:self.note];
        [NSManagedObjectContext autosave:context];
    }
}

#pragma mark - UIImagePickerControllerDelegate

- (void) imagePickerController:(UIImagePickerController *)picker
 didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSLog(@"NYE: create new attachment object for selected media");
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = self.note.title;
    
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
    
    UISwipeGestureRecognizer *rightRecognizer = [[[UISwipeGestureRecognizer alloc]
                                                  initWithTarget:self action:@selector(swipeRight:)] autorelease];
    rightRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:rightRecognizer];
    
    UISwipeGestureRecognizer *leftRecognizer = [[[UISwipeGestureRecognizer alloc]
                                                 initWithTarget:self action:@selector(swipeLeft:)] autorelease];
    leftRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:leftRecognizer];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // save state
    BOOL needsSave = NO;
    
    if (![self.titleTextField.text isEqualToString:self.note.title]) {
        self.note.title = self.titleTextField.text;
    }
    if (![self.bodyTextView.text isEqualToString:self.note.text]) {
        self.note.text = self.bodyTextView.text;
    }
    
    if (needsSave) {
        self.note.modified = [NSDate date];
        [NSManagedObjectContext autosave:[self.note managedObjectContext]];
    }
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
    [note release];
    [mediaSourceActionSheet release];
    [deletionActionSheet release];
    [swipeRightTransition release];
    [swipeLeftTransition release];
    [super dealloc];
}

@end
