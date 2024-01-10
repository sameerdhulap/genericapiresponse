import Foundation
internal struct Data : Codable {
	let meta : Meta?

	enum CodingKeys: String, CodingKey {

		case meta = "meta"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		meta = try values.decodeIfPresent(Meta.self, forKey: .meta)
	}

}
