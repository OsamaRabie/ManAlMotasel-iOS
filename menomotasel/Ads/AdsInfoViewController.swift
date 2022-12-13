//
//  AdsInfoViewController.swift
//  menodagq8gold
//
//  Created by Hussein Jouhar on 27.10.22.
//  Copyright © 2022 arabdevs. All rights reserved.
//

import UIKit
import Foundation
import Imaginary

class AdsInfoViewController: UIViewController {
    
    @IBOutlet var adTitleLabel: UILabel!
    @IBOutlet var openUrlBtn: UIButton!
    @IBOutlet var adImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        adTitleLabel.text = UserDefaults.standard.object(forKey: "savedAdTitle") as? String
        
        let imgUrl = URL(string: UserDefaults.standard.object(forKey: "savedAdImage") as! String)!
        
        adImage.setImage(url: imgUrl)
        
        adImage.layer.cornerRadius = 20
        adImage.clipsToBounds = true
        
        openUrlBtn.layer.cornerRadius = 20
        openUrlBtn.clipsToBounds = true
        
        let btnTitle = UserDefaults.standard.string(forKey: "savedAdUrl")!.replacingOccurrences(of: "tel://", with: "Call ")
        
        openUrlBtn.setTitle(btnTitle, for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupUI()
    }
    
    private func setupUI() {
        //self.view.setGradient()
    }
    
    @IBAction func closeMe(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func openUrl(_ sender: Any) {
        guard let url = URL(string: UserDefaults.standard.string(forKey: "savedAdUrl")!) else {
          return
        }
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
}
