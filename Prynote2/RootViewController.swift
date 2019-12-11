//
//  RootViewController.swift
//  Prynote2
//
//  Created by tongyi on 12/10/19.
//  Copyright © 2019 tongyi. All rights reserved.
//

import UIKit
import SnapKit

class RootViewController: UIViewController {
    private let smallPrimaryColumnWidthFraction: CGFloat = 0.25
    private let largePrimaryColumnWidthFraction: CGFloat = 0.33
    
    lazy var rootSplit: UISplitViewController = {
        let split = freshSplitViewController()
        split.delegate = self
        split.preferredDisplayMode = .allVisible
        split.preferredPrimaryColumnWidthFraction = largePrimaryColumnWidthFraction
        return split
    }()
    
    lazy var stateCoordinator = StateCoordinator(delegate: self)
    
    var isHorizontallyCompact: Bool {
        return traitCollection.horizontalSizeClass == .compact
    }
    
    override func viewDidLoad() {
        
        //add rootSplit as child view controller
        addChild(rootSplit)
        view.addSubview(rootSplit.view)
        rootSplit.didMove(toParent: self)
        
        installRootSplit()
    }
    
    func installRootSplit() {
        let nav = primaryNav(of: rootSplit)
        let notebookViewController = NotebookViewController()
        notebookViewController.stateCoordinator = stateCoordinator
        nav.viewControllers = [notebookViewController]
        
        if !isHorizontallyCompact {
            rootSplit.viewControllers = [nav, placeholderViewController()]
        }
    }
    
    func placeholderViewController() -> UIViewController {
        return R.storyboard.main().instantiateViewController(withIdentifier: Constant.Identifier.PLACEHOLDER)
    }
    
    func primaryNav(of split: UISplitViewController) -> UINavigationController {
        guard let nav = split.viewControllers.first as? UINavigationController
            else { fatalError("Navigation config error") }
        
        return nav
    }
}

extension RootViewController: UISplitViewControllerDelegate {
    
}

extension RootViewController: StateCoordinatorDelegate {
    func currentSelected(_ note: Note?) {
        
    }
}
