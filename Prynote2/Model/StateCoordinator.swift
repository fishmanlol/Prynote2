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
}

class StateCoordinator {
    var selectedNote: Note?
    weak var delegate: StateCoordinatorDelegate?
    
    init(delegate: StateCoordinatorDelegate) {
        self.delegate = delegate
    }
}
