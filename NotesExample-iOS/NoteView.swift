//
//  NoteView.swift
//  NotesExample-iOS
//
//  Created by Juan Francisco Miranda Aguilar on 13/04/2020.
//  Copyright © 2020 Juan Francisco Miranda Aguilar. All rights reserved.
//

import SwiftUI

struct NoteView: View {
	@EnvironmentObject var db : DBData
	@State private var authors = [Author]()
	@State var note: Note
	@State private var selectedItem = 0
	@State var pickerItems = [String]()

	func saveNote() {
		DispatchQueue.main.async {
			if self.selectedItem > 0 {
				self.note.author.target = self.authors[self.selectedItem - 1]
			}
			
			try! self.db.noteBox.put(self.note)
		}
	}
	
    var body: some View {
		GeometryReader { reader in
			Form {
				Section(header:
					HStack {
						Text("Metadata".uppercased())
							.font(.footnote)
							.foregroundColor(Color.gray.opacity(0.9))
							.padding(.top, 28)
							.padding(.horizontal, 20)
						Spacer()
					}.background(Color.gray.opacity(0.1))) {
						List {
							VStack(alignment: .leading) {
								TextField("Title", text: self.$note.title)
									.keyboardType(.default)
									.font(.subheadline)
									.padding(.leading)
									.frame(height: 44)
									.frame(maxWidth: .infinity)
							}
							VStack(alignment: .leading, spacing: 8) {
								HStack {
									Text("Created: \(self.note.creationDate.toString(style: .short))")
									
									Spacer()
								}
								HStack {
									Text("Modified: \(self.note.modificationDate != nil ? self.note.modificationDate?.toString(style: .short) ?? "" : "--")")
									
									Spacer()
								}
							}
							
							VStack {
								Section {
									Picker(selection: self.$selectedItem, label: Text("Author")) {
										ForEach(0..<self.pickerItems.count, id: \.self) {
											Text(self.pickerItems[$0])
										}
									}
								}
							}.frame(maxWidth: .infinity)
							VStack(alignment: .leading) {
								Text("Text")
							}
							VStack {
								TextViewUI(text: self.$note.text)
									.lineLimit(8)
									.keyboardType(.default)
									.frame(maxWidth: .infinity, maxHeight: .infinity)
									.frame(minHeight: reader.size.height / 3)
							}
						}
				}
				.background(Color.white)
			}
			.background(Color.gray.opacity(0.1)).edgesIgnoringSafeArea(.bottom)
			.navigationBarTitle("\(self.note.title)", displayMode: .inline)
			.onAppear {
				DispatchQueue.main.async {
					self.authors = try! self.db.authorBox.all().sorted(by: { $0.name < $1.name })
					self.pickerItems = self.authors.map { $0.name }.prepending("(None)")
					guard let author = self.note.author.target, let index = self.authors.firstIndex(where: { $0.name == author.name }) else { return }
					self.selectedItem = index+1
				}
			}
		}
    }
}

struct NoteView_Previews: PreviewProvider {
    static var previews: some View {
		NoteView(note: Note())
    }
}
