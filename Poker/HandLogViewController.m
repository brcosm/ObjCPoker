//
//  HandLogViewController.m
//  Poker
//
//  Created by Brandon Smith on 10/9/11.
//  Copyright (c) 2011 Brandon Smith. All rights reserved.
//

#import "HandLogViewController.h"


@implementation HandLogViewController
@synthesize log;

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithHandLog:(NSArray *)handLog {
    self = [super init];
    if (self) {
        self.log = handLog;
    }
    return self;
}

#pragma mark - View lifecycle
- (void)loadView {
    CGRect frame = [[UIScreen mainScreen] applicationFrame];
    UITableView *tv = 
    [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) 
                                 style:UITableViewStyleGrouped];
    tv.dataSource = self;
    tv.delegate = self;
    self.view = tv;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return log.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [log objectAtIndex:indexPath.row];
    
    return cell;
}

@end
