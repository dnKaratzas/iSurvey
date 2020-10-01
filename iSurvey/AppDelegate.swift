//
//  AppDelegate.swift
//  iSurvey
//
//  Created by Dionisis Karatzas on 29/9/20.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

		window = UIWindow(frame: UIScreen.main.bounds)
		window?.overrideUserInterfaceStyle = .light

		let mainViewController = StoryboardScene.Main.mainViewController.instantiate()

		mainViewController.viewModel = MainViewModel()

		self.window?.rootViewController = mainViewController
		self.window?.makeKeyAndVisible()
		return true
	}

}
