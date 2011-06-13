//
//  NewTagViewController.m
//  Breadcrumbs
//
//  Created by Adam Rothman on 6/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NewTagViewController.h"
#import "Tag_Create.h"

@interface NewTagViewController()
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@end

@implementation NewTagViewController

@synthesize delegate, titleTextField;
@synthesize managedObjectContext;

#pragma mark - Designated initializer

- (id)initInManagedObjectContext:(NSManagedObjectContext *)context {
    if (context) {
        self = [super initWithNibName:nil bundle:nil];
        if (self) {
            self.managedObjectContext = context;
        }
    } else {
        self = nil;
    }
    
    return self;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [Tag tagWithTitle:textField.text inManagedObjectContext:self.managedObjectContext];
    [self.delegate dismissModalViewControllerAnimated:YES];
    return YES;
}

#pragma mark - Button actions

- (IBAction)done:(UIButton *)sender {
    [self textFieldShouldReturn:self.titleTextField];
}

- (IBAction)cancel:(UIButton *)sender {
    [self.delegate dismissModalViewControllerAnimated:YES];
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.titleTextField becomeFirstResponder];
}

- (void)viewDidUnload {
    self.titleTextField = nil;
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Memory management


@end
