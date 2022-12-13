//
//  FullScreenAdViewController.swift
//  menodagq8gold
//
//  Created by Osama Rabie on 29/03/2020.
//  Copyright © 2020 arabdevs. All rights reserved.
//

import UIKit
import moa
import FSnapChatLoading
import SwiftyGif

class FullScreenAdViewController: BottomPopupViewController {
    
    // Popup configurations
    var height: CGFloat?
    var topCornerRadius: CGFloat?
    var presentDuration: Double?
    var dismissDuration: Double?
    var shouldDismissInteractivelty: Bool?
    
    // The snapchat loading view we will use whenever needed
    let loadingView = FSnapChatLoadingView()
    
    // The details of the full ad we wanna show
    var fullAd:FullAd?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var actionButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadImage()
        
        UserDefaults.standard.set(fullAd!.adsVersion,forKey: "adVersion")
        UserDefaults.standard.synchronize()
    }
    
    
    private func setupUI() {
        //self.view.setGradient()
        self.actionButton.layer.cornerRadius = 15
        self.actionButton.alpha = 1.0
        self.navigationItem.hidesBackButton = true
    }
    
    private func loadImage() {
        if let nonNullFullAd = fullAd {
            if nonNullFullAd.isGif ?? false {
                if let url = URL(string: nonNullFullAd.adsIcon) {
                    imageView.setGifFromURL(url,showLoader: true)
                }
            }else {
                self.view.showLoader(loadingView: loadingView,blurEffect: false)
                imageView.moa.onSuccess = { [weak self] image in
                    self?.view.hideLoader(loadingView: self!.loadingView)
                    return image
                }
                imageView.moa.url = nonNullFullAd.adsIcon
            }
            actionButton.setTitle(nonNullFullAd.adsButtonTitle, for: .normal)
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
    
    @IBAction func actionButtonClicked(_ sender: Any) {
        if let nonNullAd = fullAd {
            if let url = URL(string: nonNullAd.buttonUrl) {
                UIApplication.shared.open(url)
            }
            else
            {
                dismiss(animated: true, completion: nil)
            }
        }
        else
        {
            dismiss(animated: true, completion: nil)
        }
    }
    @IBAction func dismissButtonClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    // Bottom popup attribute variables
    // You can override the desired variable to change appearance
    
    override var popupHeight: CGFloat { return height ?? CGFloat(300) }
    
    override var popupTopCornerRadius: CGFloat { return topCornerRadius ?? CGFloat(10) }
    
    override var popupPresentDuration: Double { return presentDuration ?? 0.5 }
    
    override var popupDismissDuration: Double { return dismissDuration ?? 0.5 }
    
    override var popupShouldDismissInteractivelty: Bool { return shouldDismissInteractivelty ?? true }
    
    override var popupDimmingViewAlpha: CGFloat { return BottomPopupConstants.kDimmingViewDefaultAlphaValue }
}




struct FullAd: Codable {
    var adsVersion:String
    var adsIcon:String
    var adsMsg:String
    var adsButtonTitle:String
    var buttonUrl:String
    var isGif:Bool?
}
