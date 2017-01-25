//
//  String+Additons.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 12/10/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import Foundation
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

extension String {
    
    var isValidEmail: Bool {
        let emailRegEx = "^[_A-Za-z0-9-]+(\\.[_A-Za-z0-9-]+)*@[A-Za-z0-9]+(\\.[A-Za-z0-9]+)*(\\.[A-Za-z]{2,})$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    var isValidPhoneNumber: Bool {
        let phoneRegEx = "^\\+\\d{3}-\\d{2}-\\d{7}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegEx)
        return phoneTest.evaluate(with: self)
    }
    
    var isEmpty: Bool {
        if self.characters.count == 0 {
            return true
        }
        return false
    }
    
    var isEmptyField:Bool {
        if self.trimmingCharacters(in: CharacterSet.whitespaces).characters.count == 0 {
            return true
        }
        return false
    }
    
    func dropLast(_ n: Int) -> String {
        return String(characters.dropLast(n))
    }
    
    subscript (i: Int) -> Character {
        return self[self.index(self.startIndex, offsetBy: i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    subscript (r: Range<Int>) -> String {
        let start = self.index(self.startIndex, offsetBy: r.lowerBound)
        let end = self.index(start, offsetBy: r.upperBound)
        return self[Range(start ..< end)]
    }
    
    
    
    func lpad(_ padding: String, length: Int) -> (String) {
        if self.characters.count > length {
            return self
        }
        return "".padding(toLength: length - self.characters.count, withPad:padding, startingAt:0) + self
    }
    /**
     Pads the right side of a string with the specified string up to the specified length.
     Does not clip the string if too long.
     
     - parameter padding:   The string to use to create the padding (if needed)
     - parameter length:    Integer target length for entire string
     - returns: The padded string
     */
    func rpad(_ padding: String, length: Int) -> (String) {
        if self.characters.count > length { return self }
        return self.padding(toLength: length, withPad:padding, startingAt:0)
    }
    /**
     Returns string with left and right spaces trimmed off.
     
     - returns: Trimmed String
     */
    func trim() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespaces)
    }
    /**
     Shortcut for getting length (since Swift keeps cahnging this).
     
     - returns: Int length of string
     */
    var length: Int {
        return self.characters.count
    }
    /**
     Returns character at a specific position from a string.
     
     - parameter index:               The position of the character
     - returns: Character
     */
//    subscript (i: Int) -> Character {
//        return self[self.characters.index(self.startIndex, offsetBy: i)]
//    }
//    subscript (i: Int) -> String {
//        return String(self[i] as Character)
//    }
    /**
     Returns substring extracted from a string at start and end location.
     
     - parameter start:               Where to start (-1 acceptable)
     - parameter end:                 (Optional) Where to end (-1 acceptable) - default to end of string
     - returns: String
     */
    func stringFrom(_ start: Int, to end: Int? = nil) -> String {
        var maximum = self.characters.count
        
        let i = start < 0 ? self.endIndex : self.startIndex
        let ioffset = min(maximum, max(-1 * maximum, start))
        let startIndex = self.index(i, offsetBy: ioffset)
        
        maximum -= start
        
        let j = end < 0 ? self.endIndex : self.startIndex
        let joffset = min(maximum, max(-1 * maximum, end ?? 0))
        let endIndex = end != nil && end! < self.characters.count ? self.index(j, offsetBy: joffset) : self.endIndex
        return self.substring(with: (startIndex ..< endIndex))
    }
    /**
     Returns substring composed of only the allowed characters.
     
     - parameter allowed:             String list of acceptable characters
     - returns: String
     */
    func onlyCharacters(_ allowed: String) -> String {
        let search = allowed.characters
        return characters.filter({ search.contains($0) }).reduce("", { $0 + String($1) })
    }
    /**
     Simple pattern matcher. Requires full match (ie, includes ^$ implicitly).
     
     - parameter pattern:             Regex pattern (includes ^$ implicitly)
     - returns: true if full match found
     */
    func matches(_ pattern: String) -> Bool {
        let test = NSPredicate(format:"SELF MATCHES %@", pattern)
        return test.evaluate(with: self)
    }
    
    func widthWithConstraintHeight(height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        return boundingBox.width
    }

}
