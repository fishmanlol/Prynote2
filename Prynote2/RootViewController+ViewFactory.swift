//
//  RootViewController+ViewFactory.swift
//  Prynote2
//
//  Created by tongyi on 12/10/19.
//  Copyright © 2019 tongyi. All rights reserved.
//

import UIKit

extension RootViewController {
    func freshSplitViewController() -> UISplitViewController {
        let split = UISplitViewController()
        let nav = UINavigationController()
        nav.navigationBar.prefersLargeTitles = true
        nav.navigationBar.shadowImage = UIImage()
        nav.setToolbarHidden(false, animated: false)
        nav.toolbar.setShadowImage(UIImage(), forToolbarPosition: .any)
        nav.toolbar.setBackgroundImage(UIImage(), forToolbarPosition: .any, barMetrics: .default)
        split.viewControllers = [nav]
        return split
    }
}
