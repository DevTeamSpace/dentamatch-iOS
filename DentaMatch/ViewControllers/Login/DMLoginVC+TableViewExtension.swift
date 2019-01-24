//
//  DMLoginVC+TableViewExtension.swift
//  DentaMatch
//
//  Created by Rajan Maheshwari on 05/01/17.
//  Copyright © 2017 Appster. All rights reserved.
//

import Foundation

extension DMLoginVC: UITableViewDataSource, UITableViewDelegate {

    // MARK: - TableView Datasource/Delegates

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt _: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LoginTableViewCell") as! LoginTableViewCell
        cell.emailTextField.delegate = self
        cell.passwordTextField.delegate = self
        cell.forgotPasswordButton.addTarget(self, action: #selector(forgotPasswordButtonPressed), for: .touchUpInside)
        return cell
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return loginTableView.frame.size.height
    }
}
