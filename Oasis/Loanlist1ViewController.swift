//
//  Loanlist1ViewController.swift
//  Oasis
//
//  Created by mac on 2017. 1. 31..
//  Copyright © 2017년 Needidsoft. All rights reserved.
//

import UIKit
import RealmSwift
import Alamofire
import SDWebImage

class Loanlist1ViewController: LoanlistXViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, LoanPageViewControllerDelegate {
    
    let hj = hjUtil()
    
    let formatCurrency: NumberFormatter = {
        let format = NumberFormatter()
        format.numberStyle = .currency
        return format
    }()
    
    var p: LoanPageViewController!
    var cellheight: CGFloat = 84
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        p = storyboard?.instantiateViewController(withIdentifier: "LoanPageViewController") as! LoanPageViewController
        p.dele = self
        makeData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func selectedPage(curIndex: Int) {
        
    }
    func getState() -> Int{
        if idx == 1{
            return 10
        }else if idx == 2{
            return 20
        }else if idx == 3{
            return 50
        }else if idx == 4{
            return 30
        }
        
        return -1
    }
    
    
    
    
    
    
    // collection view
    
    let realm = try! Realm()
    var loans: Results<Loan>!
    
    fileprivate let sectionInsets = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
    fileprivate let col: CGFloat = 2
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    func makeData(){
        
        p.popLoanlist(state: "\(getState())")
    }
    func popListDone() {
        
        loans = realm.objects(Loan.self).filter("flag_state = \"\(getState())\"")
        print("loans count = \(loans?.count)")
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
        print("numberOfSections = \(loans.count)")
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return loans.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! Loan1CollectionViewCell
        
        if let obj: Loan = loans[ indexPath.row ]{
            
            cell.title.text = obj.title
            cell.price.text = formatCurrency.string(from: NSNumber(value: Int64(obj.amount)! ))
            
            
            var url = getImageUrl(imgname: "photo_1", imgid: obj._id)
            //check
        
            if let reachable = try? url.checkResourceIsReachable(){
                if !reachable { url = getImageUrl(imgname: "add_1", imgid: obj._id) }
            }
        
            
            let imgPlaceholder = UIImage(named: "ic_gallery")
            
            cell.iv.sd_setImage(with: url, placeholderImage: imgPlaceholder)
            
        }
        
        
        return cell
    }
    func getImageUrl(imgname: String, imgid: Int) -> URL{
        return URL(string: "\(hj.url)mort/\(imgid)/\(imgname)")!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let w = (collectionView.bounds.width / col)-9
        
        return CGSize(width: w, height: w * 1.26 )
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {

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
        
        var height = 130
        if loans?.count == 0 {
            
        }
        else{ height = 1 }
        
        //print("referenceSizeForFooterInSection height = \(height)")
        
        return CGSize(width: collectionView.bounds.width, height: CGFloat(height) )
        
    }
    

    
    
}
