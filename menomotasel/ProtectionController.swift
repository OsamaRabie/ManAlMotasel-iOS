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
    
    @IBOutlet var reportMsgView: UIView!
    @IBOutlet var okBtn: UIButton!
    @IBOutlet var recentLabel: UILabel!
    @IBOutlet var loadingIcon: UIImageView!
    @IBOutlet var scanImage: UIImageView!
    @IBOutlet var loadingView: UIView!
    @IBOutlet var statusLabel: UILabel!
    @IBOutlet var actView: UIActivityIndicatorView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var reportBtn: UIButton!
    @IBOutlet var numOfspmLabel: UILabel!
    @IBOutlet var howToView: UIView!
    @IBOutlet var settingsBtn: UIButton!
    @IBOutlet var protectionLabel: UILabel!
    @IBOutlet var protectionBack: UILabel!
    @IBOutlet var shieldImage: UIImageView!
    
    private var isStatusOn = false
    
    private var isProtectionOn = false
    //End of warning.
    
    private var spamNames:[String] = []
    private var spamNumbers:[String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        howToView.layer.cornerRadius = 15
        settingsBtn.layer.cornerRadius = 15
        reportBtn.layer.cornerRadius = 15
        okBtn.layer.cornerRadius = 15
        tableView.layer.cornerRadius = 15
        
        //Test
        isProtectionOn = true
        checkIfProtectionEnabled()
        
        actView.center = tableView.center
        actView.startAnimating()
        loadSpammers()
    }
    
    func checkIfProtectionEnabled() {
        if (isProtectionOn)
        {
            protectionBack.backgroundColor = hexStringToUIColor(hex: "003500")
            
            shieldImage.image = UIImage(named: "protected-image.png")
            
            protectionLabel.text = "الحماية مفعلة"
            
            numOfspmLabel.isHidden = false
            numOfspmLabel.text = "أنت محمي من 1276 متطفل"
            
            howToView.isHidden = true
            
            tableView.isHidden = false
            
            reportBtn.isHidden = false
        }
        else
        {
            protectionBack.backgroundColor = hexStringToUIColor(hex: "003500")
            
            shieldImage.image = UIImage(named: "unprotected-image.png")
            
            protectionLabel.text = "الحماية غير مفعلة"
            
            numOfspmLabel.isHidden = true
            
            howToView.isHidden = false
            
            tableView.isHidden = true
            
            recentLabel.isHidden = true
            
            reportBtn.isHidden = true
        }
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
                    self?.actView.stopAnimating()
                }
            }else{
               // self?.endScanning()
                self?.actView.stopAnimating()
            }
        }
    }
    
    func reloadData() {
        tableView.reloadData()
        actView.stopAnimating()
        recentLabel.isHidden = false
    }
    
    func showReportSuccess() {
        endLoading()
        self.tabBarController?.view.addSubview(reportMsgView)
        reportMsgView.frame = (self.tabBarController?.view.frame)!
        reportMsgView.center = (self.tabBarController?.view.center)!
    }
    
    
    @IBAction func closeReportMsg(_ sender: Any) {
        UIView.animate(withDuration: 0.2,
                       delay: 0.0,
                       options: UIView.AnimationOptions.curveEaseIn,
                   animations: { () -> Void in
            self.reportMsgView.alpha = 0
        }, completion: { (finished) -> Void in
            self.reportMsgView.removeFromSuperview()
            self.reportMsgView.alpha = 1
        })
    }
    
    @IBAction func reportContact(_ sender: Any) {
        showLoading()
        selectContactToReport()
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
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

                                alert.addAction(UIAlertAction(title: "حجب المكالمات", style: .destructive , handler:{ (UIAlertAction)in
                                    tableView.deselectRow(at: indexPath, animated: true)
                                    self.showStatus(text: "تم حجب المكالمات", isRed: true)
                                }))
                            
                                alert.addAction(UIAlertAction(title: "إلغاء", style: .cancel, handler:{ (UIAlertAction)in
                                    tableView.deselectRow(at: indexPath, animated: true)
                                }))

                                self.present(alert, animated: true, completion: {
                                    print("completion block")
                                })
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
    
    func showStatus(text:String, isRed:Bool){
        if isStatusOn
        {
            return
        }
        
        isStatusOn = true
        
        let finalText = "\("\n\n✓ ") \(text)"
        
        statusLabel.text = finalText
        statusLabel.isHidden = false
        
        if isRed
        {
            statusLabel.backgroundColor = hexStringToUIColor(hex: "d03e3e")
        }
        else
        {
            statusLabel.backgroundColor = hexStringToUIColor(hex: "65C466")
        }
        
        
        UIView.animate(withDuration: 0.2,
                   delay: 0,
                       options: UIView.AnimationOptions.curveEaseIn,
                   animations: { () -> Void in
            self.statusLabel.frame = CGRect(x: 0, y: 0, width: self.statusLabel.frame.size.width, height: self.statusLabel.frame.size.height)
        }, completion: { (finished) -> Void in
            UIView.animate(withDuration: 0.2,
                           delay: 3.0,
                           options: UIView.AnimationOptions.curveEaseIn,
                       animations: { () -> Void in
                self.statusLabel.frame = CGRect(x: 0, y: -self.statusLabel.frame.size.height, width: self.statusLabel.frame.size.width, height: self.statusLabel.frame.size.height)
            }, completion: { (finished) -> Void in
                self.statusLabel.isHidden = true
                self.isStatusOn = false
            })
        })
    }
    
    func showAlert(title:String,msg:String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "حسناً", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func showLoading() {
        self.tabBarController?.view.addSubview(loadingView)
        loadingView.frame = (self.tabBarController?.view.frame)!
        loadingView.center = (self.tabBarController?.view.center)!
        
        self.scanImage.center = loadingView.center
        self.loadingIcon.center = loadingView.center
        
        self.scanImage.isHidden = false
        self.scanImage.frame = CGRect(x: self.scanImage.frame.origin.x-41, y: self.scanImage.frame.origin.y, width: self.scanImage.frame.size.width, height: self.scanImage.frame.size.height)
        
        UIView.animate(withDuration: 0.5, delay: 0, options: [.repeat, .autoreverse], animations: {

            self.scanImage.frame = CGRect(x: self.scanImage.frame.origin.x+83, y: self.scanImage.frame.origin.y, width: self.scanImage.frame.size.width, height: self.scanImage.frame.size.height)

        }, completion: nil)
    }
    
    func endLoading() {
        //self.scanImage.isHidden = true
        self.scanImage.layer.removeAllAnimations()
        self.loadingView.removeFromSuperview()
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
    
    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        endLoading()
    }
    
}
