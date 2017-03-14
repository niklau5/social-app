//
//  FeedbVC.swift
//  social-app
//
//  Created by Nikolai Brix Laursen on 14/03/2017.
//  Copyright © 2017 CrewNET IVS. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Firebase

class FeedbVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }


    @IBAction func signoutTapped(_ sender: Any) {
        KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        try! FIRAuth.auth()?.signOut()
        performSegue(withIdentifier: "goToSignin", sender: nil)
    }

}
