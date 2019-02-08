import Foundation

protocol DMAffiliationsModuleInput: BaseModuleInput {
    
}

protocol DMAffiliationsModuleOutput: BaseModuleOutput {
}

protocol DMAffiliationsViewInput: BaseViewInput {
    var viewOutput: DMAffiliationsViewOutput? { get set }
    
    func reloadData()
}

protocol DMAffiliationsViewOutput: BaseViewOutput {
    var selectedAffiliationsFromProfile: [Affiliation] { get }
    var isEditing: Bool { get }
    var isOtherSelected: Bool { get set }
    var otherText: String { get set }
    var affiliations: [Affiliation] { get set }
    
    func getAffiliations()
    func saveAffiliationData()
}

protocol DMAffiliationsPresenterProtocol: DMAffiliationsModuleInput, DMAffiliationsViewOutput {
    
}
