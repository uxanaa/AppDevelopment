//
//  ViewController.swift
//  Multiplication table
//
//  Created by Uxanaa Shashitharen on 17/12/2022.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var multNum = 0
    var divNum = 0.0
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textView: UITextField!
    @IBAction func goButton(_ sender: Any) {
        
        multNum = Int(textView.text!) ?? 0
        divNum = Double(textView.text!) ?? 0
        
        tableView.reloadData()
        textView.resignFirstResponder()
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int{
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        30
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "multiplicationCell", for: indexPath)
        
        if (indexPath.section == 0){
            cell.textLabel!.text = "\(indexPath.row + 1) X \(multNum) = \((indexPath.row + 1) * (multNum))"
        }
        if (indexPath.section == 1){
            cell.textLabel!.text = "\(Int(divNum)) / \(indexPath.row + 1) = \(String(format: "%.4f", (Double(divNum) / Double(indexPath.row + 1))))"
        }
    
        
        return cell
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

