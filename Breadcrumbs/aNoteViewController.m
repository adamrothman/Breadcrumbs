//
//  NoteViewController.m
//  Breadcrumbs
//
//  Created by Adam Rothman on 5/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NoteViewController.h"
#import "AttachmentViewController.h"

@interface NoteViewController()

@property (nonatomic) NSUInteger numberOfPages;
@property (nonatomic, retain) NSMutableArray *pageItems;
@property (nonatomic, retain) NSArray *attachmentsArray;
@property (nonatomic) BOOL pageControlUsed;

- (void)loadScrollViewWithPage:(NSUInteger)page;

@end

@implementation NoteViewController

@synthesize note;
@synthesize titleTextField, attachmentsLabel;
@synthesize scrollView, pageControl;
@synthesize numberOfPages, pageItems, attachmentsArray, pageControlUsed;

- (void)setup {
    self.attachmentsArray = [self.note.attachments sortedArrayUsingDescriptors:[NSArray arrayWithObject:
                                                                                [NSSortDescriptor sortDescriptorWithKey:@"bytes"
                                                                                                              ascending:YES]]];
    // 1 page for text, 1 for each attachment, 1 to add attachment
    self.numberOfPages = [self.attachmentsArray count] + 2;
    NSLog(@"%d", self.numberOfPages);
    
    NSMutableArray *items = [NSMutableArray arrayWithCapacity:self.numberOfPages];
    for (int i = 0; i < self.numberOfPages; i++) {
        [items addObject:[NSNull null]];
    }
    self.pageItems = items;
    
    self.scrollView.pagingEnabled = YES;
    self.scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * [self.note.attachments count],
                                             scrollView.frame.size.height);
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.scrollsToTop = NO;
    self.scrollView.delegate = self;
    
    if (!self.pageControl) NSLog(@"null pagecontrol");
    
    self.pageControl.numberOfPages = self.numberOfPages;
    self.pageControl.currentPage = 0;
    
    [self loadScrollViewWithPage:0];
    [self loadScrollViewWithPage:1];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib {
    [self setup];
}

#pragma mark - Properties

- (void)loadScrollViewWithPage:(NSUInteger)page {
    if (page >= self.numberOfPages)
        return;
    
    id pageItem = [self.pageItems objectAtIndex:page];
    
    if ((NSNull *)pageItem == [NSNull null]) {
        NSLog(@"null item, creating new one");
        
        CGRect frame = self.scrollView.frame;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0;
        
        if (page == 0) {
            UITextView *textView = [[[UITextView alloc] initWithFrame:frame] autorelease];
            textView.text = self.note.text;
            [self.pageItems replaceObjectAtIndex:page
                                      withObject:textView];
            [self.scrollView addSubview:textView];
        } else {
            // initing AttachmentViewController with nil makes it a creator for new attachments
            Attachment *attachment = nil;
            
            if (page < self.numberOfPages - 1)
                attachment = [self.attachmentsArray objectAtIndex:page - 1];
            
            AttachmentViewController *attachmentViewController = [[[AttachmentViewController alloc]
                                                                   initWithAttachment:attachment] autorelease];
            [self.pageItems replaceObjectAtIndex:page
                                      withObject:attachmentViewController];
            
            attachmentViewController.view.frame = frame;
            [self.scrollView addSubview:attachmentViewController.view];
        }
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!self.pageControlUsed) {
        // Switch the indicator when more than 50% of the previous/next page is visible
        CGFloat pageWidth = self.scrollView.frame.size.width;
        int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        self.pageControl.currentPage = page;
        
        // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
        [self loadScrollViewWithPage:page - 1];
        [self loadScrollViewWithPage:page];
        [self loadScrollViewWithPage:page + 1];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.pageControlUsed = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.pageControlUsed = NO;
}

#pragma mark - IBActions

- (IBAction)changePage:(UIPageControl *)sender {
    int page = self.pageControl.currentPage;
	
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    
	// update the scroll view to the appropriate page
    CGRect frame = self.scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [self.scrollView scrollRectToVisible:frame animated:YES];
    
	// Set the boolean used when scrolls originate from the UIPageControl. See scrollViewDidScroll: above.
    self.pageControlUsed = YES;
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.note) {
        self.titleTextField.text = self.note.title;
        self.attachmentsLabel.text = [NSString stringWithFormat:@"%d attachments", [self.attachmentsArray count]];
    }
}

- (void)viewDidUnload {
    self.titleTextField = nil;
    self.attachmentsLabel = nil;
    self.scrollView = nil;
    self.pageControl = nil;
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Memory management

- (void)dealloc {
    [note release];
    [titleTextField release];
    [attachmentsLabel release];
    [scrollView release];
    [pageControl release];
    [pageItems release];
    [attachmentsArray release];
    [super dealloc];
}

@end
