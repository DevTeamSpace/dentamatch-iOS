//
//  SearchStateViewController.swift
//  DentaMatch
//
//  Created by Prashant Gautam on 01/11/18.
//  Copyright © 2018 Appster. All rights reserved.
//

import UIKit
import SwiftyJSON
protocol SearchStateViewControllerDelegate:class {
    func selectedState(state: String?)
}

class SearchStateViewController: DMBaseVC {
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var searchField: SearchField!
    var states: [State] = [State]()
    var searchStates: [State] = [State]()
    var isSearchOn: Bool = false
    weak var delegate:SearchStateViewControllerDelegate?
    var preSelectedState: String?
    
    weak var moduleOutput: SearchStateModuleOutput?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchField.textChange { [weak self] text in
            self?.searchAction(text)
        }
        self.getStates()
        navigationItem.leftBarButtonItem = leftBarButton()
        navigationItem.rightBarButtonItem = rightBarButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
       navigationController?.isNavigationBarHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchAction(_ text: String) {
        if text.isEmpty {
            isSearchOn = false
            searchStates.removeAll()
        }else{
            isSearchOn = true
            searchStates = states.filter {$0.stateName.localizedCaseInsensitiveContains(text)}
        }
        tableView.reloadData()
    }
    
    @objc func doneAction() {
        guard let selctedState = self.selectedState()?.stateName else {
            self.navigationController?.popViewController(animated: true)
            return
        }
        self.delegate?.selectedState(state: selctedState)
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func cancelAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func deselectStates() {
        for state in states {
            state.isSelected = false
        }
    }
    
    func selectedState() -> State? {
        var selected: State?
        if isSearchOn {
            for state in searchStates where state.isSelected == true {
                selected = state
            }
        }else{
            for state in states where state.isSelected == true {
                selected = state
            }
        }
        return selected
    }
    
    func setSelectedState(_ state: String?){
        guard let text = state else {return}
        for state in states where state.stateName == text {
            state.isSelected = true
        }
    }
    
    func rightBarButton() -> UIBarButtonItem {
        let customButton = UIButton(type: .system)
        customButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        customButton.titleLabel?.font = UIFont.fontRegular(fontSize: 16)
        customButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
        customButton.setTitle("Done", for: .normal)
        customButton.addTarget(self, action: #selector(doneAction), for: .touchUpInside)
        let barButton = UIBarButtonItem(customView: customButton)
        return barButton
    }
    
    func leftBarButton() -> UIBarButtonItem {
        let customButton = UIButton(type: .system)
        customButton.frame = CGRect(x: 0, y: 0, width: 50, height: 30)
        customButton.titleLabel?.font = UIFont.fontRegular(fontSize: 16)
        customButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
        customButton.setTitle("Cancel", for: .normal)
        customButton.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        let barButton = UIBarButtonItem(customView: customButton)
        return barButton
    }

}

extension SearchStateViewController {
    
    func getStates(){
        showLoader()
        APIManager.apiGet(serviceName: Constants.API.listStatesApi, parameters: [:]) {[weak self] (response: JSON?, error: NSError?) in
            self?.hideLoader()
            if error != nil {
                self?.makeToast(toastString: (error?.localizedDescription)!)
                return
            }
            guard let _ = response else {
                self?.makeToast(toastString: Constants.AlertMessage.somethingWentWrong)
                return
            }
            LogManager.logDebug(response?.description)
             self?.handleResponse( response)
        }
    }
    
    func handleResponse(_ response: JSON?){
        if let response = response {
            if response[Constants.ServerKey.status].boolValue {
                //let result = response[Constants.ServerKey.result]
                let stateDicts = response[Constants.ServerKey.result][Constants.ServerKey.statelist].array
                states.removeAll()
                for object in stateDicts! {
                    let state = State(object)
                    states.append(state)
                }
                self.setSelectedState(self.preSelectedState)
                self.tableView.reloadData()
            }
        }else {
            states.removeAll()
            DispatchQueue.main.async {
                //self.lblResultCount.text = Constants.Strings.zero + Constants.Strings.whiteSpace + Constants.Strings.resultsFound
                self.tableView.reloadData()
            }
           // makeToast(toastString: response![Constants.ServerKey.message].stringValue)
        }
    }

}


extension SearchStateViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return isSearchOn ? self.searchStates.count : self.states.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "StateCell")
        let state:State = isSearchOn ? searchStates[indexPath.row]: states[indexPath.row]
        cell.textLabel?.text = state.stateName
        cell.accessoryType = state.isSelected ? .checkmark : .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if states.count > 1 {
            deselectStates()
        }
        let state = isSearchOn ? searchStates[indexPath.row] : states[indexPath.row]
        state.isSelected = !state.isSelected
        self.tableView.reloadData()
    }
    
    
        
}
