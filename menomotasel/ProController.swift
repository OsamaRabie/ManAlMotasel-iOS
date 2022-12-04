//
//  ProController.swift
//  menomotasel
//
//  Created by Hussein Jouhar on 09.04.22.
//

import UIKit

class ProController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var pointsLabel: UILabel!
    @IBOutlet var proTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        proTableView.layer.cornerRadius = 15
        proTableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
        self.tabBarController?.tabBar.tintColor = hexStringToUIColor(hex: "DD5A94")
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0
        {
            return 3
        }
        else
        {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "proCell", for: indexPath as IndexPath)
        
        let serviceLabel = (cell.contentView.viewWithTag(1)) as! UILabel
        let descriptionLabel = (cell.contentView.viewWithTag(2)) as! UILabel
        let serviceImage = (cell.contentView.viewWithTag(3)) as! UIImageView
        
        if (indexPath.section == 0)
        {
            switch indexPath.row
            {
            case 0:
                serviceLabel.textColor = hexStringToUIColor(hex: "E8BC4C")
                serviceLabel.text = "الباقة السنوية"
                descriptionLabel.text = "احصل على عدد نقاط غير محدود، وتفعيل اشعارات البحث، وخدمة الدعم الفني المستعجل، وازالة الاعلانات، جربها مجاناً الآن وبعدها سيتم تجديد الاشتراك ب $99,99"
                serviceImage.image = UIImage(named:"gold-service.png")
                break
            case 1:
                serviceLabel.textColor = hexStringToUIColor(hex: "939598")
                serviceLabel.text = "الباقة الشهرية"
                descriptionLabel.text = "احصل على عدد نقاط غير محدود، وتفعيل اشعارات البحث، وخدمة الدعم الفني المستعجل، وازالة الاعلانات، جربها مجاناً الآن وبعدها سيتم تجديد الاشتراك ب $29,99"
                serviceImage.image = UIImage(named:"silver-service.png")
                break
            case 2:
                serviceLabel.textColor = hexStringToUIColor(hex: "C58561")
                serviceLabel.text = "الباقة الإسبوعية"
                descriptionLabel.text = "احصل على عدد نقاط غير محدود، وتفعيل اشعارات البحث، وخدمة الدعم الفني المستعجل، وازالة الاعلانات، جربها مجاناً الآن وبعدها سيتم تجديد الاشتراك ب $9,99"
                serviceImage.image = UIImage(named:"bronze-service.png")
                break
            default: print("default")
            }
        }
        else
        {
            serviceLabel.textColor = hexStringToUIColor(hex: "404040")
            serviceLabel.text = "1000 نقطة"
            descriptionLabel.text = "تستعمل النقاط كرصيد لديك لعمليات البحث والإبلاغ عن المتطفلين  وحظر الأرقام وخدمة الدعم الفني المستعجل وذلك لعدم الإنتظار طويلاً."
            serviceImage.image = UIImage(named:"points-icon.png")
        }
        
        cell.layer.cornerRadius = 15
        
        return cell
    }
    
    func tableView( _ tableView : UITableView,  titleForHeaderInSection section: Int)->String?
    {
        if section == 0
        {
            return "الإشتراك الماسي"
        }
        else
        {
            return "النقاط"
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        //header.textLabel?.textColor = UIColor.red
        header.textLabel?.font = UIFont(name:"TanseekModernProArabic-Medium", size: 22)
        header.textLabel?.frame = header.bounds
        header.textLabel?.textAlignment = .right
        
        if section == 0
        {
            header.textLabel?.text = "الإشتراك الماسي"
        }
        else
        {
            header.textLabel?.text = "النقاط"
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        let verticalPadding: CGFloat = 15

        let maskLayer = CALayer()
        maskLayer.cornerRadius = 10    //if you want round edges
        maskLayer.backgroundColor = UIColor.black.cgColor
        maskLayer.frame = CGRect(x: cell.bounds.origin.x, y: cell.bounds.origin.y, width: cell.bounds.width, height: cell.bounds.height).insetBy(dx: 0, dy: verticalPadding/2)
        cell.layer.mask = maskLayer
    }
    
    // set view for footer
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 40))
        footerView.backgroundColor = UIColor.clear
        return footerView
    }

    // set height for footer
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0
        {
            return 5
        }
        return 40
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
