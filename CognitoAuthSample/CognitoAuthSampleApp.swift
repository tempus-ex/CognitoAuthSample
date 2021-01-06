//
//  CognitoAuthSampleApp.swift
//  CognitoAuthSample
//
//  Created by Christopher Brown on 1/6/21.
//

import Amplify
import AmplifyPlugins
import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        do {
            try Amplify.add(plugin: AWSCognitoAuthPlugin())
            try Amplify.configure()
        } catch {
            print("Failed to initialize Amplify with \(error)")
        }

        return true
    }
}

@main
struct CognitoAuthSampleApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
