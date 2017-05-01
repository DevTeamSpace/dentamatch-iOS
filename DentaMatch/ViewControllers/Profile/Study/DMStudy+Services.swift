//
//  DMStudy+Services.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 14/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation
import SwiftyJSON

extension DMStudyVC {
    
    func getSchoolListAPI() {
        self.showLoader()
        APIManager.apiGet(serviceName: Constants.API.getSchoolListAPI, parameters: [:]) { (response:JSON?, error:NSError?) in
            self.hideLoader()
            if error != nil {
                self.makeToast(toastString: (error?.localizedDescription)!)
                return
            }
            
            if response == nil {
                self.makeToast(toastString: Constants.AlertMessage.somethingWentWrong)
                return
            }
            debugPrint(response!)
            self.handleSchoolListAPIResponse(response: response)
        }
    }
    
    func addSchoolAPI(params:[String:AnyObject]) {
        self.showLoader()
        APIManager.apiPostWithJSONEncode(serviceName: Constants.API.addSchoolAPI, parameters: params) { (response:JSON?, error:NSError?) in
            
            self.hideLoader()
            if error != nil {
                self.makeToast(toastString: (error?.localizedDescription)!)
                return
            }
            
            if response == nil {
                self.makeToast(toastString: Constants.AlertMessage.somethingWentWrong)
                return
            }
            debugPrint(response!)

            if response![Constants.ServerKey.status].boolValue {
                self.openSkillsScreen()
            }
            self.makeToast(toastString: response![Constants.ServerKey.message].stringValue)
        }
    }
    
    func handleSchoolListAPIResponse(response:JSON?) {
        if let response = response {
            if response[Constants.ServerKey.status].boolValue {
                let schoolCategoryList = response[Constants.ServerKey.result][Constants.ServerKey.list].arrayValue
                self.prepareSchoolCategoryListData(schoolCategoryList: schoolCategoryList)
                self.studyTableView.reloadData()
            } else {
                //handle fail case
                self.makeToast(toastString: response[Constants.ServerKey.message].stringValue)
            }
        }
    }
    
    func prepareSchoolCategoryListData(schoolCategoryList:[JSON]) {
        for schoolCategoryObj in schoolCategoryList {
            
            var universities = [University]()
            let universitiesArray = schoolCategoryObj[Constants.ServerKey.schoolCategory].arrayValue
            
            for universityObj in universitiesArray {
                let university = University(university: universityObj)
                universities.append(university)
            }
            
            let schoolCategory = SchoolCategory(school: schoolCategoryObj, universities: universities)
            schoolCategories.append(schoolCategory)
        }
        
        for category in schoolCategories {
            
            var flag = 0
            if let university = category.universities.filter({$0.isSelected == true}).first
            {
            if selectedData.count == 0 {
                let dict = NSMutableDictionary()
                dict["parentId"] = category.schoolCategoryId
                dict["schoolId"] = category.schoolCategoryId
                dict["other"] = university.universityName
                dict["yearOfGraduation"] = university.yearOfGraduation
                dict["parentName"] = category.schoolCategoryName
                selectedData.add(dict)
                flag = 1
            } else {
                for categoryObj in selectedData {
                    let dict = categoryObj as! NSMutableDictionary
                    
                    if dict["parentId"] as! String == category.schoolCategoryId {
                        dict["other"] = university.universityName
                        flag = 1
                    }
                }
            }
            
            //Array is > 0 but dict doesnt exists
            if flag == 0 {
                let dict = NSMutableDictionary()
                dict["parentId"] = category.schoolCategoryId
                dict["schoolId"] = university.universityId as AnyObject?
                dict["other"] = university.universityName
                dict["yearOfGraduation"] = university.yearOfGraduation
                dict["parentName"] = category.schoolCategoryName
                selectedData.add(dict)
            }
            
            debugPrint(selectedData)

            } else {
                if selectedData.count == 0 {
                    let dict = NSMutableDictionary()
                    dict["parentId"] = category.schoolCategoryId
                    dict["schoolId"] = category.schoolCategoryId
                    dict["other"] = ""
                    if let other = category.othersArray {
                        dict["other"] = other[0][Constants.ServerKey.otherSchooling].stringValue
                        dict["yearOfGraduation"] = other[0][Constants.ServerKey.yearOfGraduation].stringValue
                    }
                    dict["parentName"] = category.schoolCategoryName
                    selectedData.add(dict)
                    flag = 1
                } else {
                    for categoryObj in selectedData {
                        let dict = categoryObj as! NSMutableDictionary
                        
                        if dict["parentId"] as! String == category.schoolCategoryId {
                            if let other = category.othersArray {
                                dict["other"] = other[0][Constants.ServerKey.otherSchooling].stringValue
                            }
                            flag = 1
                        }
                    }
                }
                
                //Array is > 0 but dict doesnt exists
                if flag == 0 {
                    let dict = NSMutableDictionary()
                    dict["parentId"] = category.schoolCategoryId
                    dict["schoolId"] = category.schoolCategoryId
                    dict["other"] = ""
                    if let other = category.othersArray {
                        dict["other"] = other[0][Constants.ServerKey.otherSchooling].stringValue
                        dict["yearOfGraduation"] = other[0][Constants.ServerKey.yearOfGraduation].stringValue
                    }
                    dict["parentName"] = category.schoolCategoryName
                    selectedData.add(dict)
                }
                
                debugPrint(selectedData)
            }
            
        }
        checkForEmptySchoolField()
    }
    
