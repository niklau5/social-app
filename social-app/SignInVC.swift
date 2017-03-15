//
//  ViewController.swift
//  social-app
//
//  Created by Nikolai Brix Laursen on 12/03/2017.
//  Copyright © 2017 CrewNET IVS. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase
import SwiftKeychainWrapper

class SignInVC: UIViewController {

    @IBOutlet weak var emailField: FancyField!
    @IBOutlet weak var passwordField: FancyField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID) {
            print("Nikolai: ID found in keychain")
            performSegue(withIdentifier: "goToFeed", sender: nil)
        }
    }


    @IBAction func facebookBtnTapped(_ sender: Any) {
        
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil {
                print("Cannot login with Facebook - \(error)")
            } else if result?.isCancelled == true {
                print("user canncelled Facebook")
            } else {
                print("Succes with Facebook")
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credential)
            }
        }
    }
    
    func firebaseAuth(_ credential: FIRAuthCredential) {
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            if error != nil {
                print("Cannot auth with firebase - \(error)")
            } else {
                print("Succes with firebase auth")
                if let user = user {
                    let userData = ["provider": credential.provider]
                    self.completeSignin(id: user.uid, userData: userData)
                }
                
            }
        })
    }
    
    
    
    @IBAction func signInTapped(_ sender: Any) {
        if let email = emailField.text, let pwd = passwordField.text {
            FIRAuth.auth()?.signIn(withEmail: email, password: pwd, completion: { (user, error) in
                if error == nil {
                    print("Nikolai: Emial User auth with firebase")
                    if let user = user {
                        let userData = ["provider": user.providerID]
                        self.completeSignin(id: user.uid, userData: userData)
                    }
                    
                } else {
                    FIRAuth.auth()?.createUser(withEmail: email, password: pwd, completion: { (user, error) in
                        if error != nil {
                            print("Nikolai: uable to auth with firebase using email")
                        } else {
                            print("Nikolai: Succes with auth using mail - firebase")
                            if let user = user {
                                let userData = ["provider": user.providerID]
                                self.completeSignin(id: user.uid, userData: userData)
                            }
                            
                        }
                    })
                }
            })
        }
    }


    func completeSignin(id: String, userData: Dictionary<String, String>) {
        DataService.ds.createFirbaseDBUser(uid: id, userData: userData)
        let keychainResult = KeychainWrapper.standard.set(id, forKey: KEY_UID)
        print("Nikolai: Data saved to keychain \(keychainResult)")
        performSegue(withIdentifier: "goToFeed", sender: nil)
    }

}


