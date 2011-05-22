//
//  NotesViewController.m
//  Breadcrumbs
//
//  Created by Adam Rothman on 5/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NotesViewController.h"
#import "Note.h"
#import "Attachment_Types.h"

@interface NotesViewController()

@property (nonatomic, retain) UITableView *notes;
@property (nonatomic, retain) UITableView *sortBy;

@end

@implementation NotesViewController

@synthesize noteCell;
@synthesize notes, sortBy;

- (id)initWithStyle:(UITableViewStyle)style
inManagedObjectContext:(NSManagedObjectContext *)context {
    if (context) {
        self = [super initWithStyle:style];
        if (self) {
            NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
            request.entity = [NSEntityDescription entityForName:@"Note"
                                         inManagedObjectContext:context];
            request.sortDescriptors = [NSArray arrayWithObject:
                                       [NSSortDescriptor sortDescriptorWithKey:@"title"
                                                                     ascending:YES
                                                                      selector:@selector(localizedCaseInsensitiveCompare:)]];
            
            self.fetchedResultsController = [[[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                                 managedObjectContext:context
                                                                                   sectionNameKeyPath:nil
                                                                                            cacheName:nil] autorelease];
            
            self.searchKey = @"title";
        }
    } else {
        [self release];
        self = nil;
    }
    
    return self;
}

- (void)configureCell:(UITableViewCell *)cell forMangedObject:(NSManagedObject *)managedObject {
    if ([managedObject isKindOfClass:[Note class]]) {
        Note *note = (Note *)managedObject;
        
        UILabel *title = (UILabel *)[cell viewWithTag:0];
        title.text = note.title;
        
        UILabel *date = (UILabel *)[cell viewWithTag:1];
        NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
        [formatter setDateFormat:@"MM/dd/yy"];
        date.text = [formatter stringFromDate:note.modified];
        
        UILabel *preview = (UILabel *)[cell viewWithTag:2];
        preview.text = note.text;
        
        UIImage *attachmentIcon= (UIImage *)[cell viewWithTag:3];
        if (![note.attachments count]) {
            // no attachments
        } else if ([note.attachments count] == 1) {
            Attachment *attachment = [note.attachments anyObject];
            
            switch ([attachment.type unsignedLongLongValue]) {
                case AttachmentTypePhoto:
                    attachmentIcon = [UIImage imageNamed:@"43-film-roll.png"]; break;
                case AttachmentTypeMovie:
                    attachmentIcon = [UIImage imageNamed:@"45-movie-1.png"]; break;
                case AttachmentTypeAudio:
                    attachmentIcon = [UIImage imageNamed:@"66-microphone.png"]; break;
            }
        } else if ([note.attachments count] > 1) {
            attachmentIcon = [UIImage imageNamed:@"68-paperclip.png"];
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
          cellForManagedObject:(NSManagedObject *)managedObject {
    static NSString *identifier = @"NoteCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        [[NSBundle mainBundle] loadNibNamed:@"NoteCell" owner:self options:nil];
        cell = noteCell;
        self.noteCell = nil;
    }    
    
    [self configureCell:cell forMangedObject:managedObject];
    
    return cell;
}

- (void)didSelectManagedObject:(NSManagedObject *)managedObject {
    // do nothing for now
}

- (BOOL)canRemoveManagedObject:(NSManagedObject *)managedObject {
    return NO;
}

- (void)didRemoveManagedObject:(NSManagedObject *)managedObject {
    // do nothing for now
}

#pragma mark - Organize

-(void)organize:(UIBarButtonItem *)sender {
    // animate a view switch
}

#pragma mark - View lifecycle

- (void)loadView {
    [super loadView];
    
    self.navigationItem.title = @"Notes";
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize
                                                                                           target:self
                                                                                           action:@selector(organize:)] autorelease];
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

@end
