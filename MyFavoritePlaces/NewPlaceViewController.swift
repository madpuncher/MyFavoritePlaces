//
//  NewPlaceViewController.swift
//  MyFavoritePlaces
//
//  Created by Eʟᴅᴀʀ Tᴇɴɢɪᴢᴏᴠ on 24.07.2021.
//

import UIKit

class NewPlaceViewController: UITableViewController {

    var currentPlace: Place?
    var imageIsChanged = false
    
    @IBOutlet weak var placeImageView: UIImageView!
    
    @IBOutlet weak var placeName: UITextField!
    @IBOutlet weak var placeLocation: UITextField!
    @IBOutlet weak var placeType: UITextField!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        saveButton.isEnabled = false
        placeName.addTarget(self, action: #selector(nameDidChanged), for: .editingChanged)
        
        setupEditVC()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            
            let cameraImage = #imageLiteral(resourceName: "camera")
            let galleryImage = #imageLiteral(resourceName: "photo")
            
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            let library = UIAlertAction(title: "Photo", style: .default) { [weak self] _ in
                self?.chooseImagePicker(source: .photoLibrary)
            }
            library.setValue(galleryImage, forKey: "image")
            library.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
            
            let camera = UIAlertAction(title: "Camera", style: .default) { [weak self] _ in
                self?.chooseImagePicker(source: .camera)
            }
            camera.setValue(cameraImage, forKey: "image")
            camera.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")

            let cancel = UIAlertAction(title: "Cancel", style: .cancel)
            
            alert.addAction(library)
            alert.addAction(camera)
            alert.addAction(cancel)
            
            present(alert, animated: true)
            
        } else {
            view.endEditing(true)
        }
    }

    func setupEditVC() {
        if currentPlace != nil {
            
            setupNavBarEditVC()
            
            imageIsChanged = true
            
            guard let data = currentPlace?.image, let image = UIImage(data: data) else { return }
            placeName.text = currentPlace?.name
            placeLocation.text = currentPlace?.location
            placeType.text = currentPlace?.type
            placeImageView.image = image
            placeImageView.contentMode = .scaleAspectFill
        }
    }
    
    func setupNavBarEditVC() {
        if let topItem = navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
        navigationItem.leftBarButtonItem = nil
        title = currentPlace?.name
        saveButton.isEnabled = true
    }
    
    func savePlace() {
                
        var image: UIImage?
        
        if imageIsChanged == false {
            image = #imageLiteral(resourceName: "imagePlaceholder")
        } else {
            image = placeImageView.image
        }
        
        let newPlace = Place(
            name: placeName.text ?? "",
            location: placeLocation.text,
            type: placeType.text,
            image: image?.pngData()
        )
        
        if currentPlace != nil {
            try! realm.write{
                currentPlace?.name = newPlace.name
                currentPlace?.location = newPlace.location
                currentPlace?.type = newPlace.type
                currentPlace?.image = newPlace.image
            }
        } else {
            StorageManager.saveObjects(newPlace)
        }
        
    }
    
    @objc private func nameDidChanged() {
        if placeName.text?.isEmpty == false {
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true)
    }
}

extension NewPlaceViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

//MARK: - EXTENSION VC
extension NewPlaceViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func chooseImagePicker(source: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(source) {
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.allowsEditing = true
            picker.sourceType = source
            present(picker, animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        placeImageView.image = info[.editedImage] as? UIImage
        placeImageView.contentMode = .scaleAspectFill
        placeImageView.clipsToBounds = true
        
        imageIsChanged = true
        
        dismiss(animated: true)
    }

}
