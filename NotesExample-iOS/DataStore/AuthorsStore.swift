//
//  AuthorsStore.swift
//  NotesExample-iOS
//
//  Created by Juan Francisco Miranda Aguilar on 16/04/2020.
//  Copyright © 2020 Juan Francisco Miranda Aguilar. All rights reserved.
//

import SwiftUI

class AuthorsStore: ObservableObject {
	@EnvironmentObject var db : DBData
    @Published var authors: [Author] = []
    
	init() {
        fetchAuthors()
    }
    
    func fetchAuthors() {
		self.authors = try! db.authorBox.all()
    }
}
