//
//  DrinkDetailVC.swift
//  DrinkApp
//
//  Created by Nick Harvey on 8/23/20.
//  Copyright © 2020 Nick Harvey. All rights reserved.
//

import UIKit

class DrinkDetailVC: UIViewController, DrinksAPIDelegate {
    
    var drinkName: String?
    var drinkImage: String?
    var selectedDrink:Drink?
    var activityIndicator:UIActivityIndicatorView?
    
    var drinkImageView = UIImageView()
    var drinkNameLabel = UILabel()
    var ingredientsListLabel = UILabel()
    var insturctionsListLabel = UILabel()
    var instructionsLabel = UILabel()
    var ingredientsLabel = UILabel()
    
    let api:DrinksAPI = DrinksAPI()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        //start an activity indicator to show while content loads
        activityIndicator = UIActivityIndicatorView()
        activityIndicator?.frame = view.bounds
        view.addSubview(activityIndicator!)
        activityIndicator?.startAnimating()
        self.api.delegate = self

    }
    
    override func viewDidAppear(_ animated: Bool) {
        // make sure selectedDrink is not nil
        if let drink = self.selectedDrink {
            self.drinkName = drink.strDrink
            self.drinkImage = drink.strDrinkThumb
            self.view.addSubview(drinkImageView)
            self.view.addSubview(drinkNameLabel)
            self.view.addSubview(ingredientsListLabel)
            self.view.addSubview(insturctionsListLabel)
            self.view.addSubview(instructionsLabel)
            self.view.addSubview(ingredientsLabel)
            configureImageView()
            configureNameLabel()
            configureDetails()
            configureInstructions()
            setImageConstrainsts()
            setNameConstraints()
            setDetailsConstraints()
            setInstructionsConstraints()
            self.api.delegate = self
            api.getDrinkDetails(drink_id: selectedDrink!.idDrink)
            getImage()
            
        }
    }
    
    // get the image from url for the details page
    func getImage() {

        if drinkImage != nil {
            let drinkThumbUrl = URL(string: drinkImage!)
            let request = URLRequest(url: drinkThumbUrl!)
            
            let configuration = URLSessionConfiguration.default
            let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
            
            let task = session.dataTask(with: request) { (data,response,error) in
                if (error != nil) {
                    print("Error in dataTask")
                }
                else {
                    DispatchQueue.global(qos: .userInitiated).async {
                        let imageView = self.drinkImageView
                        
                        DispatchQueue.main.async {
                            // stop activity indicator and set image and label
                            self.activityIndicator?.stopAnimating()
                            self.activityIndicator?.removeFromSuperview()
                            imageView.image = UIImage(data: data!)
                            self.drinkNameLabel.text = self.selectedDrink?.strDrink
                            
                            
                        }
                        
                    }
                }
            }
            task.resume()
        }
    }

    func configureImageView() {
        drinkImageView.clipsToBounds = true
    }
    
    func configureNameLabel() {
        drinkNameLabel.numberOfLines = 0
        drinkNameLabel.adjustsFontSizeToFitWidth = true
        drinkNameLabel.textAlignment = NSTextAlignment.center
    }
    
    func configureDetails() {
         ingredientsListLabel.textAlignment = NSTextAlignment.center
         ingredientsListLabel.contentMode = .scaleToFill
         ingredientsListLabel.numberOfLines = 0
         
         ingredientsLabel.text = "Ingredients: "
         ingredientsLabel.textAlignment = NSTextAlignment.center
         ingredientsLabel.contentMode = .scaleToFill
         ingredientsLabel.numberOfLines = 0
         
     }
     
     func configureInstructions() {
         insturctionsListLabel.textAlignment = NSTextAlignment.center
         insturctionsListLabel.contentMode = .scaleToFill
         insturctionsListLabel.numberOfLines = 0
         
         instructionsLabel.text = "Instructions: "
         instructionsLabel.textAlignment = NSTextAlignment.center
         instructionsLabel.contentMode = .scaleToFill
         instructionsLabel.numberOfLines = 0
     }
    
    func setImageConstrainsts() {
        drinkImageView.translatesAutoresizingMaskIntoConstraints = false
        drinkImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        drinkImageView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        drinkImageView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        drinkImageView.heightAnchor.constraint(equalTo: drinkImageView.widthAnchor).isActive = true
    }
    
    func setNameConstraints() {
        drinkNameLabel.translatesAutoresizingMaskIntoConstraints = false
        drinkNameLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        drinkNameLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        drinkNameLabel.topAnchor.constraint(equalTo: drinkImageView.bottomAnchor, constant: 10).isActive = true
        drinkNameLabel.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
    }
    
    func setInstructionsConstraints() {
        insturctionsListLabel.translatesAutoresizingMaskIntoConstraints = false
        insturctionsListLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        insturctionsListLabel.topAnchor.constraint(equalTo: instructionsLabel.bottomAnchor, constant: 10).isActive = true
        insturctionsListLabel.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        
        instructionsLabel.translatesAutoresizingMaskIntoConstraints = false
        instructionsLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        instructionsLabel.topAnchor.constraint(equalTo: ingredientsListLabel.bottomAnchor, constant: 30).isActive = true
        instructionsLabel.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
    }
    
    func setDetailsConstraints() {
        ingredientsListLabel.translatesAutoresizingMaskIntoConstraints = false
        ingredientsListLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        ingredientsListLabel.topAnchor.constraint(equalTo: ingredientsLabel.bottomAnchor, constant: 10).isActive = true
        ingredientsListLabel.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        
        ingredientsLabel.translatesAutoresizingMaskIntoConstraints = false
        ingredientsLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        ingredientsLabel.topAnchor.constraint(equalTo: drinkNameLabel.bottomAnchor, constant: 30).isActive = true
        ingredientsLabel.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
    }
    
    // delegate will call this function when api call finishes
    func dataReady() {
        /// set the selectedDrink to include all the details data
        self.selectedDrink = self.api.drinkWithDetails
        // set insturctions label text once the data has been downloaded
        self.insturctionsListLabel.text = self.selectedDrink?.strInstructions
        setDetailsArray()
    }
    
    func setDetailsArray() {
        
        // checks if each ingredient is not empty then adds it to an array
        var arrayIngredients = [String]()
        if (self.selectedDrink?.strIngredient1 != "") {
            arrayIngredients.append(self.selectedDrink!.strIngredient1 + ", ")
        }
        if (self.selectedDrink?.strIngredient2 != "") {
            arrayIngredients.append(self.selectedDrink!.strIngredient2 + ", ")
        }
        if (self.selectedDrink?.strIngredient3 != "") {
            arrayIngredients.append(self.selectedDrink!.strIngredient3 + ", ")
        }
        if (self.selectedDrink?.strIngredient4 != "") {
            arrayIngredients.append(self.selectedDrink!.strIngredient4 + ", ")
        }
        if (self.selectedDrink?.strIngredient5 != "") {
            arrayIngredients.append(self.selectedDrink!.strIngredient5 + ", ")
        }
        if (self.selectedDrink?.strIngredient6 != "") {
            arrayIngredients.append(self.selectedDrink!.strIngredient6 + ", ")
        }
        if (self.selectedDrink?.strIngredient7 != "") {
            arrayIngredients.append(self.selectedDrink!.strIngredient7 + ", ")
        }
        if (self.selectedDrink?.strIngredient8 != "") {
            arrayIngredients.append(self.selectedDrink!.strIngredient8 + ", ")
        }
        if (self.selectedDrink?.strIngredient9 != "") {
            arrayIngredients.append(self.selectedDrink!.strIngredient9 + ", ")
        }
        if (self.selectedDrink?.strIngredient10 != "") {
            arrayIngredients.append(self.selectedDrink!.strIngredient10)
        }
        // set the arary as the ingredients lisst label text
        self.ingredientsListLabel.text = arrayIngredients.joined()
    }

}
