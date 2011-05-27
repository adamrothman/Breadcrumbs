//
//  NoteManagerViewController.h
//  Breadcrumbs
//
//  Created by Adam Rothman on 5/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Note.h"

@interface NoteManagerViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

- (id)initWithNote:(Note *)aNote;

@end
