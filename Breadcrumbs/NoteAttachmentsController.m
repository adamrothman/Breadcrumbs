//
//  NoteAttachmentsController.m
//  Breadcrumbs
//
//  Created by Adam Rothman on 5/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <MobileCoreServices/MobileCoreServices.h>
#import "NoteAttachmentsController.h"

@interface NoteAttachmentsController() <UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (nonatomic, retain) Note *note;
@property (nonatomic, retain) UIActionSheet *mediaSourceActionSheet;
@end

@implementation NoteAttachmentsController

@synthesize delegate;
@synthesize view;

@synthesize attachmentsView;
@synthesize attachmentsCount;
@synthesize tableView;

@synthesize note;
@synthesize mediaSourceActionSheet;

#pragma mark - Designated initializer

- (id)initWithNote:(Note *)aNote {
    self = [super init];
    if (self) {
        self.note = aNote;
    }
    return self;
}

#pragma mark - Convenience

- (void)populateViewFields {
    self.attachmentsCount.text = [NSString stringWithFormat:@"%d attachments", [self.note.attachments count]];
}

#pragma mark - Properties

- (UIView *)view {
    if (!attachmentsView) {
        [[NSBundle mainBundle] loadNibNamed:@"NoteAttachments" owner:self options:nil];
    }
    [self populateViewFields];
    return attachmentsView;
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
            [self.delegate modalDisplay:picker animated:YES];
        }
    }
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSLog(@"%@", [info description]);
    NSLog(@"NYE: create new attachment object for selected media");
}

#pragma mark - Button actions

- (IBAction)addCameraAttachment:(UIButton *)sender {
    [self.mediaSourceActionSheet showInView:self.view];
}

- (IBAction)addAudioAttachment:(UIButton *)sender {
    
}

#pragma mark - Memory management

- (void)dealloc {
    [view release];
    [attachmentsView release];
    [attachmentsCount release];
    [note release];
    [super dealloc];
}

@end
