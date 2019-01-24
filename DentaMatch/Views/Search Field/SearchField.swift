//
//  SearchField.swift
//  PanicPal
//
//  Created by Prashant Gautam on 12/10/18.
//  Copyright © 2018 Appster. All rights reserved.
//

import UIKit

class SearchField: UIView {
    @IBOutlet private weak var searchImageView: UIImageView?
    @IBOutlet private weak var searchLabel: UILabel?
    @IBOutlet private weak var searchTextField: UITextField?
    @IBOutlet private weak var placeholderView: UIView?
    private var _searchHandler: (String) -> Void = { _ in }
    var searchText: String {
        return searchTextField?.trimText() ?? ""
    }

    private var contentView: UIView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }

    func xibSetup() {
        contentView = loadViewFromNib()
        // use bounds not frame or it'll be offset
        contentView?.frame = bounds
        // Make the view stretch with containing view
        contentView?.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(contentView)
        searchTextField?.changePlaceholderColor(UIColor.white)
    }

    func textChange(_ handler: @escaping (String) -> Void) {
        _searchHandler = handler
    }

    @objc private func searchWithKeyword() {
        guard let keyword = self.searchTextField?.text else { return }
        _searchHandler(keyword.trimText)
    }
}

extension SearchField: UITextFieldDelegate {
    @IBAction func textFieldDidChangeValue(textfield _: UITextField) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(searchWithKeyword), object: nil)
        perform(#selector(searchWithKeyword), with: nil, afterDelay: 0.5)
        searchWithKeyword()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldDidBeginEditing(_: UITextField) {
        //placeholderView?.isHidden = true
        searchLabel?.isHidden = true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        searchLabel?.isHidden = !textField.isEmpty()
    }
}
