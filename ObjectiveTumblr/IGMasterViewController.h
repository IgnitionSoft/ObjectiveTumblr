//
//  IGMasterViewController.h
//  ObjectiveTumblr
//
//  Created by Chong Francis on 12年4月25日.
//  Copyright (c) 2012年 Ignition Soft Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IGObjectiveTumblr.h"

@class IGDetailViewController;

@interface IGMasterViewController : UITableViewController <IGObjectiveTumblrDelegate>

@property (strong, nonatomic) IGDetailViewController *detailViewController;
@property (strong, nonatomic) IGObjectiveTumblr* tumblr;
@end
