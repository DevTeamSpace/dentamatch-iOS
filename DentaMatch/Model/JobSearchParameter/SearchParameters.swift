//
//  SearchParameters.swift
//  DentaMatch
//
//  Created by Shailesh Tyagi on 02/02/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class SearchParameters: NSObject , NSCoding {
    
    var lat: String? = ""
    var lng: String? = ""
    var zipCode: String? = ""
    var jobTitle: [String]? = []
    var isFulltime: String? = ""
    var isParttime:String? = ""
    var parttimeDays:[String]? = []
    
    required override init() {
        super.init()
    }
    
    // MARK: - NSCoding protocol methods
    required init?(coder aDecoder: NSCoder) {
        super.init()
        self.lat = aDecoder.decodeObject(forKey: "lat") as? String
        self.lng = aDecoder.decodeObject(forKey: "lng") as? String
        self.zipCode = aDecoder.decodeObject(forKey: "zipCode") as? String
        self.jobTitle = aDecoder.decodeObject(forKey: "jobTitle") as? [String]
        self.isFulltime = aDecoder.decodeObject(forKey: "isFulltime") as? String
        self.isParttime = aDecoder.decodeObject(forKey: "isParttime") as? String
        self.parttimeDays = aDecoder.decodeObject(forKey: "parttimeDays") as? [String]
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.lat, forKey: "lat")
        aCoder.encode(self.lng, forKey: "lng")
        aCoder.encode(self.zipCode, forKey: "zipCode")
        aCoder.encode(self.jobTitle, forKey: "jobTitle")
        aCoder.encode(self.isFulltime, forKey: "isFulltime")
        aCoder.encode(self.isParttime, forKey: "isParttime")
        aCoder.encode(self.parttimeDays, forKey: "parttimeDays")
    }
}
