//
//  NoteManagerViewController.h
//  Breadcrumbs
//
//  Created by Adam Rothman on 5/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Note.h"

@protocol NoteManagerDelegate
- (void)manageTags;
- (void)addCameraAttachment;
- (void)addAudioAttachment;
- (void)deleteNote;
@end

@interface NoteManagerViewController : UIViewController

@property (nonatomic, assign) id <NoteManagerDelegate> delegate;

@end
