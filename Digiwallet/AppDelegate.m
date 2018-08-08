//
//  AppDelegate.m
//  Digiwallet
//
//  Created by Fabio Campos on 04/08/2018.
//  Copyright © 2018 green. All rights reserved.
//

#import "AppDelegate.h"
#import "UserViewModel.h"
#import "LoginViewController.h"
#import "LoginService.h"

@interface AppDelegate ()
@property (strong, nonatomic) UserViewModel *userViewModel;
@property (nonatomic, retain) UINavigationController *navigationController;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    UIViewController *viewController = [self createInitialViewController];
    UIViewController *rootViewControler = [[UINavigationController alloc] initWithRootViewController:viewController];
    
    self.window.rootViewController = rootViewControler;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (UIViewController *)createInitialViewController {
    self.userViewModel = [[UserViewModel alloc] initWithService:[[LoginService alloc] init]];
    LoginViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginViewController"];
    return [viewController initWithViewModel:self.userViewModel];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
