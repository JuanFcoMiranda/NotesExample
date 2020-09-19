//
//  DBData.swift
//  NotesExample-iOS
//
//  Created by Juan Francisco Miranda Aguilar on 12/04/2020.
//  Copyright © 2020 Juan Francisco Miranda Aguilar. All rights reserved.
//

import SwiftUI
import ObjectBox

final class DBData: ObservableObject {
    private let store: Store!
    let authorBox: Box<Author>
    let noteBox: Box<Note>

	init() {
        self.store = try! Store.createStore()

        authorBox = self.store.box(for: Author.self)
        noteBox = self.store.box(for: Note.self)
    }

	func setupDemoNotes() throws {
        guard try noteBox.isEmpty() && authorBox.isEmpty() else { return }

        try replaceWithDemoData()
    }
	
    func replaceWithDemoData() throws {
        try noteBox.removeAll()
        try authorBox.removeAll()

        let peterBrett = Author(name: "Peter V. Brett")
        let georgeMartin = Author(name: "George R. R. Martin")
        try authorBox.put([peterBrett, georgeMartin])

        try noteBox.put([
            Note(title: "Unclaimed idea", text: "This writing is not by anyone in particular."),
            peterBrett.writeNote(title: "The Warded Man", text: "I should make a movie from this book after writing the next novel."),
            peterBrett.writeNote(title: "Daylight War", text: "Who picked the cover art for this? It certainly wasn't me or someone else with taste."),
            georgeMartin.writeNote(title: "Game of Thrones", text: "This book title would've been a better choice than this Ice & Fire stuff all along. Boy, writing this takes long in DOS.")
            ])
    }
}

extension Store {
    /// Creates a new ObjectBox.Store in a temporary directory.
    static func createStore() throws -> Store {
		let documentsDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
		let destPath = URL(fileURLWithPath: documentsDirectory!)
		if !FileManager.default.fileExists(atPath: destPath.path) {
			try FileManager.default.createDirectory(at: destPath, withIntermediateDirectories: false, attributes: nil)
		}
		return try Store(directoryPath: destPath.path)
	}
}
