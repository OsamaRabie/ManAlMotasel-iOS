//
//  BusinessProfileViewController.swift
//  menodagq8gold
//
//  Created by Osama Rabie on 18/05/2020.
//  Copyright © 2020 arabdevs. All rights reserved.
//

import UIKit
//import Localize_Swift
import Imaginary
import MessageUI
import Cosmos
import Firebase
import AJMessage
//import PermissionWizard
//import Contacts
//import SwiftyContacts
//import ContactsUI

class BusinessProfileViewController: UIViewController {

    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    var businessResult:BusinessResult?
    @IBOutlet weak var iconHolderView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    lazy var dataSource:[[String:String]] = []
    @IBOutlet weak var ratingView: CosmosView!
    
    var websiteClickedBlock:((BusinessResult?) -> (Void)) = { _ in }
    var phoneClickedBlock:((BusinessResult?) -> (Void)) = { _ in }
    var notesClickedBlock:((BusinessResult?) -> (Void)) = { _ in }
    var emailClickedBlock:((BusinessResult?) -> (Void)) = { _ in }
    var locationClickedBlock:((BusinessResult?) -> (Void)) = { _ in }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        localize()
        setupBlockHandlers()
        setupIconUI()
        setupTitleLabel()
        setupBlurEffect()
        setupTableView()
        
    }
    
    private func localize() {
        guard let subCategory = businessResult else { return }
        
        titleLabel.text = subCategory.nameAR
        doneButton.setTitle("الرجوع", for: .normal)
    }
    
    private func setupIconUI() {
        guard let subCategory = businessResult else { return }
        
        iconImageView.image = UIImage(named: "shopPlaceHolder")!
        iconHolderView.layer.cornerRadius = iconHolderView.frame.width / 2
        
        guard let iconURL:URL = URL(string: subCategory.icon ?? "") else { return }
        iconImageView.setImage(url: iconURL, placeholder: UIImage(named: "shopPlaceHolder")!,completion:{ _ in
            DispatchQueue.main.async { [weak self] in
                
                self?.iconImageView.layer.cornerRadius = (self?.iconImageView.frame.width ?? 0) / 2
            }
        })
    }
    
    private func setupTitleLabel() {
        titleLabel.layer.shadowColor = UIColor.white.cgColor
        titleLabel.layer.shadowOffset = .zero
        titleLabel.layer.shadowRadius = 1.0
        titleLabel.layer.shadowOpacity = 1.0
        titleLabel.layer.masksToBounds = false
        titleLabel.layer.shouldRasterize = true
    }
    
    private func setupBlurEffect() {
        let blurEffect = UIBlurEffect(style: .prominent)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
        view.bringSubviewToFront(doneButton)
        view.bringSubviewToFront(tableView)
        view.bringSubviewToFront(iconHolderView)
        view.bringSubviewToFront(titleLabel)
        view.bringSubviewToFront(ratingView)
    }
    
    
    private func setupTableView() {
        tableView.tableFooterView = .init()
        tableView.layer.cornerRadius = 15
        
        dataSource.append(["key":"website","icon":"website"])
        dataSource.append(["key":"phone","icon":"phone"])
        dataSource.append(["key":"email","icon":"email"])
        dataSource.append(["key":"location","icon":"location"])
        dataSource.append(["key":"notes","icon":"notes"])
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
        ratingView.rating = Double(businessResult?.rates ?? "0") ?? 0
    }
    
    @IBAction func dismissClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
             return .lightContent
       }
    
    private func fetchPresentableValue(for key:String) -> (String,Bool,String) {
        guard let businessResult = businessResult else { return ("غير موجود", false,"") }
        
        var displayText:String = "غير موجود"
        var displayIndicator:Bool = false
        var iconName = "disclosureIndicator"
        
        switch key {
        case "website":
            if businessResult.isValidWebsite() {
                displayText = businessResult.website!
                displayIndicator = true
                iconName = "copyIcon"
            }
        case "email":
            if businessResult.isValidEmail() {
                displayText = businessResult.email!
                displayIndicator = true
            }
        case "phone":
            if businessResult.isValidPhone() {
                displayText = businessResult.phone!
                displayIndicator = true
            }
        case "location":
            if businessResult.isValidLocation() {
                displayText = businessResult.location!
                displayIndicator = false
            }
        case "notes":
            if businessResult.isValidNotes() {
                displayText = businessResult.notes!
                displayIndicator = true
            }
        default:
            return ("غير موجود",false,iconName)
        }
        
        return (displayText,displayIndicator,iconName)
    }
}

extension BusinessProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "businessProfileCell", for: indexPath)
        guard let keyName:String = dataSource[indexPath.row]["key"],
            let iconName:String = dataSource[indexPath.row]["icon"] else { return cell }
        
        guard let textLabel:UILabel = cell.viewWithTag(1) as? UILabel,
            let iconImageView:UIImageView = cell.viewWithTag(2) as? UIImageView,
            let indicatorImageView:UIImageView = cell.viewWithTag(3) as? UIImageView else { return cell }
        
        let (displayText,displayIndicator, accessoryIconName) = fetchPresentableValue(for: keyName)
        
        textLabel.text = displayText
        iconImageView.image = UIImage(named: iconName)
        indicatorImageView.isHidden = !displayIndicator
        indicatorImageView.image = UIImage(named: accessoryIconName)
        
        
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 84
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let keyName:String = dataSource[indexPath.row]["key"] else { return }
        switch keyName {
        case "website":
            websiteClickedBlock(businessResult)
        case "phone":
            phoneClickedBlock(businessResult)
        case "notes":
            notesClickedBlock(businessResult)
        case "email":
            emailClickedBlock(businessResult)
        default:
            return
        }
    }
}

