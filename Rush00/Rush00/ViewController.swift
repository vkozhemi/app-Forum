//
//  ViewController.swift
//  Rush00
//
//  Created by Volodymyr KOZHEMIAKIN on 1/19/19.
//  Copyright © 2019 Volodymyr KOZHEMIAKIN. All rights reserved.
//

import UIKit
import SafariServices
import WebKit

class ViewController: UIViewController {

    var authSession: SFAuthenticationSession? = nil
    
    var isLoggedIn = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        authSession = SFAuthenticationSession(url: ForumApi.link!, callbackURLScheme: ForumApi.redirect_uri) {
            ForumApi.authSessionCallback(url: $0, error: $1) {
                (success)->() in
                self.isLoggedIn = success
            }
        }

        authSession?.start()
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "goToForum" {
            
            if !isLoggedIn {
                let alert = UIAlertController(title: "Forbidden!", message: "You are not logged in.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            
            return isLoggedIn
        }
        
        return true
    }
}

