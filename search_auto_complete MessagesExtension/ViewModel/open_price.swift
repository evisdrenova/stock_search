//
//  open_price.swift
//  search_auto_complete MessagesExtension
//
//  Created by Evis Drenova on 3/4/21.
//

import Foundation
import Alamofire
import SwiftyJSON


struct open_price: Codable{

//this is a function that gets the open price for a given stock symbol from alpaca
    func getOpenPrice(stk_symbol: String, comp: @escaping (String) ->()) {

        let headers: HTTPHeaders = [
                "APCA-API-KEY-ID": "PKJZVVRRVV1B02SWGTZ4",
                "APCA-API-SECRET-KEY": "kdeCCfjoPEiShPUmBqoaAzDKB0VnZasSDBroWIsq"
            ]
      
        
        //should be in this format: '2019-04-15T09:30:00-04:00'
        let now = Date()
        let day_formatter = DateFormatter()
        day_formatter.dateFormat = "yyyy-MM-dd'T'"
        let formatted_date = day_formatter.string(from:now)
        let time = "09:30:00-04:00"
        
        
        
        //start time for the bar filtering, set to today at 930am EST
        let start_time = formatted_date + time
        
        
        //gets the bar to calculate the daily change
        let bar_url = "https://data.alpaca.markets/v1/bars/"
        let timeframe = "1D"
        let bar_api_url = bar_url + timeframe
        var ticker = stk_symbol
        ticker = ticker.uppercased()
        let parameters: Parameters = ["symbols": ticker,/*"start":start_time,*/ "limit": 1]


        AF.request(bar_api_url, parameters: parameters, encoding: URLEncoding(destination: .queryString), headers: headers ).responseData{response in
            guard let data = response.data else { return }
                    let json = JSON(data)
                    let access_arr = json[ticker].arrayValue
                    let open_price = access_arr[0]["o"].stringValue
                    comp(open_price)
        }.resume()
    }

}
