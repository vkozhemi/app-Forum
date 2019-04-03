//
//  RepliesViewController.swift
//  Rush00
//
//  Created by Volodymyr KOZHEMIAKIN on 1/20/19.
//  Copyright © 2019 Volodymyr KOZHEMIAKIN. All rights reserved.
//

import UIKit

class RepliesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var messages = [Message]()
    
    var mainMessage: Message? {
        didSet {
            if let msg = mainMessage {
                messages.append(msg)
                messages.append(contentsOf: msg.replies)
//                tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell") as! MessageViewCell
        cell.message = messages[indexPath.row]
        return cell
    }
    
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    

    

}
