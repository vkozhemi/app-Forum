//
//  Models.swift
//  rush00test
//
//  Created by Volodymyr KUKSA on 1/20/19.
//  Copyright © 2019 Volodymyr KUKSA. All rights reserved.
//

import Foundation

struct Topic {
    var name: String
    var login: String
    var date: String
    var messagesUrl: String
    var id: Int
    
    static func deserializeTopics(fromJSON json: [[String:Any]]) -> [Topic] {
        var topics = [Topic]()
        
        for topic in json {
            let authorJson = topic["author"]! as! [String: Any]
            
            let name = topic["name"]! as! String
            let login = authorJson["login"]! as! String
            let date = topic["created_at"] as! String
            let messagesUrl = topic["messages_url"] as! String  // url for the topics messages
            let id = topic["id"] as! Int
            
            topics.append(Topic(name: name, login: login, date: date, messagesUrl: messagesUrl, id: id))
        }
        
        return topics
    }
}

struct Message {
    var login: String
    var content: String
    var date: String
    var replies: [Message]
    
    func printMessage() {
        print("\(login): \(content), replies[")
        
        for reply in replies {
            reply.printMessage()
        }
        
        print("]")
    }
    
    static func deserializeMessages(fromJSON json: [[String:Any]]) -> [Message] {
        var serializedMessages = [Message]()
        
        for message in json {
            let authorJson = message["author"] as! [String: Any]
            let login = authorJson["login"] as! String
            let content = message["content"] as! String
            let date = message["created_at"] as! String
            let replies = deserializeMessages(fromJSON: message["replies"] as! [[String:Any]])
            
            serializedMessages.append(Message(login: login, content: content, date: date, replies: replies))
        }
        
        return serializedMessages
    }
}
