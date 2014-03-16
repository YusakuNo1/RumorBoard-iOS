//
//  DlAppDelegate.m
//  RumorBoard
//
//  Created by David Wu on 18/02/2014.
//  Copyright (c) 2014 David Wu. All rights reserved.
//

#import "DlAppDelegate.h"

@implementation DlAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//    // Request a custom set of notification types
//    [UAPush shared].notificationTypes = (UIRemoteNotificationTypeBadge |
//                                         UIRemoteNotificationTypeSound |
//                                         UIRemoteNotificationTypeAlert |
//                                         UIRemoteNotificationTypeNewsstandContentAvailability);
//    
//    // Populate AirshipConfig.plist with your app's info from https://go.urbanairship.com
//    // or set runtime properties here.
//    UAConfig *config = [UAConfig defaultConfig];
//    
//    // You can also programmatically override the plist values:
//    // config.developmentAppKey = @"YourKey";
//    // etc.
//    
//    // Call takeOff (which creates the UAirship singleton)
//    [UAirship takeOff:config];
//    
//    [[UAPush shared] setPushEnabled:YES];
    
    // Set log level for debugging config loading (optional)
    // It will be set to the value in the loaded config upon takeOff
    [UAirship setLogLevel:UALogLevelTrace];
    
    // Populate AirshipConfig.plist with your app's info from https://go.urbanairship.com
    // or set runtime properties here.
    UAConfig *config = [UAConfig defaultConfig];
    
    // You can then programatically override the plist values:
    config.developmentAppKey = [YOUR_URBANAIRSHIP_APP_KEY];                 // TODO
    config.developmentAppSecret = [YOUR_URBANAIRSHIP_APP_SECRET];           // TODO
    
    // Call takeOff (which creates the UAirship singleton)
    [UAirship takeOff:config];
    
    // Print out the application configuration for debugging (optional)
    UA_LDEBUG(@"Config:\n%@", [config description]);
    
    // Set the icon badge to zero on startup (optional)
    [[UAPush shared] resetBadge];
    
    // Set the notification types required for the app (optional). With the default value of push set to no,
    // UAPush will record the desired remote notification types, but not register for
    // push notifications as mentioned above. When push is enabled at a later time, the registration
    // will occur normally. This value defaults to badge, alert and sound, so it's only necessary to
    // set it if you want to add or remove types.
    [UAPush shared].notificationTypes = (UIRemoteNotificationTypeBadge |
                                         UIRemoteNotificationTypeSound |
                                         UIRemoteNotificationTypeAlert);

    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Set the icon badge to zero on resume (optional)
    [[UAPush shared] resetBadge];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    UA_LINFO(@"Received remote notification (in appDelegate): %@", userInfo);
    
    // Optionally provide a delegate that will be used to handle notifications received while the app is running
    // [UAPush shared].pushNotificationDelegate = your custom push delegate class conforming to the UAPushNotificationDelegate protocol
    
    // Reset the badge after a push received (optional)
    [[UAPush shared] resetBadge];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    UA_LINFO(@"Received remote notification (in appDelegate): %@", userInfo);
    
    // Optionally provide a delegate that will be used to handle notifications received while the app is running
    // [UAPush shared].pushNotificationDelegate = your custom push delegate class conforming to the UAPushNotificationDelegate protocol
    
    // Reset the badge after a push is received in a active or inactive state
    if (application.applicationState != UIApplicationStateBackground) {
        [[UAPush shared] resetBadge];
    }
    
    completionHandler(UIBackgroundFetchResultNoData);
}

@end
