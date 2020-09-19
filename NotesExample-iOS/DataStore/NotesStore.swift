//
//  NotesStore.swift
//  NotesExample-iOS
//
//  Created by Juan Francisco Miranda Aguilar on 16/04/2020.
//  Copyright © 2020 Juan Francisco Miranda Aguilar. All rights reserved.
//

import SwiftUI

class NotesStore: ObservableObject {
	var db = DBData()
    @Published var notes: [Note] = []
    
	init() {
        fetchNotes()
    }
    
    func fetchNotes() {
		self.notes = try! db.noteBox.all()
    }
}
