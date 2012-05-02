//
//  IGDetailViewController.h
//  ObjectiveTumblr
//
//  Created by Chong Francis on 12年4月25日.
//  Copyright (c) 2012年 Ignition Soft Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IGDetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end
