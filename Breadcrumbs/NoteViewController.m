//
//  NoteViewController.m
//  Breadcrumbs
//
//  Created by Adam Rothman on 5/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NoteViewController.h"
#import "AttachmentViewController.h"
#import "NoteManagerViewController.h"
#import "NSManagedObjectContext_Autosave.h"

@interface NoteViewController()
@property (nonatomic, retain) Note *note;
@property (nonatomic, retain) UITextView *textView;
@property (nonatomic, retain) NSArray *attachmentsArray;
@property (nonatomic, retain) NSMutableArray *viewControllers;
@property (nonatomic) NSUInteger numberOfPages;

- (void)loadScrollViewWithPage:(NSUInteger)page;
@end

@implementation NoteViewController

@synthesize note;
@synthesize titleTextField, scrollView;
@synthesize textView, attachmentsArray, viewControllers, numberOfPages;

#pragma mark - Designated initializer

- (id)initWithNote:(Note *)aNote {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.note = aNote;
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)setup {
    self.titleTextField.text = self.note.title;
    self.titleTextField.delegate = self;
    
    self.attachmentsArray = [self.note.attachments sortedArrayUsingDescriptors:
                             [NSArray arrayWithObject:
                              [NSSortDescriptor sortDescriptorWithKey:@"bytes" ascending:YES]]];
    
    self.viewControllers = [NSMutableArray arrayWithCapacity:[self.attachmentsArray count] + 2];
    for (int i = 0; i < [self.attachmentsArray count] + 2; i++) {
        [self.viewControllers addObject:[NSNull null]];
    }
    
    self.numberOfPages = [self.viewControllers count];
    
    // a page is the width of the scroll view
    self.scrollView.pagingEnabled = YES;
    self.scrollView.contentSize = CGSizeMake(scrollView.bounds.size.width * self.numberOfPages,
                                             scrollView.bounds.size.height);
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.directionalLockEnabled = YES;
    self.scrollView.scrollsToTop = NO;
    self.scrollView.delegate = self;
    
    [self loadScrollViewWithPage:0];
    [self loadScrollViewWithPage:1];
    [self loadScrollViewWithPage:2];
    
    CGRect frame = self.scrollView.frame;
    frame.origin.x = frame.size.width;
    frame.origin.y = 0;
    [self.scrollView scrollRectToVisible:frame animated:NO];
}

- (void)loadScrollViewWithPage:(NSUInteger)page {
    if (page < self.numberOfPages) {
        UIView *pageToAdd = nil;
        
        CGRect frame = self.scrollView.bounds;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0;
        
        UIViewController *vc = [self.viewControllers objectAtIndex:page];
        if ((NSNull *)vc == [NSNull null]) {
            if (page == 0) {
                NoteManagerViewController *nmvc = [[[NoteManagerViewController alloc] initWithNote:self.note] autorelease];
                [self.viewControllers replaceObjectAtIndex:page
                                                withObject:nmvc];
                nmvc.view.frame = frame;
                
                pageToAdd = nmvc.view;
            } else if (page == 1 && !self.textView) { // text view
                self.textView = [[[UITextView alloc] initWithFrame:frame] autorelease];
                self.textView.text = self.note.text;
                self.textView.font = [UIFont systemFontOfSize:14];
                self.textView.directionalLockEnabled = YES;
                self.textView.delegate = self;
                
                pageToAdd = self.textView;
            } else {
                AttachmentViewController *avc = [[[AttachmentViewController alloc] initWithAttachment:
                                                  [self.attachmentsArray objectAtIndex:page - 2]] autorelease];
                [self.viewControllers replaceObjectAtIndex:page
                                                withObject:avc];
                avc.view.frame = frame;
                
                pageToAdd = avc.view;
            }
            
            [self.scrollView addSubview:pageToAdd];
        }
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    CGFloat pageWidth = self.scrollView.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
}

#pragma mark - UITextFieldDelegate

#pragma mark - UITextViewDelegate

#pragma mark - Control actions

- (void)save:(UIBarButtonItem *)sender {
    self.note.title = self.titleTextField.text;
    self.note.text = self.textView.text;
    // also save attachments
    
    [NSManagedObjectContext autosave:[self.note managedObjectContext]];
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}

- (void)viewDidUnload {
    self.titleTextField = nil;
    self.scrollView = nil;
    
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Memory management

- (void)dealloc {
    [titleTextField release];
    [scrollView release];
    [textView release];
    [viewControllers release];
    [super dealloc];
}

@end
