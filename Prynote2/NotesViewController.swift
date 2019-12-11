//
//  NotesViewController.swift
//  Prynote2
//
//  Created by tongyi on 12/10/19.
//  Copyright © 2019 tongyi. All rights reserved.
//

import UIKit

class NotesViewController: UITableViewController {
    lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search notebook title"
        return searchController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
}

extension NotesViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}
