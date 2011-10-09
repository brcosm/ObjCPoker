//
//  PokerAI.h
//  Poker
//
//  Created by Brandon Smith on 10/8/11.
//  Copyright (c) 2011 Brandon Smith. All rights reserved.
//

@class PokerTable;
@class PokerPlayer;

typedef enum {
    kEarlyPosition = 0,
    kMiddlePosition,
    kLatePosition
} PokerPlayerPosition;

@interface PokerAI : NSObject

- (int)betForTable:(PokerTable *)tbl andCallAmount:(int)amnt;

- (BOOL)player:(PokerPlayer *)player shouldFoldStartingHandAtTable:(PokerTable *)tbl;

@end
