//
//  MyProgramsTableViewController.swift
//  Workout
//
//  Created by Chris Grayston on 4/9/19.
//  Copyright © 2019 Chris Grayston. All rights reserved.
//

import UIKit

class MyProgramsTableViewController: UITableViewController {

    // MARK: - Properties
//    var followedPrograms: [Program]? {
//        didSet{
//            //tableView.reloadData()
//        }
//    }
//
//    var createdPrograms: [Program]? {
//        didSet{
//            //tableView.reloadData()
//        }
//    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = 200
        
        // Resign keyboard on tap
        self.hideKeyboardWhenTappedAround()
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadMyPrograms), name: NotificationCenterNames.programUpdated, object: nil)
        

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Get programs user follows
//        DispatchQueue.main.async {
//            ProgramController.shared.getUserFollowedAndCreatedPrograms { (followedPrograms, createdPrograms) in
//                self.followedPrograms = followedPrograms
//                self.createdPrograms = createdPrograms
//                self.tableView.reloadData()
//            }
//        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            
            return ProgramController.shared.followedPrograms.count
        }
        if section == 1 {
            return ProgramController.shared.createdPrograms.count //createdPrograms?.count ?? 0
        } else {
            return 0
        }
    }
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 && ProgramController.shared.followedPrograms.count > 0 {
            
            return "Followed Programs"
        }
//        if section == 1 && createdPrograms?.count ?? 0 > 0 {
//            return "Created Programs"
//        }
        if section == 1 && ProgramController.shared.createdPrograms.count > 0{
            return "Created Programs"
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "programsCell", for: indexPath) as? CreatedProgramTableViewCell else { return UITableViewCell() }
        
        // Configure the cell...
        if indexPath.section == 0 {
            //guard let followedPrograms = followedPrograms else { return UITableViewCell() }
            let program = ProgramController.shared.followedPrograms[indexPath.row]
            cell.program = program
        } else if indexPath.section == 1 {
            //guard let createdPrograms = createdPrograms else { return UITableViewCell() }
            let program = ProgramController.shared.createdPrograms[indexPath.row]
            cell.program = program
        }
        return cell
    }
 
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        //TODO
        //
        if segue.identifier == "toProgramDetailVC" {
            //guard let destinationVC = segue.destination as? ProgramViewController else { return }
            guard let indexPath = tableView.indexPathForSelectedRow,
                let destinationVC = segue.destination as? ProgramViewController else { return }
            
            if indexPath.section == 0 {
                //guard let followedPrograms = followedPrograms else { return }
                let program = ProgramController.shared.followedPrograms[indexPath.row]
                destinationVC.program = program
            } else if indexPath.section == 1 {
                //guard let createdPrograms = createdPrograms else { return }
                let program = ProgramController.shared.createdPrograms[indexPath.row]
                destinationVC.program = program
            }

        }
    }
    
    // MARK: - Helper Methods
    @objc func loadMyPrograms(notification: NSNotification){
        //load data here
        
        self.tableView.reloadData()
    }
 

}
