import Foundation
import UIKit

protocol CalendarHeaderViewDelegate: class {
    func onPrevMonthButtonTapped()
    func onNextMonthButtonTapped()
    func onSetAvailabilityTapped()
}

final class CalendarHeaderView: BaseView {
    
    @IBOutlet weak var fullTimeJobIndicatorView: UIView! {
        didSet {
            fullTimeJobIndicatorView.layer.cornerRadius = fullTimeJobIndicatorView.frame.height / 2.0
            fullTimeJobIndicatorView.clipsToBounds = true
        }
    }
    @IBOutlet weak var monthTitleLabel: UILabel!
    @IBOutlet weak var viewForCalendar: UIView!
    @IBOutlet weak var viewForHeader: UIView!
    
    weak var delegate: CalendarHeaderViewDelegate?
    
    @IBAction func prevMonthButtonAction() {
        delegate?.onPrevMonthButtonTapped()
    }
    
    @IBAction func nextMonthButtonAction() {
        delegate?.onNextMonthButtonTapped()
    }
    
    @IBAction func setAvailabitityButtonTapped() {
        delegate?.onSetAvailabilityTapped()
    }
}
