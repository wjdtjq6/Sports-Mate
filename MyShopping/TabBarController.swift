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
        tabBar.tintColor = UIColor.accent
        tabBar.unselectedItemTintColor = UIColor(red: 205/255, green: 205/255, blue: 205/255, alpha: 1.0)
        
        let main = MainViewController()
        let nav1 = UINavigationController(rootViewController: main)
        nav1.tabBarItem = UITabBarItem(title: "검색", image: UIImage(systemName: "magnifyingglass"), tag: 0)
       
        let likeList = LikeListViewController()
        let nav2 = UINavigationController(rootViewController: likeList)
        nav2.tabBarItem = UITabBarItem(title: "좋아요", image: UIImage(systemName: "heart"), tag: 1)
        
        let setting = SettingViewController()
        let nav3 = UINavigationController(rootViewController: setting)
        nav3.tabBarItem = UITabBarItem(title: "설정", image: UIImage(systemName: "person"), tag: 2)
        
        setViewControllers([nav1,nav2,nav3], animated: true)
    }

}
