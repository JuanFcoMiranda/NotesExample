//
//  ContentView.swift
//  NotesExample-iOS
//
//  Created by Juan Francisco Miranda Aguilar on 12/04/2020.
//  Copyright © 2020 Juan Francisco Miranda Aguilar. All rights reserved.
//

import SwiftUI

struct ContentView: View {
	@EnvironmentObject var db : DBData
	@State var numNotes = 0
	@State var numAuthors = 0
	@State var show = false
	
	func replaceData() {
		DispatchQueue.main.async {
			try! self.db.replaceWithDemoData()
			self.loadData()
		}
	}
	
	func loadData() {
		let notes = try! db.noteBox.all()
		let authors = try! db.authorBox.all()
		
		numNotes = notes.count
		numAuthors = authors.count
	}
	
    var body: some View {
		NavigationView {
			Form {
				Section(header:
					Text("Lists".uppercased()).bold()
						.foregroundColor(Color.gray.opacity(0.7))
						.padding(.top, 20).padding(.bottom, 10)
				) {
					NavigationLink(destination: NotesView()) {
						HStack {
							VStack(alignment: .leading) {
								Text("All Notes")
							}
							Spacer()
							VStack(alignment: .trailing)  {
								Text("\(numNotes)")
							}
						}.frame(maxWidth: .infinity)
					}
					NavigationLink(destination: AuthorsView()) {
						HStack {
							VStack(alignment: .leading) {
								Text("All Authors")
							}
							Spacer()
							VStack(alignment: .trailing)  {
								Text("\(numAuthors)")
							}
						}.frame(maxWidth: .infinity)
					}
				}
				
				Section(header:
					Text("Options".uppercased()).bold()
						.foregroundColor(Color.gray.opacity(0.7))
						.padding(.top, 20).padding(.bottom, 10)
				) {
					HStack(alignment: .center) {
						Button(action: replaceData) {
							Text("Replace with Demo Data")
						}
						.buttonStyle(BorderlessButtonStyle())
						.frame(maxWidth: .infinity)
					}
				}
			}
			.onAppear(perform: {
				self.loadData()
			})
			.background(Color.gray.opacity(0.1)).edgesIgnoringSafeArea(.bottom)
				
			.navigationBarTitle("ObjectBox Demo", displayMode: .inline)
			.navigationBarItems(
				trailing: Button(action: { self.show.toggle() }) {
					Image(systemName: "plus")
				}
			).sheet(isPresented: self.$show, onDismiss: loadData) {
				AddNoteView(show: self.$show).environmentObject(self.db)
			}
		}
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
