//
//  AppraiseViewController.swift
//  Oasis
//
//  Created by Needidsoft on 2017. 1. 23..
//  Copyright © 2017년 Needidsoft. All rights reserved.
//

import UIKit
import Alamofire
import RealmSwift
import SDWebImage

class AppraiseViewController: UIViewController, CameraViewControllerDelegate {
    @IBOutlet weak var templateBack: UIView!
    @IBOutlet weak var categoryScroll: UIScrollView!
    @IBOutlet weak var categoryBack: UIView!
    @IBOutlet weak var categoryBackWidth: NSLayoutConstraint!
    @IBOutlet weak var addedBack: UIView!
    @IBOutlet weak var goodsBack: UIView!
    @IBOutlet weak var goodsHeight: NSLayoutConstraint!
    @IBOutlet weak var addedHeight: NSLayoutConstraint!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var photosBack0: UIView!
    @IBOutlet weak var photosBack: UIView!
    @IBOutlet weak var photosBackWidth: NSLayoutConstraint!
    @IBOutlet weak var warnBack: UIView!
    @IBOutlet weak var warnCheck: Checkbox!

    let seguePhotoOK = "seguePhotoOK"
    let segueToDone = "appraiseToDone"
    
    
    let hj = hjUtil()
    let realm = try! Realm()
    var categories: Results<Category>?
    var isTemplate = true
    
    var added = [String:UIImage]()
    var taken = [String:UIImage]()
    var spec: [String:Any]!
    
