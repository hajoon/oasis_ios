//
//  Loanlist0ViewController.swift
//  Oasis
//
//  Created by mac on 2017. 1. 31..
//  Copyright © 2017년 Needidsoft. All rights reserved.
//

import UIKit
import RealmSwift


class Loanlist0ViewController: LoanlistXViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, LoanPageViewControllerDelegate, LoanNavigationControllerDelegate {

    
    let hj = hjUtil()
    var nav: LoanNavigationViewController!

    let formatCurrency: NumberFormatter = {
        let format = NumberFormatter()
        format.numberStyle = .currency
        return format
    }()
    
    var selLoanid: Int!
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
    
    
    
    
    
    
    
    // collection view
    
    let realm = try! Realm()
    var loans: Results<Loan>!
    
    fileprivate let sectionInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    fileprivate let col: CGFloat = 1
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    func makeData(){
        p.popLoanlist(state: "0")
    }
    func popListDone() {
        
        loans = realm.objects(Loan.self).filter("flag_state = \"0\"")
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! Loan0CollectionViewCell
        
        if let obj: Loan = loans[ indexPath.row ]{
            
            cell.title.text = obj.title
            cell.price.text = formatCurrency.string(from: NSNumber(value: Int64(obj.amount)! ))
            let dt = hj.convertToDictionary(text: obj.date_visit_json)
            if let date = dt?["date"]{
                cell.date.text = "방문 예약일: \(date as! String)"
            }
            
            
            
        }
        
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let w = collectionView.bounds.width
        
        return CGSize(width: w, height: cellheight )
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
//        case UICollectionElementKindSectionHeader:
//            let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "sectionHeader", for: indexPath)
//            return cell
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
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var cell = collectionView.cellForItem(at: indexPath)
        if let obj: Loan = loans?[ indexPath.row ]{
            selLoanid = obj._id
            
//            if let nav = navigationController as? LoanNavigationViewController{                
//                nav.dele = self
//            }
            
            let nav = navigationController as! LoanNavigationViewController
            nav.dele = self
            nav.performSegue(withIdentifier: nav.segueToDetail, sender: nil)
            
        }
        
    }

    func navPrepare(or segue: UIStoryboardSegue, sender: Any?) {
        //if segue.identifier != nav.segueToDetail { return }
        
        let vc = segue.destination as? LoanDetailViewController
        vc?.loanid = selLoanid
        vc?.cur = 0
        
        //super.prepare(for: segue, sender: sender)
    }
    
}
