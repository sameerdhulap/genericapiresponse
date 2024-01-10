import Foundation
internal struct adAPIResponse : Codable {
	let error : Int?
	let errormsg : String?
	let data : Data?

	enum CodingKeys: String, CodingKey {

		case error = "error"
		case errormsg = "errormsg"
		case data = "data"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		error = try values.decodeIfPresent(Int.self, forKey: .error)
		errormsg = try values.decodeIfPresent(String.self, forKey: .errormsg)
		data = try values.decodeIfPresent(Data.self, forKey: .data)
	}

}
