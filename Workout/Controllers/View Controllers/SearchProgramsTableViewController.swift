//
//  SearchProgramsTableViewController.swift
//  Workout
//
//  Created by Chris Grayston on 4/8/19.
//  Copyright © 2019 Chris Grayston. All rights reserved.
//

import UIKit

class SearchProgramsTableViewController: UITableViewController, UISearchBarDelegate {
    // MARK: - Properties
    var programs: [Program] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    
    // MARK: - IBOutlets
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        
        //self.hideKeyboard()
        self.hideKeyboardWhenTappedAround()
        
        self.tableView.rowHeight = UIScreen.main.bounds.height * 0.2
        
    }
    
    // MARK: - Table view data source
    
    override func touchesBegan(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // TODO
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // TODO
        return programs.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "searchedProgramCell", for: indexPath) as? SearchedProgramTableViewCell else { return UITableViewCell() }
        
        // Configure the cell...
        let program = programs[indexPath.row]
        cell.program = program
        
        return cell
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        // toProgramDetailVC
        if segue.identifier == "toProgramDetailVC" {
            guard let indexPath = tableView.indexPathForSelectedRow,
                let destinationVC = segue.destination as? AddProgramViewController else { return }
            let program = programs[indexPath.row]
            destinationVC.program = program
        }
    }
    
    // MARK: - Search Bar Delegate Methods
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        // Get search bar text
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // Get search bar text and make sure it is not empty
        
        if let text = searchBar.text, text != "" {
            // Get all programs whoose names match
            //ProgramController.shared.fetchProgramsWith(text)
            ProgramController.shared.fetchProgramsByNameWith(text: text) { (programs) -> (Void) in
                self.programs = programs
            }
            
        } else if searchBar.text == "" {
            self.programs = []
        }
        
    }
    
    
}
