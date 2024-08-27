//
//  ViewController.swift
//  TableAndDetail
//
//  Created by Uxanaa S on 18/12/2022.
//

import UIKit


var selectedPerson = ("","","")

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
        
    private var staff =
    [ ("Phil", "A1.20", "phil@liverpool.ac.uk"), ("Terry", "A2.18", "trp@liverpool.ac.uk"), ("Valli", "A2.12", "V.Tamma@liverpool.ac.uk"), ("Boris", "A1.15", "Konev@liverpool.ac.uk")]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        staff.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"myCell",for:indexPath)
        var content = UIListContentConfiguration.cell()
        (content.text,_,_) = staff[indexPath.row]
        cell.contentConfiguration = content
        
        //MARK - adds disclosure indicator accessory
        cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedPerson = staff[indexPath.row]
        performSegue(withIdentifier: "toDetail", sender: nil)
    }
    
    // MARK: lets user delete cell
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            staff.remove(at: indexPath.row)

            tableView.deleteRows(at: [indexPath], with: .fade)

        }
    }

    
}
