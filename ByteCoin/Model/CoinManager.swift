//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdateCoin(_ coinManager: CoinManager, coinData: CoinModel)
    func didFailWithError(error: Error)
}

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "47459475-0EA8-4180-8B24-EC2EC144D15A"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    var delegate: CoinManagerDelegate?
    
    func getCoinPrice(for currency: String) {
        print(currency)
        let url = "\(baseURL)/\(currency)/?apikey=\(apiKey)"
        getData(with: url)
    }
    
    func getData(with url: String) {
        
        if let url = URL(string: url) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                
                if error != nil {
                    delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    print(self.parseJSON(safeData)!)
                    if let coinData = self.parseJSON(safeData) {
                        delegate?.didUpdateCoin(self, coinData: coinData)
                    }
                }
            }
            task.resume()
        }
        
    }
    
    func parseJSON(_ data: Data) -> CoinModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinData.self, from: data)
            return CoinModel(currency: decodedData.asset_id_quote, price: decodedData.rate)
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
