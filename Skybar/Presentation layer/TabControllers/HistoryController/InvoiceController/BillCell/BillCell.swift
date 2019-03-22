//
//  BillCell.swift
//  Skybar
//
//  Created by Christopher Nassar on 10/6/18.
//  Copyright © 2018 Christopher Nassar. All rights reserved.
//

import UIKit

class BillCell: UIView {

    var Item:[String:Any]! = nil
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    
    func setInfo(info:[String:Any]){
        Item = info
        if let quantity = info["Quantity"] as? Int,let name = info["ItemName"] as? String{
            if quantity == 1{
                titleLbl.text = name.uppercased()
            }else{
                titleLbl.text = "\(quantity)X \(name.uppercased())"
            }
        }
        
        if let price = info["ItemPrice"] as? Float{
            priceLbl.text = price.toCurrency()
        }
    }

}
