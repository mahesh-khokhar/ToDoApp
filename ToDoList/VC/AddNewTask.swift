//
//  AddNewTask.swift
//  ToDoList
//
//  Created by Gb2 on 21/05/19.
//

import UIKit

class AddNewTask: UIViewController, UITextViewDelegate {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var constraintBottomToSuperView: NSLayoutConstraint!
    
    fileprivate let obj_DatabaseModel = DatabaseModel.init()
    
    internal var dictTask = typeAliasDictionary()
    internal var isEdit: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(with:)),           name: .UIKeyboardWillShow, object: nil)
        textView.becomeFirstResponder()
        
        if self.isEdit {
            textView.text = dictTask[FLD_TASK_MESSAGE] as? String ?? ""
            textView.text = dictTask[FLD_TASK_MESSAGE] as? String ?? ""
        }

    }
    
    @objc func keyboardWillShow(with notification: Notification) {
        guard let keyboardFrame = notification.userInfo?["UIKeyboardFrameEndUserInfoKey"] as? NSValue else { return }
        
        let keyboardHeight = keyboardFrame.cgRectValue.height + 16
        constraintBottomToSuperView.constant = keyboardHeight
        UIView.animate(withDuration: 0.3) { self.view.layoutIfNeeded() }
    }

    @IBAction func btnCancelAction() {
        self.dismiss(animated: true)
        textView.resignFirstResponder()
    }
    
    @IBAction func btnDoneAction() {
        guard let title = textView.text, !title.isEmpty else {
            return
        }
        
        if self.isEdit {
            if obj_DatabaseModel.openDatabaseConnection() {
                if let id = self.dictTask[FLD_ROW_ID]  {
                    obj_DatabaseModel.updateTask(stID: id as! String, stMessage: title)
                }
                obj_DatabaseModel.closeDatabaseConnection()
            }
        }
        else {
            if obj_DatabaseModel.openDatabaseConnection() {
                obj_DatabaseModel.insertTaskEntry(stMessage: title, stDate: "\(Date())")
                obj_DatabaseModel.closeDatabaseConnection()
            }
        }
        self.dismiss(animated: true)
        textView.resignFirstResponder()
        
    }
    
    //NARK:- UITextViewDelegate
    func textViewDidChangeSelection(_ textView: UITextView) {
        if btnDone.isHidden {
            textView.text.removeAll()
            textView.textColor = .white
            
            btnDone.isHidden = false
            UIView.animate(withDuration: 0.3) { self.view.layoutIfNeeded() }
        }
    }
    
}
