//
//  AddPlayerViewController.h
//  Poker
//
//  Created by Brandon Smith on 10/2/11.
//  Copyright (c) 2011 Brandon Smith. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PlayersViewController;
@class PokerPlayer;

@interface EditPlayerViewController : UITableViewController <UITextFieldDelegate>

@property (nonatomic, assign) PlayersViewController* pvc;
@property (nonatomic, strong) PokerPlayer *player;

- (id)initWithPlayer:(PokerPlayer *)pokerPlayer;

@end
