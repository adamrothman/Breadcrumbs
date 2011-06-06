//
//  ImageViewController.h
//  Breadcrumbs
//
//  Created by Adam Rothman on 6/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

@interface ImageViewController : UIViewController <UIScrollViewDelegate>
@property (nonatomic, assign) UIViewController *delegate;

- (id)initWithContentURL:(NSURL *)aContentURL;
@end
