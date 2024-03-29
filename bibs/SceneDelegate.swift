//
//  SceneDelegate.swift
//  bibs
//
//  Created by Paul Hendrick on 22/05/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import UIKit
import SwiftUI
import CoreData
import Foundation

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).

        // Get the managed object context from the shared persistent container.
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        // the ActiveChildProfile struct is a singleton which lets us keep track of the current
        // child, and functionality for allowing co-feeding
        let profileObserver = ProfileObserver.shared
        
        let parentProfileFetchRequest:NSFetchRequest<ParentProfile> = ParentProfile.fetchRequest()
        
        var initialView: ViewSettings.InitialView = .welcome
        
        if let parent = try? context.fetch(parentProfileFetchRequest).first, parent.childrenArray.count > 0 {
            _ = parent.restoreActiveChild()
            profileObserver.parent = parent
            parent.profileObserver = profileObserver
            
            initialView = .dashboard
        }else {
            if let parent = try? context.fetch(parentProfileFetchRequest).first {
                profileObserver.parent = parent
                parent.profileObserver = profileObserver
            }else {
                let parent = ParentProfile(context: context)
                profileObserver.parent = parent
                parent.profileObserver = profileObserver
            }
        }
        
        profileObserver.parent.resumeSuspendedFeedSessions()
        
        // load settings
        configureSettingsBundle()
        
        // View settings to determine which view to show on start up (dashboard or onboarding process)
        let viewSettings = ViewSettings(initialView: initialView)
        
        // Create the SwiftUI view and set the context as the value for the managedObjectContext environment keyPath.
        // Add `@Environment(\.managedObjectContext)` in the views that will need the context.
        let contentView = ContentView()
            .environmentObject(profileObserver)
            .environmentObject(viewSettings)
            .environment(\.managedObjectContext, context)
            

        // Use a UIHostingController as window root view controller.
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: contentView)
            self.window = window
            window.makeKeyAndVisible()
        }
    }
    
    func configureSettingsBundle() {
        let userDefaults = UserDefaults.standard
        
        guard let settingsBundle = Bundle.main.url(forResource: "Settings", withExtension:"bundle") else {
            print("Settings.bundle not found")
            return;
        }
        
        guard let settings = NSDictionary(contentsOf: settingsBundle.appendingPathComponent("Root.plist")) else {
            print("Root.plist not found in settings bundle")
            return
        }
        
        guard let preferences = settings.object(forKey: "PreferenceSpecifiers") as? [[String: AnyObject]] else {
            print("Root.plist has invalid format")
            return
        }
        
        var defaultsToRegister = [String: AnyObject]()
        
        for var pref in preferences {
            if let key = pref["Key"] as? String, let val = pref["DefaultValue"] {
                defaultsToRegister[key] = val
            }
        }
        userDefaults.register(defaults: defaultsToRegister)
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }


}

