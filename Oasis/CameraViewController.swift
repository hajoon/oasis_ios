//
//  CameraViewController.swift
//  Oasis
//
//  Created by Needidsoft on 2017. 1. 24..
//  Copyright © 2017년 Needidsoft. All rights reserved.
//

import UIKit

protocol CameraViewControllerDelegate {
    func cameraDone(added: [String:UIImage], taken: [String:UIImage])
}

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var cTitle: UILabel!
    @IBOutlet weak var done: ButtonNoIcon!
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBAction func close(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

    var delegate: CameraViewControllerDelegate!
    
    let segueToAppr = "cameraToAppraise"
    
    let hj = hjUtil()
    
    var c: Category!
    var photo: [[String:Any]]!
    var added = [String:UIImage]()
    var taken = [String:UIImage]()
    var selCell: CameraCollectionViewCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.ButtonNoIconTouchUpInside), name: Notification.Name("ButtonNoIconTouchUpInside"), object: nil)
        
        setupUI()
        getPhoto()
        setupCollectionView()
        
    }
    func validate() -> Bool{
        guard taken.count == photo.count else {
            hj.showAlert(vc: self, msg: "추가를 제외한 사진 모두 필요합니다")
            return false
        }
        return true
    }
    func ButtonNoIconTouchUpInside(notification: Notification){
        // 촬영 완료
        guard validate() else {
            return
        }
        //performSegue(withIdentifier: segueToAppr, sender: nil)
        delegate.cameraDone(added: added, taken: taken)
        dismiss(animated: true, completion: nil)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func getPhoto(){
        
        let template: [String:Any] = hj.convertToDictionary(text: c.template)!
        photo = template["photo"]  as! [[String:Any]]
        
    }
    func setupUI(){
        icon.image = UIImage(data: c.icon_mini as Data, scale: 1.0)
        cTitle.text = c.name
        
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        
//        if segue.identifier != segueToAppr { return }
//        
//        let vc = segue.destination as? AppraiseViewController
//        
//        vc?.added = added
//        vc?.taken = taken
//        
//        
//    }
    
    
    
    
    
    
    
    
    
    // collection view
    
    fileprivate let sectionInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    fileprivate let col: CGFloat = 2
    var code: String?
    
    func setupCollectionView() {
        
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self

        if let layout: UICollectionViewFlowLayout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
            
            self.collectionView.collectionViewLayout = layout
        }
        
        self.collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, 0)
        
        
    }
    
    //MARK: UICollectionViewDataSource & UICollectionViewDelegate
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return (photo!.count) + (added.count + 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CameraCollectionViewCell
        
        // print("indexPath row = \(indexPath.row) photo count = \(photo.count)")
        
        
        if indexPath.row >= photo.count{
            cell.label.text = "+추가"
            cell.isAdded = true
            cell.key = "add_\( indexPath.row - photo.count )"

        }else{
            
            if let obj: [String:Any] = photo?[indexPath.row]{
                cell.label.text = obj["label"] as! String?
                cell.isAdded = false
                cell.key = obj["filename"] as! String
                
            }
        }
        // print("cell key = \(cell.key)")
        return cell
    }
    
    // 셀 크기
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let w = (collectionView.bounds.width / col)
        
        return CGSize(width: w - sectionInsets.left - (sectionInsets.right/2), height: w * 0.811 )
        
    }
    
    // 마진
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int ) -> CGFloat{
        return sectionInsets.left
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? CameraCollectionViewCell{
            selCell = cell
            // print("selCell key = \((selCell?.key))" )
            if cell.backImage.tag == 1 { showActionSheetTapped(); return }
            
            
            // 셀 선택
            cell.backImage.image = UIImage(named: "btn_box_focused")
            cell.label.textColor = hj.rgb(0x0033a0)
            
            showActionSheetTapped()
        }
        
        
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as! CameraCollectionViewCell?{
            if cell.backImage.tag == 1 { return }
            
            // 셀 선택 해제
            cell.backImage.image = UIImage(named: "btn_box_normal")
            cell.label.textColor = UIColor.black
        }
        
    }
    
    
    
    
    
    
   
    
    func showActionSheetTapped() {
        //Create the AlertController
        //        let actionSheetController: UIAlertController = UIAlertController(title: "Action Sheet", message: "Swiftly Now! Choose an option!", preferredStyle: .actionSheet)
        
        let actionSheetController = UIAlertController()
        
        //Create and add the Cancel action
        let cancelAction: UIAlertAction = UIAlertAction(title: "취소", style: .cancel) { action -> Void in
            //Just dismiss the action sheet
        }
        actionSheetController.addAction(cancelAction)
        //Create and add first option action
        let takePictureAction: UIAlertAction = UIAlertAction(title: "카메라", style: .default) { action -> Void in
            //Code for launching the camera goes here
            self.openCamera()
        }
        actionSheetController.addAction(takePictureAction)
        //Create and add a second option action
        let choosePictureAction: UIAlertAction = UIAlertAction(title: "사진", style: .default) { action -> Void in
            //Code for picking from camera roll goes here
            self.openPhoto()
        }
        actionSheetController.addAction(choosePictureAction)
        
        //Present the AlertController
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    
    func openCamera(){
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    func openPhoto(){
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            selCell?.backImage.contentMode = .scaleAspectFill
            selCell?.backImage.image = pickedImage
            selCell?.backImage.tag = 1
            
            
            
            // 추가
            if (selCell?.isAdded)! {
                //if selCell?.key == "" { selCell?.key = "add_\(added.count)" }
                added[(selCell?.key)!] = pickedImage
                collectionViewAddUpdate()
                
            }else{
                taken[(selCell?.key)!] = pickedImage
            }
            
        }
        dismiss(animated: true, completion: nil)
        
    }
    
    func collectionViewAddUpdate(){

        collectionView.performBatchUpdates({
            
            var arr = [IndexPath]()
            let count = (self.photo.count) + self.added.count
            
            // print("photo+added count = \(count) cell count = \(self.collectionView.numberOfItems(inSection: 0))")
            
            if self.collectionView.numberOfItems(inSection: 0) <= count {
                arr.append(IndexPath(row: count, section: 0))
            }
            
            self.collectionView.insertItems(at: arr)
            
        }, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        selCell?.backImage.tag = 0
        
        dismiss(animated: true, completion: nil)
    }

    func saveImage(image: UIImage){
        
        let imageData = UIImageJPEGRepresentation(image, 1)
        let compressedJPGImage = UIImage(data: imageData!)
        UIImageWriteToSavedPhotosAlbum(compressedJPGImage!, nil, nil, nil)
        
        // print("image saved!")
    }
    
    
    
}
