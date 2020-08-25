//
//  DrinksListVC.swift
//  DrinkApp
//
//  Created by Nick Harvey on 8/22/20.
//  Copyright © 2020 Nick Harvey. All rights reserved.
//

import UIKit

class DrinksListVC: UIViewController, DrinksAPIDelegate {
    
    var tableView = UITableView()
    var drinks:[Drink] = [Drink]()
    let api:DrinksAPI = DrinksAPI()
    var selectedDrink:Drink?
    
    // use Cells.drinkCell to avoid typos when trying to use "DrinkCell"
    struct Cells {
        static let drinkCell = "DrinkCell"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        
        self.api.delegate = self
        api.getDrinks()
    }
    
    func configureTableView() {
        view.addSubview(tableView)
        setTableViewDelegates()
        tableView.rowHeight = 100
        tableView.register(DrinkCell.self, forCellReuseIdentifier: Cells.drinkCell)
        tableView.pin(to: view)
    }
    
    func setTableViewDelegates()  {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func dataReady() {
        self.drinks = self.api.drinkArray
        self.tableView.reloadData()
    }

}

// all the table view functions here

extension DrinksListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return drinks.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.drinkCell) as! DrinkCell
        let image = cell.drinkImageView
        
        // using a blank image and text so activity indicator is the only thing shown until image is downloaded
        image.image = UIImage(named: "defaultCell")
        cell.drinkNameLabel.text = ""
        
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.frame = cell.bounds
        cell.addSubview(activityIndicator)
        activityIndicator.startAnimating()

        let drinkThumbUrl = URL(string: drinks[indexPath.row].strDrinkThumb)
        if drinkThumbUrl != nil {
            let request = URLRequest(url: drinkThumbUrl!)
            
            let configuration = URLSessionConfiguration.default
            let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
            
            let task = session.dataTask(with: request) { (data,response,error) in
                if (error != nil) {
                    print("Error in dataTask")
                }
                else {
                    DispatchQueue.global(qos: .userInitiated).async {
                        let imageView = cell.drinkImageView
                        
                        DispatchQueue.main.async {
                            // now image is downloaded to stop the activity indicator and set image and label
                            activityIndicator.stopAnimating()
                            activityIndicator.removeFromSuperview()
                            imageView.image = UIImage(data: data!)
                            let drinkName = self.drinks[indexPath.row].strDrink
                            cell.drinkNameLabel.text = drinkName
                        }
                        
                    }
                }
            }
            task.resume()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Take note of which drink the user selected
        self.selectedDrink = self.drinks[indexPath.row]
        // get a reference to the detail view controller to easily set selectedDrink in that veiw controller
        let detailViewController = DrinkDetailVC()
        detailViewController.selectedDrink = self.selectedDrink
        // navigate to that view controller
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}


