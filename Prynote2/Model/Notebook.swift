//
//  Notebook.swift
//  Prynote2
//
//  Created by tongyi on 12/10/19.
//  Copyright © 2019 tongyi. All rights reserved.
//

import Foundation

class Notebook {
    var title: String = ""
    var notes: [Note] = []
    var isLoading = false
    var type: NotebookType
    
    init(_ title: String) {
        self.type = .single
        self.title = title
        
        let note1 = Note(notebook: self)
        let note2 = Note(notebook: self)
        let note3 = Note(notebook: self)
        
        notes = [note1, note2, note3]
        
        isLoading = true
        let group = DispatchGroup()
        for note in notes {
            group.enter()
            note.load {
                group.leave()
            }
        }
        
        group.notify(queue: DispatchQueue.main) {
            self.isLoading = false
            NotificationCenter.default.post(name: .didLoadAllNotes, object: self)
        }
    }
    
    init(_ title: String, _ notebooks: [Notebook]) {
        self.title = title
        self.type = .all
        self.notes = notebooks.flatMap { $0.notes }
        print(notes)
    }
    
    func getCountOfNote() -> Int {
        return notes.count
    }
    
    enum NotebookType {
        case all
        case single
        case sharedWithMe
    }
}
