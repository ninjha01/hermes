//
//  AssesmentTableViewController.swift
//  hermes
//
//  Created by Nishant Jha on 1/4/19.
//  Copyright © 2019 Nishant Jha. All rights reserved.
//

import UIKit

class AssesmentTableViewController: UITableViewController {

    var assesments: [Assesment] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return assesments.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AssesmentTableViewCell", for: indexPath) as? AssesmentTableViewCell  else {
            fatalError("The dequeued cell is not an instance of AssesmentTableViewCell.")
        }
        cell.assesment = self.assesments[indexPath.row]
        cell.nameLabel.text = cell.assesment!.title
        return cell
    }
    
    // MARK: - Navigation
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "cellToAssesment", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPath = tableView.indexPathForSelectedRow!
        let currentCell = tableView.cellForRow(at: indexPath)! as! AssesmentTableViewCell
        let destinationVC = segue.destination as! AssesmentViewController
        destinationVC.assesment = currentCell.assesment!
    }
}
