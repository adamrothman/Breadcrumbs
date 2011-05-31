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
        [note release];
        note = [newNote retain];
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

- (UIColor *)dateAndTimeColor {
    if (!dateAndTimeColor) {
        dateAndTimeColor = [[UIColor colorWithRed:0.1412 green:0.4392 blue:0.8471 alpha:1.0000] retain];
    }
    return dateAndTimeColor;
}

#pragma mark - Custom drawing

- (void)drawRect:(CGRect)rect {
    
#define LEFT_MARGIN         10
#define TOP_MARGIN          5
#define LOWER_TOP_MARGIN    27
#define RIGHT_MARGIN        10
#define BOTTOM_MARGIN       5
    
#define TITLE_FONT_SIZE     14
#define MIN_TITLE_FONT_SIZE 12
#define DATE_FONT_SIZE      14
#define TIME_FONT_SIZE      10
#define PREVIEW_FONT_SIZE   12
    
#define TITLE_WIDTH         236
#define DATE_WIDTH          56
#define TIME_WIDTH          56
#define PREVIEW_WIDTH       262
#define PREVIEW_HEIGHT      32
#define IMAGE_WIDTH         30
    
    UIColor *titleColor = nil;
    UIFont *titleFont = [UIFont boldSystemFontOfSize:TITLE_FONT_SIZE];
    
    UIColor *dateColor = nil;
    UIFont *dateFont = [UIFont systemFontOfSize:DATE_FONT_SIZE];
    
    UIColor *timeColor = nil;
    UIFont *timeFont = [UIFont systemFontOfSize:TIME_FONT_SIZE];
    
    UIColor *previewColor = nil;
    UIFont *previewFont = [UIFont systemFontOfSize:PREVIEW_FONT_SIZE];
    
    if (!self.highlighted) {
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
    
    if (!self.editing) {
        CGFloat boundsX = contentRect.origin.x;
        CGPoint point;
        
        CGFloat actualFontSize;
        CGSize size;
        
        // Draw the note's title.
        [titleColor set];
        point = CGPointMake(boundsX + LEFT_MARGIN, TOP_MARGIN);
        [self.note.title drawAtPoint:point
                            forWidth:TITLE_WIDTH
                            withFont:titleFont
                         minFontSize:MIN_TITLE_FONT_SIZE
                      actualFontSize:NULL
                       lineBreakMode:UILineBreakModeTailTruncation
                  baselineAdjustment:UIBaselineAdjustmentAlignBaselines];
        
        // Draw the note's modification date.
        [dateColor set];
        [self.dateFormatter setDateFormat:@"MM/dd/yy"];
        NSString *dateString = [self.dateFormatter stringFromDate:self.note.modified];
        size = [dateString sizeWithFont:dateFont
                            minFontSize:DATE_FONT_SIZE
                         actualFontSize:&actualFontSize
                               forWidth:DATE_WIDTH
                          lineBreakMode:UILineBreakModeClip];
        
        point = CGPointMake(boundsX + contentRect.size.width - RIGHT_MARGIN - size.width, TOP_MARGIN);
        [dateString drawAtPoint:point
                       forWidth:DATE_WIDTH
                       withFont:dateFont
                    minFontSize:actualFontSize
                 actualFontSize:&actualFontSize
                  lineBreakMode:UILineBreakModeClip
             baselineAdjustment:UIBaselineAdjustmentAlignBaselines];
        
        // Draw the note's modification time.
        [self.dateFormatter setDateFormat:@"hh:mm a"];
        NSString *timeString = [self.dateFormatter stringFromDate:self.note.modified];
        size = [timeString sizeWithFont:timeFont
                            minFontSize:TIME_FONT_SIZE
                         actualFontSize:&actualFontSize
                               forWidth:TIME_WIDTH
                          lineBreakMode:UILineBreakModeClip];
        
        point = CGPointMake(boundsX + contentRect.size.width - RIGHT_MARGIN - size.width, TOP_MARGIN + 15);
        [timeString drawAtPoint:point
                       forWidth:TIME_WIDTH
                       withFont:timeFont
                    minFontSize:actualFontSize
                 actualFontSize:&actualFontSize
                  lineBreakMode:UILineBreakModeClip
             baselineAdjustment:UIBaselineAdjustmentAlignBaselines];
        
        // Draw the preview of the note's body.
        [previewColor set];
        point = CGPointMake(boundsX + LEFT_MARGIN, LOWER_TOP_MARGIN);
        [self.note.text drawInRect:CGRectMake(point.x, point.y, PREVIEW_WIDTH, PREVIEW_HEIGHT)
                          withFont:previewFont
                     lineBreakMode:UILineBreakModeWordWrap
                         alignment:UITextAlignmentLeft];
        
        // Draw the attachment image.
        UIImage *attachmentImage = nil;
        attachmentImage = [UIImage imageNamed:@"68-paperclip"];
        
        point = CGPointMake(boundsX + contentRect.size.width - RIGHT_MARGIN - IMAGE_WIDTH, LOWER_TOP_MARGIN);
        [attachmentImage drawAtPoint:point];
    }
    
}

#pragma mark - Memory management

- (void)dealloc {
    [note release];
    [dateFormatter release];
    [super dealloc];
}

@end
