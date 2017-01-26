//
//  User.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 09/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class User: NSObject , NSCoding {
    
    var zipCode: String!
    var userName: String!
    var email: String!
    var accessToken: String!
    var firstName: String?
    var lastName: String?
    var jobTitleId:String? = ""
    var jobTitle:String? = ""
    var latitude:String? = ""
    var longitude:String? = ""
    var aboutMe:String? = ""

    var profileImageURL: String? = ""
    var preferredJobLocation: String? = ""
    
    func fullName() -> String? {
        if let _ = firstName, let _ = lastName {
            return firstName! + " " + lastName!
        }
        if let _ = firstName {
            return firstName
        }
        if let _ = lastName {
            return lastName
        }
        return ""
    }
    
    required override init() {
        super.init()
    }
    
    // MARK: - NSCoding protocol methods
    required init?(coder aDecoder: NSCoder) {
        super.init()
        self.zipCode = aDecoder.decodeObject(forKey: "zipCode") as? String
        self.userName = aDecoder.decodeObject(forKey: "userName") as? String
        self.email = aDecoder.decodeObject(forKey: "email") as? String
        self.accessToken = aDecoder.decodeObject(forKey: "accessToken") as? String
        self.firstName = aDecoder.decodeObject(forKey: "firstName") as? String
        self.lastName = aDecoder.decodeObject(forKey: "lastName") as? String
        self.profileImageURL = aDecoder.decodeObject(forKey: "profileImageURL") as? String
        self.preferredJobLocation = aDecoder.decodeObject(forKey: "preferredJobLocation") as? String
        self.jobTitle = aDecoder.decodeObject(forKey: "jobTitle") as? String
        self.jobTitleId = aDecoder.decodeObject(forKey: "jobTitleId") as? String
        self.latitude = aDecoder.decodeObject(forKey: "latitude") as? String
        self.longitude = aDecoder.decodeObject(forKey: "longitude") as? String
        self.aboutMe = aDecoder.decodeObject(forKey: "aboutMe") as? String

    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.zipCode, forKey: "zipCode")
        aCoder.encode(self.userName, forKey: "userName")
        aCoder.encode(self.email, forKey: "email")
        aCoder.encode(self.accessToken, forKey: "accessToken")
        aCoder.encode(self.firstName, forKey: "firstName")
        aCoder.encode(self.lastName, forKey: "lastName")
        aCoder.encode(self.profileImageURL, forKey: "profileImageURL")
        aCoder.encode(self.preferredJobLocation, forKey: "preferredJobLocation")
        aCoder.encode(self.jobTitle, forKey: "jobTitle")
        aCoder.encode(self.jobTitleId, forKey: "jobTitleId")
        aCoder.encode(self.latitude, forKey: "latitude")
        aCoder.encode(self.longitude, forKey: "longitude")
        aCoder.encode(self.longitude, forKey: "aboutMe")

    }
}
