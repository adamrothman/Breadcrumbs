//
//  NoteCellView.m
//  Breadcrumbs
//
//  Created by Adam Rothman on 5/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NoteCellView.h"

@interface NoteCellView()
@property (nonatomic, retain) NSDateFormatter *dateFormatter;
@property (nonatomic, retain) UIColor *dateAndTimeColor;
@end

@implementation NoteCellView

@synthesize note, dateFormatter;
@synthesize highlighted, editing;
@synthesize dateAndTimeColor;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.opaque = YES;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

#pragma mark - Properties

- (void)setNote:(Note *)newNote {
    if (note != newNote) {
        note = newNote;
    }
    // Might be the same note with modified contents.
    [self setNeedsDisplay];
}

- (NSDateFormatter *)dateFormatter {
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
    }
    return dateFormatter;
}

- (void)setHighlighted:(BOOL)lit {
    if (highlighted != lit) {
        highlighted = lit;
        [self setNeedsDisplay];
    }
}

- (void)setEditing:(BOOL)edit {
    if (editing != edit) {
        editing = edit;
        [self setNeedsDisplay];
    }
}

- (UIColor *)dateAndTimeColor {
    if (!dateAndTimeColor) {
        dateAndTimeColor = [UIColor colorWithRed:0.1412
                                            green:0.4392
                                             blue:0.8471
                                            alpha:1.0000];
    }
    return dateAndTimeColor;
}

#pragma mark - Custom drawing

// Lots of hardcoded dimensions, etc in here. Future versions will determine these values in a more elegant way.
- (void)drawRect:(CGRect)rect {
    
#define LEFT_MARGIN         10
#define TOP_MARGIN          5
#define RIGHT_MARGIN        10
#define BOTTOM_MARGIN       5
    
#define DATE_TOP            14
#define TIME_TOP            28
#define PREVIEW_TOP         27
    
#define TITLE_FONT_SIZE     14
#define MIN_TITLE_FONT_SIZE 12
#define DATE_FONT_SIZE      14
#define TIME_FONT_SIZE      10
#define PREVIEW_FONT_SIZE   12
    
#define TEXT_WIDTH          250
#define DATESTAMP_WIDTH     60
#define PREVIEW_HEIGHT      32
    
#define TEXT_WIDTH_EDITING  227
    
    UIColor *titleColor = nil;
    UIFont *titleFont = [UIFont boldSystemFontOfSize:TITLE_FONT_SIZE];
    
    UIColor *dateColor = nil;
    UIFont *dateFont = [UIFont systemFontOfSize:DATE_FONT_SIZE];
    
    UIColor *timeColor = nil;
    UIFont *timeFont = [UIFont systemFontOfSize:TIME_FONT_SIZE];
    
    UIColor *previewColor = nil;
    UIFont *previewFont = [UIFont systemFontOfSize:PREVIEW_FONT_SIZE];
    
    if (!self.isHighlighted) {
        titleColor = [UIColor blackColor];
        dateColor = self.dateAndTimeColor;
        timeColor = self.dateAndTimeColor;
        previewColor = [UIColor darkGrayColor];
        self.backgroundColor = [UIColor whiteColor];
    } else {
        titleColor = [UIColor whiteColor];
        dateColor = [UIColor whiteColor];
        timeColor = [UIColor whiteColor];
        previewColor = [UIColor whiteColor];
    }
    
    CGRect contentRect = self.bounds;
    CGFloat boundsX = contentRect.origin.x;
    CGPoint point;
    
    if (!self.isEditing) {
        CGFloat actualFontSize;
        CGSize size;
        
        // note title
        [titleColor set];
        point = CGPointMake(boundsX + LEFT_MARGIN, TOP_MARGIN);
        [self.note.title drawAtPoint:point
                            forWidth:TEXT_WIDTH
                            withFont:titleFont
                         minFontSize:MIN_TITLE_FONT_SIZE
                      actualFontSize:NULL
                       lineBreakMode:UILineBreakModeTailTruncation
                  baselineAdjustment:UIBaselineAdjustmentAlignBaselines];
        
        // note modification date
        [dateColor set];
        [self.dateFormatter setDateFormat:@"MM/dd/yy"];
        NSString *dateString = [self.dateFormatter stringFromDate:self.note.modified];
        size = [dateString sizeWithFont:dateFont
                            minFontSize:DATE_FONT_SIZE
                         actualFontSize:&actualFontSize
                               forWidth:DATESTAMP_WIDTH
                          lineBreakMode:UILineBreakModeClip];
        
        point = CGPointMake(boundsX + contentRect.size.width - RIGHT_MARGIN - size.width, DATE_TOP);
        [dateString drawAtPoint:point
                       forWidth:DATESTAMP_WIDTH
                       withFont:dateFont
                    minFontSize:actualFontSize
                 actualFontSize:&actualFontSize
                  lineBreakMode:UILineBreakModeClip
             baselineAdjustment:UIBaselineAdjustmentAlignBaselines];
        
        // note modification time
        [self.dateFormatter setDateFormat:@"h:mm a"];
        NSString *timeString = [self.dateFormatter stringFromDate:self.note.modified];
        size = [timeString sizeWithFont:timeFont
                            minFontSize:TIME_FONT_SIZE
                         actualFontSize:&actualFontSize
                               forWidth:DATESTAMP_WIDTH
                          lineBreakMode:UILineBreakModeClip];
        
        point = CGPointMake(boundsX + contentRect.size.width - RIGHT_MARGIN - size.width, TIME_TOP);
        [timeString drawAtPoint:point
                       forWidth:DATESTAMP_WIDTH
                       withFont:timeFont
                    minFontSize:actualFontSize
                 actualFontSize:&actualFontSize
                  lineBreakMode:UILineBreakModeClip
             baselineAdjustment:UIBaselineAdjustmentAlignBaselines];
        
        // preview of body text
        [previewColor set];
        point = CGPointMake(boundsX + LEFT_MARGIN, PREVIEW_TOP);
        [self.note.text drawInRect:CGRectMake(point.x, point.y, TEXT_WIDTH, PREVIEW_HEIGHT)
                          withFont:previewFont
                     lineBreakMode:UILineBreakModeWordWrap
                         alignment:UITextAlignmentLeft];
    } else {
        // note title
        [titleColor set];
        point = CGPointMake(boundsX + LEFT_MARGIN, TOP_MARGIN);
        [self.note.title drawAtPoint:point
                            forWidth:TEXT_WIDTH_EDITING
                            withFont:titleFont
                         minFontSize:MIN_TITLE_FONT_SIZE
                      actualFontSize:NULL
                       lineBreakMode:UILineBreakModeTailTruncation
                  baselineAdjustment:UIBaselineAdjustmentAlignBaselines];
        
        // note body text preview
        [previewColor set];
        point = CGPointMake(boundsX + LEFT_MARGIN, PREVIEW_TOP);
        [self.note.text drawInRect:CGRectMake(point.x, point.y, TEXT_WIDTH_EDITING, PREVIEW_HEIGHT)
                          withFont:previewFont
                     lineBreakMode:UILineBreakModeWordWrap
                         alignment:UITextAlignmentLeft];
    }
}

#pragma mark - Memory management


@end
