//
//  MessageViewController.swift
//  Rush00
//
//  Created by Volodymyr KOZHEMIAKIN on 1/19/19.
//  Copyright © 2019 Volodymyr KOZHEMIAKIN. All rights reserved.
//

import UIKit

class MessageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var topicId: Int?
    var messages = [Message]()
    var messagesUrl: String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refresh()
    }
    
    func refresh() {
        if let url = messagesUrl {
            ForumApi.loadMessages(fromURL: url) {
                (messages)->() in
                self.messages = messages
                self.tableView.reloadData()
                print("refresh, \(self.messages.count)")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("get cell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell") as! MessageViewCell
        cell.message = messages[indexPath.row]
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "replies" {
            if let cell = sender as? MessageViewCell,
                let dest = segue.destination as? RepliesViewController {
                dest.mainMessage = cell.message
            }
        } else if segue.identifier == "NewMessage" {
            if let dest = segue.destination as? NewMessageViewController {
                dest.topicId = topicId
            }
        }
    }
    
    @IBAction func unwindSegue(segue: UIStoryboardSegue) {
        
    }

}
