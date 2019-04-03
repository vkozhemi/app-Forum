//
//  MessageViewCell.swift
//  Rush00
//
//  Created by Volodymyr KOZHEMIAKIN on 1/20/19.
//  Copyright © 2019 Volodymyr KOZHEMIAKIN. All rights reserved.
//

import UIKit

class MessageViewCell: UITableViewCell {

    
    // Message(login: login, content: content, date: date, replies: replies)
    
    
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var numberOfReplies: UILabel!
    
    
    var messagesUrl: String?
    
    var message: Message? {
        didSet {
            if let msg = message {
                loginLabel.text = msg.login
                dateLabel.text = String(msg.date.dropLast(14))
                contentLabel.text = msg.content
                numberOfReplies.text = "replies: \(msg.replies.count)"
            }
        }
    }

    
    

}
