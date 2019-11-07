//
//  ProgressTableViewController.swift
//  Workout
//
//  Created by Chris Grayston on 4/10/19.
//  Copyright © 2019 Chris Grayston. All rights reserved.
//

import UIKit

class ProgressTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundColor = .white
        self.tableView.separatorStyle = .none
        //navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.red]

    }
    

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        CompletedWorkoutController.shared.loadCompletedWorkouts {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return CompletedWorkoutController.shared.completedWorkouts.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "progessWorkoutCell", for: indexPath) as? ProgressTableViewCell else { return UITableViewCell() }

        let completedWorkout = CompletedWorkoutController.shared.completedWorkouts[indexPath.row]
        //cell.textLabel?.text = "\(getDayOfWeek(completedWorkout.dateCompleted.description))"
//        cell.textLabel?.text = DateHelper.dateFormatter.string(from: completedWorkout.dateCompleted)
//        cell.detailTextLabel?.text = "Program: \(completedWorkout.programName). Workout: \(completedWorkout.name)"
        
        cell.completedWorkout = completedWorkout

        return cell
    }
 
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            //tableView.deleteRows(at: [indexPath], with: .fade)
            let completedWorkout = CompletedWorkoutController.shared.completedWorkouts[indexPath.row]
            
            CompletedWorkoutController.shared.deleteCompletedWorkout(completedWorkout: completedWorkout) { (success) in
                if success {
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
 

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
        if segue.identifier == "toCompletedWorkoutVC" {
            // Get completed exercises
            guard let indexPath = tableView.indexPathForSelectedRow,
                let destinationVC = segue.destination as? CompletedWorkoutViewController
                else { return }
            
            let completedWorkout = CompletedWorkoutController.shared.completedWorkouts[indexPath.row]
            
            // Get completedExercises associated with this completedWorkout
            CompletedExerciseController.shared.getCompletedExercises(for: completedWorkout) { (completedExercises) in
                // Pass completed workout and exercises
                destinationVC.completedExercises = completedExercises
                destinationVC.completedWorkout = completedWorkout
            }
            
            
        }
    }
    
    func getDayOfWeek(_ today:String) -> Int? {
        let formatter  = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let todayDate = formatter.date(from: today) else { return nil }
        let myCalendar = Calendar(identifier: .gregorian)
        let weekDay = myCalendar.component(.weekday, from: todayDate)
        return weekDay
    }
 

}
