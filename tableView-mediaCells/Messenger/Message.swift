//
//  Message.swift
//  tableView-mediaCells
//
//  Created by u.ochilov on 20.01.2022.
//

import Foundation
import UIKit

struct MessageMedia {
	enum MediaType: Int {
		case image
		case video
	}
	let type: MediaType
	let name: String
	let size: CGSize
	
	static let emptyMedia = MessageMedia(type: .image, name: "", size: .zero)
}

struct Message {
	enum Direction: Int {
		case incoming
		case outgoing
	}
	public var direction: Direction = .incoming
	public var text: String
	public var media: MessageMedia
	
	init(direction: Direction, text: String, media: MessageMedia = MessageMedia.emptyMedia) {
		self.direction = direction
		self.text = text
		self.media = media
	}
	
	init(direction: Direction, media: MessageMedia) {
		self.direction = direction
		self.text = ""
		self.media = media
	}
}
