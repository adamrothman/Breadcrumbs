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

@interface NoteViewController : UIViewController <NoteMapDelegate>
@property (nonatomic, retain) IBOutlet UILabel *daysAgoLabel;
@property (nonatomic, retain) IBOutlet UILabel *dateLabel;
@property (nonatomic, retain) IBOutlet UILabel *timeLabel;
@property (nonatomic, retain) IBOutlet UITextField *titleTextField;
@property (nonatomic, retain) IBOutlet UITextView *bodyTextView;

- (id)initWithNote:(Note *)aNote;
@end
