//
//  Main2ViewController.swift
//  Oasis
//
//  Created by Needidsoft on 2017. 1. 11..
//  Copyright © 2017년 Needidsoft. All rights reserved.
//

import UIKit
import IOStickyHeader
import KYDrawerController
import RealmSwift
import LiquidFloatingActionButton
import Alamofire
import SDWebImage


class Main2ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, LiquidFloatingActionButtonDelegate, LiquidFloatingActionButtonDataSource, MainFloatingIconDelegate  {
    @IBOutlet weak var collectionBack: UIView!
    @IBOutlet weak var floatingIcon: MainFloatingIcon!

    var cells: [LiquidFloatingCell] = []
    var floatingActionButton: LiquidFloatingActionButton!
    let hj = hjUtil()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        floatingIcon.dele = self
        NotificationCenter.default.addObserver(self, selector: #selector(self.lightTouchUpInside), name: Notification.Name("lightTouchUpInside"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.alarmTouchUpInside), name: Notification.Name("alarmTouchUpInside"), object: nil)
        
        popMyMorts()
        
        //floating button
//        let createButton: (CGRect, LiquidFloatingActionButtonAnimateStyle) -> LiquidFloatingActionButton = { (frame, style) in
//            let floatingActionButton = CustomDrawingActionButton(frame: frame)
//            floatingActionButton.animateStyle = style
//            floatingActionButton.dataSource = self
//            floatingActionButton.delegate = self
//            return floatingActionButton
//        }
////        let cellInq: (String) -> LiquidFloatingCell = { (iconName) in
////            let cell = LiquidFloatingCell(icon: UIImage(named: iconName)!)
////            return cell
////        }
//        //cells.append(cellInq("ic_drawer_map"))
//        let floatingFrame = CGRect(x: self.view.frame.width - 68 - 16, y: self.view.frame.height - 68 - 1, width: 68, height: 68)
//        let bottomRightButton = createButton(floatingFrame, .up)
//        let image = UIImage(named: "ic_float_inquiry")
//        
//        bottomRightButton.image = image
//        bottomRightButton.color = hjUtil.rgb(0x0033a0)
//        bottomRightButton.rotationDegrees = 0
//        
//        self.view.addSubview(bottomRightButton)
    
        
        
        
    }
    
    
    func touchUpInsideFloatingIcon(sender: MainFloatingIcon) {
        presentAppraise()
    }
    func presentAppraise(){
        let storyboard = UIStoryboard(name: "Appraise", bundle: nil)
        let vc : UIViewController! = storyboard.instantiateViewController(withIdentifier: "AppraiseNavigationController")
        
        self.present(vc, animated: true, completion: nil)
    }
    
    
    
    
    //LiquidFloatingActionButton
    func numberOfCells(_ liquidFloatingActionButton: LiquidFloatingActionButton) -> Int{
        return cells.count
    }
    func cellForIndex(_ index: Int) -> LiquidFloatingCell{
        
        return cells[index]
    }
    
    
    
    
    
