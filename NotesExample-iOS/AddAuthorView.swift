//
//  AddAuthorView.swift
//  NotesExample-iOS
//
//  Created by Juan Francisco Miranda Aguilar on 14/04/2020.
//  Copyright © 2020 Juan Francisco Miranda Aguilar. All rights reserved.
//

import SwiftUI

struct AddAuthorView: View {
	@State var name : String = ""
	@Binding var show : Bool
	@State var author : Author = Author()
	@EnvironmentObject var db : DBData
	
	func saveAuthor() {
		author.name = name
		try! db.authorBox.put(author)
		
		show = false
	}
	
	var body: some View {
		NavigationView {
			Form {
				Section(header:
					HStack {
						Text("Author Details".uppercased())
							.font(.footnote)
							.foregroundColor(Color.gray.opacity(0.9))
							.padding(.top, 28)
							.padding(.horizontal, 20)
						Spacer()
					}.background(Color.gray.opacity(0.1))) {
						List {
							VStack(alignment: .leading) {
								TextField("Name", text: self.$name)
									.keyboardType(.default)
									.font(.subheadline)
									.padding(.leading)
									.frame(height: 44)
									.frame(maxWidth: .infinity)
							}
						}
				}
				.background(Color.white)
			}
			.background(Color.gray.opacity(0.1)).edgesIgnoringSafeArea(.bottom)
			.navigationBarTitle("Create Author", displayMode: .inline)
			.navigationBarItems(
				leading: Button(action: { self.show.toggle() }, label: { Text("Cancel") }),
				trailing: Button(action: self.saveAuthor, label: { Text("Save") })
			)
		}
	}
}

struct AddAuthorView_Previews: PreviewProvider {
    static var previews: some View {
        AddAuthorView(show: .constant(true), author: Author())
    }
}
