//
//  TagBrowserViewController.m
//  Breadcrumbs
//
//  Created by Adam Rothman on 6/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TagBrowserViewController.h"
#import "Tag.h"
#import "NSManagedObjectContext_Autosave.h"
#import "NoteBrowserViewController.h"

@implementation TagBrowserViewController

#pragma mark - Designated initializer

- (id)initWithStyle:(UITableViewStyle)style
inManagedObjectContext:(NSManagedObjectContext *)context {
    if (context) {
        self = [super initWithStyle:style];
        if (self) {
            NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
            request.entity = [NSEntityDescription entityForName:@"Tag" inManagedObjectContext:context];
            request.sortDescriptors = [NSArray arrayWithObject:
                                       [NSSortDescriptor sortDescriptorWithKey:@"title"
                                                                     ascending:YES
                                                                      selector:@selector(localizedCaseInsensitiveCompare:)]];
            
            self.fetchedResultsController = [[[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                                 managedObjectContext:context
                                                                                   sectionNameKeyPath:nil
                                                                                            cacheName:nil] autorelease];
        }
    } else {
        [self release];
        self = nil;
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - CoreDataTableViewController customization

- (UITableViewCell *)tableView:(UITableView *)tableView
          cellForManagedObject:(NSManagedObject *)managedObject {
    static NSString *reuseIdentifier = @"TagBrowserViewController.TagCell";
    
    Tag *tag = (Tag *)managedObject;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                       reuseIdentifier:reuseIdentifier] autorelease];
        cell.imageView.image = [UIImage imageNamed:@"14-tag"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = tag.title;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", [tag.notes count]];
    
    return cell;
}

- (void)didSelectManagedObject:(NSManagedObject *)managedObject {
    Tag *tag = (Tag *)managedObject;
    NoteBrowserViewController *nbvc = [[[NoteBrowserViewController alloc] initWithStyle:UITableViewStylePlain
                                                                 inManagedObjectContext:[tag managedObjectContext]
                                                                                 forTag:tag] autorelease];
    [self.navigationController pushViewController:nbvc animated:YES];
}

- (BOOL)canRemoveManagedObject:(NSManagedObject *)managedObject {
    return YES;
}

- (void)didRemoveManagedObject:(NSManagedObject *)managedObject {
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    [context deleteObject:managedObject];
    [NSManagedObjectContext autosave:context];
}

#pragma mark - View lifecycle

- (void)loadView {
    [super loadView];
    
    self.navigationItem.title = @"Tags";
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Memory management

- (void)dealloc {
    [super dealloc];
}

@end
