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
        
        // Call ProgramController to fetch programs array
        ProgramController.shared.loadPrograms {
            self.tableView.reloadData()
        }
        self.tableView.rowHeight = 200
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "createdProgram", for: indexPath) as? CreatedProgramTableViewCell else { return UITableViewCell() }

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
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
 

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
    @IBAction func addProgramButtonTapped(_ sender: UIBarButtonItem) {
        // User pressed add button
        // Create a Program to initilize Program's uid
        ProgramController.shared.createProgram { (success) in
            if success {
                print("Success. Should push")
                self.tableView.reloadData()
            } else {
                print("Failure creating blank Program, still will push?")
            }
        }
    }
    

}
