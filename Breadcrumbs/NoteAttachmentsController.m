//
//  NoteAttachmentsController.m
//  Breadcrumbs
//
//  Created by Adam Rothman on 5/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NoteAttachmentsController.h"
#import "Attachment_Lifecycle.h"
#import "NSManagedObjectContext_Autosave.h"
#import "ImageViewController.h"

@interface NoteAttachmentsController() <UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (nonatomic, retain) Note *note;
@property (nonatomic, retain) UIActionSheet *mediaSourceActionSheet;
@property (nonatomic, retain) NSDateFormatter *dateFormatter;
@end

@implementation NoteAttachmentsController

@synthesize delegate;
@synthesize view;
@synthesize attachmentsView;
@synthesize attachmentsTableView;
@synthesize fetchedResultsController;

@synthesize note;
@synthesize mediaSourceActionSheet;
@synthesize dateFormatter;

#pragma mark - Designated initializer

- (id)initWithNote:(Note *)aNote {
    if (aNote) {
        self = [super init];
        if (self) {
            NSManagedObjectContext *context = [aNote managedObjectContext];
            
            NSFetchRequest *request = [[NSFetchRequest alloc] init];
            request.entity = [NSEntityDescription entityForName:@"Attachment"
                                         inManagedObjectContext:context];
            request.predicate = [NSPredicate predicateWithFormat:@"owner = %@", aNote];
            request.sortDescriptors = [NSArray arrayWithObject:
                                       [NSSortDescriptor sortDescriptorWithKey:@"added"
                                                                     ascending:YES
                                                                      selector:@selector(compare:)]];
            
            self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                                 managedObjectContext:context
                                                                                   sectionNameKeyPath:nil
                                                                                            cacheName:nil];
            
            self.note = aNote;
        }
    } else {
        self = nil;
    }
    
    return self;
}

#pragma mark - Fetching

- (void)performFetch {
    NSError *error = nil;
    [self.fetchedResultsController performFetch:&error];
    if (error) {
        NSLog(@"error in [NoteAttachmentsController performFetch] %@ (%@)", [error localizedDescription], [error localizedFailureReason]);
    }
    [self.attachmentsTableView reloadData];
}

#pragma mark - Properties

- (UIView *)view {
    if (!attachmentsView) {
        [[NSBundle mainBundle] loadNibNamed:@"NoteAttachments"
                                      owner:self
                                    options:nil];
    }
    [self performFetch];
    return attachmentsView;
}

- (void)setFetchedResultsController:(NSFetchedResultsController *)newFetchedResultsController {
    fetchedResultsController.delegate = nil;
    fetchedResultsController = newFetchedResultsController;
    fetchedResultsController.delegate = self;
    if (self.view.window) [self performFetch];
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

- (NSDateFormatter *)dateFormatter {
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
    }
    return dateFormatter;
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseIdentifier = @"NoteAttachmentsController.AttachmentCell";
    
    Attachment *attachment = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                       reuseIdentifier:reuseIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    if ([attachment.type isEqualToString:(NSString *)kUTTypeImage]) {
        cell.imageView.image = [UIImage imageNamed:@"42-photos"];
    } else if ([attachment.type isEqualToString:(NSString *)kUTTypeMovie]) {
        cell.imageView.image = [UIImage imageNamed:@"46-movie-2"];
    } else {
        // future versions will support audio attachments
        cell.imageView.image = [UIImage imageNamed:@"194-note-2"];
    }
    
    [self.dateFormatter setDateFormat:@"MM/dd/yy"];
    cell.textLabel.text = [self.dateFormatter stringFromDate:attachment.added];
    [self.dateFormatter setDateFormat:@"h:mm a"];
    cell.detailTextLabel.text = [self.dateFormatter stringFromDate:attachment.added];
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return [[[self.fetchedResultsController sections] objectAtIndex:section] numberOfObjects];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView
sectionForSectionIndexTitle:(NSString *)title
               atIndex:(NSInteger)index {
    return [self.fetchedResultsController sectionForSectionIndexTitle:title
                                                              atIndex:index];
}

- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section {
    return [[[self.fetchedResultsController sections] objectAtIndex:section] name];
}

- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Attachment *attachment = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [Attachment removeAttachment:attachment];
    }
}

- (BOOL)tableView:(UITableView *)tableView
canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Attachment *attachment = [self.fetchedResultsController objectAtIndexPath:indexPath];
    NSURL *URL = [NSURL fileURLWithPath:attachment.path isDirectory:NO];
    
    if ([attachment.type isEqualToString:(NSString *)kUTTypeImage]) {
        ImageViewController *ivc = [[ImageViewController alloc] initWithContentURL:URL];
        ivc.delegate = self.delegate;
        [self.dateFormatter setDateFormat:@"MM/dd/yy"];
        NSString *dateString = [self.dateFormatter stringFromDate:attachment.added];
        [self.dateFormatter setDateFormat:@"h:mm a"];
        NSString *timeString = [self.dateFormatter stringFromDate:attachment.added];
        ivc.navigationItem.title = [NSString stringWithFormat:@"%@, %@", dateString, timeString];
        
        UINavigationController *ivnvc = [[UINavigationController alloc] initWithRootViewController:ivc];
        [self.delegate presentModalViewController:ivnvc animated:YES];
    } else if ([attachment.type isEqualToString:(NSString *)kUTTypeMovie]) {
        MPMoviePlayerViewController *mpvc = [[MPMoviePlayerViewController alloc] initWithContentURL:URL];
        [self.delegate presentMoviePlayerViewControllerAnimated:mpvc];
    } else {
        // future versions will support audio attachments
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.attachmentsTableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.attachmentsTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                                             withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [self.attachmentsTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                                             withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeUpdate:
            [self.attachmentsTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                                             withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeMove:
            [self.attachmentsTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                                             withRowAnimation:UITableViewRowAnimationFade];
            [self.attachmentsTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                                             withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex
     forChangeType:(NSFetchedResultsChangeType)type {
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.attachmentsTableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                                     withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [self.attachmentsTableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                                     withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.attachmentsTableView endUpdates];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet
clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet == self.mediaSourceActionSheet && buttonIndex != 2) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        if (buttonIndex == 0 &&
            [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        } else {
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        
        NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:picker.sourceType];
        // NSLog(@"%@", [availableMediaTypes description]);
        
        NSMutableArray *mediaTypes = [NSMutableArray arrayWithCapacity:[availableMediaTypes count]];
        if ([availableMediaTypes containsObject:(NSString *)kUTTypeImage]) {
            [mediaTypes addObject:(NSString *)kUTTypeImage];
        }
        if ([availableMediaTypes containsObject:(NSString *)kUTTypeMovie]) {
            [mediaTypes addObject:(NSString *)kUTTypeMovie];
        }
        if ([mediaTypes count]) {
            picker.mediaTypes = mediaTypes;
            [self.delegate presentModalViewController:picker animated:YES];
        }
    }
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [Attachment attachmentWithInfo:info forNote:self.note];
    [self.delegate dismissModalViewControllerAnimated:YES];
    [self performFetch];
}

#pragma mark - Button actions

- (IBAction)addCameraAttachment:(UIButton *)sender {
    [self.mediaSourceActionSheet showInView:self.view];
}

- (IBAction)addAudioAttachment:(UIButton *)sender {
    // future versions will support audio attachments
}

#pragma mark - Memory management


@end
