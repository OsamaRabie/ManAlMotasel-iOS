//
//  MusaedAdController.swift
//  menomotasel
//
//  Created by Osama Rabie on 09/12/2022.
//

import UIKit
import AlamofireImage
import SwiftyGif

class MusaedAdController: UIViewController {

    @IBOutlet weak var adImage: UIImageView!
    @IBOutlet weak var adButton: UIButton!
    
    var fullAd:Fullad?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let fullAd = fullAd else {
            dismiss(animated: true)
            return
        }
        
        
        if fullAd.isGIF {
            let url = URL(string: fullAd.adsIcon ?? "")!
            let loader = UIActivityIndicatorView(style: .large)
            adImage.setGifFromURL(url, customLoader: loader)
        }else{
            adImage.af.setImage(withURL: URL(string: fullAd.adsIcon ?? "")!)
        }
        adButton.setTitle(fullAd.adsButtonTitle, for: .normal)
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func adClicked(_ sender: Any) {
        guard let fullAd = fullAd,
        let url:URL = URL(string: fullAd.buttonURL ?? "") else {
            dismiss(animated: true)
            return
        }
        
        UIApplication.shared.open(url)
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
