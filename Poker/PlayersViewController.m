//
//  PlayersViewController.m
//  Poker
//
//  Created by Brandon Smith on 10/2/11.
//  Copyright (c) 2011 Brandon Smith. All rights reserved.
//

#import "PlayersViewController.h"
#import "EditPlayerViewController.h"
#import "SimulationViewController.h"

@implementation PlayersViewController
@synthesize players;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.players = [NSMutableArray array];
        self.title = @"Add Players";
    }
    return self;
}

- (void)loadView {
    CGRect frame = [[UIScreen mainScreen] applicationFrame];
    UITableView *tv = 
    [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) style:UITableViewStyleGrouped];
    tv.delegate = self;
    tv.dataSource = self;
    self.view = tv;
    // Add the 'add player' button to the menu
    self.navigationItem.rightBarButtonItem = 
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd 
                                                  target:self 
                                                  action:@selector(showPlayerEditor)];
    self.navigationItem.leftBarButtonItem = 
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay 
                                                  target:self 
                                                  action:@selector(startNewGame)];
    self.navigationItem.leftBarButtonItem.enabled = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.players.count > 1)
        self.navigationItem.leftBarButtonItem.enabled = YES;
    [(UITableView *)self.view reloadData];
}

- (int)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.players.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell layoutIfNeeded];
    }
    // Show the player name
    PokerPlayer *p = [self.players objectAtIndex:indexPath.row];
    NSMutableString *pInfo = [NSMutableString stringWithString:p.name];
    [pInfo appendFormat:@" %d", p.chips];
    cell.textLabel.text = pInfo;
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0)
        return @"Add at least 2 players to begin";
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PokerPlayer *p = [self.players objectAtIndex:indexPath.row];
    EditPlayerViewController *apvc = [[EditPlayerViewController alloc] initWithPlayer:p];
    apvc.pvc = self;
    [self.navigationController pushViewController:apvc animated:YES];
}

- (void)showPlayerEditor {
    EditPlayerViewController *apvc = [[EditPlayerViewController alloc] initWithStyle:UITableViewStyleGrouped];
    apvc.pvc = self;
    [self.navigationController pushViewController:apvc animated:YES];
}

- (void)startNewGame {
    SimulationViewController * svc = [[SimulationViewController alloc] initWithPlayers:[self.players mutableCopy]];
    [self.navigationController pushViewController:svc animated:YES];
}

@end
