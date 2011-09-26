//
//  PokerPlayer.h
//  Poker
//
//  Created by Brandon Smith on 9/25/11.
//  Copyright (c) 2011 Brandon Smith. All rights reserved.
//

#import "PokerTable.h"
#import "PokerHand.h"

@interface PokerPlayer : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) int currentBet;
@property (nonatomic, assign) int totalBet;
@property (nonatomic, assign) int chips;
@property (nonatomic, strong) NSMutableArray *holeCards;
@property (nonatomic, strong) PokerHand *hand;
@property (nonatomic, assign) BOOL allIn;
@property (nonatomic, assign) BOOL folded;

- (id)initWithName:(NSString *)name;
- (int)betForTable:(PokerTable *)table andCallAmount:(int)amnt;
- (void)makeBet:(int)bet;

@end
