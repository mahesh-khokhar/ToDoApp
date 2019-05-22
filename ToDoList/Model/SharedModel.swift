//
//  SharedModel.swift
//  ToDoList
//
//  Created by Gb2 on 21/05/19.
//

let FRAME_SCREEN                            = UIScreen.main.bounds


typealias typeAliasDictionary               = [String: AnyObject]
typealias typeAliasStringDictionary         = [String: String]

import UIKit

class SharedModel: NSObject {
    
    //MARK: VARIABLE
    var _MKActivtyIndicator: MKActivtyIndicator?
    
    static let sharedInstance = SharedModel()
    
    // Mark: Activity Indicator
    class func startActivityIndicator(_ view: UIView) {
        sharedInstance._MKActivtyIndicator?.removeFromSuperview()
        self.startActivityIndicator(view, title: "Loading...")
    }
    
    class func startActivityIndicator(_ view: UIView, title: String) {
        sharedInstance._MKActivtyIndicator = MKActivtyIndicator.init(title)
        view.addSubview(sharedInstance._MKActivtyIndicator!)
    }
    
    class func stopActivityIndicator() {
        sharedInstance._MKActivtyIndicator?.hideMKActivityIndicator()
        sharedInstance._MKActivtyIndicator?.removeFromSuperview()
    }

}
