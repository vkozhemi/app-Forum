//
//  TopicsLabelTableViewCell.swift
//  Rush00
//
//  Created by Volodymyr KOZHEMIAKIN on 1/19/19.
//  Copyright © 2019 Volodymyr KOZHEMIAKIN. All rights reserved.
//

import UIKit

class TopicsLabelTableViewCell: UITableViewCell {

   
    @IBOutlet weak var topicLabel: UILabel!
    
    @IBOutlet weak var loginLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    
    var top : Topic? {
        didSet {
            if let t = top {
                topicLabel?.text = String(t.name)
                loginLabel?.text = String(t.login)
                dateLabel?.text = String(t.date.dropLast(14))
//                textLabel?.text = String(t.messagesUrl)
            }
        }
    }

}
