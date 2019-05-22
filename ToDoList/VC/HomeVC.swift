//
//  HomeVC.swift
//  ToDoList
//
//  Created by Gb2 on 22/05/19.
//

import UIKit

class HomeVC: UIViewController, GoogleLoginDelegate {

    //MARK:- VARIABLE
    fileprivate let obj_GoogleLogin = GoogleLogin()
    fileprivate let obj_AppDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true , animated: false)
    }
    
    @IBAction func btnUseAppWithoutLoginAction() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "idTaskVC") as! TaskVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnLoginWithGoogleAction() {
        obj_AppDelegate._SOCIAL_LOGIN = SOCIAL_LOGIN.GOOGLE
        obj_GoogleLogin.performGoogleLoginAction(self)
        obj_GoogleLogin.delegate = self
    }
    
    //MARK:- GOOGLE LOGIN DELEGATE
    func getSocialProfile(_ dictUserInfo: typeAliasDictionary) {
        //SharedModel.stopActivityIndicator()
        print("Social Profile : \(dictUserInfo)")
        
//        let stUserName: String = dictUserInfo[SOCIAL_NAME] as? String ?? ""
//        let stMobileNumber: String = dictUserInfo[SOCIAL_MOBILE_NO] as? String ?? ""
//        let stSocialEmail: String = dictUserInfo[SOCIAL_EMAIL] as? String ?? ""
        
        if obj_AppDelegate._SOCIAL_LOGIN == SOCIAL_LOGIN.GOOGLE {
            print("Google: \(String(describing: dictUserInfo[SOCIAL_ID] as? String))")
//            let stSocialID = dictUserInfo[SOCIAL_ID] as? String ?? ""
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "idTaskVC") as! TaskVC
            self.navigationController?.pushViewController(vc, animated: true)
            
            let alert = UIAlertController(title: "ToDoApp", message: "Social Login Successfully", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
}
