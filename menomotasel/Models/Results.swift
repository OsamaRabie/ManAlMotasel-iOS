/* 
Copyright (c) 2022 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
import UIKit
struct Results : Codable {
	let gender : String?
	let name : Name?
	//let location : Location?
	let email : String?
	let login : Login?
	let dob : Dob?
	let registered : Registered?
	let phone : String?
	let cell : String?
	let id : Id?
	let picture : Picture?
	let nat : String?
    let website : String?
    let company : String?
    let cardClickingActionType : CardClickingActionType

	enum CodingKeys: String, CodingKey {

		case gender = "gender"
		case name = "name"
		//case location = "location"
		case email = "email"
		case login = "login"
		case dob = "dob"
		case registered = "registered"
		case phone = "phone"
		case cell = "cell"
		case id = "id"
		case picture = "picture"
		case nat = "nat"
        case website = "website"
        case company = "company"
        case cardClickingActionType = "cardClickingActionType"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		gender = try values.decodeIfPresent(String.self, forKey: .gender)
		name = try values.decodeIfPresent(Name.self, forKey: .name)
		//location = try values.decodeIfPresent(Location.self, forKey: .location)
		email = try values.decodeIfPresent(String.self, forKey: .email)
		login = try values.decodeIfPresent(Login.self, forKey: .login)
		dob = try values.decodeIfPresent(Dob.self, forKey: .dob)
		registered = try values.decodeIfPresent(Registered.self, forKey: .registered)
		phone = try values.decodeIfPresent(String.self, forKey: .phone)
		cell = try values.decodeIfPresent(String.self, forKey: .cell)
		id = try values.decodeIfPresent(Id.self, forKey: .id)
		picture = try values.decodeIfPresent(Picture.self, forKey: .picture)
		nat = try values.decodeIfPresent(String.self, forKey: .nat)
        website = try values.decodeIfPresent(String.self, forKey: .website)
        company = try values.decodeIfPresent(String.self, forKey: .company)
        cardClickingActionType = try values.decodeIfPresent(CardClickingActionType.self, forKey: .cardClickingActionType) ?? .OpenCard
	}
    
    
    /// Converts the results random user to acceptable CaardModel
    func toCard() -> CardModel {
        var cardModel:CardModel = .init()
        
        cardModel.fullName = "\(name?.first ?? "") \(name?.last ?? "")"
        cardModel.phone = phone
        cardModel.countryCode = nat
        cardModel.imageURL = picture?.medium
        cardModel.email = email
        cardModel.website = website
        cardModel.company = company
        cardModel.clickingActionType = cardClickingActionType
        return cardModel
    }

}



