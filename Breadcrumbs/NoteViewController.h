//
//  NoteViewController.h
//  Breadcrumbs
//
//  Created by Adam Rothman on 5/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Note.h"
#import "NoteMapViewController.h"
#import "NoteManagerViewController.h"
#import "NoteEditorViewController.h"

@interface NoteViewController : UIViewController <NoteMapDelegate, NoteManagerDelegate, NoteEditorDelegate>

@property (nonatomic, retain) IBOutlet UIView *content;

- (id)initWithNote:(Note *)aNote;

@end
