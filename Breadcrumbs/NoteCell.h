//
//  NoteCell.h
//  Breadcrumbs
//
//  Created by Adam Rothman on 5/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Note.h"
#import "NoteCellView.h"

@interface NoteCell : UITableViewCell

@property (nonatomic, assign) Note *note;
@property (nonatomic, readonly) NoteCellView *noteCellView;

@end
