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

@interface NoteViewController() <UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (nonatomic, retain) Note *note;
@property (nonatomic, retain) NSMutableArray *viewControllers;
@property (nonatomic) NSUInteger currentIndex;
@property (nonatomic, retain) CATransition *swipeRightTransition;
@property (nonatomic, retain) CATransition *swipeLeftTransition;
@property (nonatomic, retain) UIActionSheet *mediaSourceSelector;
@property (nonatomic, retain) UIActionSheet *deletionConfirmer;
@end

@implementation NoteViewController

@synthesize content;
@synthesize note, viewControllers, currentIndex;
@synthesize swipeRightTransition, swipeLeftTransition;
@synthesize mediaSourceSelector, deletionConfirmer;

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

- (NSMutableArray *)viewControllers {
    if (!viewControllers) {
        NoteMapViewController *nmvc = [[[NoteMapViewController alloc] 
                                        initWithNibName:nil bundle:nil] autorelease];
        [viewControllers addObject:nmvc];
        
        NoteEditorViewController *nevc = [[[NoteEditorViewController alloc]
                                           initWithNote:self.note] autorelease];
        nevc.delegate = self;
        [viewControllers addObject:nevc];
        
        NoteAttachmentsViewController *navc = [[[NoteAttachmentsViewController alloc]
                                                initWithStyle:UITableViewStyleGrouped andNote:self.note] autorelease];
        
        viewControllers = [[NSMutableArray alloc] initWithObjects:nmvc, nevc, navc, nil];
    }
    
    return viewControllers;
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

- (UIActionSheet *)mediaSourceSelector {
    if (!mediaSourceSelector) {
        mediaSourceSelector = [[UIActionSheet alloc] initWithTitle:nil
                                                          delegate:self
                                                 cancelButtonTitle:@"Cancel"
                                            destructiveButtonTitle:nil
                                                 otherButtonTitles:@"Take Photo or Video", @"Choose Existing", nil];
    }
    return mediaSourceSelector;
}

- (UIActionSheet *)deletionConfirmer {
    if (!deletionConfirmer) {
        deletionConfirmer = [[UIActionSheet alloc] initWithTitle:@"Are you sure?"
                                                        delegate:self
                                               cancelButtonTitle:@"Cancel"
                                          destructiveButtonTitle:@"Delete"
                                               otherButtonTitles:nil];
    }
    return deletionConfirmer;
}

#pragma mark - Gesture actions

- (void)swipeRight:(UIGestureRecognizer *)gesture {
    if (self.currentIndex >= 1) {
        UIViewController *currentController = [self.viewControllers objectAtIndex:self.currentIndex];
        UIViewController *newController = [self.viewControllers objectAtIndex:self.currentIndex - 1];
        
        [self.content.layer addAnimation:self.swipeRightTransition forKey:nil];
        
        [currentController.view removeFromSuperview];
        [self.content insertSubview:newController.view atIndex:0];
        
        self.currentIndex -= 1;
    }
}

- (void)swipeLeft:(UIGestureRecognizer *)gesture {
    if (self.currentIndex < [self.viewControllers count] - 1) {
        UIViewController *currentController = [self.viewControllers objectAtIndex:self.currentIndex];
        UIViewController *newController = [self.viewControllers objectAtIndex:self.currentIndex + 1];
        
        [self.content.layer addAnimation:self.swipeLeftTransition forKey:nil];
        
        [currentController.view removeFromSuperview];
        [self.content insertSubview:newController.view atIndex:0];
        
        self.currentIndex += 1;
    }
}

#pragma mark - NoteManagerDelegate

- (void)addCameraAttachment {
    [self.mediaSourceSelector showInView:self.view];
}

- (void)addAudioAttachment {
    
}


#pragma mark - NoteMapDelegate

- (void)setRightBarButtonItem:(UIBarButtonItem *)item {
    self.navigationItem.rightBarButtonItem = item;
}

#pragma mark - NoteEditorDelegate

- (void)deleteNote {
    [self.deletionConfirmer showInView:self.view];
    //[self.deletionConfirmer showFromTabBar:self.navigationController.tabBarController.tabBar];
}

- (void)showOnMap {
    [self swipeRight:nil];
}

- (void)manageTags {
    // modal view of tags manager
}

- (void)showAttachments {
    [self swipeLeft:nil];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet
clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet == self.mediaSourceSelector && buttonIndex != 2) {
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
    } else if (actionSheet == self.deletionConfirmer && buttonIndex == 0) {
        [self.navigationController popViewControllerAnimated:YES];
        NSManagedObjectContext *context = [self.note managedObjectContext];
        [context deleteObject:self.note];
        [NSManagedObjectContext autosave:context];
    }
}

#pragma mark - UIImagePickerControllerDelegate

- (void) imagePickerController:(UIImagePickerController *)picker
 didFinishPickingMediaWithInfo:(NSDictionary *)info {
    // done picking an image or video, so attach it to the current note
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = self.note.title;
    
    UIViewController *defaultVC = [self.viewControllers objectAtIndex:1];
    [self.content insertSubview:defaultVC.view atIndex:0];
    self.currentIndex = 1;
    
    UISwipeGestureRecognizer *rightRecognizer = [[[UISwipeGestureRecognizer alloc]
                                                  initWithTarget:self action:@selector(swipeRight:)] autorelease];
    rightRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.content addGestureRecognizer:rightRecognizer];
    
    UISwipeGestureRecognizer *leftRecognizer = [[[UISwipeGestureRecognizer alloc]
                                                 initWithTarget:self action:@selector(swipeLeft:)] autorelease];
    leftRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.content addGestureRecognizer:leftRecognizer];
}

- (void)viewDidUnload {
    self.content = nil;
    
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Memory management

- (void)dealloc {
    [content release];
    [note release];
    [viewControllers release];
    [swipeRightTransition release];
    [swipeLeftTransition release];
    [mediaSourceSelector release];
    [deletionConfirmer release];
    [super dealloc];
}

@end
