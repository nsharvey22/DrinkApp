//
//  DrinksAPI.swift
//  DrinkApp
//
//  Created by Nick Harvey on 8/22/20.
//  Copyright © 2020 Nick Harvey. All rights reserved.
//

import UIKit
import Alamofire

protocol DrinksAPIDelegate {
    func dataReady()
}

class DrinksAPI: NSObject {
    
    let API_KEY = "1"
    var drinkArray = [Drink]()
    var drinkWithDetails = Drink()
    var delegate:DrinksAPIDelegate?
    
    
    // api call to get a list of drinks including id, name, and thumbnail url
    func getDrinks() {
        let request = AF.request("https://www.thecocktaildb.com/api/json/v1/1/filter.php?a=Alcoholic")
        request.responseJSON { (response) in
            guard let data = response.data else { return }

            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:Any]
                let drinks = json?["drinks"] as? [[String: Any]] ?? []
                
                // parse the json into a Drink object
                for item in drinks as NSArray {
                    let drinkObj = Drink()
                    drinkObj.idDrink = (item as AnyObject).value(forKeyPath: "idDrink") as? String ?? ""
                    drinkObj.strDrink = (item as AnyObject).value(forKeyPath: "strDrink") as? String ?? ""
                    drinkObj.strDrinkThumb = (item as AnyObject).value(forKeyPath: "strDrinkThumb") as? String ?? ""
                    
                    // append each drink object to an array to use for each tableview cell
                    self.drinkArray.append(drinkObj)
                    
                    if self.delegate != nil {
                        self.delegate?.dataReady()
                    }
                }
                
            }catch{
                print("Unexpected error: \(error).")
            }

        }
        
    }
    
    
    // api call to get further details a specific drink id including ingredients, insturcionts, etc.
    func getDrinkDetails(drink_id: String) {
        let request = AF.request("https://www.thecocktaildb.com/api/json/v1/1/lookup.php?i=\(drink_id)")
        request.responseJSON { (response) in
            guard let data = response.data else { return }

            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:Any]

                let drinks = json?["drinks"] as? [[String: Any]] ?? []
                
                // parse the json into a Drink object
                for item in drinks as NSArray {
                    let drinkObj = self.drinkWithDetails
                    drinkObj.idDrink = (item as AnyObject).value(forKeyPath: "idDrink") as? String ?? ""
                    drinkObj.strDrink = (item as AnyObject).value(forKeyPath: "strDrink") as? String ?? ""
                    drinkObj.strDrinkThumb = (item as AnyObject).value(forKeyPath: "strDrinkThumb") as? String ?? ""
                    drinkObj.strIngredient1 = (item as AnyObject).value(forKeyPath: "strIngredient1") as? String ?? ""
                    drinkObj.strIngredient2 = (item as AnyObject).value(forKeyPath: "strIngredient2") as? String ?? ""
                    drinkObj.strIngredient3 = (item as AnyObject).value(forKeyPath: "strIngredient3") as? String ?? ""
                    drinkObj.strIngredient4 = (item as AnyObject).value(forKeyPath: "strIngredient4") as? String ?? ""
                    drinkObj.strIngredient5 = (item as AnyObject).value(forKeyPath: "strIngredient5") as? String ?? ""
                    drinkObj.strIngredient6 = (item as AnyObject).value(forKeyPath: "strIngredient6") as? String ?? ""
                    drinkObj.strIngredient7 = (item as AnyObject).value(forKeyPath: "strIngredient7") as? String ?? ""
                    drinkObj.strIngredient8 = (item as AnyObject).value(forKeyPath: "strIngredient8") as? String ?? ""
                    drinkObj.strIngredient9 = (item as AnyObject).value(forKeyPath: "strIngredient9") as? String ?? ""
                    drinkObj.strIngredient10 = (item as AnyObject).value(forKeyPath: "strIngredient10") as? String ?? ""
                    drinkObj.strInstructions = (item as AnyObject).value(forKeyPath: "strInstructions") as? String ?? ""
                    
                    // now that drink object has all the detail members, call the delegate functions so content updates on the details page
                    if self.delegate != nil {
                        self.delegate?.dataReady()
                    }
                }
                
                
            }catch{
                print("Unexpected error: \(error).")
            }

        }
    }
}
