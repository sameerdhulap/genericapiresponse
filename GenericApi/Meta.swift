import Foundation
fileprivate func decode(fromObject container: KeyedDecodingContainer<JSONCodingKeys>) -> [String: Any] {
  var result: [String: Any] = [:]

  for key in container.allKeys {
    if let val = try? container.decode(Int.self, forKey: key) {
      result[key.stringValue] = val
    } else if let val = try? container.decode(Double.self, forKey: key) {
      result[key.stringValue] = val
    } else if let val = try? container.decode(String.self, forKey: key) {
      result[key.stringValue] = val
    } else if let val = try? container.decode(Bool.self, forKey: key) {
      result[key.stringValue] = val
    } else if let nestedContainer = try? container.nestedContainer(
      keyedBy: JSONCodingKeys.self, forKey: key)
    {
      result[key.stringValue] = decode(fromObject: nestedContainer)
    } else if var nestedArray = try? container.nestedUnkeyedContainer(forKey: key) {
      result[key.stringValue] = decode(fromArray: &nestedArray)
    } else if (try? container.decodeNil(forKey: key)) == true {
      result.updateValue(Any?(nil) as Any, forKey: key.stringValue)
    }
  }

  return result
}

fileprivate func decode(fromArray container: inout UnkeyedDecodingContainer) -> [Any] {
  var result: [Any] = []

  while !container.isAtEnd {
    if let value = try? container.decode(String.self) {
      result.append(value)
    } else if let value = try? container.decode(Int.self) {
      result.append(value)
    } else if let value = try? container.decode(Double.self) {
      result.append(value)
    } else if let value = try? container.decode(Bool.self) {
      result.append(value)
    } else if let nestedContainer = try? container.nestedContainer(keyedBy: JSONCodingKeys.self) {
      result.append(decode(fromObject: nestedContainer))
    } else if var nestedArray = try? container.nestedUnkeyedContainer() {
      result.append(decode(fromArray: &nestedArray))
    } else if (try? container.decodeNil()) == true {
      result.append(Any?(nil) as Any)
    }
  }

  return result
}

fileprivate func encodeValue(
  fromObjectContainer container: inout KeyedEncodingContainer<JSONCodingKeys>, map: [String: Any]
) throws {
  for k in map.keys {
    let value = map[k]
    let encodingKey = JSONCodingKeys(stringValue: k)

    if let value = value as? String {
      try container.encode(value, forKey: encodingKey)
    } else if let value = value as? Int {
      try container.encode(value, forKey: encodingKey)
    } else if let value = value as? Double {
      try container.encode(value, forKey: encodingKey)
    } else if let value = value as? Bool {
      try container.encode(value, forKey: encodingKey)
    } else if let value = value as? [String: Any] {
      var keyedContainer = container.nestedContainer(
        keyedBy: JSONCodingKeys.self, forKey: encodingKey)
      try encodeValue(fromObjectContainer: &keyedContainer, map: value)
    } else if let value = value as? [Any] {
      var unkeyedContainer = container.nestedUnkeyedContainer(forKey: encodingKey)
      try encodeValue(fromArrayContainer: &unkeyedContainer, arr: value)
    } else {
      try container.encodeNil(forKey: encodingKey)
    }
  }
}

fileprivate func encodeValue(fromArrayContainer container: inout UnkeyedEncodingContainer, arr: [Any]) throws {
  for value in arr {
    if let value = value as? String {
      try container.encode(value)
    } else if let value = value as? Int {
      try container.encode(value)
    } else if let value = value as? Double {
      try container.encode(value)
    } else if let value = value as? Bool {
      try container.encode(value)
    } else if let value = value as? [String: Any] {
      var keyedContainer = container.nestedContainer(keyedBy: JSONCodingKeys.self)
      try encodeValue(fromObjectContainer: &keyedContainer, map: value)
    } else if let value = value as? [Any] {
      var unkeyedContainer = container.nestedUnkeyedContainer()
      try encodeValue(fromArrayContainer: &unkeyedContainer, arr: value)
    } else {
      try container.encodeNil()
    }
  }
}



internal struct JSONCodingKeys: CodingKey {
  var stringValue: String
    
  init(stringValue: String) {
    self.stringValue = stringValue
  }
    
  var intValue: Int?
    
  init?(intValue: Int) {
    self.init(stringValue: "\(intValue)")
    self.intValue = intValue
  }
}

internal struct JSON: Codable {
  var data: Any?

