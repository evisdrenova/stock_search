//
//  getchartdata.swift
//  search_auto_complete MessagesExtension
//
//  Created by Evis Drenova on 3/7/21.
//

import Foundation
import Alamofire
import SwiftyJSON
import Charts

struct chartlinedata: Codable{
    
    
    func getChartLineData(stock_symbol: String, comp: @escaping ([ChartDataEntry]) ->()){
        
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
        
        let bar_url = "https://data.alpaca.markets/v1/bars/"
        let timeframe = "15Min" //15Min
        let ticker = String(stock_symbol).uppercased()
        let bar_api_url = bar_url + timeframe
        let parameters: Parameters = ["symbols": ticker, /*"start": start_time*/]
        
        AF.request(bar_api_url, parameters: parameters,encoding: URLEncoding(destination: .queryString), headers: headers ).responseJSON{response in
            let json = JSON(response.data!)
            let price = json[ticker].arrayValue
            var vals: [ChartDataEntry] = []
            
            var a = 0.0
            for i in price{
                let c = i["c"].doubleValue
                vals.append(ChartDataEntry(x:a, y:c))
                a += 1.0
            }
           comp(vals)

        }.resume()
        
    }

    
}