extension BusinessProfileViewController {
    
    func setupBlockHandlers() {
       
        websiteClickedBlock = { [weak self] _ in
            let (urlString,validURL,_) = self?.fetchPresentableValue(for: "website") ?? ("",false,"")
            guard validURL,
                let _:URL = URL(string: urlString) else { return }
            DispatchQueue.main.async {
                UIPasteboard.general.string = urlString
                AJMessage.show(title: "Done", message: "Url is copied")
            }
        }
        
        // CONTACTS
        phoneClickedBlock = {  [weak self] _ in
            let (phoneString,validPhone,_) = self?.fetchPresentableValue(for: "phone") ?? ("",false,"")
            guard validPhone,
                let validNumber = URL(string: "tel://" + phoneString) else { return }
            DispatchQueue.main.async {
                let alertController:UIAlertController = .init(title: "المزيد", message: nil, preferredStyle: .actionSheet)
                /*let saveContactAction:UIAlertAction = .init(title: "addToContacts".localized(), style: .destructive) { (_) in
                    let contact = CNMutableContact()
                    contact.givenName = self?.titleLabel.text ?? ""
                    contact.phoneNumbers = [.init(label: CNLabelPhoneNumberMain, value: CNPhoneNumber(stringValue:phoneString))]
                    let saveContactVC = CNContactViewController(forNewContact: contact)
                    
                    saveContactVC.contactStore = CNContactStore()
                    saveContactVC.delegate = self
                    saveContactVC.allowsActions = false
                    
                    let navigationController = UINavigationController(rootViewController: saveContactVC)
                    DispatchQueue.main.async { [weak self] in
                        self?.present(navigationController, animated: false)
                    }
                    
                }*/
                let callContactAction:UIAlertAction = .init(title: "إتصال", style: .default) { (_) in
                    UIApplication.shared.open(validNumber)
                }
                let cancelAction:UIAlertAction = .init(title: "إلغاء", style: .cancel) { (_) in
                }
                
                //alertController.addAction(saveContactAction)
                alertController.addAction(callContactAction)
                alertController.addAction(cancelAction)
                self?.present(alertController, animated: true, completion: nil)
            }
        }
        
        
        locationClickedBlock = { [weak self] _ in
            let name = self?.businessResult?.nameEN
            guard let nonNullName = name,
                let validURL = URL(string: "https://www.google.com/maps/search/\(nonNullName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")/@29.3018973,48.0842123,17z/data=!3m1!4b1") else { return }
            DispatchQueue.main.async {
                UIApplication.shared.open(validURL)
            }
        }
        
        notesClickedBlock = { [weak self] _ in
            let (notes,validNotes,_) = self?.fetchPresentableValue(for: "notes") ?? ("",false,"")
            guard validNotes else { return }
            
            let alertController:UIAlertController = UIAlertController(title: "ملاحظات", message: notes, preferredStyle: .alert)
            let okAction:UIAlertAction = .init(title: "الرجوع", style: .cancel, handler: nil)
            alertController.addAction(okAction)
            
            DispatchQueue.main.async {
                self?.present(alertController, animated: true, completion: nil)
            }
        }
        
        emailClickedBlock = { [weak self] _ in
            let (emailString,validEmail,_) = self?.fetchPresentableValue(for: "email") ?? ("",false,"")
            guard validEmail else { return }
            DispatchQueue.main.async {
                if MFMailComposeViewController.canSendMail() {
                    let mail = MFMailComposeViewController()
                    mail.mailComposeDelegate = self
                    mail.setToRecipients([emailString])
                    self?.present(mail, animated: true)
                }else {
                    let alertController:UIAlertController = .init(title: "Error happened", message: "Make sure you have added at least one email from the iPhone's settings first.", preferredStyle: .alert)
                    let settingsAction:UIAlertAction = .init(title: "Open settings", style: .default) { (_) in
                        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                            return
                        }
                        
                        if UIApplication.shared.canOpenURL(settingsUrl) {
                            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                                print("Settings opened: \(success)") // Prints true
                            })
                        }
                    }
                    let cancelAction:UIAlertAction = .init(title: "Cancel", style: .cancel) { (_) in
                        
                    }
                    alertController.addAction(settingsAction)
                    alertController.addAction(cancelAction)
                    self?.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
}


extension BusinessProfileViewController:MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
/*
extension BusinessProfileViewController: CNContactViewControllerDelegate {
    
    func contactViewController(_ viewController: CNContactViewController, didCompleteWith contact: CNContact?) {
        viewController.dismiss(animated: true, completion: nil)
    }
    
}*/
