//
//  MainViewController.swift
//  MyFavoritePlaces
//
//  Created by Eʟᴅᴀʀ Tᴇɴɢɪᴢᴏᴠ on 24.07.2021.
//

import UIKit
import RealmSwift

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var places: Results<Place>!
    var ascending = false
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var sortedButtonLabel: UIBarButtonItem!
    @IBOutlet weak var segmentLabel: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        places = realm.objects(Place.self)
        ascendingSorted()
    }
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.isEmpty ? 0 : places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell
        
        let place = places[indexPath.row]
        
        cell.nameLabel.text = place.name
        cell.locationLabel.text = place.location
        cell.typeLabel.text = place.type
        cell.placeImageView.image = UIImage(data: place.image!)
        cell.placeImageView.contentMode = .scaleAspectFill
        
        cell.placeImageView.layer.cornerRadius = cell.placeImageView.frame.size.height / 2
        cell.placeImageView.clipsToBounds = true
        
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
    
    
     // MARK: - Navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editPlace" {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let currentPlace = places[indexPath.row]
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
        
        if ascending {
            sortedButtonLabel.image = #imageLiteral(resourceName: "ZA")
        } else {
            sortedButtonLabel.image = #imageLiteral(resourceName: "AZ")
        }
        
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
