import Foundation
import SwiftyJSON

class DMEditStudyPresenter: DMEditStudyPresenterProtocol {
    
    unowned let viewInput: DMEditStudyViewInput
    unowned let moduleOutput: DMEditStudyModuleOutput
    
    var selectedSchoolCategories: [SelectedSchool]
    
    init(selectedCategories: [SelectedSchool]?, viewInput: DMEditStudyViewInput, moduleOutput: DMEditStudyModuleOutput) {
        self.selectedSchoolCategories = selectedCategories ?? []
        self.viewInput = viewInput
        self.moduleOutput = moduleOutput
    }
    
    var isFilledFromAutoComplete = false
    var schoolCategories = [SchoolCategory]()
    var selectedData = NSMutableArray()
}

extension DMEditStudyPresenter: DMEditStudyModuleInput {
    
    func viewController() -> UIViewController {
        return viewInput.viewController()
    }
}

extension DMEditStudyPresenter: DMEditStudyViewOutput {
    
    func getSchoolList() {
        
        viewInput.showLoading()
        APIManager.apiGet(serviceName: Constants.API.getSchoolListAPI, parameters: [:]) { [weak self] (response: JSON?, error: NSError?) in
            
            self?.viewInput.hideLoading()
            
            if let error = error {
                self?.viewInput.show(toastMessage: error.localizedDescription)
                return
            }
            
            guard let response = response else {
                self?.viewInput.show(toastMessage: Constants.AlertMessage.somethingWentWrong)
                return
            }
            
            if response[Constants.ServerKey.status].boolValue {
                
                let schoolCategoryList = response[Constants.ServerKey.result][Constants.ServerKey.list].arrayValue
                self?.prepareSchoolCategoryListData(schoolCategoryList: schoolCategoryList)
                self?.viewInput.reloadData()
            } else {
                
                self?.viewInput.show(toastMessage: response[Constants.ServerKey.message].stringValue)
            }
        }
    }
    
    func addSchool() {
        
        var params = [String: Any]()
        let selectedArray = NSMutableArray()
        if selectedData.count == 0 {
            viewInput.show(toastMessage: "Please select your school")
            return
        }
        
        guard let finalData = selectedData.mutableCopy() as? NSMutableArray else { return }
        
        selectedData.removeAllObjects()
        for school in finalData {
            if let dict = school as? NSMutableDictionary {
                
                checkAvailabilityInAutoComplete(dictionary: dict)
                
                let makeData = NSMutableDictionary()
                makeData.setObject((dict["schoolId"] as? String) ?? "", forKey: "schoolingChildId" as NSCopying)
                makeData.setObject((dict["yearOfGraduation"] as? String) ?? "", forKey: "yearOfGraduation" as NSCopying)
                
                if (dict["isOther"] as? Bool) ?? false {
                    makeData.setObject((dict["other"] as? String) ?? "", forKey: "otherSchooling" as NSCopying)
                } else {
                    makeData.setObject("", forKey: "otherSchooling" as NSCopying)
                }
                
                selectedArray.add(makeData)
            }
            
        }
        params["schoolDataArray"] = selectedArray
        
        viewInput.showLoading()
        APIManager.apiPostWithJSONEncode(serviceName: Constants.API.addSchoolAPI, parameters: params) { [weak self] (response: JSON?, error: NSError?) in
            
            self?.viewInput.hideLoading()
            
            if let error = error {
                self?.viewInput.show(toastMessage: error.localizedDescription)
                return
            }
            
            guard let response = response else {
                self?.viewInput.show(toastMessage: Constants.AlertMessage.somethingWentWrong)
                return
            }
            
            if response[Constants.ServerKey.status].boolValue {
                self?.updateProfileScreen()
                self?.viewInput.popViewController()
            }
            self?.viewInput.show(toastMessage: response[Constants.ServerKey.message].stringValue)
        }
    }
    
    func checkForEmptySchoolField() {
        
        let emptyData = NSMutableArray()
        for category in selectedData {
            if let dict = category as? NSMutableDictionary, let other = dict["other"] as? String  {
                if other.isEmptyField {
                    emptyData.add(dict)
                }
            }
        }
    }
    
    func didSelect(schoolCategoryId: String, university: University) {
        
        let school = schoolCategories.filter({ $0.schoolCategoryId == schoolCategoryId }).first
        isFilledFromAutoComplete = true
        var flag = 0
        
        if selectedData.count == 0 {
            let dict = NSMutableDictionary()
            dict["parentId"] = "\(schoolCategoryId)"
            dict["schoolId"] = "\(university.universityId)"
            dict["other"] = university.universityName
            dict["parentName"] = school?.schoolCategoryName
            selectedData.add(dict)
            flag = 1
        } else {
            for category in selectedData {
                if let dict = category as? NSMutableDictionary, let parentId = dict["parentId"] as? String {
                    if parentId == "\(schoolCategoryId)" {
                        dict["other"] = university.universityName
                        dict["parentName"] = school?.schoolCategoryName
                        flag = 1
                    }
                }
            }
        }
        // Array is > 0 but dict doesnt exists
        if flag == 0 {
            let dict = NSMutableDictionary()
            dict["parentId"] = schoolCategoryId as AnyObject?
            dict["schoolId"] = university.universityId as AnyObject?
            dict["other"] = university.universityName
            dict["parentName"] = school?.schoolCategoryName
            dict["yearOfGraduation"] = ""
            selectedData.add(dict)
        }
        
        viewInput.reloadData()
    }
    
