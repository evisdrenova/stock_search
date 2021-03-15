//
//  MessagesViewController.swift
//  search_auto_complete MessagesExtension
//
//  Created by Evis Drenova on 2/15/21.
//

import UIKit
import Messages
import Alamofire
import Charts

class MessagesViewController: MSMessagesAppViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var searchbar: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    
    var filteredData: [Ticker]?
    
    var tickers_list = [Ticker]()
    
    let parse = Parser()//instantiates the parser class and parse method
    
    let price_parser = Price_parser()
    
    let opening_price = open_price()
    
    let chartdataclass = chartlinedata()
    
    var stock_screenshot: UIImage? = nil
    
    var stock_check: String?
    
    var createcharts = create_chart()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchbar.delegate = self
        self.tableView.delegate = self
        self.tableView.dataSource = self
        filteredData = tickers_list
        let nib = UINib(nibName: "stock_abbrev_TableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "stock_abbrev_TableViewCell")
        
        parse.importjson
        {
            response in
            self.tickers_list = response
            DispatchQueue.main.async{
                self.tableView.reloadData()
            }

        }
        
    }
    
    
//creates the cell that is shown in the table
func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
    let cell = tableView.dequeueReusableCell(withIdentifier: "stock_abbrev_TableViewCell", for: indexPath) as! stock_abbrev_TableViewCell
        

    if (filteredData?.isEmpty == false){
        cell.stock_name.text = filteredData?[indexPath.row].securityName
        cell.stock_abbrev.text = filteredData?[indexPath.row].symbol
       // cell.daily_change.text = "4.3%"
    }else{
        cell.stock_name.text = tickers_list[indexPath.row].securityName
        cell.stock_abbrev.text = tickers_list[indexPath.row].symbol
       // cell.daily_change.text = "4.3%"
    }
        
        return cell
    }
    
    //does something when someone clicks on a row in the table
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let stck_name = tickers_list[indexPath.row].securityName
        let stck_ticker = tickers_list[indexPath.row].symbol
        let viewController = storyboard?.instantiateViewController(identifier: "charts") as? chartsViewController
        
        if (filteredData?.isEmpty == true){
    
            getPrice(symbol: stck_ticker){ [self](currprice, begprice, chartdata) in
                viewController!.curr_price = currprice
                viewController!.beg_price = begprice
                viewController!.stock_titles = stck_name
                viewController!.chartdata = chartdata
                viewController!.modalPresentationStyle = .automatic
                self.sendmess(stock_symbol: stck_ticker, stock_name: stck_name, current_price: currprice, begin_price: begprice, chartdata: chartdata)
                self.present(viewController!, animated: true)
    }

            
        } else {
            let filtered_stck_name = filteredData?[indexPath.row].securityName
            let filtered_stck_ticker = filteredData?[indexPath.row].symbol
            
            getPrice(symbol: filtered_stck_ticker!){(currprice, begprice, chartdata) in
                viewController!.curr_price = currprice
                viewController!.beg_price = begprice
                viewController!.stock_titles = filtered_stck_name
                viewController!.chartdata = chartdata
                viewController!.modalPresentationStyle = .automatic
                self.sendmess(stock_symbol: filtered_stck_ticker!, stock_name:filtered_stck_name!, current_price: currprice,begin_price: begprice, chartdata: chartdata)
                self.present(viewController!, animated: true)
             
                
                }
            
        }
    }


    //creates the number of sections
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    //defines the number of rows in the table, set equal to data so that each data element has a row
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //return filteredData.count
    if (filteredData?.isEmpty == false){
        return filteredData?.count ?? 0
    }
       return tickers_list.count

    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText == ""{
            filteredData = tickers_list
        }else {
            filteredData = []
            for data in tickers_list{
                if data.symbol.lowercased().starts(with: searchText.lowercased()) ||
                    data.securityName.lowercased().starts(with: searchText.lowercased()){
                    filteredData?.append(data)
                }
            }
        }
        self.tableView.reloadData()
        
    }
    
  
    
    func getPrice(symbol: String, comp: @escaping (String, String,[ChartDataEntry])->()){
        
        let group = DispatchGroup()
        var currprice: String?
        var begprice: String?
        var chartdata: [ChartDataEntry]?
        
        group.enter()
        price_parser.parse_price(stock_symbol: symbol){(price) in
            currprice = price
            group.leave()
        }
        group.enter()
        opening_price.getOpenPrice(stk_symbol:symbol){(opening) in
            begprice = opening
            group.leave()
        }
        group.enter()
        chartdataclass.getChartLineData(stock_symbol: symbol){(data) in
            chartdata = data
            group.leave()
        }
        
        group.notify(queue: DispatchQueue.main){
            comp(currprice!, begprice!,chartdata!)
        }
    }
    
    
   
   // random auto generated stuff when i created the project
    override func willBecomeActive(with conversation: MSConversation) {
        // Called when the extension is about to move from the inactive to active state.
        // This will happen when the extension is about to present UI.
        
        // Use this method to configure the extension and restore previously stored state.
    }
    
    override func didResignActive(with conversation: MSConversation) {
        // Called when the extension is about to move from the active to inactive state.
        // This will happen when the user dismisses the extension, changes to a different
        // conversation or quits Messages.
        
        // Use this method to release shared resources, save user data, invalidate timers,
        // and store enough state information to restore your extension to its current state
        // in case it is terminated later.
    }
   
    override func didReceive(_ message: MSMessage, conversation: MSConversation) {
        // Called when a message arrives that was generated by another instance of this
        // extension on a remote device.
        
        // Use this method to trigger UI updates in response to the message.
    }
    
    override func didStartSending(_ message: MSMessage, conversation: MSConversation) {
        // Called when the user taps the send button.
    }
    
    override func didCancelSending(_ message: MSMessage, conversation: MSConversation) {
        // Called when the user deletes the message without sending it.
    
        // Use this to clean up state related to the deleted message.
    }
    
    override func willTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        // Called before the extension transitions to a new presentation style.
    
        // Use this method to prepare for the change in presentation style.
    }
    
    override func didTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        // Called after the extension transitions to a new presentation style.
    
        // Use this method to finalize any behaviors associated with the change in presentation style.
    }

    
    func sendmess(stock_symbol: String, stock_name: String, current_price: String, begin_price: String, chartdata: [ChartDataEntry]){
    let conversation = activeConversation
     if conversation == nil{
         print("active convo is nil")
     }
     let session = conversation?.selectedMessage?.session ?? MSSession()
     
     
     let layout = MSMessageTemplateLayout()
     layout.caption = stock_name
     layout.subcaption = stock_symbol
     layout.trailingCaption = current_price
        
     let curr_price_doub = Double(current_price)
     let beg_price_doub = Double(begin_price)
     let perc_change_double = ((curr_price_doub!/beg_price_doub!)-1)
    let perc_change_nsnumber = NSNumber(value: perc_change_double)
        
     let per_formatter = NumberFormatter()
     per_formatter.numberStyle = .percent
     per_formatter.maximumFractionDigits = 2
     per_formatter.minimumFractionDigits = 2
        
    if perc_change_double < 0 {
        layout.trailingSubcaption = "(" + per_formatter.string(from: perc_change_nsnumber)! + ")"
    } else if perc_change_double > 0{
        layout.trailingSubcaption = "(+" + per_formatter.string(from: perc_change_nsnumber)! + ")"
        }
        
        createcharts.createChart(chartdata: chartdata){(image) in
            layout.image = image
        }
     
     let message = MSMessage(session: session)
     message.layout = layout

     conversation?.insert(message){error in
         if let e = error{
             print(e.localizedDescription)
         }
     }
    }
}


