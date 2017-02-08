//
//  RecordsTableViewController.swift
//  WhereAmI
//
//  Created by Sergey Leskov on 2/8/17.
//  Copyright © 2017 Sergey Leskov. All rights reserved.
//

import UIKit
import CoreData

class RecordsTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    
    //==================================================
    // MARK: - Stored Properties
    //==================================================
    
    var fetchResultController = CoreDataManager.shared.fetchedResultsController(entityName: "Route", keyForSort: "timestamp")

    
    //==================================================
    // MARK: - General
    //==================================================
    override func viewDidLoad() {
        super.viewDidLoad()

        
        fetchResultController.delegate = self
        do {
            try fetchResultController.performFetch()
        } catch {
            print(error)
        }
        
      }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //==================================================
    // MARK: - Table view data source
    //==================================================

    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchResultController.sections?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchResultController.sections, sections.count > 0 {
            return sections[section].numberOfObjects
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! RecordsTableViewCell
        
        let route = fetchResultController.object(at: indexPath) as! Route
        
        updateCell(cell: cell, route: route)
        
        return cell
    }
    
    func updateCell(cell: RecordsTableViewCell, route: Route)  {
        
        cell.dateLabel.text = DateManager.dateAndTimeToString(date: route.timestamp)
        cell.distanceLabel.text = "Distance: \(Int(route.distance)) m"
        cell.durationLabel.text = "Time: \(Int(route.duration)) sek"
    }
    

    //==================================================
    // MARK: - Fetched Results Controller Delegate
    //==================================================
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }

 
    
    //==================================================
    // MARK: - Navigation
    //==================================================
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "detail") {
            let destinationController = segue.destination as! MapRouteViewController
            let indexPath = (self.tableView.indexPathForSelectedRow!)
            let route = fetchResultController.object(at: indexPath ) as! Route

            destinationController.route = route
        }
    }

    
}
