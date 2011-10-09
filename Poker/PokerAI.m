//
//  PokerAI.m
//  Poker
//
//  Created by Brandon Smith on 10/8/11.
//  Copyright (c) 2011 Brandon Smith. All rights reserved.
//

#import "PokerAI.h"
#import "PokerTable.h"
#import "PokerPlayer.h"
#import "PokerHand.h"

@implementation PokerAI

- (PokerPlayerPosition)positionForPlayer:(PokerPlayer *)player atTable:(PokerTable *)tbl {
    int playerIndex = [tbl.players indexOfObject:player];
    int distFromButton = tbl.players.count - (playerIndex - tbl.buttonIndex);
    PokerPlayerPosition position;
    if (distFromButton > 2*tbl.players.count/3)
        position = kLatePosition;
    else if (distFromButton > tbl.players.count/2)
        position = kMiddlePosition;
    else
        position = kEarlyPosition;
    return position;
}

- (int)rankForStartingHand:(NSArray *)cards {
    int cardValueProduct = ((Card *)[cards objectAtIndex:0]).primeRank * ((Card *)[cards objectAtIndex:0]).primeRank;
    return cardValueProduct;//startingHandRank[cardValueProduct];
}

- (int)maximumRankToPlayForPosition:(PokerPlayerPosition)position {
    switch (position) {
        case kEarlyPosition:
            return 10;
            break;
        case kMiddlePosition:
            return 15;
            break;
        case kLatePosition:
            return 20;
            break;
        default:
            return 0;
            break;
    }
}

- (BOOL)player:(PokerPlayer *)player shouldFoldStartingHandAtTable:(PokerTable *)tbl {
    // Get the player's position based on button index (early - mid - late)
    PokerPlayerPosition position = [self positionForPlayer:player atTable:tbl];
    
    // Calculate the hand rank
    int rank = [self rankForStartingHand:player.holeCards];
    
    // Apply bet and random factors to rank
    
    // Test rank against maximum for position
    
    NSLog(@"%d,%d",position,rank);
    return 0;
}

- (int)betForTable:(PokerTable *)tbl andCallAmount:(int)amnt {
    return 0;
}

@end
