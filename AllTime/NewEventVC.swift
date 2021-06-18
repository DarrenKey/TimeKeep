//
//  NewEventVC.swift
//  Calendar
//
//  Created by Mi Yan on 12/31/19.
//  Copyright © 2019 Darren Key. All rights reserved.
//
/*
import UIKit

class NewEventVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate{

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var eventName: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        eventName.delegate = self
        // Do any additional setup after loading the view.
    }
    @IBAction func exitWOSavingPressed(_ sender: Any) {
        performSegue(withIdentifier: "toMain", sender: nil)
    }
    
    
    //if user touches anywhere or presses return keyboard closed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    @IBAction func confirmButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "toMain", sender: nil)
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Singleton.categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellC") as! ColorCellinCategoryVC
        
        cell.insideCircle.tintColor = Singleton.colorsC[indexPath.row]
        cell.backgroundColor = UIColor.clear
        cell.labelT.text = Singleton.categories[indexPath.row]
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.white.cgColor
        return cell
    }
    
        
       
        
}
*/
