import Foundation
import SwiftyJSON

class DMEditCertificatePresenter: DMEditCertificatePresenterProtocol {
    
    unowned let viewInput: DMEditCertificateViewInput
    unowned let moduleOutput: DMEditCertificateModuleOutput
    
    var certificate: Certification?
    var isEditing: Bool
    
    init(certificate: Certification?, isEditing: Bool, viewInput: DMEditCertificateViewInput, moduleOutput: DMEditCertificateModuleOutput) {
        self.certificate = certificate
        self.isEditing = isEditing
        self.viewInput = viewInput
        self.moduleOutput = moduleOutput
    }
    
    var certificateImage: UIImage?
    var dateSelected = ""
}

extension DMEditCertificatePresenter: DMEditCertificateModuleInput {
    
    func viewController() -> UIViewController {
        return viewInput.viewController()
    }
}

extension DMEditCertificatePresenter: DMEditCertificateViewOutput {
    
    func uploadCertificateImage(_ image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            viewInput.show(toastMessage: "Image compression problem")
            return
        }
        
        let params = [ "certificateId": certificate?.certificationId ?? "",
                       "image": imageData ] as [String : Any]
        
        viewInput.showLoading()
        APIManager.apiMultipart(serviceName: Constants.API.updateCertificate, parameters: params, completionHandler: { [weak self] (response: JSON?, error: NSError?) in
            
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
                
                self?.viewInput.configureImageButton(image: image)
                self?.viewInput.show(toastMessage: response[Constants.ServerKey.message].stringValue)
                self?.certificate?.certificateImageURL = response[Constants.ServerKey.result][Constants.ServerKey.imageURLForPostResponse].stringValue
                
                if let certificate = self?.certificate {
                    NotificationCenter.default.post(name: .updateProfileScreen, object: nil, userInfo: ["certification": certificate])
                }
            } else {
                self?.viewInput.show(toastMessage: response[Constants.ServerKey.message].stringValue)
            }
        })
    }
    
    func uploadValidityDate() {
        
        let params: [String: Any] = [ "certificateValidition": [ ["id": self.certificate?.certificationId,
                                                                "value": self.dateSelected == Constants.kEmptyDate ? "" : self.dateSelected ] ]]
        
        viewInput.showLoading()
        APIManager.apiPostWithJSONEncode(serviceName: Constants.API.updateValidationDates, parameters: params) { [weak self] (response: JSON?, error: NSError?) in
            
            self?.viewInput.hideLoading()
            
            if let error = error {
                self?.viewInput.show(toastMessage: error.localizedDescription)
                return
            }
            
            guard let response = response else {
                self?.viewInput.show(toastMessage: Constants.AlertMessage.somethingWentWrong)
                return
            }
            
            self?.viewInput.show(toastMessage: response[Constants.ServerKey.message].stringValue)
            
            if response[Constants.ServerKey.status].boolValue {
                
                self?.certificate?.validityDate = self?.dateSelected ?? ""
                if let certificate = self?.certificate {
                    NotificationCenter.default.post(name: .updateProfileScreen, object: nil, userInfo: ["certification": certificate])
                }
                self?.viewInput.popViewController()
            }
        }
    }
}

extension DMEditCertificatePresenter {
    
}
