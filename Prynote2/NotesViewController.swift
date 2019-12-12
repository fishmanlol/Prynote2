//
//  NotesViewController.swift
//  Prynote2
//
//  Created by tongyi on 12/10/19.
//  Copyright © 2019 tongyi. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class NotesViewController: UITableViewController {
    lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search notebook title"
        return searchController
    }()
    var notebook: Notebook!
    var stateCoordinator: StateCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
    }
    
    private func setUp() {
        navigationItem.searchController = searchController
        navigationItem.title = notebook.title
        definesPresentationContext = true
        
        //tableview
        tableView.register(UINib(resource: R.nib.noteCell), forCellReuseIdentifier: Constant.Identifier.NOTECELL)
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.tableFooterView = UIView()
        tableView.backgroundView = UIImageView(image: R.image.paper_light())
        tableView.allowsMultipleSelection = false
    }
}

extension NotesViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}

extension NotesViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    func customView(forEmptyDataSet scrollView: UIScrollView!) -> UIView! {
        let waitingView = WaitingView(frame: CGRect(x: 0, y: 0, width: 100, height: 44))
        
        if notebook.isLoading {
            waitingView.setMsg("Loading...")
            waitingView.startAnimating()
        } else {
            waitingView.setMsg("No notes")
            waitingView.stopAnimating()
        }
        
        return waitingView
    }
}
