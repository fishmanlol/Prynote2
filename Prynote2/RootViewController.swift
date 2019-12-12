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
        UINavigationBar.appearance().isTranslucent = true
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
        
        installRootSplit()
    }
    
    func installRootSplit() {
        let nav = primaryNav(of: rootSplit)
        let notebookViewController = NotebookViewController(style: .grouped)
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
    
    func notebookViewController() -> NotebookViewController {
        guard let notebook = primaryNav(of: rootSplit).viewControllers.first as? NotebookViewController else {
            fatalError("Notebook controller config error")
        }
        return notebook
    }
    
    func secondSplitViewController() -> UISplitViewController? {
        return rootSplit.viewControllers.last as? UISplitViewController
    }
    
    func notesViewController() -> NotesViewController? {
        if isHorizontallyCompact {
            let navigation = primaryNav(of: rootSplit)
            if navigation.viewControllers.count > 1, let notesVC = navigation.viewControllers[1] as? NotesViewController {
                return notesVC
            } else {
                return nil
            }
        } else {
            if let sec = secondSplitViewController(), let notesVC = primaryNav(of: sec).viewControllers.first as? NotesViewController {
                return notesVC
            } else {
                return nil
            }
        }
    }
    
    func activeEditor() -> EditorViewController? {
        if let sec = secondSplitViewController(), sec.viewControllers.count > 0, let editor = sec.viewControllers[1] as? EditorViewController {
            return editor
        } else {
            return nil
        }
    }
    
    func navigationStack(_ navigation: UINavigationController, isAt state: StackState) -> Bool {
        let count = navigation.viewControllers.count
        if let s = StackState(rawValue: count) {
            return s == state
        } else {
            return false
        }
    }
    
    enum StackState: Int {
        case notebook = 1
        case notes
        case editor
    }
}

extension RootViewController: UISplitViewControllerDelegate {
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        let navigation = primaryNav(of: rootSplit)
        var navStack = navigation.viewControllers
        
        if let notesVC = notesViewController() {
            navStack.append(notesVC)
        }
        
        if let editor = activeEditor() {
            navStack.append(editor)
        }
        
        primaryNav(of: rootSplit).viewControllers = navStack
        return true
    }
    
    func splitViewController(_ splitViewController: UISplitViewController, separateSecondaryFrom primaryViewController: UIViewController) -> UIViewController? {
        let navigation = primaryNav(of: rootSplit)

        if navigationStack(navigation, isAt: .notes) {
            configureSplit(notebookViewController(), placeholderViewController(), in: rootSplit)
        } else if navigationStack(navigation, isAt: .notebook) {
            let sec = secondSplitViewController() ?? freshSplitViewController()
            configureSplit(<#T##master: UIViewController##UIViewController#>, <#T##detail: UIViewController##UIViewController#>, in: <#T##UISplitViewController#>)
            
        } else if navigationStack(navigation, isAt: .editor) {
            
        }

        return nil
    }
}

extension RootViewController: StateCoordinatorDelegate {
    func currentSelected(_ note: Note?) {
        if let note = note {
            if let notesVC = notesViewController() {
                if isHorizontallyCompact {
                    let editor = freshEditorViewController()
                    editor.note = note
                    notesVC.showDetailViewController(editor, sender: nil)
                } else {
                    let sec = secondSplitViewController() ?? freshSplitViewController()
                    let editor = freshEditorViewController()
                    editor.note = note
                    let nav = freshNavigationController(root: editor)
                    rootSplit.preferredPrimaryColumnWidthFraction = smallPrimaryColumnWidthFraction
                    sec.preferredPrimaryColumnWidthFraction = largePrimaryColumnWidthFraction
                    configureSplit(notesVC, nav, in: sec)
                    configureSplit(notebookViewController(), sec, in: rootSplit)
                }
            }
        } else {
            if isHorizontallyCompact {
                //do nothing
            } else {//regular
                rootSplit.preferredPrimaryColumnWidthFraction = smallPrimaryColumnWidthFraction
                if let secondSplit = secondSplitViewController() {//have secondSplit
                    secondSplit.viewControllers = [primaryNav(of: secondSplit), placeholderViewController()]
                    rootSplit.viewControllers = [primaryNav(of: rootSplit), secondSplit]
                    secondSplit.preferredPrimaryColumnWidthFraction = largePrimaryColumnWidthFraction
                } else { //no second split, in case
                    let sec = freshSplitViewController()
                    sec.preferredPrimaryColumnWidthFraction = largePrimaryColumnWidthFraction
                    if let notebook = stateCoordinator.selectedNotebook {
                        let notesViewController = freshNotesViewController()
                        notesViewController.notebook = notebook
                        configureSplit(notesViewController, placeholderViewController(), in: sec)
                        rootSplit.viewControllers = [primaryNav(of: rootSplit), sec]
                    } else {
                        rootSplit.viewControllers = [primaryNav(of: rootSplit), placeholderViewController()]
                    }
                }
            }
        }
    }
    
    func currentSelected(_ notebook: Notebook?) {
        if let notebook = notebook {
            let notesViewController = freshNotesViewController()
            notesViewController.notebook = notebook
            notesViewController.stateCoordinator = stateCoordinator
            if isHorizontallyCompact {
                notebookViewController().showDetailViewController(notesViewController, sender: nil)
            } else {
                let secondSplit = secondSplitViewController() ?? freshSplitViewController()
                secondSplit.preferredPrimaryColumnWidthFraction = largePrimaryColumnWidthFraction
                rootSplit.preferredPrimaryColumnWidthFraction = smallPrimaryColumnWidthFraction
                configureSplit(notesViewController, placeholderViewController(), in: secondSplit)
                configureSplit(notebookViewController(), secondSplit, in: rootSplit)
            }
        } else {
            let navigation = primaryNav(of: rootSplit)
            
            if !(navigation.topViewController is NotebookViewController) {
                navigation.viewControllers = [notebookViewController()]
            }
            
            if !isHorizontallyCompact {
                rootSplit.preferredPrimaryColumnWidthFraction = largePrimaryColumnWidthFraction
                rootSplit.viewControllers[1] = placeholderViewController()
            }
        }
    }
    
    func configureSplit(_ master: UIViewController, _ detail: UIViewController, in split: UISplitViewController) {
        let navigation = primaryNav(of: split)
        navigation.viewControllers = [master]
        split.viewControllers = [navigation, detail]
    }
}
