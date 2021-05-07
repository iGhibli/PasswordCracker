//
//  TabBarC.swift
//  PasswordCracker
//
//  Created by iGhibli on 2021/1/20.
//

import UIKit

class TabBarC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setValue(TabBar(), forKeyPath: "tabBar")
        tabBar.barTintColor = UIColor.white
        // dock.arrow.up.rectangle
        // dock.arrow.down.rectangle
        
        // menubar.arrow.up.rectangle
        // menubar.arrow.down.rectangle
        
        addChild("自主录入", "input_n", InputVC.self)
        addChild("随机获取", "output_n", OutputVC.self)
    }
    
    func addChild(_ title: String,
                  _ image: String,
                  _ type: UIViewController.Type) {
        let child = UINavigationController(rootViewController: type.init())
        child.title = title
        child.tabBarItem.image = UIImage(named: image)
        child.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.link], for: .selected)
        addChild(child)
    }
}
