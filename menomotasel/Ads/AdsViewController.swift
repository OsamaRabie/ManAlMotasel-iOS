//
//  AdsViewController.swift
//  menomotasel
//
//  Created by Osama Rabie on 13/12/2022.
//

import UIKit
import Foundation
import FSnapChatLoading
import Firebase
import FirebaseStorage

class AdsViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet var noResultsLabel: UILabel!
    @IBOutlet var collectionView: UICollectionView!
    
    let loadingView = FSnapChatLoadingView()
    
    var adsArray = [ad]()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.view.showLoader(loadingView: loadingView)
        
        setupUI()
        loadAllAds()
    }
    
    private func setupUI() {
        //self.view.setGradient()
    }
    
    private func loadAllAds() {
        let storage = Storage.storage()
        let pathReference = storage.reference(withPath: "wasetAds.json")
        pathReference.getData(maxSize: 1 * 1024 * 1024) { [weak self] data, error  in
            if let _ = error {
                // Uh-oh, an error occurred!
            } else {
                // Data for "images/island.jpg" is returned
                if let data = data {
                    do {
                        if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [Dictionary<String,Any>]
                        {
                            self?.adsArray = []
                            jsonArray.forEach{ self?.adsArray.append(.init(imgURL: URL(string: $0["image"] as! String)!, url: "tel://\($0["phone"] as! String)", title: $0["title"] as! String)) }
                        } else {
                            print("bad json")
                        }
                    } catch let error as NSError {
                        print(error)
                    }
                }
            }
            self?.refreshAdsCollectionView()
        }
    }
    
    private func refreshAdsCollectionView() {
        DispatchQueue.main.async { [weak self] in
            self?.view.hideLoader(loadingView: self!.loadingView)
            self?.collectionView.reloadData()
            self?.collectionView.isHidden = false
        }
    }
    
    @IBAction func openAdWithUs(_ sender: Any) {
        performSegue(withIdentifier: "uploadSeg", sender: self)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return adsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "adCell", for: indexPath) as! AdsCollectionViewCell
        
        let adInfo = adsArray[indexPath.row]
        
        cell.setupCell(img: adInfo.imgURL)
        
        cell.layer.cornerRadius = 20
        cell.contentView.layer.cornerRadius = 20
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let adInfo = adsArray[indexPath.row]
        
        UserDefaults.standard.set(adInfo.title, forKey: "savedAdTitle")
        UserDefaults.standard.set(adInfo.url, forKey: "savedAdUrl")
        UserDefaults.standard.set(adInfo.imgURL.absoluteString, forKey: "savedAdImage")
        
        performSegue(withIdentifier: "adInfoSeg", sender: self)
        
        //        if let clickURL:URL = URL(string: adInfo.url) {
        //            UIApplication.shared.open(clickURL)
        //        }else{
        //            UserDefaults.standard.set(adInfo.title, forKey: "savedAdTitle")
        //            UserDefaults.standard.set(adInfo.url, forKey: "savedAdUrl")
        //            UserDefaults.standard.set(adInfo.imgURL.absoluteString, forKey: "savedAdImage")
        //
        //            performSegue(withIdentifier: "adInfoSeg", sender: self)
        //        }
        //
        //        print(adInfo.title)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:collectionView.frame.width * 0.45, height: 280)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.1
    }
    
    struct ad {
        let imgURL : URL
        let url : String
        let title : String
    }
}




extension UIView {
    
    func showLoader(loadingView:FSnapChatLoadingView,blurEffect:Bool = true) {
        DispatchQueue.main.async {
            loadingView.isBlurEffect = blurEffect
            //loadingView.setBackgroundBlurEffect()
            loadingView.backgroundColor = .clear
            loadingView.show(view: self,color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
        }
    }
    
    func hideLoader(loadingView:FSnapChatLoadingView) {
        DispatchQueue.main.async {
            loadingView.hide()
        }
    }
}
