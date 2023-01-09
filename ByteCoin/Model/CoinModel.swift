//
//  CoinModel.swift
//  ByteCoin
//
//  Created by Eydde on 09/01/23.
//  Copyright © 2023 The App Brewery. All rights reserved.
//

import Foundation

struct CoinModel {
    let currency: String
    let price: Double
    
    var getStringPrice: String {
        return String(format: "%.2f", price)
    }
}
