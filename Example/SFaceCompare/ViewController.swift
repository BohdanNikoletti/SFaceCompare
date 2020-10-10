//
//  ViewController.swift
//  SFaceCompare
//
//  Created by Bohdan Mihiliev on 06/06/2018.
//  Copyright (c) 2018 Bohdan Mihiliev. All rights reserved.
//

import SFaceCompare

final class ViewController: UIViewController {
  
  // MARK: - Outlets
  @IBOutlet weak private var firstImageView: UIImageView!
  @IBOutlet weak private var secondImageView: UIImageView!
  @IBOutlet weak private var activityIndicator: UIActivityIndicatorView!
  @IBOutlet weak private var infoLabel: UILabel!
  
  // MARK: - Properties
  private var images = [UIImage]() {
    didSet {
      guard images.count == 2 else { return }
      activityIndicator.startAnimating()
      let faceComparator = SFaceCompare.init(on: self.images[0], and: self.images[1])
      faceComparator.compareFaces { [weak self] result in
        switch result {
        case .failure(let error):
          self?.activityIndicator.stopAnimating()
          self?.infoLabel.text = (error as? SFaceError)?.localizedDescription
          self?.view.backgroundColor = UIColor.red
        case .success(let data):
          self?.activityIndicator.stopAnimating()
          self?.view.backgroundColor = UIColor.green
          self?.infoLabel.text = "Yay! Faces are the same!\n With Coefficient: \(data.probability)"
        }
      }
    }
  }
  private var selectedImageViewTag = 0
  
  // MARK: - Lifecycle events
  override func viewDidLoad() {
    super.viewDidLoad()
    setDegaultViewsStates()
    addClickListenersToImageViews()
  }
  
  override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
    guard motion == .motionShake else { return }
    setDegaultViewsStates()
  }
  
  
  // MARK: - Actions
  @objc func connected( _ sender:AnyObject) {
    selectedImageViewTag = sender.view.tag
    presentImagePicker()
  }
  
  // MARK: - Private methods
  private func setDegaultViewsStates() {
    images.removeAll()
    infoLabel.text = ""
    firstImageView.image = #imageLiteral(resourceName: "empty-image")
    secondImageView.image = #imageLiteral(resourceName: "empty-image")
    firstImageView.isUserInteractionEnabled = true
    UIView.animate(withDuration: 0.35, animations: {
      self.view.backgroundColor = UIColor.white
      self.secondImageView.alpha = 0.1
    })
  }
  
  private func addClickListenersToImageViews() {
    let firstImageViewTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.connected(_:)))
    let secondImageViewTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.connected(_:)))
    
    firstImageView.addGestureRecognizer(firstImageViewTapGestureRecognizer)
    secondImageView.addGestureRecognizer(secondImageViewTapGestureRecognizer)
  }
}

// MARK: - UIImagePickerControllerDelegate
extension ViewController: UIImagePickerControllerDelegate {
  
  func imagePickerController(_ picker: UIImagePickerController,
                             didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    guard let selectedPhoto = info[.originalImage] as? UIImage else {
      return
    }
    dismiss(animated: true, completion: { [unowned self, selectedPhoto] in
      self.images.append(selectedPhoto)
      switch self.selectedImageViewTag {
      case 0:
        self.firstImageView.image = selectedPhoto
        self.secondImageView.isUserInteractionEnabled = true
        self.firstImageView.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.35, animations: { [weak self] in
          self?.secondImageView.alpha = 1
        })
      case 1:
        self.secondImageView.image = selectedPhoto
        self.secondImageView.isUserInteractionEnabled = false
      default:
        fatalError("Unexpected behaviour")
      }
    })
  }
  
  func presentImagePicker() {
    let imagePickerActionSheet = UIAlertController(title: "Snap/Upload Image",
                                                   message: nil, preferredStyle: .actionSheet)
    
    if UIImagePickerController.isSourceTypeAvailable(.camera) {
      let cameraButton = UIAlertAction(title: "Take Photo",
                                       style: .default) { [unowned self] (alert) -> Void in
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        self.present(imagePicker, animated: true)
      }
      imagePickerActionSheet.addAction(cameraButton)
    }
    
    let libraryButton = UIAlertAction(title: "Choose Existing",
                                      style: .default) { [unowned self] (alert) -> Void in
      let imagePicker = UIImagePickerController()
      imagePicker.delegate = self
      imagePicker.sourceType = .photoLibrary
      self.present(imagePicker, animated: true)
    }
    imagePickerActionSheet.addAction(libraryButton)
    let cancelButton = UIAlertAction(title: "Cancel", style: .cancel)
    imagePickerActionSheet.addAction(cancelButton)
    present(imagePickerActionSheet, animated: true)
  }
  
}

// MARK: - UINavigationControllerDelegate
extension ViewController: UINavigationControllerDelegate { }
