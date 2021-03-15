//
//  fetch_price.swift
//  search_auto_complete MessagesExtension
//
//  Created by Evis Drenova on 2/26/21.
//

import Foundation
import Alamofire
import SwiftyJSON


struct Price_parser: Codable{

 //this is a function that gets the last quoted price for a given stock from alpaca
    func parse_price(stock_symbol: String, comp: @escaping (String)-> ()){
        
        let headers: HTTPHeaders = [
                "APCA-API-KEY-ID": "PKJZVVRRVV1B02SWGTZ4",
                "APCA-API-SECRET-KEY": "kdeCCfjoPEiShPUmBqoaAzDKB0VnZasSDBroWIsq"
            ]
        //gets the latest price
       let api_url = "https://data.alpaca.markets/v1/last/stocks/"
       var ticker = stock_symbol
       ticker = ticker.uppercased()
       let final_url = api_url + ticker
    
        AF.request(final_url, headers: headers).responseData{response in

            guard let data = response.value else { return }
                do{
                    let result = try JSONDecoder().decode(Root.self, from: data)
                    let price = String(result.last.price)
                    comp(price)
                  
                }catch{
                    let error = error
                    print(error)
                }
    }.resume()
        
}
}
