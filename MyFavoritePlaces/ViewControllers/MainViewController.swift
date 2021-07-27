//
//  MainViewController.swift
//  MyFavoritePlaces
//
//  Created by Eʟᴅᴀʀ Tᴇɴɢɪᴢᴏᴠ on 24.07.2021.
//

import UIKit
import RealmSwift

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private var places: Results<Place>!
    private var filteredPlaces: Results<Place>!
    private var ascending = false
    private var searchController = UISearchController(searchResultsController: nil)
    
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return true }
        return text.isEmpty
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var sortedButtonLabel: UIBarButtonItem!
    @IBOutlet weak var segmentLabel: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        places = realm.objects(Place.self)
        ascendingSorted()
        
        //Setup search controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !searchBarIsEmpty {
            return filteredPlaces.count
        }
        return places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell
        
        let place = searchBarIsEmpty ? places[indexPath.row] : filteredPlaces[indexPath.row]
        
        cell.nameLabel.text = place.name
        cell.locationLabel.text = place.location
        cell.typeLabel.text = place.type
        cell.placeImageView.image = UIImage(data: place.image!)
        cell.cosmosView.rating = place.rating
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        85
    }
    
    //MARK: - Table view delegate
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let place = places[indexPath.row]
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
            StorageManager.deleteObject(place)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction])
        return swipeActions
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editPlace" {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            
            let currentPlace = searchBarIsEmpty ? places[indexPath.row] : filteredPlaces[indexPath.row]
            
            guard let editVC = segue.destination as? NewPlaceViewController else { return }
            editVC.currentPlace = currentPlace
        }
        
    }
    
    @IBAction func unwindSegue(_ segue: UIStoryboardSegue) {
        guard let newPlaceVC = segue.source as? NewPlaceViewController else { return }
        newPlaceVC.savePlace()
        tableView.reloadData()
    }
    
    @IBAction func segmentController(_ sender: UISegmentedControl) {
        ascendingSorted()
        tableView.reloadData()
    }
    
    
    @IBAction func sortedAction(_ sender: Any) {
        ascending.toggle()
        
        sortedButtonLabel.image = ascending ?  #imageLiteral(resourceName: "ZA") : #imageLiteral(resourceName: "AZ")
        
        ascendingSorted()
    }
    
    private func ascendingSorted() {
        if segmentLabel.selectedSegmentIndex == 0 {
            places = places.sorted(byKeyPath: "date", ascending: ascending)
        } else if segmentLabel.selectedSegmentIndex == 1 {
            places = places.sorted(byKeyPath: "name", ascending: ascending)
        }
        
        tableView.reloadData()
    }
}

extension MainViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContent(searchController.searchBar.text ?? "")
    }
    
    func filterContent(_ searchText: String) {
        filteredPlaces = places.filter("name CONTAINS[c] %@ OR location CONTAINS[c] %@", searchText, searchText)
        tableView.reloadData()
    }
    
}
