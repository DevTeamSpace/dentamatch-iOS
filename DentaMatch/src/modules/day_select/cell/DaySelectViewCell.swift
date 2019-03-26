import Foundation
import UIKit

protocol DaySelectViewCellDelegate: class {
    
}

struct DaySelectViewCellObject {

    var isSelected: Bool
    let date: Date
    weak var delegate: DaySelectViewCellDelegate?
}

class DaySelectViewCell: UITableViewCell {

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var checkView: UIView! {
        didSet {
            checkView.backgroundColor = UIColor.clear
            checkView.layer.borderColor = UIColor.silverCheck.cgColor
            checkView.layer.cornerRadius = checkViewCornerRadius
        }
    }
    
    weak var delegate: DaySelectViewCellDelegate?
    private var isChecked: Bool = true
    
    override func draw(_ rect: CGRect) {
        guard let ctx = UIGraphicsGetCurrentContext() else { return }
        
        let rect = CGRect(origin: stackView.frame.origin, size: checkView.bounds.size)
        let clipPath = UIBezierPath(roundedRect: rect, cornerRadius: checkViewCornerRadius).cgPath
        
        ctx.addPath(clipPath)
        ctx.setLineWidth(2.66)
        ctx.setLineCap(.square)
        ctx.setStrokeColor(UIColor.white.cgColor)
        ctx.setFillColor(isChecked ? UIColor.darkBlue.cgColor : UIColor.white.cgColor)
        ctx.fillPath()
        ctx.strokePath()
        
        if isChecked {
            ctx.beginPath()
            ctx.move(to: CGPoint(x: rect.minX + 0.28 * rect.width, y: rect.midY))
            ctx.addLine(to: CGPoint(x: rect.minX + 0.43 * rect.width, y: rect.minY + 0.66 * rect.height))
            ctx.addLine(to: CGPoint(x: rect.minX + 0.75 * rect.width, y: rect.minY + 0.33 * rect.height))
            ctx.strokePath()
        }
    }
    
    private static let dateFormatter: DateFormatter = {
        let dF = DateFormatter()
        dF.dateFormat = "eeee (MMMM dd, yyyy)"
        
        return dF
    }()
    
    private func checkDay(_ isSelected: Bool) {
        
        checkView.layer.borderWidth = isSelected ? 0.0 : checkViewBorderWidth
        isChecked = isSelected
        setNeedsDisplay()
    }
}

extension DaySelectViewCell: BaseTableViewCell {

    func configure(for object: Any?) {
        guard let object = object as? DaySelectViewCellObject else { return }

        delegate = object.delegate
        
        let dateString = DaySelectViewCell.dateFormatter.string(from: object.date)
        let weekDayLength = dateString.components(separatedBy: " ").first?.count ?? 0
        let attrString = NSMutableAttributedString(string: dateString)
        attrString.addAttributes([.font: UIFont.systemFont(ofSize: 16, weight: .medium)], range: NSRange(location: 0, length: weekDayLength))
        attrString.addAttributes([.font: UIFont.systemFont(ofSize: 16, weight: .light)], range: NSRange(location: weekDayLength, length: dateString.count - weekDayLength))
        
        dateLabel.attributedText = attrString
        checkDay(object.isSelected)
    }
}

private let checkViewCornerRadius: CGFloat = 5.0
private let checkViewBorderWidth: CGFloat = 1.33
