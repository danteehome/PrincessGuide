//
//  AppDelegate.swift
//  PrincessGuide
//
//  Created by zzk on 19/03/2018.
//  Copyright © 2018 zzk. All rights reserved.
//

import UIKit
import Kingfisher
import KingfisherWebP
import Gestalt

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let rootTabBarController = storyboard.instantiateViewController(withIdentifier: "RootTabBarController") as! UITabBarController
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = rootTabBarController
        window?.makeKeyAndVisible()
        
        ThemeManager.default.apply(theme: Theme.self, to: self) { themeable, theme in
            let tabBar = rootTabBarController.tabBar
            tabBar.tintColor = theme.color.tint
            tabBar.barStyle = theme.barStyle
            themeable.window?.backgroundColor = theme.color.background
        }
        
        ThemeManager.default.theme = Defaults.prefersDarkTheme ? Theme.dark : Theme.light
        
        KingfisherManager.shared.defaultOptions = [.processor(WebPProcessor.default), .cacheSerializer(WebPSerializer.default)]

        // set Kingfisher cache never expiring
        ImageCache.default.maxCachePeriodInSecond = -1
        
        VersionManager.shared.executeDocumentReset { (lastVersion) in
            do {
                if lastVersion < 1 {
                    try FileManager.default.removeItem(at: ConsoleVariables.url)
                }
            } catch (let error) {
                print(error)
            }
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