    func lightTouchUpInside(notification: Notification){
        if let drawerController = parent as? KYDrawerController {
            drawerController.setDrawerState(.opened, animated: true)
        }
        
    }
    func alarmTouchUpInside(notification: Notification){
        
        presentNoti()
        
    }
    func presentNoti(){
        let vc : UIViewController! = self.storyboard!.instantiateViewController(withIdentifier: "NotiNavViewController")
        
        self.present(vc, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillLayoutSubviews() {
        if let layout: IOStickyHeaderFlowLayout = self.collectionView.collectionViewLayout as? IOStickyHeaderFlowLayout {
        
            layout.parallaxHeaderReferenceSize = CGSize(width: UIScreen.main.bounds.size.width, height: 287)
            layout.parallaxHeaderMinimumReferenceSize = CGSize(width: UIScreen.main.bounds.size.width, height: 45)
        }
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
    
    
    func popMyMorts(){
        let me = realm.objects(Member.self)[0]
        Alamofire.request("\(hj.url)app/api/estm/paging/\(me._id)/1/1/10/").responseJSON { response in
            if let JSON = response.result.value  as? [String: Any] {
                let result = JSON["result"] as! [String:Any]
                if let err = result["error"] as! String?{ self.hj.showAlert(vc: self, msg: err); return }
                
                let rslts = result["results"] as! [[String:Any]]
                try! self.realm.write {
                    //self.realm.delete(self.realm.objects(Mort.self))
                    rslts.map{
                        
                        let a = $0
                        
                        let c = Mort()
                        c._id = Int( a["estm_id"] as! String )!
                        c.category_id = a["category_id"] as! String
                        c.brand = a["brand_name"] as! String
                        c.member_id = a["member_id"] as! String
                        c.loan_id = a["loan_id"] as! String
                        c.title = a["title"] as! String
                        c.buy_date = a["buy_date"] as! String
                        c.buy_price = a["buy_price"] as! String
                        c.buy_route = a["buy_path"] as! String
                        c.memo = a["memo"] as! String
                        c.flag_state = a["state"] as! String
                        c.reg_date = a["reg_date"] as! String
                        c.date_update = String( a["order_by_date"] as! Int)
                        c.flag_result = a["flag_result"] as! String
                        c.cnt_addimage = a["img_count"] as! String
                        c.is_reloan = a["is_reloan"] as! String
                        c.appraise_id = a["appraise_id"] as? String ?? ""
                        c.appraise_date = a["appraise_date"] as? String ?? ""
                        c.appraise_amount = a["appraise_amount"] as? String ?? ""
                        c.rate = a["rate"] as? String ?? ""
                        c.partner_id = a["partner_id"] as? String ?? ""
                        c.admin_id = a["admin_id"] as? String ?? ""
                        c.history = a["history"] as? String ?? ""
                        c.is_permission = a["is_permission"] as? String ?? ""
                        
                        
                        self.realm.add(c, update: true)
                        
                    } // end - map
                    
                } // end - realm.write
                
                self.morts = self.realm.objects(Mort.self)
                
                print("Mort count: \(self.morts?.count)")
                
                self.setupCollectionView()
                
            }
        }
    } // end - pop
    
    
    
    
    // collection view
    
    let realm = try! Realm()
    var morts: Results<Mort>?
    //fileprivate var itmSize:CGSize?
    fileprivate let sectionInsets = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
    fileprivate let col: CGFloat = 2
    
    @IBOutlet weak var collectionView: UICollectionView!
    let headerNib = UINib(nibName: "MainParallaxHeader", bundle: Bundle.main)
    //var section: Array<String> = []

    func setupCollectionView() {
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        if let layout: IOStickyHeaderFlowLayout = self.collectionView.collectionViewLayout as? IOStickyHeaderFlowLayout {
            
//            itmSize = CGSize(width: (UIScreen.main.bounds.size.width-20) / 2, height: (UIScreen.main.bounds.size.width / 2)*1.173 )
            
//            layout.itemSize = CGSize(width: UIScreen.main.bounds.size.width, height: layout.itemSize.height)
            
//            if let sizeItm = itmSize{
//                layout.itemSize = CGSize(width: sizeItm.width, height: sizeItm.height)
//            }
            

//            layout.itemSize = CGSize(width: (itmSize?.width)!, height: (itmSize?.height)!)
       
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 6
            
            layout.parallaxHeaderAlwaysOnTop = true
            layout.disableStickyHeaders = false
            self.collectionView.collectionViewLayout = layout
        }
        
        self.collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, 0)
        
        self.collectionView.register(self.headerNib, forSupplementaryViewOfKind: IOStickyHeaderParallaxHeader, withReuseIdentifier: "header")
    }
    
    //MARK: UICollectionViewDataSource & UICollectionViewDelegate
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        print("numberOfSections = \(morts?.count)")
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (morts?.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: MainCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MainCell
        
        //let obj = self.section[(indexPath as NSIndexPath).section]
        
        
        if let obj = morts?[ indexPath.row ]{
            
            //print("cur cell id = \(obj._id) indexpath = \(indexPath.section)")
            
            
            let imgname = obj.category_id == "9" ? "add_0" : "photo_1"
            let url = URL(string: "\(hj.url)mort/\(obj._id)/\(imgname)" )
            let imgPlaceholder = UIImage(named: "ic_gallery")
            
            cell.image.sd_setImage(with: url, placeholderImage: imgPlaceholder)
            
            // Closuer Block Example
//            cell.image.sd_setImage(with: URL(string: url ), placeholderImage: imgPlaceholder, options: .allowInvalidSSLCertificates, progress: { (a:Int, b:Int, c:URL?) in
//                
//            }, completed: { (a: UIImage?, b: Error?, c: SDImageCacheType, d: URL?) in
//                
//                print("completed image = \(a)")
//                if a == nil {
//                    let url = "\(self.hj.url)mort/\(obj._id)/add_0"
//                    cell.image.sd_setImage(with: URL(string: url), placeholderImage: imgPlaceholder)
//                    
//                }
//                
//            })
            
            cell.price.text = obj.appraise_amount
            cell.title.text = obj.title
        }
        
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let w = (collectionView.bounds.width / col)-9

        return CGSize(width: w, height: w*1.26)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "sectionHeader", for: indexPath) as! MainSectionHeader
            return cell
        case IOStickyHeaderParallaxHeader:
            let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! MainParallaxHeader
            return cell
        case UICollectionElementKindSectionFooter:
            let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "sectionFooter", for: indexPath) as! MainSectionFooter
            
            return cell
        default:
            assert(false, "Unexpected element kind")
        }
        fatalError()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int ) -> CGFloat{
        return sectionInsets.left
    }
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
        var height = 200 
        if morts?.count == 0 {  }
        else{ height = 1 }
        
        //print("referenceSizeForFooterInSection height = \(height)")
        
        return CGSize(width: collectionView.bounds.width, height: CGFloat(height) )
        
    }
    
}







