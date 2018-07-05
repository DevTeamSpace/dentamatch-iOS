//
//  User.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 09/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class User: NSObject, NSCoding {
    var zipCode: String!
    var userName: String!
    var userId: String!
    var email: String!
    var accessToken: String!
    var firstName: String?
    var lastName: String?
    var jobTitleId: String? = ""
    var jobTitle: String? = ""
    var latitude: String? = ""
    var longitude: String? = ""
    var aboutMe: String? = ""
    var licenseNumber: String? = ""

    var isJobSeekerVerified: Bool? = false
    var profileImageURL: String? = ""

    var preferredJobLocation: String? = ""
    var city: String? = ""
    var country: String? = ""
    var state: String? = ""
    var preferredLocationId: String? = ""

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
        zipCode = aDecoder.decodeObject(forKey: "zipCode") as? String
        userName = aDecoder.decodeObject(forKey: "userName") as? String
        userId = aDecoder.decodeObject(forKey: "userId") as? String
        email = aDecoder.decodeObject(forKey: "email") as? String
        accessToken = aDecoder.decodeObject(forKey: "accessToken") as? String
        firstName = aDecoder.decodeObject(forKey: "firstName") as? String
        lastName = aDecoder.decodeObject(forKey: "lastName") as? String
        profileImageURL = aDecoder.decodeObject(forKey: "profileImageURL") as? String
        preferredJobLocation = aDecoder.decodeObject(forKey: "preferredJobLocation") as? String
        city = aDecoder.decodeObject(forKey: "city") as? String
        country = aDecoder.decodeObject(forKey: "country") as? String
        state = aDecoder.decodeObject(forKey: "state") as? String

        jobTitle = aDecoder.decodeObject(forKey: "jobTitle") as? String
        jobTitleId = aDecoder.decodeObject(forKey: "jobTitleId") as? String
        latitude = aDecoder.decodeObject(forKey: "latitude") as? String
        longitude = aDecoder.decodeObject(forKey: "longitude") as? String
        aboutMe = aDecoder.decodeObject(forKey: "aboutMe") as? String
        licenseNumber = aDecoder.decodeObject(forKey: "licenseNumber") as? String
        preferredLocationId = aDecoder.decodeObject(forKey: "preferredLocationId") as? String

        isJobSeekerVerified = aDecoder.decodeObject(forKey: "isJobSeekerVerified") as? Bool
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(zipCode, forKey: "zipCode")
        aCoder.encode(userName, forKey: "userName")
        aCoder.encode(userId, forKey: "userId")
        aCoder.encode(email, forKey: "email")
        aCoder.encode(accessToken, forKey: "accessToken")
        aCoder.encode(firstName, forKey: "firstName")
        aCoder.encode(lastName, forKey: "lastName")
        aCoder.encode(profileImageURL, forKey: "profileImageURL")
        aCoder.encode(preferredJobLocation, forKey: "preferredJobLocation")
        aCoder.encode(city, forKey: "city")
        aCoder.encode(country, forKey: "country")
        aCoder.encode(state, forKey: "state")
        aCoder.encode(jobTitle, forKey: "jobTitle")
        aCoder.encode(jobTitleId, forKey: "jobTitleId")
        aCoder.encode(latitude, forKey: "latitude")
        aCoder.encode(longitude, forKey: "longitude")
        aCoder.encode(aboutMe, forKey: "aboutMe")
        aCoder.encode(preferredLocationId, forKey: "preferredLocationId")
        aCoder.encode(licenseNumber, forKey: "licenseNumber")
        aCoder.encode(isJobSeekerVerified, forKey: "isJobSeekerVerified")
    }
}
