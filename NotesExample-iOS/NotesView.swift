//
//  NotesView.swift
//  NotesExample-iOS
//
//  Created by Juan Francisco Miranda Aguilar on 12/04/2020.
//  Copyright © 2020 Juan Francisco Miranda Aguilar. All rights reserved.
//

import SwiftUI
import ObjectBox

struct NotesView: View {
	@EnvironmentObject var db : DBData
	@State var notes = [Note]()
	@State var show = false
	@State var authorId : Id?
	
	func loadData() {
		guard let id = authorId else {
			self.notes = try! db.noteBox.all()
			return
		}
		self.notes = try! db.noteBox.all().filter { note -> Bool in
			note.author.target?.id == id
		}
	}
	
	func removeNote(note : Note) {
		try! self.db.noteBox.remove(note)
		self.loadData()
	}
	
	var body: some View {
		List {
			ForEach(notes) { note in
				NavigationLink(destination: NoteView(note: note)) {
					VStack {
						VStack(alignment: .leading) {
							HStack {
								Text(note.title)
								Spacer()
							}
						}
						VStack(alignment: .trailing)  {
							HStack {
								if note.author.target?.name != nil {
									Text(note.author.target?.name ?? "")
										.font(.caption)
								} else {
									EmptyView()
								}
								Spacer()
							}
						}
					}
				}
			}
			.onDelete { index in
				if let first = index.first {
					let deleted = self.notes[first]
					self.removeNote(note: deleted)
				}
			}
		}
		.onAppear(perform: {
			DispatchQueue.main.async {
				self.loadData()
			}
		})
		.navigationBarTitle("Notes")
		.navigationBarItems(
			trailing: HStack(spacing: 16) {
				EditButton()
				Button(action: { self.show.toggle() }, label: { Image(systemName: "plus") })
			}
		)
		.sheet(isPresented: self.$show, onDismiss: { self.loadData() }) {
			AddNoteView(show: self.$show).environmentObject(self.db)
		}
	}
}

struct NotesView_Previews: PreviewProvider {
	static var previews: some View {
		NotesView()
	}
}
