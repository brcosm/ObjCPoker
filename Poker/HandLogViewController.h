//
//  HandLogViewController.h
//  Poker
//
//  Created by Brandon Smith on 10/9/11.
//  Copyright (c) 2011 Brandon Smith. All rights reserved.
//

@interface HandLogViewController : UITableViewController

@property (nonatomic, copy) NSArray *log;

- (id)initWithHandLog:(NSArray *)handLog;

@end
