//
//  CreatedProgramsListTableViewController.swift
//  Workout
//
//  Created by Chris Grayston on 4/4/19.
//  Copyright © 2019 Chris Grayston. All rights reserved.
//

import UIKit

class CreatedProgramsListTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Call ProgramController to fetch programs array
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1 // ProgramController.shared.programs.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Cast as custom cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "createdProgram", for: indexPath)

        // Get created program at current IndexPath.row
        //let program = ProgramController.shared.programs[indexPath.row]
        
        // Pass program to custom cell to display
        //cell.program = program
        
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
    

}
