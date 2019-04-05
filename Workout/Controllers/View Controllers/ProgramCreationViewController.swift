//
//  CreateNewProgramViewController.swift
//  Workout
//
//  Created by Chris Grayston on 4/5/19.
//  Copyright © 2019 Chris Grayston. All rights reserved.
//

import UIKit

class ProgramCreationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate {
    
    
    // MARK: - Properties
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var programNameTextField: UITextField!
    @IBOutlet weak var programDescriptionTextView: UITextView!
    @IBOutlet weak var programImageView: UIImageView!
    
    // MARK: - Landing Pad
    var program: Program? {
        didSet {
            loadViewIfNeeded()
            updateViews()
        }
    }
    
    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Set delegates
        tableView.delegate = self
        tableView.dataSource = self
        
        programDescriptionTextView.text = "Program Description..."
        programDescriptionTextView.textColor = UIColor.lightGray
        programDescriptionTextView.font = UIFont(name: "verdana", size: 13.0)
        programDescriptionTextView.returnKeyType = .done
        programDescriptionTextView.delegate = self
        //updateViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let programUID = program?.uid else { return }
        WorkoutController.shared.loadWorkouts(programUID: programUID) {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Text View Delegate Methods
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Program Description..." {
            textView.text = ""
            textView.textColor = UIColor.black
            //textView.font = UIFont(name: "verdana", size: 18.0)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
        }
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = "Program Description..."
            textView.textColor = UIColor.lightGray
            textView.font = UIFont(name: "verdana", size: 13.0)
        }
    }
    
    // MARK: - Helper Methods
    func updateViews() {
        guard let program = program else { return }
        if program.name == "" {
            programNameTextField.placeholder = "Program Title..."
        } else {
            programNameTextField.text = program.name
        }
        
        if program.description == "" {
            programDescriptionTextView.text = "Program Description..."
        } else {
            programDescriptionTextView.text = program.description
        }
        
        if program.photoURL == "" {
            programImageView.image = UIImage(named: "300-Pound-Bench")
        }
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let programUID = program?.uid else { return }
        // Declare empty workout to assign if user creates a new workout
        var workout: Workout?
        
        // User clicked on the "+" bar button item
        if segue.identifier == "toCreateNewWorkoutVC" {
            let dispatchGroup = DispatchGroup()
            dispatchGroup.enter()
            
            WorkoutController.shared.createWorkout(programUID: programUID) { (success, createdWorkout) in
                if success {
                    print("Success creatign new workout. Should push")
                    
                    workout = createdWorkout
                    dispatchGroup.leave()
                } else {
                    print("Failure creating blank Workout, still will push?")
                }
            }
            
            // Pass Program we jsut created to CreateNewProgramVC
            dispatchGroup.notify(queue: .main) {
                guard let destinationVC = segue.destination as? WorkoutCreationViewController
                    else { return }
                
                // Pass workout we got from createWorkout call to the next VC
                guard let workout = workout else { return }
                destinationVC.workout = workout
            }
        }
        
        // User clicked on a created Program in tableView
        if segue.identifier == "toShowNewWorkoutVC" {
            guard let indexPath = tableView.indexPathForSelectedRow,
                let destinationVC = segue.destination as? WorkoutCreationViewController
                else { return }
            
            // Pass program we got from tableView to the next VC
            let workout = WorkoutController.shared.workouts[indexPath.row]
            destinationVC.workout = workout
        }
    }
    
    
    // MARK: - Table View Delegate Functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return WorkoutController.shared.workouts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "workoutCell", for: indexPath) as UITableViewCell
        let workout = WorkoutController.shared.workouts[indexPath.row]
        if workout.name == "" {
            cell.textLabel?.text = "Enter Workout Name..."
        } else {
            cell.textLabel?.text = workout.name
        }
        
        if workout.description == "" {
            cell.detailTextLabel?.text = "Enter Workout Description..."
        } else {
            cell.detailTextLabel?.text = workout.description
        }
        
        return cell
    }
    
    // Override to support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let workout = WorkoutController.shared.workouts[indexPath.row]
            
            WorkoutController.shared.deleteWorkout(workout: workout) { (success) in
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
    
    // MARK: - Actions
    @IBAction func saveProgramInfoButtonTapped(_ sender: Any) {
        // TODO photoURL change
        guard let program = program,
            let name = programNameTextField.text,
            var description = programDescriptionTextView.text
            else { return }
        
        if description == "Program Description..." {
            description = ""
        }
        // Update programs values
        ProgramController.shared.updateProgram(program: program, name: name, description: description, photoURL: "") { (success) in
            if success {
                let alert = UIAlertController(title: "Program Info Updated!", message: "Successfully updated \(name) program", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true)
            }
        }
    }
    
}
