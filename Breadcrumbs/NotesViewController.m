//
//  NotesViewController.m
//  Breadcrumbs
//
//  Created by Adam Rothman on 5/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "NotesViewController.h"
#import "Note_Create.h"
#import "Attachment_Types.h"

@interface NotesViewController()

@property (nonatomic, retain) UINib *noteCellNib;
@property (nonatomic, retain) UITableView *notes;
@property (nonatomic, retain) UITableView *sortBy;

@end

@implementation NotesViewController

@synthesize notes, sortBy;
@synthesize noteCellNib, noteCell;

#pragma mark - Designated initializer

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

#pragma mark - Memory management

- (void)dealloc {
    [noteCellNib release];
    [notes release];
    [sortBy release];
    [super dealloc];
}

#pragma mark - Properties

- (UINib *)noteCellNib {
    if (!noteCellNib) {
        noteCellNib = [[UINib nibWithNibName:@"NoteCell" bundle:[NSBundle mainBundle]] retain];
    }
    return noteCellNib;
}

#pragma mark - Superclass methods

- (void)configureCell:(UITableViewCell *)cell
      forMangedObject:(NSManagedObject *)managedObject {
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
            attachmentIcon = nil;
        } else if ([note.attachments count] == 1) {
            Attachment *attachment = [note.attachments anyObject];
            
            switch ([attachment.type unsignedLongLongValue]) {
                case AttachmentTypePhoto:
                    attachmentIcon = [UIImage imageNamed:@"43-film-roll"]; break;
                case AttachmentTypeMovie:
                    attachmentIcon = [UIImage imageNamed:@"45-movie-1"]; break;
                case AttachmentTypeAudio:
                    attachmentIcon = [UIImage imageNamed:@"66-microphone"]; break;
            }
        } else if ([note.attachments count] > 1) {
            attachmentIcon = [UIImage imageNamed:@"68-paperclip.png"];
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
          cellForManagedObject:(NSManagedObject *)managedObject {
    static NSString *reuseIdentifier = @"NoteCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        [self.noteCellNib instantiateWithOwner:self options:nil];
        
        cell = self.noteCell;
        self.noteCell = nil;
    }
    
    [self configureCell:cell forMangedObject:managedObject];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64.0f;
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

#pragma mark - Tools

- (int)randomDoubleFrom:(double)low
                     to:(double)high {
    double multiplier = arc4random() / (pow(2, 32) - 1);
    double retVal = low + multiplier * (high - low);
    
    NSLog(@"random double: %g", retVal);
    return retVal;
}

#pragma mark - View lifecycle

- (void)loadView {
    [super loadView];
    
    self.navigationItem.title = @"Notes";
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Sort"
                                                                              style:UIBarButtonItemStyleBordered
                                                                             target:self
                                                                             action:@selector(organize:)] autorelease];
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    for (int i = 0; i < 15; i++) {
        NSMutableDictionary *info = [NSMutableDictionary dictionary];
        [info setObject:[NSString stringWithFormat:@"Note %d", i + 1]
                 forKey:@"title"];
        [info setObject:@"Suspendisse dictum feugiat nisl ut dapibus. Mauris iaculis porttitor posuere. Praesent id metus massa, ut blandit odio. Proin quis tortor orci. Etiam at risus et justo dignissim congue. Donec congue lacinia dui, a porttitor lectus condimentum laoreet. Nunc eu ullamcorper orci. Quisque eget odio ac lectus vestibulum faucibus eget in metus. In pellentesque faucibus vestibulum. Nulla at nulla justo, eget luctus tortor. Nulla facilisi. Duis aliquet egestas purus in blandit. Curabitur vulputate, ligula lacinia scelerisque tempor, lacus lacus ornare ante, ac egestas est urna sit amet arcu. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Sed molestie augue sit amet leo consequat posuere. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Proin vel ante a orci tempus eleifend ut et magna. Lorem."
                 forKey:@"text"];
        [info setObject:[NSDate date]
                 forKey:@"modified"];
        [info setObject:[[[CLLocation alloc] initWithLatitude:[self randomDoubleFrom:-90 to:90]
                                                    longitude:[self randomDoubleFrom:-180 to:180]] autorelease]
                 forKey:@"location"];
        
        [Note noteWithInfo:info inManagedObjectContext:self.fetchedResultsController.managedObjectContext];
    }
}

- (void)viewDidUnload {
    self.noteCellNib = nil;
    self.noteCell = nil;
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

@end
