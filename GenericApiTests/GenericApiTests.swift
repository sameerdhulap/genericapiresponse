//
//  GenericApiTests.swift
//  GenericApiTests
//
//  Created by WGS on 10/01/24.
//

import XCTest
@testable import GenericApi

final class GenericApiTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        let JSON = """
        {
          "error": 0,
          "errormsg": "",
          "data": {
            "meta": {
              "all_ads": "5",
              "veve_ads": 5,
              "gsdk_ads": "0",
              "sdk_template_id": "79",
              "google_ad_unit_id": "/21930596546/App_TicTacToe_Native_MC",
              "google_app_id": "ca-app-pub-6491779345308528~1860688724",
              "first_preference": "google",
              "gsdk_load_type": 1,
              "is_restrict_gads_duplicate": 1,
              "start_applist_service": true,
              "applist_service_duration": 86400000,
              "ad_json": null,
              "no_row_disp": "1",
              "no_of_ads": "5",
              "ist": "rc",
              "is": 144,
              "tmp_md5": "fe741518a317bcf09f4625e5f9fc821c",
              "template_view": {
                "widget": "android.widget.RelativeLayout",
                "properties": [
                  {
                    "name": "id",
                    "type": "",
                    "value": "ads_parent"
                  },
                  {
                    "name": "layout_width",
                    "type": "dimen",
                    "value": "match_parent"
                  },
                  {
                    "name": "layout_height",
                    "type": "dimen",
                    "value": "wrap_parent"
                  },
                  {
                    "name": "padding",
                    "type": "dimen",
                    "value": "2dp"
                  },
                  {
                    "name": "alpha",
                    "type": "float",
                    "value": "0"
                  }
                ]
              }
            }
          }
        }
        """

        let jsonData = JSON.data(using: .utf8)!
        let blogPost: adAPIResponse = try! JSONDecoder().decode(adAPIResponse.self, from: jsonData)

        if let result: [String: Any] = blogPost.data?.meta?.template_view?.data as? [String:Any]{
            if let widget = result["widget"] as? String{
                XCTAssertEqual(widget ,"android.widget.RelativeLayout")
            }
            if let properties = result["properties"] as? [Any]{
                XCTAssertEqual(properties.count ,5)
            }
        }
        XCTAssertEqual(blogPost.error ?? 0 ,0)
    }

}
