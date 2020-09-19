//
//  TextViewUI.swift
//  NotesExample-iOS
//
//  Created by Juan Francisco Miranda Aguilar on 14/04/2020.
//  Copyright © 2020 Juan Francisco Miranda Aguilar. All rights reserved.
//

import SwiftUI

struct TextViewUI: UIViewRepresentable {
	typealias UIViewType = UITextView
	@Binding var text: String

	func makeUIView(context: UIViewRepresentableContext<TextViewUI>) -> UITextView {
		return UITextView()
	}

	func updateUIView(_ uiView: UITextView, context: UIViewRepresentableContext<TextViewUI>) {
		uiView.text = text
	}
}
