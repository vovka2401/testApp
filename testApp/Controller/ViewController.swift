//
//  ViewController.swift
//  testApp
//
//  Created by Volodymyr Khvaliuk on 31.08.2022.
//

import UIKit
import CoreData

class ViewController: UIViewController, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var yearTextField: UITextField!
    
    var dataStoreManager: DataStoreManager = DataStoreManager()
    var fetchResultController: NSFetchedResultsController<Movie>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fetchRequest: NSFetchRequest<Movie> = Movie.fetchRequest()
        
        let sortDescriptor = NSSortDescriptor(key: "year", ascending: false)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataStoreManager.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchResultController.delegate = self
        
        try! fetchResultController.performFetch()
    }

    @IBAction func addMovie() {
        guard let year = Int16(yearTextField.text!), titleTextField.hasText, let title = titleTextField.text?.trimmingCharacters(in: CharacterSet(charactersIn: " ")) else {
            return
        }
        let fetchRequestResult = dataStoreManager.fetchRequest()
        let titlePredicate = NSPredicate(format: "title == %@", title)
        let yearPredicate = NSPredicate(format: "year = %@", String(year))
        fetchRequestResult.predicate = NSCompoundPredicate(type: .and, subpredicates: [titlePredicate, yearPredicate])
        
        if let movies = try? dataStoreManager.viewContext.fetch(fetchRequestResult) as? [Movie], movies.isEmpty {
            let movie = Movie(context: dataStoreManager.persistentContainer.viewContext)
            movie.title = title
            movie.year = year
            
            dataStoreManager.saveContext()
            tableView.reloadData()
        } else {
            let alertController = UIAlertController(title: "This movie has already been added to your collection", message: nil, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if indexPath != nil {
                tableView.insertRows(at: [indexPath!], with: .automatic)
            }
        case .delete:
            if indexPath != nil {
                tableView.deleteRows(at: [indexPath!], with: .middle)
            }
        default:
            break
        }
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchResultController.sections?[section]

        return sectionInfo?.numberOfObjects ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as! MovieCell
        let movie = fetchResultController.object(at: indexPath)
        
        cell.title.text = movie.title
        cell.year.text = String(movie.year)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let movie = fetchResultController.object(at: indexPath)
            dataStoreManager.persistentContainer.viewContext.delete(movie)
            dataStoreManager.saveContext()
        }
    }
}
