//
//  ViewController.swift
//  GuessGame
//
//  Created by Uxanaa S on 13/11/2022.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var guessBox: UITextField!
    @IBOutlet weak var guessMessage: UILabel!
    
    @IBAction func guessButton(_ sender: Any) {
        let diceRoll = Int.random(in: 2..<13)
        let userGuess = Int(guessBox.text!)
        let output = "You guessed right"
        let outputt = "You guessed wrong"
        if diceRoll == userGuess{
            guessMessage.text = output
        }
        else{
            guessMessage.text = outputt
        }
        guessBox.resignFirstResponder()
    }
    
 
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

