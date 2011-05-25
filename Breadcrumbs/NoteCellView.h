//
//  NoteCellView.h
//  Breadcrumbs
//
//  Created by Adam Rothman on 5/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Note.h"

@interface NoteCellView : UIView

@property (nonatomic, retain) Note *note;
@property (nonatomic, retain) NSDateFormatter *dateFormatter;
@property (nonatomic, getter = isHighlighted) BOOL highlighted;
@property (nonatomic, getter = isEditing) BOOL editing;

@end
