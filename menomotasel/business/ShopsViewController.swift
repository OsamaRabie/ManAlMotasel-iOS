//
//  ShopsViewController.swift
//  menodagq8gold
//
//  Created by Osama Rabie on 17/05/2020.
//  Copyright © 2020 arabdevs. All rights reserved.
//

import UIKit
//import Localize_Swift
import Imaginary
import FSnapChatLoading
import Alamofire
import Firebase

class ShopsViewController: UIViewController {
    
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    var subCategory:SubCategory?
    lazy var dataSource:[BusinessResult] = []
    @IBOutlet weak var collectionView: UICollectionView!
    let loadingView = FSnapChatLoadingView()
    var fromCategoryID:String {
        guard dataSource.count > 0,
              let fromID = dataSource.last?.id else { return "0"}
        return fromID
    }
    lazy var shouldLoadMore:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        loadResults()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        localize()
        
        
        titleLabel.layer.shadowColor = UIColor.white.cgColor
       titleLabel.layer.shadowOffset = .zero
       titleLabel.layer.shadowRadius = 1.0
       titleLabel.layer.shadowOpacity = 1.0
       titleLabel.layer.masksToBounds = false
       titleLabel.layer.shouldRasterize = true
        
    }
    
    private func localize() {
        
        guard let subCategory = subCategory else { return }
        
        titleLabel.text = subCategory.nameAR
        doneButton.setTitle("الرجوع", for: .normal)
    }
    
    @IBAction func dismissClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    private func loadResults() {
        
        guard let baseURL = sharedConfigurationSharedManager?.base,
            let subCategory = subCategory else { return }
        
        view.showLoader(loadingView: loadingView)
        let countryCode = (UICKeyChainStore.readCode()).lowercased()
        
        let params = ["categoryID":"\(subCategory.id ?? 0)","fromID":fromCategoryID,"codeAuth":countryCode.baseIt(),"lang":"ar"]
        let headers: HTTPHeaders = [
            "UserAgent": "iPhone CFNetwork Darwin IchIJe",
            "User-Agent": "iPhone CFNetwork Darwin IchIJe",
            "Accept": "application/json"
        ]
        AF.request("\(baseURL)shops", method: .post, parameters: params, headers: headers).response { [weak self] (response) in
            if let jsonData = response.data {
                do {
                    let results:[BusinessResult] = try JSONDecoder().decode([BusinessResult].self, from: jsonData)
                    DispatchQueue.main.async {
                        self?.dataSource.append(contentsOf: results)
                        self?.collectionView.reloadData()
                        self?.shouldLoadMore = (results.count < 200) ? false : true
                    }
                }catch {
                    self?.dismissClicked(UIButton())
                }
            }else{
                self?.dismissClicked(UIButton())
            }
            if let nonNullSelf = self {
                nonNullSelf.view.hideLoader(loadingView: nonNullSelf.loadingView)
            }
        }
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension ShopsViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "shopCollectionCell", for: indexPath)
        
        let subCategory:BusinessResult = dataSource[indexPath.row]
        
        guard let subCategoryNameLabel:UILabel = cell.viewWithTag(2) as? UILabel,
            let subCategoryImageView:UIImageView = cell.viewWithTag(3) as? UIImageView,
            let imageHolderView:UIView = cell.viewWithTag(4) else { return cell }
        
        subCategoryNameLabel.text = subCategory.nameAR
        subCategoryImageView.image = UIImage(named: "shopPlaceHolder")!
        imageHolderView.layer.cornerRadius = imageHolderView.frame.width / 2
        
        guard let iconURL:URL = URL(string: subCategory.icon ?? "") else { return cell }
        subCategoryImageView.setImage(url: iconURL, placeholder: UIImage(named: "shopPlaceHolder")!,completion:{ _ in
            DispatchQueue.main.async {
                
                subCategoryImageView.layer.cornerRadius = subCategoryImageView.frame.width / 2
            }
        })
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 90, height: 122)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 70.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let businessResult:BusinessResult = dataSource[indexPath.row]
        
        if businessResult.openUponClick ?? false {
            if let url:URL = URL(string: businessResult.link ?? "") {
                DispatchQueue.main.async {
                     UIApplication.shared.open(url)
                }
                return
            }
        }
        
        guard let businessProfileViewController:BusinessProfileViewController = storyboard?.instantiateViewController(withIdentifier: "BusinessProfileViewController") as? BusinessProfileViewController else { return }
        
        businessProfileViewController.businessResult = businessResult
        present(businessProfileViewController, animated: true, completion: nil)
    }
}
