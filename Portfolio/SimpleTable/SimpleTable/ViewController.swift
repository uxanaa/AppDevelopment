//
//  ViewController.swift
//  SimpleTableExample
//
//  Created by Uxanaa S on 13/10/2022.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    let my2DArray = [["Emma","Tanisha","Gabi","Ekose"],["Mulan","Hulk","Thor","Black Widow"]]
    
    func numberOfSections(in tableView: UITableView) -> Int{
        return my2DArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return my2DArray[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellTitle = my2DArray[indexPath.section][indexPath.row]
        let aCell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        aCell.textLabel?.text = cellTitle
      
       
  
        return aCell
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

