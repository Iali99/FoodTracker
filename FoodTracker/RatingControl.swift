//
//  RatingControl.swift
//  FoodTracker
//
//  Created by Irfan Ali on 30/11/18.
//  Copyright © 2018 Irfan Ali. All rights reserved.
//

import UIKit

@IBDesignable class RatingControl: UIStackView {
    
    //MARK: Properties
    private var ratingButtons = [UIButton]()
    var rating = 0 {
        didSet {
            updateButtonSelectionStates()
        }
    }
    @IBInspectable var starSize: CGSize = CGSize(width: 44.0, height: 44.0) {
        didSet {
            setupButtons()
        }
    }
    @IBInspectable var starCount: Int = 5 {
        didSet {
            setupButtons()
        }
    }
    
    //MARK: Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButtons()
    }
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupButtons()
    }
    
    //MARK: Button Action
    
    @objc func ratingButtonTapped(button : UIButton) {
        guard let index = ratingButtons.index(of : button) else {
            fatalError("The button, \(button), is not in the ratingButtons array: \(ratingButtons)")
        }
        
        // Calculate the rating of the selected button
        let selectedRating = index + 1
        
        if selectedRating == rating {
            rating = 0
        }
        else {
            rating = selectedRating
        }
    }
    //MARK: Private methods
    
    private func setupButtons(){
        // Remove any existing buttons
        for button in ratingButtons {
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        ratingButtons.removeAll()
        
        // Add new buttons
        
        let bundle = Bundle(for: type(of: self))
        let emptyStar = UIImage(named: "emptyStar", in: bundle, compatibleWith: self.traitCollection)
        let filledStar = UIImage(named: "filledStar", in: bundle, compatibleWith: self.traitCollection)
        let highlightedStar = UIImage(named: "highlightedStar", in: bundle, compatibleWith: self.traitCollection)
        for index in 0..<starCount {
            // Create a button
            let button = UIButton()
            
            // Set button images
            button.setImage(emptyStar, for: .normal)
            button.setImage(filledStar, for: .selected)
            button.setImage(highlightedStar, for: .highlighted)
            button.setImage(highlightedStar, for: [.highlighted,.selected])
            // Add constraints
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
            button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true
            
            // Set up the buttons accessibility lable
            button.accessibilityLabel = "set \(index + 1) star rating"
            
            // Setup the button action
            button.addTarget(self, action: #selector(RatingControl.ratingButtonTapped(button:)), for: .touchUpInside)
            
            // Add button to the stack
            addArrangedSubview(button)
            
            // Add the new button to the ratingButtons array
            ratingButtons.append(button)
            
        }
        
        updateButtonSelectionStates()
    }
    
    private func updateButtonSelectionStates() {
        for index in 0..<starCount {
            let button = ratingButtons[index]
            button.isSelected = index < rating
            
            // The accessibility hint
            let hint : String?
            if rating == index + 1 {
                hint = "Tap to reset the rating to 0"
            }
            else {
                hint = nil
            }
            
            // The accessibility value
            let value : String
            switch (rating) {
            case 0 :
                value = "No stars set"
            case 1 :
                value = "1 star set"
            default:
                value = "\(rating) stars set"
            }
            
            button.accessibilityHint = hint
            button.accessibilityValue = value
        }
    }
}
