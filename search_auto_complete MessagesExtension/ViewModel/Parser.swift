//
//  Parser.swift
//  search_auto_complete MessagesExtension
//
//  Created by Evis Drenova on 2/18/21.
//

import Foundation
import Alamofire

struct Parser: Codable{
    //imports json from the convertcsv.json file and makes it available through an API
    func importjson(comp: @escaping ([Ticker])->()){
        
        let data = Bundle.main.path(forResource: "convertcsv", ofType: ".json")
        let url = URL(fileURLWithPath: data!)
        AF.request(url).responseData{ response in
            guard let data = response.value else { return }
                do{
                    let result = try JSONDecoder().decode([Ticker].self, from: data)
                    comp(result)
                }catch{
                    let error = error
                    print(error)
                }

    }.resume()
    }

    
}
