//
//  ViewController.swift
//  tableView-mediaCells
//
//  Created by u.ochilov on 20.01.2022.
//

import UIKit

class ViewController: UIViewController {
	@IBOutlet weak var horisontalSlider: UISlider!
	@IBOutlet weak var verticalSlider: UISlider!
	@IBOutlet weak var bubbleView: UIView!
	@IBOutlet weak var thambView: UIImageView!
	@IBOutlet weak var thumbWidth: NSLayoutConstraint!
	@IBOutlet weak var thumbHeight: NSLayoutConstraint!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		bubbleView.clipsToBounds = true
		bubbleView.layer.cornerRadius = 15
		bubbleView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner, .layerMaxXMinYCorner]
		
		horisontalSlider.minimumValue = 0
		horisontalSlider.maximumValue = Float(view.frame.width) - 20
		horisontalSlider.value = Float(thumbWidth.constant)
		
		verticalSlider.minimumValue = 0
		verticalSlider.maximumValue = Float(view.frame.height / 2) + 20
		verticalSlider.value = Float(thumbHeight.constant)
		
		horisontalSlider.addTarget(self, action: #selector(onSliderValueChanged(_:)), for: .valueChanged)
		verticalSlider.addTarget(self, action: #selector(onSliderValueChanged(_:)), for: .valueChanged)
		
		thambView.contentMode = .scaleAspectFill
	}

	@objc
	func onSliderValueChanged(_ slider: UISlider) {
		let constraint = slider == verticalSlider ? thumbHeight : thumbWidth
		constraint?.constant = CGFloat(slider.value)
	}
}

