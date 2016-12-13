//
//  InAppPurchase.swift
//  Guidance Cards
//
//  Created by Rajan Maheshwari on 29/01/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import UIKit
import Foundation
import StoreKit

protocol InAppPurchaseDelegate{
    
    func productPurchased(productId:String)
    func productPurchaseFailedWithError()
    func productRestorationFailedWithError(error:NSError)
    func productRestored(productId:String)
    func productsList(anArray:NSArray)
    func invalidProductIDList(anArray:NSArray)
    
}

class InAppPurchase: NSObject,SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    enum PurchaseIds: String {
        case PURCHASE_CARDS   = "com.appster.dentamatch.purchase"
    }
    
    var delegate:InAppPurchaseDelegate?
    var arrProductIdentifiers:NSArray!
    /// singleton method
    
    //MARK: - Singleton
    static let sharedManager: InAppPurchase = {
        let instance = InAppPurchase()
        // setup code
        return instance
    }()

    //MARK: - Product Request
    func requestProductData()
    {
        SKPaymentQueue.default().add(self)
        if SKPaymentQueue.canMakePayments() {
            let request = SKProductsRequest(productIdentifiers: Set(self.arrProductIdentifiers as! [String]))
            request.delegate = self
            request.start()
        } else {
            let alert = UIAlertController(title: "In-App Purchases Not Enabled", message: "Please enable In App Purchase in Settings", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { alertAction in
                alert.dismiss(animated: true, completion: nil)
            }))
            
            UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
            
        }
    }
    
    //MARK: - SKPaymentTransaction
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
    }
    /*!
    this method will be called when error will occur while restoring transaction
    
    - parameter queue: number of transaction in queue
    - parameter error: what is the error
    */
    func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        delegate?.productRestorationFailedWithError(error: error as NSError)
    }
    
    
    /*!
    this method will called when you will download any content which is hosted on itune.
    
    - parameter queue:     transaction queue
    - parameter downloads: download
    */
    func paymentQueue(_ queue: SKPaymentQueue, updatedDownloads downloads: [SKDownload]) {
        
    }
    /*!
    transaction will be update in this method when purchage or restoration will be done.
    
    - parameter queue:        number of transation
    - parameter transactions: transation descriptions
    */
    func paymentQueue(_ queue: SKPaymentQueue, removedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions
        {
            switch transaction.transactionState {
                
            case .purchased:
                debugPrint("Transaction Approved")
                debugPrint("Product Identifier: \(transaction.payment.productIdentifier)")
                //self.deliverProduct(transaction)
                delegate?.productPurchased(productId: transaction.payment.productIdentifier);
                SKPaymentQueue.default().finishTransaction(transaction)
                
            case .failed:
                debugPrint("Transaction Failed")
                delegate?.productPurchaseFailedWithError()
                SKPaymentQueue.default().finishTransaction(transaction)
                
            case .restored:
                debugPrint("Transaction Restored")
                debugPrint("Product Identifier: \(transaction.payment.productIdentifier)")
                
            case .deferred:
                 debugPrint("Transaction Deferred")

            default:
                break
            }
        }
    }
    
    /*!
    restoration will be finished here
    
    - parameter queue: transaction queue
    */
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        
        for transaction:SKPaymentTransaction in queue.transactions {
                        
            debugPrint(transaction.payment.productIdentifier)
        
            delegate?.productRestored(productId: transaction.payment.productIdentifier)
        }
        
//        Utilities.hideLoader()

        let alert = UIAlertController(title: "Thank You", message: "Your purchase(s) were restore", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action:UIAlertAction) in
            
        }))
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - SKProductsRequestDelegate
    /*!
    this delegate method will request product from itune and wil iterate over the each products
    
    - parameter request:  request
    - parameter response: response with product details
    */
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        debugPrint("number of products: \(response.products.count)")
        let products = response.products
        
        if (products.count != 0) {
            for aProduct in products {
                debugPrint("products found:\(aProduct.productIdentifier)")
                debugPrint("products price:\(aProduct.price)")
                debugPrint("products description:\(aProduct.localizedDescription)")
                delegate?.productsList(anArray: products as NSArray)
            }
        }
        else
        {
            
            delegate?.invalidProductIDList(anArray: response.invalidProductIdentifiers as NSArray)
            debugPrint("No products found")
            
            let alert = UIAlertController(title: "Error", message: "Could not fetch product information", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { alertAction in
                alert.dismiss(animated: true, completion: nil)
            }))
            
            UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK: - Buy product
    
    func buyProduct(withIdentifier identifier:String){
        let payment = SKMutablePayment()
        payment.productIdentifier = identifier
        SKPaymentQueue.default().add(payment)
    }
    
    //MARK: - Buy product
    
    func restoreProduct(){
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
}
