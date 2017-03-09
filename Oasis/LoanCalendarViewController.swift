//
//  LoanCalendarViewController.swift
//  Oasis
//
//  Created by Needidsoft on 2017. 1. 17..
//  Copyright © 2017년 Needidsoft. All rights reserved.
//

import UIKit
import FSCalendar
import RealmSwift
import Alamofire

class LoanCalendarViewController: UIViewController, FSCalendarDataSource, FSCalendarDelegate {
    @IBOutlet weak var calendar: FSCalendar?
    @IBOutlet weak var timePicker: UIDatePicker!
    private let gregorian = Calendar(identifier: .gregorian)
    private let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    private let formatterDic: DateFormatter = {
        let formatterDic = DateFormatter()
        formatterDic.dateFormat = "yyyy년 MM월 dd일"
        return formatterDic
    }()
    private let formatterTime: DateFormatter = {
        let formatterTime = DateFormatter()
        formatterTime.dateFormat = "HH:mm:ss"
        return formatterTime
    }()
    private let formatterTimedic: DateFormatter = {
        let formatterTimedic = DateFormatter()
        formatterTimedic.dateFormat = "h시mm분 a"
        formatterTimedic.amSymbol = "am"
        formatterTimedic.pmSymbol = "pm"
        return formatterTimedic
    }()
    
    @IBAction func valueChanged(_ sender: UIDatePicker) {
        
        selTm = sender.date
        
        
    }
    
    let hj = hjUtil()
    let realm = try! Realm()
    
    var mortids = [Int]()
    var partnerid = -1
    var selStr = ""
    var selDic = [String: String]()
    var selDt: Date!
    var selTm: Date!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        print("mortids=\(mortids) partnerid=\(partnerid)")
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.ButtonNoIconTouchUpInside), name: Notification.Name("ButtonNoIconTouchUpInside"), object: nil)
        
        
    }
    func getTime(){
        let time = formatterTime.string(from: selTm)
        let timeDic = formatterTimedic.string(from: selTm)
        let arr = timeDic.components(separatedBy: " ")
        let hour = arr[0]
        let ampm = arr[1]
        print("selected time = \(time)")
        selStr += " \(time)"
        selDic["ampm"] = ampm
        selDic["time"] = hour
    }
    func ButtonNoIconTouchUpInside(notification: Notification){
        
        let me = (notification.object as! ButtonNoIcon).view!
        if me.tag == 0 {
            dismiss(animated: true, completion: nil)
        }else{
            
            send()
            
            
        }
        
        
    }
    
    func validate() -> Bool{
        guard mortids.count > 0 else { hj.showAlert(vc: self, msg: "담보물이 선택되지 않았습니다");  return false }
        guard partnerid != -1 else { hj.showAlert(vc: self, msg: "방문 영업점이 선택되지 않았습니다");  return false }
        
        guard selDt != nil && selTm != nil else { hj.showAlert(vc: self, msg: "날짜와 시간을 선택하세요");  return false }
        return true
    }
    
    func send(){
        guard validate() else {
            return
        }

        getDate()
        getTime()
        
        
        //파라메터 만들기
        var param = [String:Any]()
        
        let me = self.realm.objects(Member.self)[0]
        param["member_id"] = me._id
        param["visit_formatted"] = selStr
        param["visit"] = hj.jsonToString(json: selDic as AnyObject)
        param["partner_id"] = self.partnerid
        
        let mortidstr = mortids.map{ return String($0) }
        param["estm_id_list"] = hj.jsonToString(json: mortidstr as AnyObject)
        
        
        
        Alamofire.request("\(hj.url)app/api/loan/insert", method: .post, parameters: param).responseJSON { response in
            print(response.result)   // result of response serialization
            print(response.error ?? "")
            if let JSON = response.result.value  as? [String: Any] {
                // 에러 처리
                if let result = JSON["result"] as? [String:Any] {
                    if let err = result["error"] as! String?{
                        self.hj.showAlert(vc: self, msg: err); return
                    }
                }
                
                // 리턴 형식 정의
                let rslt = JSON["result"] as! [String:Any]
                
                print("loan_id = \(rslt["loan_id"])")
                
                self.presentLoanDone()
                
            } // end - response
        } // end - Alamofire
        
        
    }
    
    func presentLoanDone(){
        
        let vc : UIViewController! = self.storyboard!.instantiateViewController(withIdentifier: "LoanDoneViewController")
        
        self.present(vc, animated: true, completion: nil)

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date) {
        
        selDt = date
        
    }
    func getDate(){
        let strDT = self.formatter.string(from: selDt)
        let dicDT = self.formatterDic.string(from: selDt)
        print("did select date \(strDT)")
        selStr = strDT
        selDic["date"] = dicDT
        
    }

}
