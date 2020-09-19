//
//  AuthorView.swift
//  NotesExample-iOS
//
//  Created by Juan Francisco Miranda Aguilar on 13/04/2020.
//  Copyright © 2020 Juan Francisco Miranda Aguilar. All rights reserved.
//

import SwiftUI

struct AuthorView: View {
	@EnvironmentObject var db: DBData
    @State var author: Author

    var body: some View {
		VStack {
			Section(header:
				HStack {
					Text("Author details".uppercased())
						.font(.footnote)
						.foregroundColor(Color.gray.opacity(0.9))
						.padding(.top, 28)
						.padding(.horizontal, 20)
					Spacer()
				}
				.background(Color.gray.opacity(0.1))) {
					List {
						VStack(alignment: .leading) {
							TextField(author.name, text: $author.name)
						}
						NavigationLink(destination: NotesView(authorId: author.id)) {
							HStack {
								VStack(alignment: .leading) {
									Text("\(author.notes.count) Note" + ((author.notes.count > 1 || author.notes.count == 0) ? "s" : ""))
								}
								Spacer()
								VStack(alignment: .trailing)  {
									Text("")
								}
							}.frame(maxWidth: .infinity)
						}
					}
			}
			.background(Color.white)
		}
		.onDisappear {
			try! self.db.authorBox.put(self.author)
		}
		.background(Color.gray.opacity(0.1)).edgesIgnoringSafeArea(.bottom)
    }
}

struct AuthorView_Previews: PreviewProvider {
    static var previews: some View {
		AuthorView(author: Author())
    }
}
