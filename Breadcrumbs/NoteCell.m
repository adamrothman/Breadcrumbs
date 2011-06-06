//
//  NoteCell.m
//  Breadcrumbs
//
//  Created by Adam Rothman on 5/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NoteCell.h"

@implementation NoteCell

@synthesize noteCellView;

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGRect cellViewFrame = CGRectMake(0, 0, self.contentView.bounds.size.width, self.contentView.bounds.size.height);
        noteCellView = [[NoteCellView alloc] initWithFrame:cellViewFrame];
        self.noteCellView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.contentView addSubview:self.noteCellView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected
           animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

#pragma mark - Properties

- (Note *)note {
    return self.noteCellView.note;
}

- (void)setNote:(Note *)newNote {
    self.noteCellView.note = newNote;
}

- (void)redisplay {
    [self.noteCellView setNeedsDisplay];
}

- (void)willTransitionToState:(UITableViewCellStateMask)state {
    [super willTransitionToState:state];
    
    if (state == UITableViewCellStateDefaultMask) {
        self.noteCellView.editing = NO;
    } else if (state == UITableViewCellStateShowingDeleteConfirmationMask) {
        self.noteCellView.editing = YES;
    }
}

#pragma mark - Memory management

- (void)dealloc {
    [noteCellView release];
    [super dealloc];
}

@end
