import Foundation
import SwiftyJSON

protocol DMCalendarSetAvailabilityModuleInput: BaseModuleInput {
    
}

protocol DMCalendarSetAvailabilityModuleOutput: BaseModuleOutput {
    
    func showTabBar()
}

protocol DMCalendarSetAvailabilityViewInput: BaseViewInput {
    var viewOutput: DMCalendarSetAvailabilityViewOutput? { get set }
    
    func configureView(fromJobSelection: Bool)
    func configureWithAvailability(response: JSON)
    func reloadData()
}

protocol DMCalendarSetAvailabilityViewOutput: BaseViewOutput {
    
    func didLoad()
    func setAvailability(params: [String: Any])
}

protocol DMCalendarSetAvailabilityPresenterProtocol: DMCalendarSetAvailabilityModuleInput, DMCalendarSetAvailabilityViewOutput {
    
}
