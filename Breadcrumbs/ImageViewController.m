//
//  ImageViewController.m
//  Breadcrumbs
//
//  Created by Adam Rothman on 6/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController()
@property (nonatomic, retain) NSURL *contentURL;
@property (nonatomic, retain) UIImageView *imageView;
@end

@implementation ImageViewController

@synthesize delegate;
@synthesize contentURL, imageView;

#pragma mark - Designated initializer

- (id)initWithContentURL:(NSURL *)aContentURL {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.contentURL = aContentURL;
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - Convenience

- (void)scrollView:(UIScrollView *)scrollView
zoomToFitContentsAnimated:(BOOL)animated {
    CGFloat newMinimumZoomScale, newZoomScale;
    
    if (self.interfaceOrientation == UIInterfaceOrientationPortrait ||
        self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {    // vertical device orientation
        if (scrollView.contentSize.width >= scrollView.contentSize.height) {
            newMinimumZoomScale = scrollView.bounds.size.width / scrollView.contentSize.width;
            newZoomScale = scrollView.bounds.size.height / scrollView.contentSize.height;
        } else {
            newMinimumZoomScale = scrollView.bounds.size.height / scrollView.contentSize.height;
            newZoomScale = scrollView.bounds.size.width / scrollView.contentSize.width;
        }
    } else {                                                                        // horizontal device orientation
        if (scrollView.contentSize.width >= scrollView.contentSize.height) {
            newMinimumZoomScale = scrollView.bounds.size.height / scrollView.contentSize.height;
            newZoomScale = scrollView.bounds.size.width / scrollView.contentSize.width;
        } else {
            newMinimumZoomScale = scrollView.bounds.size.width / scrollView.contentSize.width;
            newZoomScale = scrollView.bounds.size.height / scrollView.contentSize.height;
        }
    }
    
    scrollView.minimumZoomScale = newMinimumZoomScale;
    [scrollView setZoomScale:newZoomScale
                    animated:animated];
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

#pragma mark - Button actions

- (void)done:(UIButton *)sender {
    [self.delegate dismissModalViewControllerAnimated:YES];
}

#pragma mark - View lifecycle

- (void)loadView {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                            target:self
                                                                                            action:@selector(done:)];
    
    UIView *loadingView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    loadingView.backgroundColor = [UIColor whiteColor];
    
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner startAnimating];
    
    self.view = loadingView;
    spinner.center = self.view.center;
    [self.view addSubview:spinner];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    dispatch_queue_t imageQueue = dispatch_queue_create("Image loader", NULL);
    dispatch_async(imageQueue, ^{
        UIImage *image = [UIImage imageWithContentsOfFile:[self.contentURL path]];
        self.imageView = [[UIImageView alloc] initWithImage:image];
        
        UIScrollView *scrollView = [[UIScrollView alloc]
                                     initWithFrame:[[UIScreen mainScreen] applicationFrame]];
        [scrollView addSubview:self.imageView];
        scrollView.contentSize = self.imageView.image.size;
        scrollView.maximumZoomScale = 2;
        scrollView.delegate = self;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.view = scrollView;
            [self scrollView:(UIScrollView *)self.view zoomToFitContentsAnimated:NO];
        });
    });
    dispatch_release(imageQueue);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

#pragma mark - Memory management


@end
