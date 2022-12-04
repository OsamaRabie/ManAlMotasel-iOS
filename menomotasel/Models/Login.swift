/* 
Copyright (c) 2022 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct Login : Codable {
	let uuid : String?
	let username : String?
	let password : String?
	let salt : String?
	let md5 : String?
	let sha1 : String?
	let sha256 : String?

	enum CodingKeys: String, CodingKey {

		case uuid = "uuid"
		case username = "username"
		case password = "password"
		case salt = "salt"
		case md5 = "md5"
		case sha1 = "sha1"
		case sha256 = "sha256"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		uuid = try values.decodeIfPresent(String.self, forKey: .uuid)
		username = try values.decodeIfPresent(String.self, forKey: .username)
		password = try values.decodeIfPresent(String.self, forKey: .password)
		salt = try values.decodeIfPresent(String.self, forKey: .salt)
		md5 = try values.decodeIfPresent(String.self, forKey: .md5)
		sha1 = try values.decodeIfPresent(String.self, forKey: .sha1)
		sha256 = try values.decodeIfPresent(String.self, forKey: .sha256)
	}

}