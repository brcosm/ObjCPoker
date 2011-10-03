//
//  PlayersViewController.h
//  Poker
//
//  Created by Brandon Smith on 10/2/11.
//  Copyright (c) 2011 Brandon Smith. All rights reserved.
//

#import "PokerPlayer.h"

@interface PlayersViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *players;

@end
