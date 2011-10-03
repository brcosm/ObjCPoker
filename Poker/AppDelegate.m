//
//  AppDelegate.m
//  Poker
//
//  Created by Brandon Smith on 9/20/11.
//  Copyright (c) 2011 Brandon Smith. All rights reserved.
//

#import "AppDelegate.h"
#import "PlayersViewController.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize navController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    //gv = [[GameViewController alloc] initWithNibName:nil bundle:nil];
    PlayersViewController *pv = [[PlayersViewController alloc] initWithNibName:nil bundle:nil];
    self.navController = [[UINavigationController alloc] initWithRootViewController:pv];
    self.window.rootViewController = self.navController;
    [self.window makeKeyAndVisible];
    return YES;
}

@end
