//
//  NotesViewController+.swift
//  Prynote2
//
//  Created by Yi Tong on 12/11/19.
//  Copyright © 2019 tongyi. All rights reserved.
//

import UIKit

extension NotesViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        stateCoordinator?.selectedNote = getNote(in: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notebook.getCountOfNote()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constant.Identifier.NOTECELL, for: indexPath) as! NoteCell
        let note = notebook.notes[indexPath.row]
        
        configure(cell, with: note)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    private func getNote(in indexPath: IndexPath) -> Note {
        return notebook.notes[indexPath.row]
    }
    
    private func configure(_ cell: NoteCell, with note: Note) {
        cell.titleLabel.text = note.title.string
        cell.detailLabel.text = note.content.string
        cell.dateLabel.text = note.lastUpdateDate.formattedDate
    }
}
