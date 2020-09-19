//
//  AuthorsView.swift
//  NotesExample-iOS
//
//  Created by Juan Francisco Miranda Aguilar on 12/04/2020.
//  Copyright © 2020 Juan Francisco Miranda Aguilar. All rights reserved.
//

import SwiftUI

struct AuthorsView: View {
	@EnvironmentObject var db : DBData
	@State var show = false
	@State var authors = [Author]()
	
	func loadData() {
		self.authors = try! db.authorBox.all()
	}
	
	func removeAuthor(author : Author) {
		try! self.db.authorBox.remove(author)
		self.loadData()
	}
	
	var body: some View {
		List {
			ForEach(authors) { author in
				NavigationLink(destination: AuthorView(author: author)) {
					HStack {
						VStack(alignment: .leading) {
							Text(author.name)
						}
						Spacer()
						VStack(alignment: .trailing)  {
							Text("\(author.notes.count) Note" + ((author.notes.count > 1 || author.notes.count == 0) ? "s" : ""))
						}
					}.frame(maxWidth: .infinity)
				}
			}
			.onDelete { index in
				if let first = index.first {
					let deleted = self.authors[first]
					self.removeAuthor(author: deleted)
				}
			}
		}
		.onAppear {
			DispatchQueue.main.async {
				self.loadData()
			}
		}
		.navigationBarTitle("Authors")
		.navigationBarItems(
			trailing: HStack(spacing: 16) {
				EditButton()
				Button(action: { self.show.toggle() }, label: {Image(systemName: "plus")})
			}
		)
		.sheet(isPresented: self.$show, onDismiss: self.loadData) {
			AddAuthorView(show: self.$show).environmentObject(self.db)
		}
	}
}

struct AuthorsView_Previews: PreviewProvider {
	static var previews: some View {
		AuthorsView()
	}
}
