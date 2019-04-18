//
//  ExerciseCreationViewController.swift
//  Workout
//
//  Created by Chris Grayston on 4/5/19.
//  Copyright © 2019 Chris Grayston. All rights reserved.
//

import UIKit

class ExerciseCreationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    // MARK: - Properties
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var setsLabel: UILabel!
    
    @IBOutlet weak var repsTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var setsCount: Int = 0
    
    // MARK: - Landing Pad
    var exercise: Exercise? {
        didSet {
            loadViewIfNeeded()
            // Update Views
            updateViews()
        }
    }
    
    func updateViews() {
        guard let exercise = exercise  else { return }
        nameTextField.text = exercise.name
        photoImageView.image = UIImage(named: "300-Pound-Bench")
        setsLabel.text = "\(exercise.setsCount)"
        repsTextField.text = exercise.reps
        setsCount = exercise.setsCount
    }
    
    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set delegates
        tableView.delegate = self
        tableView.dataSource = self
        
        self.hideKeyboardWhenTappedAround()
        
    }
    
    // MARK: - Delegate Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return setsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "setCell", for: indexPath) as? SetsCreationTableViewCell else { return UITableViewCell() }
        
        cell.setNumber = indexPath.row + 1
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellHeight = UIScreen.main.bounds.height * 0.07
        if cellHeight < 50 {
            return 50
        } else {
            return cellHeight
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    @IBAction func saveExerciseInfoButtonTapped(_ sender: UIButton) {
        // TODO delete
//        // Save to Firestore
//        guard let exercise = exercise,
//            let name = nameTextField.text,
//            //let description = "",
//            let sets = setsTextField.text,
//            let reps = repsTextField.text else { return }
//        ExerciseController.shared.updateExercise(exercise: exercise, name: name, description: "", sets: sets, setsCount: setsCount, reps: reps, photoURL: "") { (success) in
//            if success {
//                // TODO present alert
//            }
//        }
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        // Save to Firestore
        guard let exercise = exercise,
            let name = nameTextField.text,
            //let description = "",
            let sets = setsLabel.text,
            let reps = repsTextField.text else { return }
        ExerciseController.shared.updateExercise(exercise: exercise, name: name, description: "", sets: sets, setsCount: setsCount, reps: reps, photoURL: "") { (success) in
            if success {
                // TODO present alert
            }
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func removeSetTextField(_ sender: UIButton) {
        // Decrement setsCount
        if setsCount > 0 {
            setsCount = setsCount - 1
            setsLabel.text = "\(setsCount)"
            tableView.reloadData()
        } else {
            let alert = UIAlertController(title: "Can't Minus Set!", message: "You can't have less than 0 sets", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true)
        }
    }
    
    @IBAction func addSetTextField(_ sender: UIButton) {
        // Decrement setsCount
        if setsCount < 11 {
            setsCount = setsCount + 1
            setsLabel.text = "\(setsCount)"
            tableView.reloadData()
        } else {
            let alert = UIAlertController(title: "Can't Add Set!", message: "That's a lot of sets. Maybe work something else", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true)
        }
    }
    
}
