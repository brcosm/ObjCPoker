//
//  Card.m
//  Poker
//
//  Created by Brandon Smith on 9/20/11.
//  Copyright (c) 2011 Brandon Smith. All rights reserved.
//

#import "Card.h"

static char *ranks = "23456789TJQKA";
static char *suits = "cdhs";
static int primes[] = {2,3,5,7,11,13,17,19,23,29,31,37,41};

@implementation Card {
    CardRank rank_;
    CardSuit suit_;
}

- (CardRank)rank {
    return rank_;
}

- (CardSuit)suit {
    return suit_;
}

- (int)primeRank {
    return primes[rank_];
}

- (int)binaryRank {
    return pow(2,rank_);
}

- (id)initWithSuit:(CardSuit)suit andRank:(CardRank)rank {
    self = [super init];
    if (self) {
        suit_ = suit;
        rank_ = rank;
    }
    return self;
}

- (NSString *)description {
    char desc[] = {ranks[self.rank], suits[self.suit], '\0'};
    return [[NSString alloc] initWithCString:desc encoding:NSUTF8StringEncoding];
}

@end
