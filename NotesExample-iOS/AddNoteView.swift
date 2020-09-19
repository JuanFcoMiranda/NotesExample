//
//  AddNoteView.swift
//  NotesExample-iOS
//
//  Created by Juan Francisco Miranda Aguilar on 13/04/2020.
//  Copyright © 2020 Juan Francisco Miranda Aguilar. All rights reserved.
//

import SwiftUI

struct AddNoteView: View {
	@EnvironmentObject var db : DBData
	@State private var authors = [Author]()
	@Binding var show : Bool
	@State var title : String = ""
	@State var text : String = ""
	@State var note : Note = Note()
	@State private var selectedItem = 0
	@State var pickerItems = [String]()
	
	func saveNote() {
		DispatchQueue.main.async {
			self.note.title = self.title
			self.note.text = self.text
			if self.selectedItem > 0 {
				self.note.author.target = self.authors[self.selectedItem - 1]
			}
			
			try! self.db.noteBox.put(self.note)

			self.show = false
		}
	}
	
	@ViewBuilder
    var body: some View {
		NavigationView {
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
									TextField("Title", text: self.$title)
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
										Picker(selection: self.$selectedItem, label: Text("")) {
											ForEach(0..<self.pickerItems.count, id: \.self) {
												Text(self.pickerItems[$0])
											}
										}
										//.pickerStyle(WheelPickerStyle())
									}
								}.frame(maxWidth: .infinity)
								VStack(alignment: .leading) {
									Text("Text")
								}
								VStack {
									TextViewUI(text: self.$text)
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
				.navigationBarTitle("Create Note", displayMode: .inline)
				.navigationBarItems(
					leading: Button(action: { self.show.toggle() }, label: { Text("Cancel") }),
					trailing: Button(action: self.saveNote, label: { Text("Save") })
				)
				.onAppear {
					DispatchQueue.main.async {
						self.authors = try! self.db.authorBox.all().sorted(by: { $0.name < $1.name })
						self.pickerItems = self.authors
							.map { $0.name }
							.prepending("(None)")
					}
				}
			}
			.onAppear {
				DispatchQueue.main.async {
					self.authors = try! self.db.authorBox.all().sorted(by: { $0.name < $1.name })
					self.pickerItems = self.authors.map { $0.name }.prepending("(None)")
				}
			}
		}
    }
}

struct AddNoteView_Previews: PreviewProvider {
    static var previews: some View {
		AddNoteView(show: .constant(false), note: Note())
    }
}

extension Array {
    func prepending(_ element: Element) -> [Element] {
        var result = [element]
        result.append(contentsOf: self)
        return result
    }
}
