//
//  PokerTable.h
//  Poker
//
//  Created by Brandon Smith on 9/25/11.
//  Copyright (c) 2011 Brandon Smith. All rights reserved.
//

@interface PokerTable : NSObject

@property (nonatomic, strong) NSMutableArray *players;
@property (nonatomic, assign) int smallBlind;
@property (nonatomic, assign) int bigBlind;
@property (nonatomic, assign) int buttonIndex;
@property (nonatomic, assign) int pot;
@property (nonatomic, strong) NSMutableArray *communityCards;
@property (nonatomic, strong) NSMutableArray *burnedCards;

- (id)initWithPlayers:(NSMutableArray *)players;
- (void)reset;

@end
