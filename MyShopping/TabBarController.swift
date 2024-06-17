//
//  TabBarController.swift
//  MyShopping
//
//  Created by t2023-m0032 on 6/14/24.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.tintColor = UIColor(red: 239/255, green: 137/255, blue: 71/255, alpha: 1.0)
        tabBar.unselectedItemTintColor = UIColor(red: 205/255, green: 205/255, blue: 205/255, alpha: 1.0)
        
        let main = MainViewController()
        let nav1 = UINavigationController(rootViewController: main)
        nav1.tabBarItem = UITabBarItem(title: "검색", image: UIImage(systemName: "magnifyingglass"), tag: 0)
        
        let setting = SettingViewController()
        let nav2 = UINavigationController(rootViewController: setting)
        nav2.tabBarItem = UITabBarItem(title: "설정", image: UIImage(systemName: "person"), tag: 1)
        
        setViewControllers([nav1, nav2], animated: true)
    }

}
