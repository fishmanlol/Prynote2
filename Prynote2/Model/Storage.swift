//
//  Storage.swift
//  Prynote2
//
//  Created by tongyi on 12/10/19.
//  Copyright © 2019 tongyi. All rights reserved.
//

import Foundation

struct Storage {
    static var shared = Storage()
    var notebooks: [Notebook] = []
    private init() {}
    
    mutating func createDefaultNotebook() {
        let notebook = Notebook("Notes")
        notebooks.append(notebook)
    }
    
    static func load() {
        shared.createDefaultNotebook()
        shared.createDefaultNotebook()
        shared.createDefaultNotebook()
        NotificationCenter.default.post(name: .didLoadAllNotebooks, object: nil, userInfo: nil)
    }
    
    func getCountOfNotebook() -> Int {
        return notebooks.count
    }
    
    func getCountOfAllNote() -> Int {
        return notebooks.reduce(0, { (result, notebook) -> Int in
            return result + notebook.getCountOfNote()
        })
    }
}
