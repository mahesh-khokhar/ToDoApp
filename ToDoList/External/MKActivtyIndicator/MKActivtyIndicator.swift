//
//  MKActivtyIndicator.swift
//  ToDoList
//

import UIKit

class MKActivtyIndicator: UIView {
    
    //MARK:- PROPERTY
    @IBOutlet var viewBG: UIView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    //MARK:- Variable
    let obj_AppDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var stMessage: String = ""
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: FRAME_SCREEN.width, height: FRAME_SCREEN.height))
        self.loadXIB()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required init(_ message: String) {
        super.init(frame: CGRect(x: 0, y: 0, width: FRAME_SCREEN.width, height: FRAME_SCREEN.height))
        stMessage = message;
        self.loadXIB()
    }
    
    //MARK:- loadXIB Function
    fileprivate func loadXIB() {
        //Get XIB
        let view = Bundle.main.loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)?[0] as! UIView
        view.translatesAutoresizingMaskIntoConstraints = false;
        self.addSubview(view)
        self.alpha = 1;
        
        //Set Constraint
        //TOP
        self.addConstraint(NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0))
        
        //LEADING
        self.addConstraint(NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.leading, multiplier: 1, constant:0))
        
        //WIDTH
        self.addConstraint(NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.width, multiplier: 1, constant:0))
        
        //HEIGHT
        self.addConstraint(NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.height, multiplier: 1, constant:0))
        
        view.addSubview(self)
        self.layoutIfNeeded()
        
        viewBG.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.8)
        activityIndicator.startAnimating()
    }
    
    //Mark:- Custom Method
    internal func hideMKActivityIndicator() {
        activityIndicator.stopAnimating()
    }
}
