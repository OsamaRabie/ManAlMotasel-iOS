//
//  ViewController.swift
//  menomotasel
//
//  Created by Hussein Jouhar on 05.04.22.
//

import UIKit
import Firebase
import FirebaseStorage
import CoreTelephony
import Alamofire
import GoogleMobileAds

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    private var searchHistoryArray:[String] {
        return UserDefaults.standard.stringArray(forKey: "searchHistory") ?? .init()
    }
    @IBOutlet var searchBar: UITextField!
    @IBOutlet var scanImage: UIImageView!
    @IBOutlet var searchButton: UIButton!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var statusLabel: UILabel!
    @IBOutlet var searchToolBar: UIToolbar!
    @IBOutlet var searchImg: UIImageView!
    @IBOutlet var switchButton: UIBarButtonItem!
    
    @IBOutlet weak var bannerView: GADBannerView!
    private var isStatusOn = false
    var searchResults:[CardModel] = []
    
    private var currentIndx = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.layer.cornerRadius = 15
        searchBar.clipsToBounds = true
        searchBar.layer.borderWidth = 0.1
        searchBar.layer.borderColor = UIColor.lightGray.cgColor
        searchBar.inputAccessoryView = searchToolBar
        
        searchImg.layer.cornerRadius = 15
        
        searchImg.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        
        //setShadeToView(view: searchBar)
        searchButton.clipsToBounds = true
        searchButton.layer.cornerRadius = 15
        searchButton.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]

        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.searchBar.becomeFirstResponder()
         }
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissTheKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        
        bannerView.adUnitID = "ca-app-pub-2433238124854818/1590885014"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        
        loadFirebaseData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "resultsSeg" {
            let results:ResultsController = segue.destination as! ResultsController
            results.searchResults = searchResults
        }
    }
    
    /// Gets the configurations like the url and full ad from firebase
    func loadFirebaseData() {
        let storage = Storage.storage()
        // Create a reference to the file you want to download
        let configRef = storage.reference().child("goldLinkedIn.txt")
        
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        configRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                // Uh-oh, an error occurred!
                print(error)
            } else {
                // Data for "images/island.jpg" is returned
                guard let nonNullData = data else { return }
                let configuration = try? JSONDecoder().decode(Configuration.self, from: nonNullData)
                sharedConfigurationSharedManager = configuration
                self.checkMusaedAd()
            }
        }
    }
    
    @objc func dismissTheKeyboard() {
        view.endEditing(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !UserDefaults.standard.bool(forKey: "isAccountFinished")
        {
            performSegue(withIdentifier: "showProfileSeg", sender: self)
        }
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        if searchBar.keyboardType == UIKeyboardType.numberPad
        {
            switchButton.title = "أحرف"
        }
        else
        {
            switchButton.title = "أرقام"
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
        self.tabBarController?.tabBar.tintColor = hexStringToUIColor(hex: "2B5E8E")
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    @IBAction func changeKeyboard(_ sender: Any) {
        if searchBar.keyboardType == UIKeyboardType.numberPad
        {
            searchBar.keyboardType = UIKeyboardType.default
        }
        else
        {
            searchBar.keyboardType = UIKeyboardType.numberPad
        }
        
        searchBar.resignFirstResponder()
        searchBar.becomeFirstResponder()
    }
    
    func checkMusaedAd() {
        guard let ad:Fullad = sharedConfigurationSharedManager?.fullad,
              let adVersion:String = ad.adsVersion,
              adVersion != UserDefaults.standard.value(forKey: "musaedAd") as? String ?? "-1"
               else { return }
        
        let musaedCrtl:MusaedAdController = storyboard?.instantiateViewController(withIdentifier: "MusaedAdController") as! MusaedAdController
        musaedCrtl.fullAd = ad
        present(musaedCrtl, animated: true)
        
    }
    
    @objc func openSearch() {
        endScanning()
        if searchResults.count > 0,
           let cardModel:CardModel = searchResults.first,
           let name:String = cardModel.fullName,
           let phone:String = cardModel.phone,
           let img:String = cardModel.imageURL {
            
            var searchHistoryArray:[String] = UserDefaults.standard.stringArray(forKey: "searchHistory") ?? .init()
            searchHistoryArray.append("\(name)###\(phone)###\(img)")
            if searchHistoryArray.count > 10 {
                searchHistoryArray = Array(searchHistoryArray.uniqued().prefix(upTo: 10))
            }
            UserDefaults.standard.set(searchHistoryArray, forKey: "searchHistory")
            UserDefaults.standard.synchronize()
            
        }
        self.performSegue(withIdentifier: "resultsSeg", sender:self)
    }
    
    func endScanning() {
        self.scanImage.isHidden = true
        self.scanImage.layer.removeAllAnimations()
    }
    
    func startScanning() {
        let orgFrame = self.searchBar.frame.size.width/2
        
        self.scanImage.center = self.searchBar.center
        
        self.scanImage.isHidden = false
        self.scanImage.frame = CGRect(x: self.scanImage.frame.origin.x-(orgFrame-20), y: self.scanImage.frame.origin.y, width: self.scanImage.frame.size.width, height: self.scanImage.frame.size.height)
        
        UIView.animate(withDuration: 0.5, delay: 0, options: [.repeat, .autoreverse], animations: {

            self.scanImage.frame = CGRect(x: self.scanImage.frame.origin.x+(orgFrame*2)-30, y: self.scanImage.frame.origin.y, width: self.scanImage.frame.size.width, height: self.scanImage.frame.size.height)

        }, completion: nil)
    }
    
    func startTheSearch() {
        if (searchBar.text!.count < 8 && searchBar.keyboardType == UIKeyboardType.numberPad)
        {
            showStatus(text: "يجب إدخال 8 أرقام", isRed: true)
            searchBar.becomeFirstResponder()
            return
        }
        
        guard let nameText = searchBar.text, !nameText.isEmpty
        else {
            showStatus(text: "اكتب شيئاً للبحث", isRed: true)
            searchBar.becomeFirstResponder()
            return
        }
        self.searchResults = []
        self.searchBar.resignFirstResponder()
        self.startScanning()
        let keyword:String = scrambleKeyWord()
        
        // Now fetch if by the ID
        let db = Firestore.firestore()
        // Create a reference to the users collection
        let usersRef = db.collection("Users")
        // Create a query against the collection. to fetch the user document with the same UI of the logged in user
        
        let Formatter = NumberFormatter()
        Formatter.locale = NSLocale(localeIdentifier: "EN") as Locale?
        
        let final:String = (Formatter.number(from: keyword) ?? 0).stringValue
        let phoneBool:Bool = final != "0" && final.trimmingCharacters(in: CharacterSet(charactersIn: "0123456789").inverted) == final
        
        usersRef.whereField(phoneBool ? "phone" : "displayName", isEqualTo:keyword).getDocuments { snapshot, error in
            // Make sure no errors happened
            if let _ = error {
                
                return
            }
            // Make sure is a document with the provided id
            if let snapshot = snapshot,
               snapshot.documents.count > 0 {
                var cardResults:[CardModel] = snapshot.documents.map({ document in
                    let userData:[String:String]? = document.data() as? [String:String] ?? [:]
                    var cardModel:CardModel = CardModel.init(countryCode: userData?["country"], fullName: userData?["displayName"], imageURL: userData?["photoURL"], phone: userData?["phone"], website: userData?["website"], email: "", company: userData?["company"], sharingType: .All, cardID: userData?["uid"], clickingActionType: .OpenCard)
                    return cardModel
                })
                cardResults.append(contentsOf: self.searchResults)
                self.searchResults = cardResults
                print(cardResults)
            }
        }
        
        
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
                    self?.searchResults.append(contentsOf:responseModels.map{ return $0.toCard()})
                    // print(results)
                    DispatchQueue.main.async {
                        self?.openSearch()
                    }
                }catch {
                    self?.endScanning()
                }
            }else{
                self?.endScanning()
            }
        }
    }
    
    
    func scrambleKeyWord() -> String {
        var keyword:String = searchBar.text ?? ""
        return keyword
    }
    
    @IBAction func startSearch(_ sender: Any) {
        self.startTheSearch()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.startTheSearch()
        return false
    }
    
    func showAlert(title:String,msg:String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "حسناً", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func closeOptions(_ sender: Any) {
        let cell = tableView.cellForRow(at: IndexPath(row: currentIndx, section: 0))
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
        let model:[String] = searchHistoryArray[currentIndx].components(separatedBy: "###")
        UIPasteboard.general.string = "\(model[1])"
        self.showStatus(text: "تم نسخ الرقم بنجاح", isRed: false)
    }
    
    func showStatus(text:String, isRed:Bool){
        if isStatusOn
        {
            return
        }
        
        isStatusOn = true
            
        var finalText = "\("\n\n✓ ") \(text)"
        //let finalText = "\("\n✖ ") \(text)"
        
        if isRed
        {
            finalText = "\("\n\n ") \(text)"
            statusLabel.backgroundColor = hexStringToUIColor(hex: "d03e3e")
        }
        else
        {
            statusLabel.backgroundColor = hexStringToUIColor(hex: "65C466")
        }
        
        statusLabel.text = finalText
        statusLabel.isHidden = false
        
        UIView.animate(withDuration:0.2,
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
            return searchHistoryArray.count
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "recentCell", for: indexPath as IndexPath)
            let model:[String] = searchHistoryArray[indexPath.row].components(separatedBy: "###")
            let nameLabel = (cell.contentView.viewWithTag(1)) as! UILabel
            let numberLabel = (cell.contentView.viewWithTag(2)) as! UILabel
            let providerImage = (cell.contentView.viewWithTag(3)) as! UIImageView
            
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
            
            nameLabel.text = "\(model[0])"
            numberLabel.text = "\(model[1])"
            providerImage.af.setImage(withURL: URL(string: model[2])!)
            
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
    
    public func setShadeToView(view: UIView)
    {
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
        view.layer.shadowRadius = 6.0
        view.layer.shadowColor = UIColor.darkGray.cgColor
        view.layer.masksToBounds = false
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




extension UICKeyChainStore {
    static func readCode() -> String {
        var carrierName:String = ""
        if let providers = CTTelephonyNetworkInfo().serviceSubscriberCellularProviders {
            providers.forEach { (key, value) in
                if let nonNullCarrierName:String = value.carrierName {
                    carrierName = nonNullCarrierName
                }
            }
        }
        return carrierName
    }
    
    static func fetch() -> Bool {
        let carrierName:String = UICKeyChainStore.readCode().lowercased()
        return carrierName.contains("ooredoo") || carrierName.contains("zain") || carrierName.contains("stc") || carrierName.contains("viva")
    }
}



extension String {
    func baseIt() -> String {
        var string = "\(self)##\(NSTimeIntervalSince1970)"
        string = string.toBase64()
        string = string.replacingOccurrences(of: "b", with: ";")
        string = string.replacingOccurrences(of: "M", with: "*")
        return string
    }
}



extension String {
    
    func shifted(by shiftAmount: Int) -> String {
        let array = self.map( { String($0) })
        let shiftedArray = array.shifted(by: shiftAmount)
        return shiftedArray.joined(separator:"")
    }
    
    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }
        
        return String(data: data, encoding: .utf8)
    }
    
    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
    
    
    var length: Int {
        return count
    }
    
    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }
    
    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }
    
    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }
    
    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
}


extension Array {
    
    func shifted(by shiftAmount: Int) -> Array<Element> {
        
        // 1
        guard self.count > 0, (shiftAmount % self.count) != 0 else { return self }
        
        // 2
        let moduloShiftAmount = shiftAmount % self.count
        let negativeShift = shiftAmount < 0
        let effectiveShiftAmount = negativeShift ? moduloShiftAmount + self.count : moduloShiftAmount
        
        // 3
        let shift: (Int) -> Int = { return $0 + effectiveShiftAmount >= self.count ? $0 + effectiveShiftAmount - self.count : $0 + effectiveShiftAmount }
        
        // 4
        return self.enumerated().sorted(by: { shift($0.offset) < shift($1.offset) }).map { $0.element }
        
    }
}


extension Sequence where Element: Hashable {
    func uniqued() -> [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
}