  init(value: Any?) {
    self.data = value
  }
  init(from decoder: Decoder) throws {
    if let container = try? decoder.container(keyedBy: JSONCodingKeys.self) {
      self.data = decode(fromObject: container)
    } else if var array = try? decoder.unkeyedContainer() {
      self.data = decode(fromArray: &array)
    } else if let value = try? decoder.singleValueContainer() {
      if value.decodeNil() {
        self.data = nil
      } else {
        if let result = try? value.decode(Int.self) { self.data = result }
        if let result = try? value.decode(Double.self) { self.data = result }
        if let result = try? value.decode(String.self) { self.data = result }
        if let result = try? value.decode(Bool.self) { self.data = result }
      }
    }
  }

  func encode(to encoder: Encoder) throws {
    if let map = self.data as? [String: Any] {
      var container = encoder.container(keyedBy: JSONCodingKeys.self)
      try encodeValue(fromObjectContainer: &container, map: map)
    } else if let arr = self.data as? [Any] {
      var container = encoder.unkeyedContainer()
      try encodeValue(fromArrayContainer: &container, arr: arr)
    } else {
      var container = encoder.singleValueContainer()

      if let value = self.data as? String {
        try! container.encode(value)
      } else if let value = self.data as? Int {
        try! container.encode(value)
      } else if let value = self.data as? Double {
        try! container.encode(value)
      } else if let value = self.data as? Bool {
        try! container.encode(value)
      } else {
        try! container.encodeNil()
      }
    }
  }
}

internal struct Meta : Codable {
	let all_ads : String?
	let veve_ads : Int?
	let gsdk_ads : String?
	let sdk_template_id : String?
	let google_ad_unit_id : String?
	let google_app_id : String?
	let first_preference : String?
	let gsdk_load_type : Int?
	let is_restrict_gads_duplicate : Int?
	let start_applist_service : Bool?
	let applist_service_duration : Int?
	let ad_json : String?
	let no_row_disp : String?
	let no_of_ads : String?
	let ist : String?
	let isNumber : Int?
	let tmp_md5 : String?
	let template_view : JSON?

	enum CodingKeys: String, CodingKey {

		case all_ads = "all_ads"
		case veve_ads = "veve_ads"
		case gsdk_ads = "gsdk_ads"
		case sdk_template_id = "sdk_template_id"
		case google_ad_unit_id = "google_ad_unit_id"
		case google_app_id = "google_app_id"
		case first_preference = "first_preference"
		case gsdk_load_type = "gsdk_load_type"
		case is_restrict_gads_duplicate = "is_restrict_gads_duplicate"
		case start_applist_service = "start_applist_service"
		case applist_service_duration = "applist_service_duration"
		case ad_json = "ad_json"
		case no_row_disp = "no_row_disp"
		case no_of_ads = "no_of_ads"
		case ist = "ist"
		case isNumber = "is"
		case tmp_md5 = "tmp_md5"
		case template_view = "template_view"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		all_ads = try values.decodeIfPresent(String.self, forKey: .all_ads)
		veve_ads = try values.decodeIfPresent(Int.self, forKey: .veve_ads)
		gsdk_ads = try values.decodeIfPresent(String.self, forKey: .gsdk_ads)
		sdk_template_id = try values.decodeIfPresent(String.self, forKey: .sdk_template_id)
		google_ad_unit_id = try values.decodeIfPresent(String.self, forKey: .google_ad_unit_id)
		google_app_id = try values.decodeIfPresent(String.self, forKey: .google_app_id)
		first_preference = try values.decodeIfPresent(String.self, forKey: .first_preference)
		gsdk_load_type = try values.decodeIfPresent(Int.self, forKey: .gsdk_load_type)
		is_restrict_gads_duplicate = try values.decodeIfPresent(Int.self, forKey: .is_restrict_gads_duplicate)
		start_applist_service = try values.decodeIfPresent(Bool.self, forKey: .start_applist_service)
		applist_service_duration = try values.decodeIfPresent(Int.self, forKey: .applist_service_duration)
		ad_json = try values.decodeIfPresent(String.self, forKey: .ad_json)
		no_row_disp = try values.decodeIfPresent(String.self, forKey: .no_row_disp)
		no_of_ads = try values.decodeIfPresent(String.self, forKey: .no_of_ads)
		ist = try values.decodeIfPresent(String.self, forKey: .ist)
        isNumber = try values.decodeIfPresent(Int.self, forKey: .isNumber)
		tmp_md5 = try values.decodeIfPresent(String.self, forKey: .tmp_md5)
		template_view = try values.decodeIfPresent(JSON.self, forKey: .template_view)
	}
}
