//
//  CardModel.swift
//  menodag
//
//  Created by Osama Rabie on 11/07/2022.
//

import Foundation
import Contacts

/// The model to hold a business card details
struct CardModel: Codable {
    /// The country code of the card
    var countryCode: String?
    /// The full name for the card holder
    var fullName: String?
    /// His image url if he uploaded one
    var imageURL: String?
    /// His phone number
    var phone:String?
    /// The website to hist company/portofoli
    var website:String?
    /// The email of the user
    var email:String?
    /// The company name
    var company:String?
    /// How his data is shared
    var sharingType:CardShareType?
    /// His unique ID
    var cardID:String?
    /// His clicking action
    var clickingActionType:CardClickingActionType = .OpenCard
    
    
    
    /// Converts the card model to a swift contacts model to be stored directly
    func toContact(withImageData:Data? = nil) -> CNContact {
        let contact = CNMutableContact()
        
        if let email = email {
            contact.emailAddresses.append(CNLabeledValue(label: CNLabelWork, value: email as NSString))
        }
        
        if let fullName = fullName {
            contact.givenName = fullName
        }
        
        if let company = company {
            contact.organizationName = company
        }
        
        if let website = website {
            contact.urlAddresses.append(.init(label: CNLabelWork, value: website as NSString))
        }
        
        if let phone = phone {
            let cnPhoneNumber:CNPhoneNumber = .init(stringValue: phone)
            contact.phoneNumbers.append(.init(label: CNLabelWork, value: cnPhoneNumber))
        }
        
        if let withImageData = withImageData {
            contact.imageData = withImageData
        }
        
        return contact
    }
    
}


/// Defines the sharing type for the card
enum CardShareType: String, Codable {
    /// Meaning, data is shared through mobile apps + website
    case All
    /// Meaning data is shared only through website
    case Website
}


/// Defines the action type
enum CardClickingActionType: String, Codable {
    /// Meaning, when clicked show the card in full screen
    case OpenCard
    /// Meaning open the website
    case Website
}
