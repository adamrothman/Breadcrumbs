//
//  NoteViewController.h
//  Breadcrumbs
//
//  Created by Adam Rothman on 5/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Note.h"

@interface NoteViewController : UIViewController <UIScrollViewDelegate>

@property (nonatomic, retain) Note *note;

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIPageControl *pageControl;

@end
