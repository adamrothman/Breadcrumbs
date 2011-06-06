//
//  NoteCellView.h
//  Breadcrumbs
//
//  Created by Adam Rothman on 5/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Note.h"

@interface NoteCellView : UIView
@property (nonatomic, retain) Note *note;
@property (nonatomic, getter = isHighlighted) BOOL highlighted;
@property (nonatomic, getter = isEditing) BOOL editing;
@end
