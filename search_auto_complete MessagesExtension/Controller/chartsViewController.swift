//
//  chartsViewController.swift
//  search_auto_complete MessagesExtension
//
//  Created by Evis Drenova on 2/25/21.
//

import UIKit
import Charts
import TinyConstraints
import Messages

class chartsViewController: MSMessagesAppViewController {

    var stock_titles: String?
    var curr_price: String?
    var beg_price: String?
    var dollar_change_amount: String?
    var chartdata: [ChartDataEntry]?
    var activeCon: MSConversation?
    
    
    @IBOutlet weak var stock_title: UILabel!
    
    @IBOutlet weak var price_label: UILabel!

    @IBOutlet weak var percent_change: UILabel!
    
    @IBOutlet weak var dollar_change: UILabel!
    
    @IBOutlet weak var chartview: UIView!

    
    @IBOutlet var send: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        send.layer.cornerRadius = 20
  
    
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        
        let per_formatter = NumberFormatter()
        per_formatter.numberStyle = .percent
        per_formatter.maximumFractionDigits = 2
        per_formatter.minimumFractionDigits = 2

        stock_title.text = stock_titles
        let curr_price_doub = Double(curr_price!)
        let beg_price_doub = Double(beg_price!)
        let stock_price_nsnumber = NSNumber(value: curr_price_doub!)
        price_label.text = formatter.string(from:stock_price_nsnumber)!
        let perc_change_double = ((curr_price_doub!/beg_price_doub!)-1)
        let perc_change_nsnumber = NSNumber(value: perc_change_double)
        let dollar_change_double = (curr_price_doub! - beg_price_doub!)
        let dollar_change_nsnumber = NSNumber(value: dollar_change_double)
        
        if dollar_change_double < 0 {
            dollar_change.textColor = .systemRed
            dollar_change.text = formatter.string(from: dollar_change_nsnumber)
            percent_change.textColor = .systemRed
            percent_change.text = "(" + per_formatter.string(from: perc_change_nsnumber)! + ")"
        } else if dollar_change_double > 0{
            dollar_change.textColor = .systemGreen
            dollar_change.text = "+" + formatter.string(from: dollar_change_nsnumber)!
            percent_change.textColor = .systemGreen
            percent_change.text = "(+" + per_formatter.string(from: perc_change_nsnumber)! + ")"
            
        }
        
        
        //defines the linechart in the uiview
        //think i might have to change this to the chartview object
        view.addSubview(linechart)
        linechart.centerInSuperview()
        linechart.width(to: chartview)
        linechart.heightToWidth(of: chartview)

        setData()

    }
    
    lazy var linechart: LineChartView = {
         var linechart = LineChartView()
         linechart.backgroundColor = .white
         linechart.rightAxis.enabled = false
         linechart.xAxis.labelPosition = .bottom
         linechart.xAxis.drawGridLinesEnabled = false
         linechart.leftAxis.drawGridLinesEnabled = false
         linechart.legend.enabled = false
         linechart.xAxis.drawAxisLineEnabled = false
         linechart.leftAxis.drawAxisLineEnabled = false
         linechart.xAxis.drawLabelsEnabled = false
         linechart.leftAxis.labelXOffset = 0
         linechart.leftAxis.decimals = 0
    
         return linechart
     }()

    
    func setData(){

        let set1 = LineChartDataSet(entries: chartdata)
        set1.drawCirclesEnabled = false
        set1.drawCirclesEnabled = false
        set1.mode = .cubicBezier
        set1.lineWidth = 3
        set1.setColor(.systemBlue)
        set1.drawHorizontalHighlightIndicatorEnabled = false
        set1.highlightColor = .systemBlue


        let data = LineChartData(dataSet: set1)
        data.setDrawValues(false)
        self.linechart.data = data


    }
    
    
    @IBAction func dismissScreen(){
        dismiss()
    }

    
}
