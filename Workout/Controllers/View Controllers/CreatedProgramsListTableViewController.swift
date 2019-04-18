//
//  CreatedProgramsListTableViewController.swift
//  Workout
//
//  Created by Chris Grayston on 4/4/19.
//  Copyright © 2019 Chris Grayston. All rights reserved.
//

import UIKit

// Fetches and displays user created programs
class CreatedProgramsListTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = UIScreen.main.bounds.height * 0.15
        self.tableView.backgroundColor = .white
        self.tableView.separatorStyle = .none
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Call ProgramController to fetch programs array
        ProgramController.shared.loadPrograms {
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return ProgramController.shared.programs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Cast as custom cell
        /*guard*/ let cell = tableView.dequeueReusableCell(withIdentifier: "createdProgramCell", for: indexPath) as! CreatedProgramTableViewCell /*else { return UITableViewCell() }*/
        
        // Get created program at current IndexPath.row
        let program = ProgramController.shared.programs[indexPath.row]
        
        // Pass program to custom cell to display
        cell.program = program
        
        return cell
    }
    
    
    // TODO Deletion of Programs
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let program = ProgramController.shared.programs[indexPath.row]
            
            ProgramController.shared.deleteProgram(program: program) { (success) in
                if success {
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
            //tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        var program: Program?
        
        // User clicked on the "+" bar button item
        if segue.identifier == "toCreateNewProgramVC" {
            let dispatchGroup = DispatchGroup()
            dispatchGroup.enter()
            
            // Create new program locally and on Firestore
            ProgramController.shared.createProgram { (success, createdProgram) in
                if success {
                    print("Success. Should push")
                    
                    //self.tableView.reloadData()
                    program = createdProgram
                    
                    dispatchGroup.leave()
                } else {
                    print("Failure creating blank Program, still will push?")
                }
            }
            // Pass Program we jsut created to CreateNewProgramVC
            dispatchGroup.notify(queue: .main) {
                guard let destinationVC = segue.destination as? ProgramCreationViewController
                    else { return }
                
                // Pass program we got from createProgram call to the next VC
                guard let program = program else { return }
                destinationVC.program = program
            }
        }
        
        // User clicked on a created Program in tableView
        if segue.identifier == "toShowProgramDetailsVC" {
            guard let indexPath = tableView.indexPathForSelectedRow,
                let destinationVC = segue.destination as? ProgramCreationViewController
                else { return }
            
            // Pass program we got from tableView to the next VC
            let program = ProgramController.shared.programs[indexPath.row]
            destinationVC.program = program
        }
    }
}
