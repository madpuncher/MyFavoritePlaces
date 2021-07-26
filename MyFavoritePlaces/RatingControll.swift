//
//  RatingControll.swift
//  MyFavoritePlaces
//
//  Created by Eʟᴅᴀʀ Tᴇɴɢɪᴢᴏᴠ on 26.07.2021.
//

import UIKit


class RatingControll: UIStackView {
    
    //MARK: - Properties
    private var ratingButtons = [UIButton]()
        
    var rating = 0
    
    //MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButtons()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupButtons()
    }
    
    //MARK: - Action Button
    @objc func ratingButtonTapped(_ button: UIButton) {
        guard let index = ratingButtons.firstIndex(of: button) else { return }
        let ratingNumber = index + 1
        
        if rating == ratingNumber {
            rating = 0
        } else {
            rating = ratingNumber
        }
        
        updateButtonSelected()
    }
    
    //MARK: - Setup Buttons
    
    private func setupButtons() {
        
        let filledStar = #imageLiteral(resourceName: "filledStar")
        let emptyStar = #imageLiteral(resourceName: "emptyStar")
        let highlightedStar = #imageLiteral(resourceName: "highlightedStar")
        
        for _ in 1...5 {
            
            //Create button
            let button = UIButton()
            button.setImage(emptyStar, for: .normal)
            button.setImage(filledStar, for: .selected)
            button.setImage(highlightedStar, for: .highlighted)
            button.setImage(highlightedStar, for: [.selected, .highlighted])
            
            //Add consttaints
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: 44.0).isActive = true
            button.widthAnchor.constraint(equalToConstant: 44.0).isActive = true
            
            //Add action
            button.addTarget(self, action: #selector(ratingButtonTapped(_:)), for: .touchUpInside)
            
            //Add the button to the stack
            addArrangedSubview(button)
            
            //Add the new button at the ranged buttons
            ratingButtons.append(button)
        }
    }
    
    private func updateButtonSelected() {
        for (index, button) in ratingButtons.enumerated() {
            button.isSelected = index < rating
        }
    }
}
