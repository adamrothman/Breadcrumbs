//
//  NoteManagerViewController.m
//  Breadcrumbs
//
//  Created by Adam Rothman on 5/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NoteManagerViewController.h"

@implementation NoteManagerViewController

@synthesize delegate;

#pragma mark - IBActions

- (IBAction)tagsButtonPressed:(UIButton *)sender {
    [self.delegate manageTags];
}

- (IBAction)cameraButtonPressed:(UIButton *)sender {
    [self.delegate addCameraAttachment];
}

- (IBAction)audioButtonPressed:(UIButton *)sender {
    [self.delegate addAudioAttachment];
}

- (IBAction)deleteButtonPressed:(UIButton *)sender {
    [self.delegate deleteNote];
}

#pragma mark - View lifecycle

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
