//
//  GoogleLogin.swift
//
//


let SOCIAL_ID                           = "SOCIAL_ID"
let SOCIAL_TOKEN                        = "SOCIAL_TOKEN"
let SOCIAL_EMAIL                        = "SOCIAL_EMAIL"
let SOCIAL_MOBILE_NO                    = "SOCIAL_MOBILE_NO"
let SOCIAL_NAME                         = "SOCIAL_NAME"
let SOCIAL_PROFILE_IMAGE                = "SOCIAL_PROFILE_IMAGE"

public enum SOCIAL_LOGIN: Int {
    case DUMMY
    case GOOGLE
}

import UIKit
import GoogleSignIn
import FirebaseAuth
import Firebase


protocol GoogleLoginDelegate {
    func getSocialProfile(_ dictUserInfo: typeAliasDictionary)
}

class GoogleLogin: NSObject, GIDSignInDelegate, GIDSignInUIDelegate {
    
    //MARK: PROPERTIES
    var delegate: GoogleLoginDelegate! = nil
    
    //MARK: VARIABLES
    fileprivate let obj_AppDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    fileprivate var viewController: UIViewController!
    
    //MARK:- CUSTOME METHODS
    internal func performGoogleLoginAction(_ viewController: UIViewController) {
        self.viewController = viewController
        obj_AppDelegate._SOCIAL_LOGIN = SOCIAL_LOGIN.GOOGLE
        
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        let signIn: GIDSignIn = GIDSignIn.sharedInstance()
        signIn.signOut()
        signIn.shouldFetchBasicProfile = true
        
        //LIVE
        signIn.clientID = "216098635857-jmoudatsbnie56abafhid0ir0r8gipnc.apps.googleusercontent.com"
        signIn.scopes = ["https://www.googleapis.com/auth/plus.login"]
        signIn.delegate = self
        signIn.uiDelegate = self
        signIn.signIn()
    }
    
    //MARK: GID SIGNIN UI DELEGATE
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
        //SharedModel.startActivityIndicator(self.viewController.view)
    }
    
    // Present a view that prompts the user to sign in with Google
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) { self.viewController.present(viewController, animated: true, completion: nil) }
    
    // Dismiss the "Sign in with Google" view
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        self.viewController.dismiss(animated: true, completion: nil)
        SharedModel.stopActivityIndicator()
    }
    
    //MARK: GID SIGNIN DELEGATE
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        SharedModel.stopActivityIndicator()
        if (error == nil) {
            // Perform any operations on signed in user here.
            SharedModel.startActivityIndicator(self.viewController.navigationController!.view)
            guard let authentication = user.authentication else { return }
            let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                           accessToken: authentication.accessToken)
            Auth.auth().signInAndRetrieveData(with: credential) { (authenticationResult, error) in
                if error == nil {
                    print(authenticationResult!.user.displayName!)
                    
                    let stId: String = authenticationResult!.user.uid
                    let stToken: String = authenticationResult!.user.refreshToken!
                    let stEmail: String = user.profile.email != nil ? user.profile.email : ""
                    //let stEmail: String = authenticationResult!.user.email!
                    let stName: String = authenticationResult!.user.displayName!
                    
                    var dictInfo: typeAliasDictionary = [SOCIAL_ID: stId as AnyObject, SOCIAL_TOKEN: stToken as AnyObject, SOCIAL_EMAIL: stEmail as AnyObject, SOCIAL_NAME: stName as AnyObject]
                    
                    if user.profile.hasImage {
                        let imageUrl:URL = user.profile.imageURL(withDimension: 100)
                        
                        do {
                            let imageData = try Data.init(contentsOf: imageUrl)
                            let imagProfile = UIImage.init(data: imageData)
                            dictInfo[SOCIAL_PROFILE_IMAGE] = imagProfile
                            
                        }
                        catch{print("error")}
                    }
                    self.delegate.getSocialProfile(dictInfo)
                }
                else {
                    SharedModel.stopActivityIndicator()
                    print("\(String(describing: error?.localizedDescription))")
                }
            }
        }
        else { print("\(error.localizedDescription)") }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) { SharedModel.stopActivityIndicator() }
}