    var curC: Category!
    
    
    @IBAction func prev(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        showPhotosTaken(isOpen: false)
        
        hj.hideKeyboardWhenTappedAround(vc: self)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.ButtonNoIconTouchUpInside), name: Notification.Name("ButtonNoIconTouchUpInside"), object: nil)
        
        
        pop()
        
        
    }
    func ButtonNoIconTouchUpInside(notification: Notification){
        
        let me = (notification.object as! ButtonNoIcon).view!
        if me.tag == 0{ // 물품촬영
            guard isTemplate else {return}
            
            performSegue(withIdentifier: "seguePhotoOK", sender: self)
        }else if me.tag == 1{ // 취소
            dismiss(animated: true, completion: nil)
        }else{ // 견적문의하기
            guard isTemplate else {return}
            
            print("added count = \(added.count) taken count = \(taken.count) ")
            
            sendMultipart()
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier != seguePhotoOK { return }
        
        let navVC = segue.destination as? UINavigationController
        
        let vc = navVC?.viewControllers.first as! CameraViewController

        vc.delegate = self
        
        vc.c = curC
     
        
    }
    func cameraDone(added: [String : UIImage], taken: [String : UIImage]) {
        self.added = added
        self.taken = taken
        
        // 가져온 사진 붙이기
        if taken.count > 0 || added.count > 0 {
            attachPhotos()
            showPhotosTaken(isOpen: true)
        }
        
    }
    func showPhotosTaken(isOpen: Bool){
        if isOpen{
            photosBack0.isHidden = false
            warnBack.isHidden = false
        }else{
            photosBack0.isHidden = true
            warnBack.isHidden = true
        }
    }
    
    func getSpec(){

        spec = [:]
        var param = [String : Any]()
        var dicTmpl = [String:String]()
        
        param["category_id"] = String(curC._id)
        let me = self.realm.objects(Member.self)[0]
        param["member_id"] = String(me._id)
        
        
        // dicTmpl 만들기
        let goodsStack = goodsBack.subviews[0]
        for i in goodsStack.subviews{
            let itm = i as! AppruiText
            if itm.tag == 1 { param["title"] = itm.text.text }
            if itm.tag == 2 { param["buy_date"] = itm.text.text }
            if itm.tag == 3 { param["buy_price"] = itm.text.text }
            if itm.tag == 4 { param["buy_path"] = itm.text.text }
            if itm.tag == 5 { param["memo"] = itm.text.text }
            
            dicTmpl[String(itm.tag)] = itm.text.text
            
        }
        let addedStack = addedBack.subviews[0]
        for i in addedStack.subviews{
            let itm = i as! AppruiText
            dicTmpl[String(itm.tag)] = itm.text.text
        }
        
        //validate
        guard
            dicTmpl["1"] != ""
            && dicTmpl["2"] != ""
            && dicTmpl["3"] != ""
            && dicTmpl["4"] != ""
            && dicTmpl["5"] != ""
            else {
                showAlert(msg: "물품정보는 필수항목 입니다")
                return
        }
        guard warnCheck.checked! else {
            showAlert(msg: "본인 소유 확인 바랍니다")
            return
        }
        
        
        //template data 가져오기
        var template: [String:Any] = hj.convertToDictionary(text: curC.template)!
        let ui = template["ui"] as! [[String:Any]]
        let goodsBody = ui[0]["body"] as! [[String:Any]]
        let addedBody = ui[1]["body"] as! [[String:Any]]

        
        //템플릿 재구성
        var tmpl = [String:Any]()
        tmpl["photo"] = template["photo"]
        var uis = [[String:Any]]()
        var ui0 = [String:Any]()
        var ui1 = [String:Any]()
        ui0["header"] = ui[0]["header"]
        ui1["header"] = ui[1]["header"]
        var body0 = [[String:Any]]()
        for var g in goodsBody{
            g["val"] = dicTmpl[g["id"] as! String]
            body0.append(g)
        }
        var body1 = [[String:Any]]()
        for var a in addedBody{
            a["val"] = dicTmpl[a["id"] as! String]
            body1.append(a)
        }
        ui0["body"] = body0
        ui1["body"] = body1
        uis.append(ui0)
        uis.append(ui1)
        tmpl["ui"] = uis
        
        let json = try! JSONSerialization.data(withJSONObject: tmpl, options: .prettyPrinted)
        // json 데이터 확인
        let jsonstring = NSString(data: json, encoding: String.Encoding.utf8.rawValue ) ?? ""

        param["template_data"] = jsonstring
        param["cnt_addimage"] = added.count
        
        self.spec = param
        
        
    }
    
    func sendMultipart(){
        getSpec()
        
        guard spec.count > 0 else {return}
        let param = spec
        
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                
                let json = self.hj.jsonToString(json: param as AnyObject)
                multipartFormData.append( (json.data(using: .utf8))! , withName: "description")
                
                //사진
                for t in self.taken{
                    
                    multipartFormData.append(UIImagePNGRepresentation(self.hj.resized(image: t.value, toWidth: 600)!)!, withName: t.key, fileName: t.key, mimeType: "text/plain")
                }
                for a in self.added{
                    multipartFormData.append(UIImagePNGRepresentation(self.hj.resized(image: a.value, toWidth: 600)!)!, withName: a.key, fileName: a.key, mimeType: "text/plain")
                }
                
        },
            to: "\(hj.url)app/api/estm/insert",
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        debugPrint(response)
                        if let JSON = response.result.value  as? [String: Any] {
                            let result = JSON["result"] as! [String:Any]
                            if let err = result["error"] as! String?{ self.showAlert(msg: err); return }
                            
                            let mort_id = result["estm_id"]
                            print("mort_id = \(mort_id)")
                            
                            self.performSegue(withIdentifier: self.segueToDone, sender: self)
                            
                        }
                    }
                case .failure(let encodingError):
                    print(encodingError)
                }
        }
        )
        
    }
    
    
    func pop(){
        Alamofire.request("\(hj.url)appapi/category").responseJSON { response in
//            print(response.request)  // original URL request
//            print(response.response) // HTTP URL response
//            print(response.data)     // server data
//            print(response.result)   // result of response serialization
            
            if let JSON = response.result.value  as? [String: Any] {
                //print("JSON: \(JSON)")
                
                let result = JSON["result"] as! [Any]

                // Insert from NSData containing JSON
                try! self.realm.write {
                    //self.realm.delete(self.realm.objects(Category.self))
                    
                    result.map{
                        
                        let a = $0 as! [String : Any]
                        
                        var c = Category()
                        c._id = a["_id"] as! Int
                        c.me = a["me"] as! String
                        c.parent = a["parent"] as! String
                        c.type = a["type"] as! String
                        c.icon_name = a["icon_name"] as! String
                        c.name = a["name"] as! String
                        c.template = a["template"] as! String
                        c.seq = a["seq"] as! Int
                      
                        self.realm.add(c, update: true)
                        
                    } // end - map
                    
                } // end - realm.write
                
                self.categories = self.realm.objects(Category.self)
                
                print("category count: \(self.categories?.count)")
                
                self.makeIcons()
                
            }
        }
    } // end - pop
    
    func attachPhotos(){
        photosBack.subviews.map{ $0.removeFromSuperview() }
        
        let template: [String:Any] = hj.convertToDictionary(text: curC.template)!
        let photo = template["photo"] as! [[String:Any]]
        let w = 69
        let h = 69
        var idx = 0
        
        for p in photo{
            let iv = UIImageView(frame: CGRect(x: w * idx, y: 0, width: w, height: h))
            iv.image = taken[p["filename"] as! String]
            iv.contentMode = .scaleAspectFit
            photosBack.addSubview(iv)
            idx += 1
        }
        for i in 0...added.count{
            let iv = UIImageView(frame: CGRect(x: w * idx, y: 0, width: w, height: h))
            iv.image = added["add_\(i)"]
            iv.contentMode = .scaleAspectFit
            photosBack.addSubview(iv)
            idx += 1
        }
        
        photosBackWidth.constant = CGFloat(w * idx)
        
    }
    
    func makeIcons(){
        var idx = 0
        let w = 74
        let predicate = NSPredicate(format: "parent = %@", "0")
        let cates0 = (realm.objects(Category.self).filter(predicate))
        let manager = SDWebImageManager.shared()
        var btnFirst: UIButton?
        for i in cates0{
            
            let itm = CategoryIcon(frame: CGRect(x: w * idx, y: 0, width: w, height: 115))
            
            //let imgV = UIImageView(frame: CGRect(x: w * idx, y: 0, width: w, height: 115))
            categoryBack.addSubview(itm)
            idx += 1
            let url = "\(hj.url)category/ios/\(i.icon_name)_normal.png"
            let url_pressed = "\(hj.url)category/ios/\(i.icon_name)_pressed.png"
            let url_mini = "\(hj.url)category/ios/\(i.icon_name)_mini.png"
            print(url)
            
            
            itm.image.sd_setImage(with: URL(string: url ), placeholderImage: UIImage(named: "ic_gallery"))
            itm.tag = i._id
            
            itm.name.text = i.name
            
            print("icon name = \(i.name)")
           
            //pressed image save
            manager.loadImage(with: URL.init(string: url_pressed), options: SDWebImageOptions(rawValue: 0), progress: {( _ receivedSize: Int, _ expectedSize: Int, _ url: URL?) -> () in
                
            }, completed: {(_ image: UIImage?, _ data: Data?, _ err: Error?, _ cacheType: SDImageCacheType, _ finished: Bool, _ imageUrl: URL?) -> () in
                if (image != nil) {
                    // do something with image
                    
                    try! self.realm.write {
                        i.icon_pressed = UIImagePNGRepresentation(image!)! as NSData
                    }
                    
                }
            })
            manager.loadImage(with: URL.init(string: url), options: SDWebImageOptions(rawValue: 0), progress: {( _ receivedSize: Int, _ expectedSize: Int, _ url: URL?) -> () in
                
            }, completed: {(_ image: UIImage?, _ data: Data?, _ err: Error?, _ cacheType: SDImageCacheType, _ finished: Bool, _ imageUrl: URL?) -> () in
                if (image != nil) {
                    // do something with image
                    
                    try! self.realm.write {
                        i.icon_normal = UIImagePNGRepresentation(image!)! as NSData
                    }
                    
                }
            })
            //mini
            manager.loadImage(with: URL.init(string: url_mini), options: SDWebImageOptions(rawValue: 0), progress: {( _ receivedSize: Int, _ expectedSize: Int, _ url: URL?) -> () in
                
            }, completed: {(_ image: UIImage?, _ data: Data?, _ err: Error?, _ cacheType: SDImageCacheType, _ finished: Bool, _ imageUrl: URL?) -> () in
                if (image != nil) {
                    // do something with image
                    
                    try! self.realm.write {
                        i.icon_mini = UIImagePNGRepresentation(image!)! as NSData
                    }
                    
                }
            })

            
            if btnFirst == nil {btnFirst = itm.button}
            itm.button.addTarget(self, action: #selector(iconClick(_:)), for: .touchUpInside)
            
            
            
        }
        
        //set width
        categoryBackWidth.constant = CGFloat(w * cates0.count)
        
        btnFirst?.sendActions(for: .touchUpInside)
        
    }
    
    
    
    func iconClick(_ sender: UIButton) {
        
        if let me = sender.superview?.superview as! CategoryIcon?{
            
            //초기화
            clearIcons()
            showPhotosTaken(isOpen: false)
            added = [:]
            taken = [:]
            
            let predicate = NSPredicate(format: "_id = \(me.tag)")
            let c = (realm.objects(Category.self).filter(predicate))[0]
            
            curC = c
            me.image.image = UIImage(data: c.icon_pressed as Data, scale: 1.0)
            me.name.textColor = hj.rgb(0x0033a0)
            
            
            //template 여부 확인
            if c.template.trimmingCharacters(in: .whitespacesAndNewlines) == "" { emptyTemplate(); return }
            else{ notEmptyTemplate() }
            makeUIs()

            
        }
        
        
    }
    
    func emptyTemplate(){
        isTemplate = false
        goodsBack.subviews.map{ $0.removeFromSuperview() }
        addedBack.subviews.map{ $0.removeFromSuperview() }
        
        showAlert(msg: "카테고리 템플릿 정보가 없습니다")
    }
    func notEmptyTemplate(){
        isTemplate = true
    }
    // Alert
    func showAlert( msg: String ) {
        
        let alertController = UIAlertController(title: msg, message: "", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "확인", style: UIAlertActionStyle.default) {
            (result : UIAlertAction) -> Void in
            
        }
        
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    func makeUIs(){
        
        //template get
        
        let template: [String:Any] = hj.convertToDictionary(text: curC.template)!
        let photo = template["photo"]
        let ui = template["ui"] as! [[String:Any]]
        
        ui.map{
            let header = $0["header"] as! String
            let body = $0["body"] as! [[String:Any]]
        
            
            if header == "물품정보" {
                goodsBack.subviews.map{ $0.removeFromSuperview() }
                let stack = makeBody(body: body)
                addStack(stack: stack, parent: goodsBack)
                goodsHeight.constant = CGFloat( stack.subviews.count * 40 )
            }
            if header == "추가정보" {
                addedBack.subviews.map{ $0.removeFromSuperview() }
                let stack = makeBody(body: body)
                addStack(stack: stack, parent: addedBack)
                addedHeight.constant = CGFloat( stack.subviews.count * 40 )
            }
            
        }
        
        
    }
    func makeBody(body: [[String:Any]]) -> UIStackView{
        var uis = [UIView]()
        body.map{
            let ui = makeUI(i: $0)
            uis.append(ui)
            
            
            //print("added ui height = \(ui.frame)")
        }
        return UIStackView(arrangedSubviews: uis)

    }
    
    func makeUI(i: [String:Any]) -> UIView{

        let h = 40
        let seq = Int(i["seq"] as! String)!
        let title = i["title"] as! String
        let hint = i["hint"] as? String ?? ""
        let suffix = i["suffix"] as? String ?? ""
        let type = i["type"] as! String
        let id = Int( i["id"] as! String )!

        
        let ui = AppruiText(frame: CGRect(x: 0, y: (seq - 1) * h, width: Int(view.bounds.width), height: h), type: type)
        ui.title.text = title
        ui.text.placeholder = hint
        ui.tag = id
        if type == "cal" { ui.arrow.isHidden = false }
        if type == "num" { ui.text.keyboardType = .numberPad }
        if suffix != "" { ui.text.textAlignment = .right; ui.text.placeholder = suffix }
        
        
        return ui
    }
    
    
    func addStack(stack: UIStackView, parent: UIView){
        
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.alignment = .fill
        stack.spacing = 8
        
        
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        parent.addSubview(stack)
        
        //constraint
        NSLayoutConstraint(item: stack, attribute: .leading, relatedBy: .equal, toItem: parent, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: stack, attribute: .trailing, relatedBy: .equal, toItem: parent, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
//        NSLayoutConstraint(item: stack, attribute: .centerY, relatedBy: .equal, toItem: parent, attribute: .centerY, multiplier: 1.0, constant: 0).isActive = true

        NSLayoutConstraint(item: stack, attribute: .top, relatedBy: .equal, toItem: parent, attribute: .top, multiplier: 1.0, constant: 5).isActive = true
        NSLayoutConstraint(item: stack, attribute: .bottom, relatedBy: .equal, toItem: parent, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
        
    }
    
    
    
    
    func clearIcons(){
        
        for v in categoryBack.subviews{
            let i = v as! CategoryIcon
            let c = (realm.objects(Category.self).filter("_id = \(i.tag)"))[0]
            i.image.image = UIImage(data: c.icon_normal as Data, scale: 1.0)
            i.name.textColor = UIColor.black
        }
        
    }
    
   

}

