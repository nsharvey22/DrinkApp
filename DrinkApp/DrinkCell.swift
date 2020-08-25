//
//  DrinkCell.swift
//  DrinkApp
//
//  Created by Nick Harvey on 8/22/20.
//  Copyright © 2020 Nick Harvey. All rights reserved.
//

import UIKit

class DrinkCell: UITableViewCell {
    
    var drinkImageView = UIImageView()
    var drinkNameLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(drinkImageView)
        addSubview(drinkNameLabel)
        
        configureImageView()
        configureNameLabel()
        setImageConstrainsts()
        setNameConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configureImageView() {
        drinkImageView.layer.cornerRadius = 10
        drinkImageView.clipsToBounds = true
    }
    
    func configureNameLabel() {
        drinkNameLabel.numberOfLines = 0
        drinkNameLabel.adjustsFontSizeToFitWidth = true
    }
    
    func setImageConstrainsts() {
        drinkImageView.translatesAutoresizingMaskIntoConstraints = false
        drinkImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        drinkImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12).isActive = true
        drinkImageView.heightAnchor.constraint(equalTo: heightAnchor, constant: -15).isActive = true
        drinkImageView.widthAnchor.constraint(equalTo: drinkImageView.heightAnchor).isActive = true
    }
    
    func setNameConstraints() {
        drinkNameLabel.translatesAutoresizingMaskIntoConstraints = false
        drinkNameLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        drinkNameLabel.leadingAnchor.constraint(equalTo: drinkImageView.trailingAnchor, constant: 20).isActive = true
        drinkNameLabel.heightAnchor.constraint(equalToConstant: 100).isActive = true
        drinkNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12).isActive = true
    }
}
