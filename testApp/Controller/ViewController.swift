//
//  ViewController.swift
//  testApp
//
//  Created by Volodymyr Khvaliuk on 31.08.2022.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var yearTextField: UITextField!
    
    var dataStoreManager: DataStoreManager = DataStoreManager()
    var movies: [Movie]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movies = dataStoreManager.obtainMovies()
    }

    @IBAction func addMovie() {
        guard let year = Int16(yearTextField.text!), titleTextField.hasText, let title = titleTextField.text?.trimmingCharacters(in: CharacterSet(charactersIn: " ")) else {
            return
        }
        for movie in movies {
            if movie.title == title && movie.year == year {
                let alertController = UIAlertController(title: "This movie has already been added to your collection", message: nil, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
                return
            }
        }
        dataStoreManager.addMovie(title: title, year: year)
        movies = dataStoreManager.obtainMovies()
        self.tableView.reloadData()
    }
    
    func deleteMovie(at number: Int) {
        dataStoreManager.deleteMovie(at: number)
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell") as? MovieCell else {
            let newCell = UITableViewCell(style: .default, reuseIdentifier: "movieCell") as! MovieCell
            newCell.title.text = movies[indexPath.row].title
            newCell.year.text = String(movies[indexPath.row].year)
            
            return newCell
        }
        cell.title.text = movies[indexPath.row].title
        cell.year.text = String(movies[indexPath.row].year)
        
        return cell
    }
    
    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let actionDelete = UIContextualAction(style: .destructive, title: "Delete") { _,_,_ in
            self.movies.remove(at: indexPath.row)
            self.deleteMovie(at: indexPath.row)
            self.tableView.reloadData()
        }
        let actions = UISwipeActionsConfiguration(actions: [actionDelete])
        return actions
    }
}
