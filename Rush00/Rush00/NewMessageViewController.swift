//
//  NewMessageViewController.swift
//  Rush00
//
//  Created by Volodymyr KOZHEMIAKIN on 1/20/19.
//  Copyright © 2019 Volodymyr KOZHEMIAKIN. All rights reserved.
//

import UIKit

class NewMessageViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    var topicId: Int?
    var postedMessage: Message?
    
    @IBAction func onDonePressed(_ sender: UIBarButtonItem) {
        if !textView.text.isEmpty {
            ForumApi.postMessage(topicId: topicId!, text: textView.text) {
                (message)->() in
                self.postedMessage = message?.first
            }
        }
        
        performSegue(withIdentifier: "unwind", sender: nil)
    }
}
