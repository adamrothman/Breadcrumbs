//
//  NoteViewController.h
//  Breadcrumbs
//
//  Created by Adam Rothman on 5/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Note.h"

@interface NoteViewController : UIViewController <UIScrollViewDelegate, UITextFieldDelegate, UITextViewDelegate>

@property (nonatomic, retain) IBOutlet UITextField *titleTextField;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;

- (id)initWithNote:(Note *)aNote;

@end
