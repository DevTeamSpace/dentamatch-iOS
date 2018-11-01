//
//  SearchField.swift
//  PanicPal
//
//  Created by Prashant Gautam on 12/10/18.
//  Copyright © 2018 Appster. All rights reserved.
//

import UIKit

class SearchField: UIView {
    @IBOutlet private var searchTextField: UITextField?
    @IBOutlet private var placeholderView: UIView?
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
        contentView?.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(contentView)
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
        placeholderView?.isHidden = true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        placeholderView?.isHidden = !textField.isEmpty()
    }
}
