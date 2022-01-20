//
//  ChatViewMessageCell.swift
//  tableView-mediaCells
//
//  Created by u.ochilov on 20.01.2022.
//

import UIKit

class ChatViewMessageCell: UITableViewCell {
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setupViews()
	}
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		setupViews()
	}
	
	override func prepareForReuse() {
	}
	
	class func estimatedHeight(for data: Message?) -> CGFloat {
		return UIScreen.main.bounds.height/2
	}
	
	// MARK: Data View config
	var message: Message? = nil {
		didSet { configure(with: message) }
	}
	func configure(with data: Message?) {
		guard let data = data else {
			timeLabel.text = "-:-"
			thumbView.image = nil
			thumbHeight.constant = 0
			return
		}
		
		bubbleType = data.direction == .incoming ? .incoming : .outgoing
		
		if #available(iOS 15.0, *) {
			timeLabel.text = Date.now.formatted(date: .omitted, time: .shortened)
		} else {
			timeLabel.text = "12:51"
		}
		thumbView.image = UIImage(named: data.media.name)
		
		let thumbSize = calculateThumbSize(from: data.media.size)
		thumbWidth.constant = thumbSize.width
		thumbHeight.constant = thumbSize.height
		self.needsUpdateConstraints()
	}
	
	func calculateThumbSize(from realSize: CGSize) -> CGSize {
		var size = realSize
		let realAspect = realSize.width / realSize.height
		let limitedAspect = min(max(realAspect, 1/1.25), 2)
		
		let maxWidth = UIScreen.main.bounds.width - 150
		let maxHeight = UIScreen.main.bounds.height / 2
		
		if (size.width > maxWidth) {
			size.width = maxWidth
			size.height = size.width / limitedAspect
		}
		if (size.height > maxHeight) {
			size.height = maxHeight
			size.width = size.height * limitedAspect
		}
		return size
	}
	
	enum BubbleType: Int {
		case incoming
		case outgoing
	}
	var bubbleType: BubbleType = .incoming {
		didSet { updateBubbleView() }
	}
	
	func updateBubbleView() {
		switch bubbleType {
		case .incoming:
			bubbleView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner]
			NSLayoutConstraint.deactivate(bubbleRightAnckorConstraints)
			NSLayoutConstraint.activate(bubbleLeftAnckorConstraints)
		case .outgoing:
			bubbleView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner, .layerMaxXMinYCorner]
			NSLayoutConstraint.deactivate(bubbleLeftAnckorConstraints)
			NSLayoutConstraint.activate(bubbleRightAnckorConstraints)
		}
	}
	
	// MARK: Views
	func setupViews() {
		selectionStyle = .none
		
		contentView.addSubview(bubbleView)
		contentView.addSubview(timeLabel)
		bubbleView.addSubview(thumbView)
		
		
		// for debug
		/*
		contentView.backgroundColor = .systemGreen
		bubbleView.backgroundColor = .systemBlue
		timeLabel.backgroundColor = .systemYellow
		timeLabel.textColor = .white
		timeLabel.text = "12:51"
		*/
		// ------------
		
		setupConstraints()
	}
	
	lazy var bubbleView: UIView = {
		let view = UIView()
		view.clipsToBounds = true
		view.layer.cornerRadius = 20
		view.translatesAutoresizingMaskIntoConstraints = false
		
		return view;
	}()
	
	lazy var timeLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
		label.textColor = .placeholderText
		label.translatesAutoresizingMaskIntoConstraints = false
		return label;
	}()
	
	lazy var thumbView: UIImageView = {
		let view = UIImageView()
		view.contentMode = .scaleAspectFill
		view.translatesAutoresizingMaskIntoConstraints = false
		return view;
	}()
	
	// MARK: Constraints
	var thumbWidth: NSLayoutConstraint!
	var thumbHeight: NSLayoutConstraint!
	var bubbleLeftAnckorConstraints: [NSLayoutConstraint] = []
	var bubbleRightAnckorConstraints: [NSLayoutConstraint] = []
	func setupConstraints() {
		thumbWidth = thumbView.widthAnchor.constraint(equalToConstant: 100)
		thumbHeight = thumbView.heightAnchor.constraint(equalToConstant: 100)
		// Случай для автоматического подсчёта высоты ячейки:
		// видимо система после расчёта добавляет некоторые округелния, в итоге возникает конфликт между
		// AutoLayout размером и 'UIView-Encapsulated-Layout-Height'
		// Решение: немного уменьшить приоритет констраинта.
		thumbHeight.priority = UILayoutPriority(rawValue: 999)
		
		NSLayoutConstraint.activate([
			thumbWidth, thumbHeight,
			
			thumbView.leftAnchor.constraint(equalTo: thumbView.superview!.leftAnchor),
			thumbView.rightAnchor.constraint(equalTo: thumbView.superview!.rightAnchor),
			thumbView.topAnchor.constraint(equalTo: thumbView.superview!.topAnchor),
			thumbView.bottomAnchor.constraint(equalTo: thumbView.superview!.bottomAnchor),
			
//			bubbleView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 13),
//			bubbleView.rightAnchor.constraint(lessThanOrEqualTo: contentView.rightAnchor, constant: -13),
			bubbleView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
			bubbleView.bottomAnchor.constraint(equalTo: timeLabel.topAnchor, constant: -5),
			
			timeLabel.heightAnchor.constraint(equalToConstant: 16),
			timeLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 40),
			timeLabel.leftAnchor.constraint(equalTo: bubbleView.leftAnchor),
			timeLabel.rightAnchor.constraint(greaterThanOrEqualTo: contentView.rightAnchor, constant: -13),
			timeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
		])
		
		bubbleLeftAnckorConstraints = [
			bubbleView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 13),
			bubbleView.rightAnchor.constraint(lessThanOrEqualTo: contentView.rightAnchor, constant: -13),
		]
		bubbleRightAnckorConstraints = [
			bubbleView.leftAnchor.constraint(greaterThanOrEqualTo: contentView.leftAnchor, constant: 13),
			bubbleView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -13),
		]
		NSLayoutConstraint.activate(bubbleType == .incoming ? bubbleLeftAnckorConstraints : bubbleRightAnckorConstraints)
	}
}
