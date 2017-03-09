//
//  Util.swift
//  Oasis
//
//  Created by Needidsoft on 2017. 1. 5..
//  Copyright © 2017년 Needidsoft. All rights reserved.
//

import Foundation
import UIKit
public class hjUtil: NSObject {
    
    let url = "http://14.63.226.241:8110/"
    
    func rgb(_ hex: Int) -> UIColor{
        
        return UIColor(
            red: CGFloat((hex >> 16) & 0xff) / 255,
            green: CGFloat((hex >> 8) & 0xff) / 255,
            blue: CGFloat(hex & 0xff) / 255,
            alpha: CGFloat(1))
        
    }
    
    func hideKeyboardWhenTappedAround(vc: UIViewController) {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(vc:))   )
        vc.view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard(vc: UIViewController) {
        vc.view.endEditing(true)
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    func jsonToString(json: AnyObject) -> String{
        do {
            let data1 =  try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted) // first of all convert json to the data
            let convertedString = String(data: data1, encoding: String.Encoding.utf8) // the data will be converted to the string
            return convertedString ?? ""
            
        } catch let myJSONError {
            print(myJSONError)
        }
        return ""
    }
    
    // Alert
    func showAlert( vc: UIViewController, msg: String ) {
        
        let alertController = UIAlertController(title: msg, message: "", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "확인", style: UIAlertActionStyle.default) {
            (result : UIAlertAction) -> Void in
            
        }
        
        alertController.addAction(okAction)
        vc.present(alertController, animated: true, completion: nil)
    }
    
    func resized(image: UIImage, withPercentage percentage: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: image.size.width * percentage, height: image.size.height * percentage)
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, image.scale)
        defer { UIGraphicsEndImageContext() }
        image.draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    func resized(image: UIImage, toWidth width: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: width, height: CGFloat(ceil(width/image.size.width * image.size.height)))
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, image.scale)
        defer { UIGraphicsEndImageContext() }
        image.draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    
    
}


//extension UIColor {
//    convenience init(red: Int, green: Int, blue: Int) {
//        assert(red >= 0 && red <= 255, "Invalid red component")
//        assert(green >= 0 && green <= 255, "Invalid green component")
//        assert(blue >= 0 && blue <= 255, "Invalid blue component")
//        
//        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
//    }
//    
//    convenience init(netHex:Int) {
//        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
//    }
//}

