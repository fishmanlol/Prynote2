//
//  StateCoordinator.swift
//  Prynote2
//
//  Created by tongyi on 12/10/19.
//  Copyright © 2019 tongyi. All rights reserved.
//

import Foundation

protocol StateCoordinatorDelegate: class {
    func currentSelected(_ note: Note?)
    func currentSelected(_ notebook: Notebook?)
}

class StateCoordinator {
    var selectedNote: Note? {
        didSet {
            delegate?.currentSelected(selectedNote)
        }
    }
    
    var selectedNotebook: Notebook? {
        didSet {
            delegate?.currentSelected(selectedNotebook)
        }
    }
    
    weak var delegate: StateCoordinatorDelegate?
    
    init(delegate: StateCoordinatorDelegate) {
        self.delegate = delegate
    }
    
    
}
