//
//  NoteManagerViewController.m
//  Breadcrumbs
//
//  Created by Adam Rothman on 5/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NoteManagerViewController.h"

@interface NoteManagerViewController()
@property (nonatomic, retain) Note *note;
@end

@implementation NoteManagerViewController

@synthesize note;

- (id)initWithNote:(Note *)aNote {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.note = aNote;
    }
    return self;
}

#pragma mark - IBActions

- (IBAction)browseTags:(UIButton *)sender {
    
}

- (IBAction)addPhotoAttachment:(UIButton *)sender {
    // check that this is supported
    
    UIImagePickerController *picker = [[[UIImagePickerController alloc] init] autorelease];
    picker.delegate = self;
    
    NSLog(@"%@", [self.parentViewController class]);
    
    [self presentModalViewController:picker animated:YES];
}

- (IBAction)addVideoAttachment:(UIButton *)sender {
    
}

- (IBAction)addAudioAttachment:(UIButton *)sender {
    
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Memory management

- (void)dealloc {
    [note release];
    [super dealloc];
}

@end
