//
//  User.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 09/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import UIKit

class User: NSObject {
    
    /*
     "email" : "sanjay.yadav@appster.in",
     "firstName" : "Sanjay Yadav",
     "lastName" : "Sanjay Yadav",
     "zipCode" : 95014,
     "preferredJobLocation" : "2 Infinite Loop Cupertino, CA 95014, USA",
     "accessToken" : "9149e1ac16240e6101406eb32da64acb"
     */
    var zipCode: String!
    var userName: String!
    var email: String!
    var accessToken: String!
//    var id: String!
    
    //    var _fullName: String?
    var firstName: String?
    var lastName: String?
    
    var thumbImageUrl: String?
    var preferredJobLocation: String?
    
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
//        self.id = aDecoder.decodeObject(forKey: "id") as? String
        self.userName = aDecoder.decodeObject(forKey: "userName") as? String
        self.email = aDecoder.decodeObject(forKey: "email") as? String
        self.accessToken = aDecoder.decodeObject(forKey: "accessToken") as? String
        //        self.fullName = aDecoder.decodeObjectForKey("fullName") as? String
        self.firstName = aDecoder.decodeObject(forKey: "firstName") as? String
        self.lastName = aDecoder.decodeObject(forKey: "lastName") as? String
        self.thumbImageUrl = aDecoder.decodeObject(forKey: "thumbImageUrl") as? String
        self.preferredJobLocation = aDecoder.decodeObject(forKey: "preferredJobLocation") as? String
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encode(self.zipCode, forKey: "zipCode")
//        aCoder.encode(self.id, forKey: "id")
        aCoder.encode(self.userName, forKey: "userName")
        aCoder.encode(self.email, forKey: "email")
        aCoder.encode(self.accessToken, forKey: "accessToken")
        //       aCoder.encodeObject(self.fullName, forKey: "fullName")
        aCoder.encode(self.firstName, forKey: "firstName")
        aCoder.encode(self.lastName, forKey: "lastName")
        aCoder.encode(self.thumbImageUrl, forKey: "thumbImageUrl")
        aCoder.encode(self.preferredJobLocation, forKey: "preferredJobLocation")
    }


}
