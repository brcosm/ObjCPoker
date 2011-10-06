//
//  Card.h
//  Poker
//
//  Created by Brandon Smith on 9/20/11.
//  Copyright (c) 2011 Brandon Smith. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    kCardRankTwo,
    kCardRankThree,
    kCardRankFour,
    kCardRankFive,
    kCardRankSix,
    kCardRankSeven,
    kCardRankEight,
    kCardRankNine,
    kCardRankTen,
    kCardRankJack,
    kCardRankQueen,
    kCardRankKing,
    kCardRankAce,
    kCardRankCount
} CardRank;

typedef enum {
    kCardSuitClubs,
    kCardSuitDiamonds,
    kCardSuitHearts,
    kCardSuitSpades,
    kCardSuitCount
} CardSuit;

@interface Card : NSObject

@property (nonatomic, readonly) CardRank rank;
@property (nonatomic, readonly) CardSuit suit;
@property (nonatomic, readonly) int primeRank;
@property (nonatomic, readonly) int binaryRank;

- (id)initWithSuit:(CardSuit)suit andRank:(CardRank)rank;


@end
