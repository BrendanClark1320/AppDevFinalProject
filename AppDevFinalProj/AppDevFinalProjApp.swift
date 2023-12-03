//
//  AppDevFinalProjApp.swift
//  AppDevFinalProj
//
//  Created by Student on 12/3/23.
//

import SwiftUI
import FirebaseCore
import GoogleSignIn
class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
    
    func application(_ application: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] =  [:]) -> Bool{
        return GIDSignIn.sharedInstance.handle(url)
    }
}

@main
struct AppDevFinalProjApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
