//
//  DateExtensions.swift
//  NotesExample-iOS
//
//  Created by Juan Francisco Miranda Aguilar on 13/04/2020.
//  Copyright © 2020 Juan Francisco Miranda Aguilar. All rights reserved.
//

import Foundation

extension Date {
	/// Converts the date to string using the short date and time style.
    func toString(style: DateStyleType = .short) -> String {
		var dateString: String?
		let modificationDate = self
		dateString = DateFormatter.localizedString(from: modificationDate, dateStyle: .short, timeStyle: .short)
		return dateString ?? ""
    }
}

public enum DateStyleType {
	case none
	case short
	case medium
	case long
	case full
}
