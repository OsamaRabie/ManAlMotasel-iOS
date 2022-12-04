//
//  Configuration.swift
//  menomotasel
//
//  Created by Osama Rabie on 04/12/2022.
//

import Foundation
import UIKit

/// Singleton shared access to the configuration
var sharedConfigurationSharedManager:Configuration?

/// Configuration data from firebase
struct Configuration: Codable {
    let autoVerify, blk, live, base, freename, knetblock, blockTime, shake: String?
    let fullad: Fullad
}

// MARK: - Fullad
struct Fullad: Codable {
    let adsVersion,adsIcon, adsMsg, adsButtonTitle, buttonURL: String?
    let isGIF: Bool
    
    enum CodingKeys: String, CodingKey {
        case adsVersion, adsIcon, adsMsg, adsButtonTitle
        case buttonURL = "buttonUrl"
        case isGIF = "isGif"
    }
}
