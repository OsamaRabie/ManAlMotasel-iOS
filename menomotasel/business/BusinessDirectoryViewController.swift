//
//  BusinessDirectoryViewController.swift
//  menodagq8gold
//
//  Created by Osama Rabie on 17/05/2020.
//  Copyright © 2020 arabdevs. All rights reserved.
//

import UIKit
//import Localize_Swift
import MessageUI
import Firebase

class BusinessDirectoryViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    lazy var dataSource:[BusinessCategory] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDataSource()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
    }
    
    private func setupUI() {
        //self.view.setGradient()
        //self.titleLabel.text = "directoryTitle".localized()
    }
    
    private func setupDataSource() {
        let url = Bundle.main.url(forResource: "Categories", withExtension: "json")!
        let data = try! Data(contentsOf: url)
        dataSource = try! JSONDecoder().decode([BusinessCategory].self, from: data)
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
             return .lightContent
       }
    
    @IBAction func addCompanyClicked(_ sender: Any) {
        
        let alert:UIAlertController = UIAlertController(title: "أضف شركتك", message: "ارسل لنا بيانات شركتك و اعلن بأشهر تطبيق بالكويت", preferredStyle: .alert)
        let yes:UIAlertAction = .init(title: "OK", style: .default) { [weak self] (_) in
            if MFMailComposeViewController.canSendMail() {
                let mail = MFMailComposeViewController()
                mail.mailComposeDelegate = self
                mail.setToRecipients(["sales@manalmotasel.com"])
                mail.setSubject("Add My Company")
                mail.setMessageBody("<h1 style=\"color: #5e9ca0;\"><span style=\"color: #993366;\">You are one step away from taking your business to the next level!</span></h1> <h2 style=\"color: #2e6c80;\">Provide us with the following:</h2> <ol> <li><strong>Manadatory Fields:</strong> <ol> <li>Name Arabic.</li> <li>Name English.</li> <li>Website.</li> <li>Phone.</li> <li>Business sector.</li> </ol> </li> <li><strong>Optional Fields:</strong> <ol> <li>Location.</li> <li>Email.</li> <li>Notes.&nbsp;</li> </ol> </li> </ol> <p><strong>Notes:</strong></p> <ol> <li>We will review the data provided including the mandatory fields.</li> <li>If all went alright! We will call you to authenticate you and your relation to the mentioned business.</li> <li>This may take up to a week.</li> </ol>", isHTML: true)
                DispatchQueue.main.async {
                    self?.present(mail, animated: true)
                }
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
                DispatchQueue.main.async {
                    self?.present(alertController, animated: true, completion: nil)
                }
            }
        }
        let no:UIAlertAction = .init(title: "إلغاء", style: .cancel, handler: nil)
        alert.addAction(yes)
        alert.addAction(no)
        
        present(alert, animated: true, completion: nil)
    }
}

extension BusinessDirectoryViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource[section].subCategories?.count ?? 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCollectionCell", for: indexPath)
        
        guard let subCategory:SubCategory = dataSource[indexPath.section].subCategories?[indexPath.row] else { return cell }
        
        guard let subCategoryNameLabel:UILabel = cell.viewWithTag(2) as? UILabel,
            let subCategoryImageView:UIImageView = cell.viewWithTag(3) as? UIImageView,
            let imageHolderView:UIView = cell.viewWithTag(4) else { return cell }
        
        subCategoryNameLabel.text = subCategory.nameAR
        subCategoryImageView.image = UIImage(named: "cat\(indexPath.section+1)sub\(indexPath.row+1).png")
        imageHolderView.layer.cornerRadius = imageHolderView.frame.width / 2
        
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 90, height: 122)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 70.0)
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
            
        case UICollectionView.elementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "categoryCollectionHeader", for: indexPath)
            
            let category:BusinessCategory = dataSource[indexPath.section]
            guard let categoryNameLabel:UILabel = headerView.viewWithTag(1) as? UILabel else { return headerView }
            categoryNameLabel.text = category.nameAR
            
            categoryNameLabel.layer.shadowColor = UIColor.white.cgColor
            categoryNameLabel.layer.shadowOffset = .zero
            categoryNameLabel.layer.shadowRadius = 1.0
            categoryNameLabel.layer.shadowOpacity = 1.0
            categoryNameLabel.layer.masksToBounds = false
            categoryNameLabel.layer.shouldRasterize = true
            
            return headerView
            
        case UICollectionView.elementKindSectionFooter:
            let footerView = UICollectionReusableView()
            footerView.backgroundColor = .clear
            return footerView
            
        default:
            assert(false, "Unexpected element kind")
        }
        
        return UICollectionReusableView()
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let subCategory:SubCategory = dataSource[indexPath.section].subCategories?[indexPath.row],
            let shopsViewController:ShopsViewController = storyboard?.instantiateViewController(withIdentifier: "ShopsViewController") as? ShopsViewController else { return }
        
        shopsViewController.subCategory = subCategory        
        present(shopsViewController, animated: true, completion: nil)
    }
}

