//
//  ProtectionController.swift
//  menomotasel
//
//  Created by Hussein Jouhar on 07.04.22.
//

import UIKit
import CallKit
import Alamofire
import ContactsUI

class ProtectionController: UIViewController , UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var howToView: UIView!
    @IBOutlet var settingsBtn: UIButton!
    @IBOutlet var protectionLabel: UILabel!
    @IBOutlet var protectionBack: UILabel!
    @IBOutlet var shieldImage: UIImageView!
    
    private var spamNames:[String] = []
    private var spamNumbers:[String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        howToView.layer.cornerRadius = 15
        settingsBtn.layer.cornerRadius = 15
        loadSpammers()
    }
    
    
    func loadSpammers() {
        let keyword:String = "Mohammed"
        
        let headers: HTTPHeaders = [
            "UserAgent": "iPhone CFNetwork Darwin IchIJe",
            "User-Agent": "iPhone CFNetwork Darwin IchIJe",
            "Accept": "application/json"
        ]
        AF.request("\(sharedConfigurationSharedManager?.base ?? "")getNamesLinkedIn??keyword=\(keyword.toBase64())", method: .get, parameters: [:], headers: headers).response { [weak self] (response) in
            if let jsonData = response.data {
                do {
                    debugPrint(jsonData)
                    
                    let jsonDecoder = JSONDecoder()
                    let responseModels:[Results] = try jsonDecoder.decode([Results].self, from: jsonData)
                    self?.spamNames = responseModels.map{ return $0.toCard().fullName ?? ""}
                    self?.spamNumbers = responseModels.map{ return $0.toCard().phone ?? ""}
                    // print(results)
                    DispatchQueue.main.async {
                        self?.reloadData()
                    }
                }catch {
                    //self?.endScanning()
                }
            }else{
               // self?.endScanning()
            }
        }
    }
    
    func reloadData() {
        
    }
    
    func showReportSuccess() {
        
    }
    
    
    func selectContactToReport() {
        let contactPickerVC = CNContactPickerViewController()
        contactPickerVC.delegate = self
        present(contactPickerVC, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
        self.tabBarController?.tabBar.tintColor = hexStringToUIColor(hex: "BA3C36")
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    @IBAction func openiPhoneSettings(_ sender: Any) {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                print("Settings opened: \(success)") // Prints true
            })
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            print("Name: \(spamNames[indexPath.row])")
        }

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return spamNames.count
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "spamCell", for: indexPath as IndexPath)
            
            let nameLabel = (cell.contentView.viewWithTag(1)) as! UILabel
            let numberLabel = (cell.contentView.viewWithTag(2)) as! UILabel
            let spamImage = (cell.contentView.viewWithTag(3)) as! UIImageView
            
            nameLabel.text = "\(spamNames[indexPath.row])"
            numberLabel.text = "\(spamNumbers[indexPath.row])"
            
            spamImage.layer.cornerRadius = spamImage.frame.size.width/2
            spamImage.clipsToBounds = true
            
            cell.layer.cornerRadius = 15
            
            return cell
        }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        let verticalPadding: CGFloat = 8

        let maskLayer = CALayer()
        maskLayer.cornerRadius = 10    //if you want round edges
        maskLayer.backgroundColor = UIColor.black.cgColor
        maskLayer.frame = CGRect(x: cell.bounds.origin.x, y: cell.bounds.origin.y, width: cell.bounds.width, height: cell.bounds.height).insetBy(dx: 0, dy: verticalPadding/2)
        cell.layer.mask = maskLayer
    }
    
    public func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}


extension ProtectionController:CNContactPickerDelegate {
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        // handle selection
        showReportSuccess()
    }
    
    
}
