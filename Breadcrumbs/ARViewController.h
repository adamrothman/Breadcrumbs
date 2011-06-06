//
//  ARViewController.h
//  Breadcrumbs
//
//  Created by Adam Rothman on 6/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ARController.h"

@interface ARViewController : UIViewController
@property (nonatomic, retain) ARController *arController;

- (id)initInManagedObjectContext:(NSManagedObjectContext *)context;
@end
