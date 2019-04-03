//
//  Topics.swift
//  Rush00
//
//  Created by Volodymyr KOZHEMIAKIN on 1/19/19.
//  Copyright © 2019 Volodymyr KOZHEMIAKIN. All rights reserved.
//

import UIKit

class Topics: UIViewController, UITableViewDataSource, UITableViewDelegate {

   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ForumApi.loadTopicsPage {
            self.tableView.reloadData()
        }
    }
    
    @IBOutlet weak var tableView: UITableView! {
        didSet{
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return ForumApi.topics.count
        }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "topicCell") as! TopicsLabelTableViewCell
        cell.top = ForumApi.topics[indexPath.row]
        
        if indexPath.row == ForumApi.topics.count - 1 {
            ForumApi.loadTopicsPage {
                self.tableView.reloadData()
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showTopicMessages" {
            if let dest = segue.destination as? MessageViewController,
                let cell = sender as? TopicsLabelTableViewCell {
                dest.messagesUrl = cell.top?.messagesUrl
                dest.topicId = cell.top?.id
            }
        }
    }  
}
