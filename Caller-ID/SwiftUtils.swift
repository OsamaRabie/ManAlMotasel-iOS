//
//  SwiftUtils.swift
//  Caller-ID
//
//  Created by Osama Rabie on 2/24/21.
//  Copyright © 2021 SADAH Software Solutions, LLC. All rights reserved.
//

import Foundation
@objc public class VpnChecker: NSObject {
    
    private static let vpnProtocolsKeysIdentifiers = [
        "tap", "tun", "ppp", "ipsec", "utun"
    ]
    
    @objc public static func isVpnActive() -> Bool {
        guard let cfDict = CFNetworkCopySystemProxySettings() else { return false }
        let nsDict = cfDict.takeRetainedValue() as NSDictionary
        guard let keys = nsDict["__SCOPED__"] as? NSDictionary,
              let allKeys = keys.allKeys as? [String] else { return false }
        
        // Checking for tunneling protocols in the keys
        for key in allKeys {
            for protocolId in vpnProtocolsKeysIdentifiers
            where key.starts(with: protocolId) {
                // I use start(with:), so I can cover also `ipsec4`, `ppp0`, `utun0` etc...
                return true
            }
        }
        return false
    }
}