//Liquid Floating button - not use
public class CustomCell : LiquidFloatingCell {
    var name: String = "sample"
    
    init(icon: UIImage, name: String) {
        self.name = name
        super.init(icon: icon)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func setupView(_ view: UIView) {
        super.setupView(view)
//        let label = UILabel()
//        label.text = name
//        label.textColor = UIColor.white
//        label.font = UIFont(name: "Helvetica-Neue", size: 12)
//        addSubview(label)
//        label.snp.makeConstraints { make in
//            make.left.equalTo(self).offset(-80)
//            make.width.equalTo(75)
//            make.top.height.equalTo(self)
//        }
    }
}

public class CustomDrawingActionButton: LiquidFloatingActionButton {
    
    override public func createPlusLayer(_ frame: CGRect) -> CAShapeLayer {
        
        let plusLayer = CAShapeLayer()
//        plusLayer.lineCap = kCALineCapRound
//        plusLayer.strokeColor = UIColor.white.cgColor
//        plusLayer.lineWidth = 3.0
//        
//        let w = frame.width
//        let h = frame.height
//        
//        let points = [
//            (CGPoint(x: w * 0.25, y: h * 0.35), CGPoint(x: w * 0.75, y: h * 0.35)),
//            (CGPoint(x: w * 0.25, y: h * 0.5), CGPoint(x: w * 0.75, y: h * 0.5)),
//            (CGPoint(x: w * 0.25, y: h * 0.65), CGPoint(x: w * 0.75, y: h * 0.65))
//        ]
//        
//        let path = UIBezierPath()
//        for (start, end) in points {
//            path.move(to: start)
//            path.addLine(to: end)
//        }
//        
//        plusLayer.path = path.cgPath
        
        return plusLayer
    }
}






