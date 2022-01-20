//
//  ChatViewController.swift
//  tableView-mediaCells
//
//  Created by u.ochilov on 20.01.2022.
//

import UIKit

class ChatViewController: UIViewController {
	@IBOutlet weak var tableView: UITableView!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		tableView.register(ChatViewMessageCell.self, forCellReuseIdentifier: "cell")
		tableView.separatorStyle = .none
		
		loadData()
		tableView.reloadData()
    }
	
	var messages: [Message] = []
	func loadData() {
		messages = [
			.init(direction: .incoming, media: MessageMedia(type: .image, name: "msg1", size:.init(width: 352, height: 152))),
			.init(direction: .incoming, media: MessageMedia(type: .image, name: "msg2", size:.init(width: 1200, height: 892))),
			.init(direction: .outgoing, media: MessageMedia(type: .image, name: "msg3", size:.init(width: 354, height: 746))),
		]
	}
}

extension ChatViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return messages.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
		if let cell = cell as? ChatViewMessageCell {
			cell.message = messages[indexPath.row]
		}
		return cell
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return UITableView.automaticDimension
	}
	
	func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
		return ChatViewMessageCell.estimatedHeight(for: messages[indexPath.row]);
	}
}

extension ChatViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let message = messages[indexPath.row]
		if message.media.type == .image, message.media.name.count > 0 {
			if let image = UIImage(named: message.media.name) {
				showImage(image)
			}
		}
	}
	
	func showImage(_ image: UIImage) {
		let vc = UIViewController()
		
		let imageView = UIImageView()
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.contentMode = .scaleAspectFit
		imageView.image = image
		imageView.layer.borderWidth = 1
		imageView.layer.borderColor = UIColor.separator.cgColor
		vc.view.addSubview(imageView)
		NSLayoutConstraint.activate([
			imageView.leftAnchor.constraint(equalTo: vc.view.leftAnchor, constant: 5),
			imageView.rightAnchor.constraint(equalTo: vc.view.rightAnchor, constant: -5),
			imageView.topAnchor.constraint(equalTo: vc.view.topAnchor, constant: 5),
			imageView.bottomAnchor.constraint(equalTo: vc.view.bottomAnchor, constant: -5),
		])
		
		let closeButton = UIButton(type: .close)
		closeButton.translatesAutoresizingMaskIntoConstraints = false
		vc.view.addSubview(closeButton)
		NSLayoutConstraint.activate([
			closeButton.heightAnchor.constraint(equalToConstant: 40),
			closeButton.widthAnchor.constraint(equalToConstant: 40),
			closeButton.topAnchor.constraint(equalTo: vc.view.topAnchor, constant: 20),
			closeButton.leftAnchor.constraint(equalTo: vc.view.leftAnchor, constant: 20),
		])
		closeButton.addAction(for: .touchUpInside) {
			vc.dismiss(animated: true, completion: nil)
		}
		
		vc.view.backgroundColor = .systemBackground.withAlphaComponent(0.9)
		navigationController?.present(vc, animated: true, completion: nil)
	}
}

extension UIControl {
	func addAction(for controlEvents: UIControl.Event = .touchUpInside, _ closure: @escaping()->()) {
		addAction(UIAction { (action: UIAction) in closure() }, for: controlEvents)
	}
}
