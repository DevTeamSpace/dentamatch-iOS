//
//  SearchParameters.swift
//  DentaMatch
//
//  Created by Shailesh Tyagi on 02/02/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class SearchParameters: NSObject, NSCoding {
    var lat: String? = ""
    var lng: String? = ""
    var zipCode: String? = ""
    var jobTitle: [String]? = []
    var jobTitleIds: [Int]? = []
    var isFulltime: String? = ""
    var isParttime: String? = ""
    var partTimeDays: [String]? = []
    var pageNo: Any? = 1

    required override init() {
        super.init()
    }

    // MARK: - NSCoding protocol methods

    required init?(coder aDecoder: NSCoder) {
        super.init()
        lat = aDecoder.decodeObject(forKey: "lat") as? String
        lng = aDecoder.decodeObject(forKey: "lng") as? String
        zipCode = aDecoder.decodeObject(forKey: "zipCode") as? String
        jobTitle = aDecoder.decodeObject(forKey: "jobTitle") as? [String]
        isFulltime = aDecoder.decodeObject(forKey: "isFulltime") as? String
        isParttime = aDecoder.decodeObject(forKey: "isParttime") as? String
        partTimeDays = aDecoder.decodeObject(forKey: "partTimeDays") as? [String]
        jobTitleIds = aDecoder.decodeObject(forKey: "jobTitleIds") as? [Int]
        pageNo = aDecoder.decodeObject(forKey: "pageNo")
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(lat, forKey: "lat")
        aCoder.encode(lng, forKey: "lng")
        aCoder.encode(zipCode, forKey: "zipCode")
        aCoder.encode(jobTitle, forKey: "jobTitle")
        aCoder.encode(isFulltime, forKey: "isFulltime")
        aCoder.encode(isParttime, forKey: "isParttime")
        aCoder.encode(partTimeDays, forKey: "parttimeDays")
        aCoder.encode(jobTitleIds, forKey: "jobTitleIds")
        aCoder.encode(pageNo, forKey: "pageNo")
    }
}
