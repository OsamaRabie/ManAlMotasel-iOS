//
//  UploadAdViewController.swift
//  menodagq8gold
//
//  Created by Hussein Jouhar on 02.11.22.
//  Copyright © 2022 arabdevs. All rights reserved.
//

import UIKit
import Foundation

class UploadAdViewController: UIViewController ,UINavigationControllerDelegate ,UIImagePickerControllerDelegate,UITextFieldDelegate {
    
    @IBOutlet var submitBtn: UIButton!
    @IBOutlet var adTitleTextField: UITextField!
    @IBOutlet var addImgBtn: UIButton!
    @IBOutlet var adImage: UIImageView!
    
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        adImage.layer.cornerRadius = 20
        adImage.clipsToBounds = true
        
        addImgBtn.titleLabel?.textAlignment = .center
        
        submitBtn.layer.cornerRadius = 20
        submitBtn.clipsToBounds = true
        submitBtn.alpha = 0.5
        
        adTitleTextField.delegate = self
        
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupUI()
    }
    
    private func setupUI() {
        //self.view.setGradient()
    }
    
    func updateSubmitButtonUI() {
        guard adImage.image != nil,
              let text = adTitleTextField.text, !text.isEmpty else {
            submitBtn.alpha = 0.5
            return
        }
        
        submitBtn.alpha = 1
    }
    
    @IBAction func closeMe(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addNewImg(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            adImage.image = editedImage
        } else if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            adImage.image = image
        }
        
        addImgBtn.setTitle("", for: .normal)
        updateSubmitButtonUI()
        self.dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
        }
    
    @IBAction func submitAd(_ sender: Any) {
        if adImage.image == nil
        {
            showAlert(title: "صوره الإعلان", msg: "يجب اختيار صوره للاعلان")
        }
        else if let text = adTitleTextField.text, text.isEmpty
        {
            showAlert(title: "عنوان الإعلان", msg: "يجب وضع عنوان للاعلان")
            adTitleTextField.becomeFirstResponder()
        }
        else
        {
            
            let alertController:UIAlertController = .init(title: "شكرا لك", message: "سيتم العمل على مراجعة إعلانك قبل عرضه بالتطبيق خلال ٥ أيام عمل.", preferredStyle: .alert)
            let okAction:UIAlertAction = .init(title: "OK", style: .destructive) { [weak self] _ in
                self?.dismiss(animated: true)
            }
            
            alertController.addAction(okAction)
            present(alertController, animated: true)
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        updateSubmitButtonUI()
        return true
    }
    
    func showAlert(title:String,msg:String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}
