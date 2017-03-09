//
//  MortScene0ViewController.swift
//  Oasis
//
//  Created by Needidsoft on 2017. 1. 18..
//  Copyright © 2017년 Needidsoft. All rights reserved.
//

import UIKit
import RealmSwift
import SDWebImage

class MortScene0ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, CheckboxDelegate, SelPartnerDelegate, MortViewControllerDelegate {
    @IBOutlet weak var btnLoanreq: ButtonNoIcon!
    @IBOutlet weak var checkAll: Checkbox!
    @IBOutlet weak var checkAllLabel: UILabel!

    let hj = hjUtil()
    let txtAll = "전체 선택"
    var mvc: MortViewController!
    var cellheight: CGFloat = 153
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.ButtonNoIconTouchUpInside), name: Notification.Name("ButtonNoIconTouchUpInside"), object: nil)
        
        checkAll.delegate = self
        mvc = parent as! MortViewController
        mvc.dele = self
        
        makeData()
        makePopup()
    }
    func ButtonNoIconTouchUpInside(notification: Notification){
        let me = notification.object as! ButtonNoIcon
        
        guard me.tagInt == 1 else {return}
        
        // 선택한 담보물 id 가져오기
        var ids = [Int]()
        
        for m in morts{
            if m.is_check { ids.append(m._id) }
        }
        
        print("선택한 ids = \(ids)")
        
        vc.mortids = ids
        
        guard ids.count > 0 else { hj.showAlert(vc: self, msg: "선택한 담보물이 없습니다"); return }
        
        showPopup()
    }
    
    
    //SelPartnerDelegate
    func next(sender: SelPartner) {
        print("Next!")
    }
    func cancel(sender: SelPartner) {
        print("cancel!")
        closePopup()
    }

    var vc: SelPartner!
    func makePopup(){
        
        let storyboard : UIStoryboard = UIStoryboard(name: "SelPartner", bundle: nil)
        vc = storyboard.instantiateViewController(withIdentifier: "SelPartner") as! SelPartner

        vc.delegate = self
        
    }
    
    //let window = UIWindow(frame: UIScreen.main.bounds)
    
    func showPopup(){
       
        navigationController?.addChildViewController(vc)
        
        navigationController?.view.addSubview(vc.view)
        
        
        
    }
    func closePopup(){
        vc.view.removeFromSuperview()
        vc.removeFromParentViewController()
        
    }
    func popCenter(){
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        
        //constraint
        NSLayoutConstraint(item: vc.view, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: vc.view, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1.0, constant: 0).isActive = true
        
    }
    
    func presentPartners(){
        
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "SelPartnerViewController")
        
        self.present(vc, animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    // delegate
    func onCheck(sender: Checkbox) {
        //print(sender.checked ?? false)
        
        let id = sender.tag
        print("체크셀 id = \(id)")
        
        if sender.iTag == 99 { // 전체선택
            checkAllDB(isChk: sender.checked!)
        }else{
            if !sender.checked! { checkAll.isChecked = false }
            checkDB(id: id, isChk: sender.checked!)
            
        }
        collectionView.reloadData()
        setLabelText()
        
    }
    
    func checkDB(id: Int, isChk: Bool){
        try! realm.write {
            let m = morts.filter("_id=\(id)")
            m.setValue(isChk, forKey: "is_check")
        }
        
    }
    func checkAllDB(isChk: Bool){
        try! realm.write {
            
            for m in morts{
                m.setValue(isChk, forKey: "is_check")
            }
            
        }
    }
    
    
    
    
    // collection view
    
    let realm = try! Realm()
    var morts: Results<Mort>!
    //fileprivate var itmSize:CGSize?
    fileprivate let sectionInsets = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
    fileprivate let col: CGFloat = 1
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    func makeData(){
        mvc.popMorts(result: 1)
    }
    func mortsResponse() {
        
        morts = realm.objects(Mort.self).filter("flag_result = \"1\"")
        print("morts count = \(morts?.count)")
        self.setupCollectionView()
    }
    
    func setupCollectionView() {
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        if let layout: UICollectionViewFlowLayout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 6
            
            self.collectionView.collectionViewLayout = layout
        }
        
        self.collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, 0)
        
    }
    
    //MARK: UICollectionViewDataSource & UICollectionViewDelegate
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        print("numberOfSections = \(morts.count)")
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        setLabelText()
        return morts.count
    }

    func getNumChecked() -> Int{
        
        let ms = morts.filter("is_check = true")
        
        return ms.count
    }
    func setLabelText(){
        checkAllLabel.text = "\(txtAll)(총\(getNumChecked())/\(morts.count)개)"
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MortSceneCollectionViewCell
        
        //let obj = self.section[(indexPath as NSIndexPath).section]
        
        
        if let obj: Mort = morts[ indexPath.row ]{
            
            cell.check.delegate = self
            
            cell.headerTitle.text = "\(obj.title)(\(obj._id))"
            //cell.image.image.image = UIImage(named: "photo_\(obj._id)")
            
            let imgname = obj.category_id == "9" ? "add_0" : "photo_1"
            let url = URL(string: "\(hj.url)mort/\(obj._id)/\(imgname)" )
            let imgPlaceholder = UIImage(named: "ic_gallery")
            
            cell.image.image.sd_setImage(with: url, placeholderImage: imgPlaceholder)
            
            cell.price.text = "대출가능금액: \(obj.appraise_amount)원"
            cell.rate.text = "연대출금리: \(obj.rate)%"
            cell.date.text = "감정일자: \(obj.appraise_date)"
            
            cell.id = obj._id
            
            cell.check.isChecked = obj.is_check
            cell.check.tag = obj._id
            
            
            
        }
        
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let w = collectionView.bounds.width
        
        return CGSize(width: w, height: cellheight)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "sectionHeader", for: indexPath) 
            return cell
        case UICollectionElementKindSectionFooter:
            let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "sectionFooter", for: indexPath)
            
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
        
        var height = 350
        if morts?.count == 0 {
        
        }
        else{ height = 1 }
        
        //print("referenceSizeForFooterInSection height = \(height)")
        
        return CGSize(width: collectionView.bounds.width, height: CGFloat(height) )
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: CGFloat(1) )
    }
    
    
    
    
    
    
}




