//
//  SettingsController.swift
//  menomotasel
//
//  Created by Hussein Jouhar on 09.04.22.
//

import UIKit
import StoreKit
import MessageUI
import FirebaseAuth

class SettingsController: UITableViewController,MFMailComposeViewControllerDelegate {
    
    @IBOutlet var cell1: UITableViewCell!
    @IBOutlet var cell2: UITableViewCell!
    @IBOutlet var cell3: UITableViewCell!
    @IBOutlet var cell4: UITableViewCell!
    @IBOutlet var settingsTopImg: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let selectedView1 = UIView()
        selectedView1.backgroundColor = self.hexStringToUIColor(hex: "82d7ff")
        cell1.selectedBackgroundView = selectedView1
        
        let selectedView2 = UIView()
        selectedView2.backgroundColor = self.hexStringToUIColor(hex: "82d7ff")
        cell2.selectedBackgroundView = selectedView2
        
        let selectedView3 = UIView()
        selectedView3.backgroundColor = self.hexStringToUIColor(hex: "82d7ff")
        cell3.selectedBackgroundView = selectedView3
        
        let selectedView4 = UIView()
        selectedView4.backgroundColor = self.hexStringToUIColor(hex: "82d7ff")
        cell4.selectedBackgroundView = selectedView4
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
        self.tabBarController?.tabBar.tintColor = hexStringToUIColor(hex: "222C26")
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        //header.textLabel?.textColor = UIColor.red
        header.textLabel?.font = UIFont(name:"TanseekModernProArabic-Medium", size: 20)
        header.textLabel?.frame = header.bounds
        header.textLabel?.textAlignment = .right
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0
        {
            if indexPath.row == 0
            {
                if !UserDefaults.standard.bool(forKey: "isRegistrationDone")
                {
                    let action = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                        
                    action.addAction(UIAlertAction(title: "تعديل معلوماتك", style: .default , handler:{ (UIAlertAction)in
                            self.performSegue(withIdentifier: "settingsShowProfile", sender: self)
                            tableView.deselectRow(at: indexPath, animated: true)
                        }))

                    action.addAction(UIAlertAction(title: "حذف الحساب", style: .destructive , handler:{ (UIAlertAction)in
                            print("User click Delete button")
                        self.deleteAccount()
                            tableView.deselectRow(at: indexPath, animated: true)
                        }))
                    
                    action.addAction(UIAlertAction(title: "إلغاء", style: .cancel, handler:{ (UIAlertAction)in
                        
                            tableView.deselectRow(at: indexPath, animated: true)
                        }))
                        
                        //uncomment for iPad Support
                        //alert.popoverPresentationController?.sourceView = self.view

                        self.present(action, animated: true, completion: {
                            print("completion block")
                        })
                }
                else
                {
                    performSegue(withIdentifier: "settingsShowProfile", sender: self)
                }
            }
        }
        else if indexPath.section == 1
        {
            if (indexPath.row == 0)
            {
                //ContactUs
                if MFMailComposeViewController.canSendMail() {
                    let composeVC = MFMailComposeViewController()
                        composeVC.mailComposeDelegate = self

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
                
                tableView.deselectRow(at: indexPath, animated: true)
            }
            else if (indexPath.row == 1)
            {
                //RateApp
                if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                    DispatchQueue.main.async {
                        SKStoreReviewController.requestReview(in: scene)
                    }
                }
                
                tableView.deselectRow(at: indexPath, animated: true)
            }
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    private func deleteAccount() {
        let alert = UIAlertController(title: "حذف الحساب", message: "هل أنت متأكد برغبتك بحذف حسابك وبياناتك من التطبيق ومن شبكة منو المتصل؟", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "حذف الحساب بالكامل", style: UIAlertAction.Style.destructive, handler: deleteAllData))
        
        alert.addAction(UIAlertAction(title: "إلغاء", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func deleteAllData(alert: UIAlertAction){
        sharedFirebaseAuthUsersManager.deleteUserFromFireStore { _ in }
        try? Auth.auth().signOut()
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