    func preparePostSchoolData(schoolsSelected:NSMutableArray) {
        
        var params = [String:AnyObject]()
        let selectedArray = NSMutableArray()
        if schoolsSelected.count == 0 {
            self.makeToast(toastString: "Please select your school")
            return
        }
        for school in schoolsSelected {
            let dict = school as! NSMutableDictionary
            if let yearOfGraduation =  dict["yearOfGraduation"] as? String{
                //Everything fine
                if yearOfGraduation.isEmpty {
                    self.makeToast(toastString: "Please enter graduation year for \(dict["other"] as! String)")
                    return
                }

            } else {
                self.makeToast(toastString: "Please enter graduation year for \(dict["other"] as! String)")
                return
            }
            self.checkAvailabilityInAutoComplete(dictionary: dict)
            debugPrint(dict)
            
            let makeData = NSMutableDictionary()
            makeData.setObject(dict["schoolId"] as! String, forKey: "schoolingChildId" as NSCopying)
            makeData.setObject(dict["yearOfGraduation"] as! String, forKey: "yearOfGraduation" as NSCopying)
            
            if dict["isOther"] as! Bool {
                makeData.setObject(dict["other"] as! String, forKey: "otherSchooling" as NSCopying)
            } else {
                makeData.setObject("", forKey: "otherSchooling" as NSCopying)
            }

            selectedArray.add(makeData)
            
        }
        params["schoolDataArray"] = selectedArray as AnyObject
        
        
        debugPrint("\nPost School Params\n \(params.description)")
        addSchoolAPI(params: params)
    }
    
    func checkAvailabilityInAutoComplete(dictionary:NSMutableDictionary) {
        let dict = dictionary
        let schoolName = (dict["other"] as! String).trim()
        let parentId = dict["parentId"] as! String
        let universities = schoolCategories.filter({$0.schoolCategoryId == parentId}).first?.universities
        
        let university = universities?.filter({$0.universityName == schoolName})
        
        if (university?.count)! > 0 {
            if university?.first?.universityName == schoolName {
                dict["schoolId"] = university!.first!.universityId
                dict["isOther"] = false
                dict["other"] = schoolName
            }
        } else {
            dict["other"] = schoolName
            dict["isOther"] = true
        }
    }
}