extension BusinessDirectoryViewController:MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}





struct BusinessCategory : Codable {
    let icon : String?
    let nameAR : String?
    let nameEN : String?
    let link : String?
    let subCategories : [SubCategory]?
    
    enum CodingKeys: String, CodingKey {
        
        case icon = "icon"
        case nameAR = "nameAR"
        case nameEN = "nameEN"
        case link = "link"
        case subCategories = "subCategories"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        icon = try values.decodeIfPresent(String.self, forKey: .icon)
        nameAR = try values.decodeIfPresent(String.self, forKey: .nameAR)
        nameEN = try values.decodeIfPresent(String.self, forKey: .nameEN)
        link = try values.decodeIfPresent(String.self, forKey: .link)
        subCategories = try values.decodeIfPresent([SubCategory].self, forKey: .subCategories)
    }
}

struct SubCategory : Codable {
    let id : Int?
    let nameAR : String?
    let nameEN : String?
    let link : String?
    let icon : String?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case nameAR = "nameAR"
        case nameEN = "nameEN"
        case link = "link"
        case icon = "icon"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        nameAR = try values.decodeIfPresent(String.self, forKey: .nameAR)
        nameEN = try values.decodeIfPresent(String.self, forKey: .nameEN)
        link = try values.decodeIfPresent(String.self, forKey: .link)
        icon = try values.decodeIfPresent(String.self, forKey: .icon)
    }
    
}

struct BusinessResult : Codable {
    let id : String?
    let phone : String?
    let rates : String?
    let nameEN : String?
    let link : String?
    let nameAR : String?
    let notes : String?
    let location : String?
    let icon : String?
    let customPhone : String?
    let website : String?
    let categoryID : String?
    let email : String?
    var bgColor:String?
    let openUponClick : Bool?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case phone = "phone"
        case rates = "rates"
        case nameEN = "nameEN"
        case link = "link"
        case nameAR = "nameAR"
        case notes = "notes"
        case location = "location"
        case icon = "icon"
        case customPhone = "customPhone"
        case website = "website"
        case categoryID = "categoryID"
        case email = "email"
        case bgColor = "bgColor"
        case openUponClick = "openUponClick"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        phone = try values.decodeIfPresent(String.self, forKey: .phone)
        rates = try values.decodeIfPresent(String.self, forKey: .rates)
        nameEN = try values.decodeIfPresent(String.self, forKey: .nameEN)
        link = try values.decodeIfPresent(String.self, forKey: .link)
        nameAR = try values.decodeIfPresent(String.self, forKey: .nameAR)
        notes = try values.decodeIfPresent(String.self, forKey: .notes)
        location = try values.decodeIfPresent(String.self, forKey: .location)
        icon = try values.decodeIfPresent(String.self, forKey: .icon)
        customPhone = try values.decodeIfPresent(String.self, forKey: .customPhone)
        website = try values.decodeIfPresent(String.self, forKey: .website)
        categoryID = try values.decodeIfPresent(String.self, forKey: .categoryID)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        bgColor = try values.decodeIfPresent(String.self, forKey: .bgColor)
        openUponClick = (try values.decodeIfPresent(String.self, forKey: .openUponClick) ?? "0") == "1" ? true : false
    }
    
    func isValidWebsite() -> Bool {
        guard let website = website,
              let _ = URL(string: website) else { return false }
        return true
    }
    
    func isValidEmail() -> Bool {
        guard let email = email else { return false }
        let emailRegEx = "^(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+(?:\\.[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+)*)|(?:\"(?:(?:(?:(?: )*(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: )*)|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)*)|(?:\\[(?:(?:(?:(?:(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))\\.){3}(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))))|(?:(?:(?: )*[!-Z^-~])*(?: )*)|(?:[Vv][0-9A-Fa-f]+\\.[-A-Za-z0-9._~!$&'()*+,;=:]+))\\])))(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: email)
        return result
    }
    
    func isValidPhone() -> Bool {
        guard let phoneString = phone,
              let phone = Int(phoneString),
              phone > 0 else { return false }
        
        return true
    }
    
    func isValidLocation() -> Bool {
        guard let location = location,
              location != "" else { return false }
        return true
    }
    
    func isValidNotes() -> Bool {
        guard let notes = notes,
              notes != "" else { return false }
        return true
    }
}

