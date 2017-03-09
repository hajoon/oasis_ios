//
//  SelPartnerTabViewController.swift
//  Oasis
//
//  Created by Needidsoft on 2017. 1. 20..
//  Copyright © 2017년 Needidsoft. All rights reserved.
//

import UIKit
import RealmSwift

class SelPartnerTabViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    @IBOutlet var collectionView: UICollectionView!
    
    let realm = try! Realm()
    var partners2: Results<Partner>!
    var mortids: [Int]!

    convenience init(cd: String, morts: [Int]){
        self.init(nibName: "SelPartnerTabViewController", bundle: nil)
        print("code= \(cd)")
        code = cd
        mortids = morts
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print("SelPartnerTabViewController viewDidLoad!")
        self.setupCollectionView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // collection view

    fileprivate let sectionInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    fileprivate let col: CGFloat = 1
    var code: String?

    
    
    func setupCollectionView() {
        print("SelPartnerTabViewController setupCollectionView!")
        
        guard let code = code else {return}
        
        let predicate = NSPredicate(format: "adm_single_code = %@", code)
        partners2 = realm.objects(Partner.self).filter(predicate)
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        registerCell()

        if let layout: UICollectionViewFlowLayout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {

            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0

            self.collectionView.collectionViewLayout = layout
        }

        self.collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, 0)

        
    }

    func registerCell(){
        
        //register nib
        let nib = UINib(nibName: "SelPartnerCell", bundle: nil)
        self.collectionView.register(nib, forCellWithReuseIdentifier: "cell")
        
        //register class
//        self.collectionView.register(SelPartnerCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    }
    
    //MARK: UICollectionViewDataSource & UICollectionViewDelegate

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        print("numberOfSections = \(realm.objects(Partner.self).count)")
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("numberOfItemsInSection partners2.count \(partners2.count)")
        return (partners2.count)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SelPartnerCell

        if let obj: Partner = partners2?[ indexPath.row ]{

            cell.title.text = obj.partner_name
            cell.body.text = obj.addr
            
        }

        return cell
    }


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let w = collectionView.bounds.width

        return CGSize(width: w - sectionInsets.left - sectionInsets.right, height: 76)

    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int ) -> CGFloat{
        return sectionInsets.left
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var cell = collectionView.cellForItem(at: indexPath)
        if let obj: Partner = partners2?[ indexPath.row ]{
            
            presentCalendar(partnerid: obj._id)
            
        }
        
        
    }
    func presentCalendar(partnerid: Int){
        let storyboard : UIStoryboard = UIStoryboard(name: "Mort", bundle: nil)
        let navc = storyboard.instantiateViewController(withIdentifier: "BookCalendarNavController") as! UINavigationController
        let vc = navc.viewControllers.first as! LoanCalendarViewController
        vc.mortids = mortids
        vc.partnerid = partnerid
        
        
        self.present(navc, animated: true, completion: nil)
    }


}
