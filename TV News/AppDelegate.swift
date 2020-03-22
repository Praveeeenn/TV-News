//
//  AppDelegate.swift
//  TV News
//
//  Created by Praveen on 21/03/20.
//  Copyright © 2020 Praveen. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let categories: [String] = ["Business", "Culture", "Sport", "Technology", "Travel"]

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //1. grab the root viewconrtller and type cast it to tabbar controller
        if let tabBarController = window?.rootViewController as? UITabBarController {
            
            //2. create an empty view controller  array ready to hold the view controllers
            var viewControllers = [UIViewController]()
            
            // 3. Loop over all the categories
            for cat in categories {
                
                //4. Create a new view controller for this category
                if let newsController = tabBarController.storyboard?.instantiateViewController(identifier: "News") as? ViewController {
                    //5.  Give it the title of this category
                    newsController.title = cat
                    //6. Append it to our array  of view controllers
                    viewControllers.append(newsController)
                }               
            }
            viewControllers.append(createSearch(storyboard: tabBarController.storyboard))
            //7. Assign the viewcontroller array to the tab bar
            tabBarController.viewControllers = viewControllers
            
        }
        
        return true
    }

    func createSearch(storyboard: UIStoryboard?) -> UIViewController {
        guard let newsController = storyboard?.instantiateViewController(withIdentifier: "News") as? ViewController else {
            return UIViewController()
        }
        let searchController = UISearchController(searchResultsController: newsController)
        searchController.searchResultsUpdater = newsController
        searchController.title = "Search"
        
        let searchContainer = UISearchContainerViewController(searchController: searchController)
        searchContainer.title = "Search"
        return searchContainer
    }
    
    
}

