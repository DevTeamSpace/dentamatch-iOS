import Foundation

protocol DMEditCertificateModuleInput: BaseModuleInput {
    
}

protocol DMEditCertificateModuleOutput: BaseModuleOutput {
    
}

protocol DMEditCertificateViewInput: BaseViewInput {
    var viewOutput: DMEditCertificateViewOutput? { get set }
    
    func configureImageButton(image: UIImage)
}

protocol DMEditCertificateViewOutput: BaseViewOutput {
    var certificate: Certification? { get }
    var isEditing: Bool { get }
    var certificateImage: UIImage? { get set }
    var dateSelected: String { get set }
    
    func uploadCertificateImage(_ image: UIImage)
    func uploadValidityDate()
}

protocol DMEditCertificatePresenterProtocol: DMEditCertificateModuleInput, DMEditCertificateViewOutput {
    
}