    func removeEmptyYear() {
        
        let emptyData = NSMutableArray()
        for category in selectedData {
            if let dict = category as? NSMutableDictionary {
                if ((dict["other"] as? String) ?? "").isEmptyField {
                    emptyData.add(dict)
                }
            }
        }
        // debugPrint(selectedData.description)
        selectedData.removeObjects(in: emptyData as [AnyObject])
        viewInput.reloadData()
    }
    
    func onDoneButtonTap(year: Int, tag: Int) {
        
        var flag = 0
        if selectedData.count == 0 {
            let dict = NSMutableDictionary()
            dict["parentId"] = "\(tag)"
            dict["schoolId"] = "\(tag)"
            if year == -1 {
                dict["yearOfGraduation"] = ""
                removeEmptyYear()
            } else {
                dict["yearOfGraduation"] = "\(year)"
            }
            
            if let _ = dict["other"] {
                // debugPrint("Other dict")
            } else {
                dict["other"] = ""
            }
            selectedData.add(dict)
            flag = 1
        } else {
            for category in selectedData {
                if let dict = category as? NSMutableDictionary, let parentId = dict["parentId"] as? String {
                    if parentId == "\(tag)" {
                        if year == -1 {
                            dict["yearOfGraduation"] = ""
                        } else {
                            dict["yearOfGraduation"] = "\(year)"
                        }
                        if let _ = dict["other"] {
                            // debugPrint("Other dict")
                        } else {
                            dict["other"] = ""
                        }
                        flag = 1
                    }
                }
            }
        }
        
        // Array is > 0 but dict doesnt exists
        if flag == 0 {
            let dict = NSMutableDictionary()
            dict["parentId"] = "\(tag)"
            dict["schoolId"] = "\(tag)"
            if year == -1 {
                dict["yearOfGraduation"] = ""
                removeEmptyYear()
            } else {
                dict["yearOfGraduation"] = "\(year)"
            }
            
            if let _ = dict["other"] {
                // debugPrint("Other dict")
            } else {
                dict["other"] = ""
            }
            selectedData.add(dict)
        }
        
        viewInput.reloadData()
    }
}

extension DMEditStudyPresenter {
    
    private func checkAvailabilityInAutoComplete(dictionary: NSMutableDictionary) {
        let dict = dictionary
        let schoolName = (dict["other"] as? String)?.trim()
        let parentId = (dict["parentId"] as? String) ?? ""
        let universities = schoolCategories.filter({ $0.schoolCategoryId == parentId }).first?.universities
        
        let university = universities?.filter({ $0.universityName == schoolName })
        
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
    
    private func updateProfileScreen() {
        selectedSchoolCategories.removeAll()
        for school in selectedData {
            if let dict = school as? NSMutableDictionary {
                let selectedSchool = SelectedSchool()
                selectedSchool.schoolCategoryId = (dict["parentId"] as? String) ?? ""
                selectedSchool.universityId = (dict["schoolId"]  as? String) ?? ""
                selectedSchool.universityName = (dict["other"]  as? String) ?? ""
                selectedSchool.yearOfGraduation = dict["yearOfGraduation"] as? String ?? ""
                selectedSchool.schoolCategoryName = dict["parentName"] as? String ?? ""
                selectedSchoolCategories.append(selectedSchool)
            }
            
        }
        NotificationCenter.default.post(name: .updateProfileScreen, object: nil, userInfo: ["schools": self.selectedSchoolCategories])
    }
    
    private func prepareSchoolCategoryListData(schoolCategoryList: [JSON]) {
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
            if let university = category.universities.filter({ $0.isSelected == true }).first {
                // If university selected exists
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
                        if let dict = categoryObj as? NSMutableDictionary, let parentId = dict["parentId"] as? String {
                            if parentId == category.schoolCategoryId {
                                dict["other"] = university.universityName
                                flag = 1
                            }
                        }
                    }
                }
                
                // Array is > 0 but dict doesnt exists
                if flag == 0 {
                    let dict = NSMutableDictionary()
                    dict["parentId"] = category.schoolCategoryId
                    dict["schoolId"] = university.universityId as AnyObject?
                    dict["other"] = university.universityName
                    dict["yearOfGraduation"] = university.yearOfGraduation
                    dict["parentName"] = category.schoolCategoryName
                    selectedData.add(dict)
                }
                
                // debugPrint(selectedData)
                
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
                        if let dict = categoryObj as? NSMutableDictionary, let parentId = dict["parentId"] as? String {
                            if parentId == category.schoolCategoryId {
                                if let other = category.othersArray {
                                    dict["other"] = other[0][Constants.ServerKey.otherSchooling].stringValue
                                }
                                flag = 1
                            }
                        }
                    }
                }
                
                // Array is > 0 but dict doesnt exists
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
                
                // debugPrint(selectedData)
            }
        }
        checkForEmptySchoolField()
    }
}
