//
//  ResultsController.swift
//  menomotasel
//
//  Created by Hussein Jouhar on 06.04.22.
//

import UIKit
import AlamofireImage
import GoogleMobileAds
import FirebaseRemoteConfig
import MessageUI

class ResultsController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var resultsTableView: UITableView!
    @IBOutlet var statusLabel: UILabel!
    private var interstitial: GADInterstitialAd?
    @IBOutlet weak var bannerView: GADBannerView!
    var searchResults:[CardModel] = []
    var remoteConfig:RemoteConfig?
    var adLink:String?
    
    @IBOutlet weak var adButton: UIButton!
    private var currentIndx = -1
    
    private var isStatusOn = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        resultsTableView.reloadData()
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        
        let request = GADRequest()
        GADInterstitialAd.load(withAdUnitID:"ca-app-pub-3940256099942544/4411468910",
                               request: request,
                               completionHandler: { [self] ad, error in
            if let error = error {
                print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                return
            }
            interstitial = ad
            interstitial?.present(fromRootViewController: self)
        }
        )
        
        loadFireBaseRemoteConfig()
    }
    
    
    func loadFireBaseRemoteConfig() {
        remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig?.configSettings = settings
        
        remoteConfig?.fetch { [weak self] (status, error) -> Void in
            if status == .success {
                print("Config fetched!")
                self?.remoteConfig?.activate { changed, error in
                    guard let imageUrl:String = self?.remoteConfig?.configValue(forKey: "searchImageLink").stringValue,
                          let clickUrl:String = self?.remoteConfig?.configValue(forKey: "searchAdLink").stringValue else {
                        return
                    }
                    self?.adLink = clickUrl
                    DispatchQueue.main.async {
                        self?.adButton.af.setBackgroundImage(for: .normal, url: URL(string: imageUrl)!)
                    }
                }
            } else {
                print("Config not fetched")
                print("Error: \(error?.localizedDescription ?? "No error available.")")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    @IBAction func closeResults(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func closeOptions(_ sender: Any) {
        let cell = resultsTableView.cellForRow(at: IndexPath(row: currentIndx, section: 0))
        let optionsView = (cell?.contentView.viewWithTag(5))!
        let reslutsView = (cell?.contentView.viewWithTag(6))!
        
        currentIndx = -1
        self.flipTransition(with: optionsView, view2: reslutsView, isReverse: true)
    }
    
    @IBAction func optionClicked(_ sender: UIButton) {
        switch sender.tag
        {
        case 11: showStatus(text: "تم التبليغ بنجاح!", isRed: false)
            break
        case 12: showStatus(text: "تم حظر الرقم بنجاح!", isRed: true)
            break
        case 13: self.copTheNumber()
            break
        default: print("default")
        }
        
        self.closeOptions(sender)
    }
    
    func copTheNumber() {
        UIPasteboard.general.string = "\(searchResults[currentIndx].phone ?? "")"
        self.showStatus(text: "تم نسخ الرقم بنجاح",isRed: false)
    }
    
    func showStatus(text:String, isRed:Bool){
        if isStatusOn
        {
            return
        }
        
        isStatusOn = true
        
        let finalText = "\("✓ ") \(text)"
        
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
    
    func hexStringToUIColor (hex:String) -> UIColor {
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
    
    func flipTransition (with view1: UIView, view2: UIView, isReverse: Bool = false) {
        var transitionOptions = UIView.AnimationOptions()
        transitionOptions = isReverse ? [.transitionFlipFromLeft] : [.transitionFlipFromRight] // options for transition

        // animation durations are equal so while first will finish, second will start
        // below example could be done also using completion block.
        UIView.transition(with: view1, duration: 0.5, options: transitionOptions, animations: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                view1.isHidden = true
             }
        })

        UIView.transition(with: view2, duration: 0.5, options: transitionOptions, animations: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                view2.isHidden = false
             }
        })
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        var cell = tableView.cellForRow(at: indexPath)
        
        var optionsView = (cell?.contentView.viewWithTag(5))!
        var reslutsView = (cell?.contentView.viewWithTag(6))!
        
        
        if (currentIndx != -1)
        {
            cell = tableView.cellForRow(at: IndexPath(row: currentIndx, section: 0))
            optionsView = (cell?.contentView.viewWithTag(5))!
            reslutsView = (cell?.contentView.viewWithTag(6))!
            
            self.flipTransition(with: optionsView, view2: reslutsView, isReverse: true)
        }
        
        cell = tableView.cellForRow(at: indexPath)
        optionsView = (cell?.contentView.viewWithTag(5))!
        reslutsView = (cell?.contentView.viewWithTag(6))!
        
        let rowNumber : Int = indexPath.row
        
        if (currentIndx != rowNumber)
        {
            currentIndx = rowNumber
            self.flipTransition(with: reslutsView, view2: optionsView)
        }
        else
        {
            currentIndx = -1
            self.flipTransition(with: optionsView, view2: reslutsView, isReverse: true)
        }
        
        }

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return searchResults.count
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "resultsCell", for: indexPath as IndexPath)
            
            let nameLabel = (cell.contentView.viewWithTag(1)) as! UILabel
            let numberLabel = (cell.contentView.viewWithTag(2)) as! UILabel
            //let reportedLabel = (cell.contentView.viewWithTag(3)) as! UILabel
            let providerImage = (cell.contentView.viewWithTag(4)) as! UIImageView
            
            let result = searchResults[indexPath.row]
            
            if (currentIndx == indexPath.row)
            {
                cell.viewWithTag(5)?.isHidden = false
                cell.viewWithTag(6)?.isHidden = true
            }
            else
            {
                cell.viewWithTag(5)?.isHidden = true
                cell.viewWithTag(6)?.isHidden = false
            }
            
            nameLabel.text = result.fullName
            numberLabel.text = result.phone
            //reportedLabel.text = "التبليغات:\n\(Int.random(in: 50..<99999))"
            
            providerImage.af.setImage(withURL: URL(string: result.imageURL ?? "")!)
            
            providerImage.layer.cornerRadius = providerImage.frame.size.width/2
            providerImage.clipsToBounds = true
            
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
    
    @IBAction func openSearchAd(_ sender: Any) {
        if let adLink = adLink {
            UIApplication.shared.open(URL(string: adLink)!)
        }else{
            //ContactUs
            if MFMailComposeViewController.canSendMail() {
                let composeVC = MFMailComposeViewController()
                
                // Configure the fields of the interface.
                composeVC.setToRecipients(["menomotasel@gmail.com"])
                composeVC.setMessageBody("\n\n\n\n\n\n\nتطبيق منو المتصل الإصدار 3.0", isHTML: false)
                
                // Present the view controller modally.
                self.present(composeVC, animated: true, completion: nil)
            }
            else
            {
                guard let url = URL(string: "mailto:menomotasel@gmail.com") else {
                    return
                }
                
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
}
