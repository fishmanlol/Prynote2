//
//  Note.swift
//  Prynote2
//
//  Created by tongyi on 12/10/19.
//  Copyright © 2019 tongyi. All rights reserved.
//

import Foundation
import UIKit

class Note {
    lazy var title = NSAttributedString(string: "Note", attributes: defaultTitleAttributes)
    lazy var content = NSAttributedString(string: "", attributes: defaultContentAttributes)
    var createDate = Date()
    var lastUpdateDate = Date()
    var url: URL?
    unowned var notebook: Notebook
    private var defaultTitleAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 22, weight: .bold)]
    private var defaultContentAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .regular)]
    
    init(notebook: Notebook) {
        self.notebook = notebook
    }
    
    func load(completion: @escaping () -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
            completion()
        }
    }
    
    func hasTitle() -> Bool {
        return title.string.isEmpty
    }
    
    func hasContent() -> Bool {
        return content.string.isEmpty
    }
    
    func updateTitle(_ title: NSAttributedString?) {
        self.title = title ?? NSAttributedString()
        
        if self.title.string.isEmpty {
            self.title = NSAttributedString(string: "Note", attributes: defaultTitleAttributes)
        }
        
        NotificationCenter.default.post(name: .didUpdateNote, object: self)
    }
    
    func updateContent(_ content: NSAttributedString?) {
        self.content = content ?? NSAttributedString()
        NotificationCenter.default.post(name: .didUpdateNote, object: self)
    }
}

extension Note: Equatable {
    static func ==(lhs: Note, rhs: Note) -> Bool {
        return lhs === rhs
    }
}
