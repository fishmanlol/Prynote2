//
//  NotebookViewController.swift
//  Prynote2
//
//  Created by tongyi on 12/10/19.
//  Copyright © 2019 tongyi. All rights reserved.
//

import UIKit
import SnapKit

class NotebookViewController: UITableViewController {
    var open = true
    var stateCoordinator: StateCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
    }
    
    @objc func didPullToRefreshing(refreshControl: UIRefreshControl) {
        print("Refreshing...")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            refreshControl.endRefreshing()
        }
    }
    
    @objc func didTapSetting() {
        
    }
    
    @objc func didTapEdit() {
        
    }
    
    @objc func didTapAdd() {
        
    }
    
    private func setUp() {
        //add background view
        let backgroundView = UIImageView(image: R.image.paper_light())
        backgroundView.contentMode = .scaleToFill
        
        //tableview
        tableView.register(UINib(resource: R.nib.notebookCell), forCellReuseIdentifier: Constant.Identifier.NOTEBOOKCELL)
        tableView.register(UINib(resource: R.nib.notebookHeader), forHeaderFooterViewReuseIdentifier: Constant.Identifier.NOTEBOOKHEADER)
        tableView.separatorStyle = .none
        tableView.backgroundView = backgroundView
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0.01))
        
        //navigation item
        navigationItem.title = "Notebooks"
        let userItem = UIBarButtonItem(image: R.image.user(), style: .plain, target: self, action: #selector(didTapSetting))
        let editItem = UIBarButtonItem(title: "Edit", style: .done, target: self, action: #selector(didTapEdit))
        navigationItem.setLeftBarButton(userItem, animated: false)
        navigationItem.setRightBarButton(editItem, animated: false)
        
        //toolbar item
        let addItem = UIBarButtonItem(title: "New Notebook", style: .done, target: self, action: #selector(didTapAdd))
        let spaceItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        setToolbarItems([spaceItem, spaceItem, spaceItem, spaceItem, addItem], animated: false)
        
        //refreshing
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: Constant.Strings.refreshingText)
        refreshControl.addTarget(self, action: #selector(didPullToRefreshing), for: .valueChanged)
        self.refreshControl = refreshControl
    }
}
