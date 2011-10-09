//
//  SimulationViewController.h
//  Poker
//
//  Created by Brandon Smith on 10/2/11.
//  Copyright (c) 2011 Brandon Smith. All rights reserved.
//

@class PokerGame;

@interface SimulationViewController : UITableViewController

@property (nonatomic, strong) PokerGame *game;

- (id)initWithPlayers:(NSMutableArray *)pokerPlayers;

- (void)simulateHand;

- (void)viewLastHand;

- (void)simulateGame;

@end
