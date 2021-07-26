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
        print("PRINT")
    }
    
    //MARK: - Setup Buttons
    
    private func setupButtons() {
        
        for _ in 1...5 {
            //Create button
            let button = UIButton()
            button.backgroundColor = .red
            
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
    
}
