//
//  SearchStateViewController.swift
//  DentaMatch
//
//  Created by Prashant Gautam on 01/11/18.
//  Copyright © 2018 Appster. All rights reserved.
//

import UIKit

class SearchStateViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var searchField: SearchField!
    override func viewDidLoad() {
        super.viewDidLoad()

        searchField.textChange { [weak self] text in
            //self?.refresh(sender: nil)
            self?.searchAction()
            print(text)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchAction(){
        
    }
    
    @IBAction func doneAction(_ : UIButton) {
        
    }
    
    @IBAction func cancelAction(_ : UIButton) {
        self.navigationController?.popViewController(animated: false)
    }

}
