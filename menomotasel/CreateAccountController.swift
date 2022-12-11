//
//  CreateAccountController.swift
//  menomotasel
//
//  Created by Hussein Jouhar on 30.11.22.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseStorage

class CreateAccountController: UIViewController,UINavigationControllerDelegate ,UIImagePickerControllerDelegate {
    
    @IBOutlet var skipBtn: UIButton!
    @IBOutlet var createBtn: UIButton!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var numberTextField: UITextField!
    @IBOutlet var uploadBtn: UIButton!
    @IBOutlet var profileImageView: UIImageView!
    
    /// holding the data of the current card model
    var cardModel:CardModel = .init()
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width/2
        profileImageView.layer.borderWidth = 5
        profileImageView.layer.borderColor = UIColor.white.cgColor
        profileImageView.clipsToBounds = true
        
        createBtn.layer.cornerRadius = 15
        createBtn.clipsToBounds = true
        
        skipBtn.layer.cornerRadius = 15
        skipBtn.clipsToBounds = true
        
        uploadBtn.setTitle("", for: .normal)
        
        cardModel.imageURL = "https://firebasestorage.googleapis.com/v0/b/menomotaselq8.appspot.com/o/images%2Fapp-icon.png?alt=media&token=8e339179-8cf8-4427-9178-c17752e74d9c"
        preloadData()
        self.hideKeyboardWhenTappedAround()
        
        UserDefaults.standard.set(true, forKey: "isAccountFinished")
        UserDefaults.standard.synchronize()
    }
    
    func preloadData() {
        // logged in user, let us load his data for him to edit
        if let _ = sharedFirebaseAuthUsersManager.loggedInUser() {
            sharedFirebaseAuthUsersManager.fetchUserData { [weak self] userData, snapShot in
                self?.cardModel = CardModel(countryCode: userData?["country"], fullName: userData?["displayName"], imageURL: userData?["photoURL"], phone: userData?["phone"], website: userData?["website"], email: sharedFirebaseAuthUsersManager.loggedInUser()?.email, company: userData?["company"], sharingType: .All, cardID: userData?["uid"], clickingActionType: .Website)
                self?.nameTextField.text = self?.cardModel.fullName
                self?.numberTextField.text = self?.cardModel.phone
                self?.numberTextField.isEnabled = false
                self?.numberTextField.alpha = 0.75
                self?.profileImageView.af.setImage(withURL: URL(string: self?.cardModel.imageURL ?? "")!)
                self?.skipBtn.isHidden = true
                self?.createBtn.setTitle("تعديل البيانات", for: .normal)
            }
        }
    }
    
    @IBAction func closeMe(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func uploadPhoto(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            profileImageView.image = editedImage
        } else if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            profileImageView.image = image
            uploadImage()
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func uploadImage() {
        let data:Data = profileImageView.image?.jpegData(compressionQuality: 0.3) ?? .init()
        
        // Create a reference to the file you want to upload
        let storage = Storage.storage()
        let configRef = storage.reference().child("images/\(NSTimeIntervalSince1970).jpeg")
        
        // Upload the file to the path "images/rivers.jpg"
        let uploadTask = configRef.putData(data, metadata: nil) { (metadata, error) in
           
            guard let _ = metadata else {
                // Uh-oh, an error occurred!
                return
            }
            // You can also access to download URL after upload.
            configRef.downloadURL { [weak self] (url, error) in
                guard let downloadURL = url else {
                    // Uh-oh, an error occurred!
                    return
                }
                self?.cardModel.imageURL = downloadURL.absoluteString
            }
        }
        
        uploadTask.resume()
    }
    
    @IBAction func changeCountry(_ sender: Any) {
        self.showAlert(title:"رقم كويتي", msg:"حالياً تستطيع التسجيل برقم الكويت فقط.")
    }
    
    func showAlert(title:String,msg:String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "حسناً", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func saveNewAccount(_ sender: Any) {
        guard let nameText = nameTextField.text, !nameText.isEmpty
        else {
            self.showAlert(title: "خطأ", msg: "الرجاء إدخال الإسم")
            nameTextField.becomeFirstResponder()
            return
        }
        guard  let phoneText = numberTextField.text, !phoneText.isEmpty
        else {
            self.showAlert(title: "خطأ", msg: "الرجاء إدخال الرقم")
            numberTextField.becomeFirstResponder()
            return
        }
        
        cardModel.fullName = nameText
        cardModel.phone = phoneText
        
        if let _ = sharedFirebaseAuthUsersManager.loggedInUser() {
            sharedFirebaseAuthUsersManager.updateCurrentUserProfile(with: cardModel)
            dismiss(animated: true)
        }else{
            PhoneAuthProvider.provider().verifyPhoneNumber("+965\(phoneText)", uiDelegate: nil) { [weak self] verificationID, error in
                if let error = error {
                    print(error)
                    return
                }
                // Sign in using the verificationID and the code sent to the user
                DispatchQueue.main .async { [weak self] in
                    let pinCodeViewController:OTPController = self?.storyboard?.instantiateViewController(identifier: "OTPController") as! OTPController
                    
                    pinCodeViewController.otpVerificationClosure = { otp in
                        self?.verify(otp: otp, with: verificationID ?? "")
                    }
                    // Present pinCodeController
                    self?.present(pinCodeViewController, animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func skipRegistration(_ sender: Any) {
        UserDefaults.standard.set(true, forKey: "isAccountFinished")
        UserDefaults.standard.synchronize()
        self.dismiss(animated: true, completion: nil)
    }
    
    
    /**
     Validates the entered OTP with firebase
     - Parameter otp: The otp the user entered
     - Parameter with code: The verification token code shared by firebase
     */
    private func verify(otp:String, with code:String) {
        // Validate the entered OTP agains the vrification code shareed by Firebase
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: code,
            verificationCode: otp
        )
        Auth.auth().signIn(with: credential) { [weak self] result, error in
            if let _ = error {
                // Display an error message for the user
                self?.showOTPError()
                return
            }else{
                // Update his profile with the data he just entered
                self?.saveCurrentUserData()
            }
        }
    }
    
    
    /// Saves the data to the user's profile no firebase after successfully verifying his phone number
    private func saveCurrentUserData() {
        cardModel.cardID = Auth.auth().currentUser?.uid
        cardModel.phone = numberTextField.text ?? ""
        cardModel.fullName = nameTextField.text ?? ""
        sharedFirebaseAuthUsersManager.updateCurrentUserProfile(with: cardModel)
        dismiss(animated: true)
    }
    /// Displays a message to the user that his OTP verification failed
    private func showOTPError() {
        let otpErrorAlertController:UIAlertController = .init(title: "عفواً", message: "الرمز خطأ", preferredStyle: .alert)
        
        let otpErrorAlertOkAction:UIAlertAction = .init(title: "OK", style: .default)
        otpErrorAlertController.addAction(otpErrorAlertOkAction)
        
        DispatchQueue.main.async { [weak self] in
            self?.present(otpErrorAlertController,animated: true)
        }
    }
    
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
