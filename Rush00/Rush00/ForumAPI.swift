//
//  ForumAPI.swift
//  rush00test
//
//  Created by Volodymyr KUKSA on 1/20/19.
//  Copyright © 2019 Volodymyr KUKSA. All rights reserved.
//

import Foundation

class ForumApi {
    
    static let urlBase = "https://api.intra.42.fr"
    
    static let uid = "a1c83f222fa183cff76ecd1f25ad1e715c155a793113762a42da36457b066609"
    static let secret = "5c1bed2f62ee5616cecdbaebb8642b6022e78c230c11a928e3f3d0b563f8579f"
    static let redirect_uri = "rush00%3A%2F%2Frush00"
    
    static let link = URL(string: "https://api.intra.42.fr/oauth/authorize?client_id=a1c83f222fa183cff76ecd1f25ad1e715c155a793113762a42da36457b066609&redirect_uri=rush00://rush00&response_type=code&scope=public forum".addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!)
    
    static var accessCode: String? = nil
    static var accessToken: String? = nil
    static var currentTopicsPage = 1
    
    static var login: String?
    static var userId: Int?
    
    static var topics = [Topic]()
    
    
    static func authSessionCallback(url: URL?, error: Error?, callback: @escaping (Bool)->()) {
        guard let callbackUrl = url,
            let code = NSURLComponents(string: callbackUrl.absoluteString)?.queryItems?.filter({$0.name == "code"}).first else {
                callback(false)
                return;
        }
        
        print(code.value!)
        ForumApi.accessCode = code.value
        
        let url = ForumApi.urlBase + "/oauth/token"
        let params = "?grant_type=authorization_code&client_id=\(ForumApi.uid)&client_secret=\(ForumApi.secret)&code=\(ForumApi.accessCode!)&redirect_uri=\(ForumApi.redirect_uri)"
        
        var request = URLRequest(url: (URL(string : url + params))!)
        request.httpMethod = "POST"
        
        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            
            do {
                let json =  try? JSONSerialization.jsonObject(with: data!) as! [String: Any]
                print((json?["access_token"])!)
                ForumApi.accessToken = json?["access_token"] as? String
                
                ForumApi.getSelf {
                    (success)->() in
                    
                    DispatchQueue.main.async {
                        callback(success)
                    }
                }
            }
        }
        task.resume()
    }
    
    
    static func loadTopicsPage(callback: @escaping ()->()) {
        
        if ForumApi.currentTopicsPage < 0 {
            callback()
            return
        }
        
        let url = urlBase + "/v2/topics"
        let params = "?per_page=100&page=" + String(ForumApi.currentTopicsPage)
        
        var request = URLRequest(url: URL(string: url + params)!)
        request.addValue("Bearer " + ForumApi.accessToken!, forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            
            do {
                let json =  try? JSONSerialization.jsonObject(with: data!) as! [[String: Any]]
                
                if json!.isEmpty {
                    ForumApi.currentTopicsPage = -1
                } else {
                    ForumApi.currentTopicsPage += 1
                }
                
                ForumApi.topics += Topic.deserializeTopics(fromJSON: json!)
                
                DispatchQueue.main.async {
                    callback()
                }
            }
        }
        task.resume()
    }
    
    
    static func loadMessages(fromURL url: String, callback: @escaping ([Message])->()) {
        let params = "?per_page=100"
        
        var request = URLRequest(url: URL(string: url + params)!)
        request.addValue("Bearer " + ForumApi.accessToken!, forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            
            do {
                if let json =  try? JSONSerialization.jsonObject(with: data!) as! [[String: Any]] {
                    let messages = Message.deserializeMessages(fromJSON: json)
                    
                    DispatchQueue.main.async {
                        callback(messages)
                    }
                }
            }
        }
        task.resume()
    }
    
    
    static func getSelf(callback: @escaping (Bool)->()) {
        let url = urlBase + "/v2/me"
        
        var request = URLRequest(url: URL(string: url)!)
        request.addValue("Bearer " + ForumApi.accessToken!, forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            
            do {
                if let json =  try? JSONSerialization.jsonObject(with: data!) as! [String: Any],
                    let userId = json["id"] as? Int,
                    let login = json["login"] as? String {
                    
                    ForumApi.userId = userId
                    ForumApi.login = login
                    
                    DispatchQueue.main.async {
                        callback(true)
                    }
                } else {
                    DispatchQueue.main.async {
                        callback(false)
                    }
                }
            }
        }
        task.resume()
    }
    
    static func postMessage(topicId: Int, text: String, callback: @escaping ([Message]?)->()) {
        let url = urlBase + "/v2/topics/\(topicId)/messages"
        let params = "?message[author_id]=\(ForumApi.userId!)&message[content]=\(text)"
        let fullUrl = (url + params).addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        
        let requestUrl = URL(string: fullUrl!)
        
        var request = URLRequest(url: requestUrl!)
        request.httpMethod = "POST"
        request.addValue("Bearer " + ForumApi.accessToken!, forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            
            do {
                if let json =  try? JSONSerialization.jsonObject(with: data!) as! [String: Any] {
                    let messages = Message.deserializeMessages(fromJSON: [json])
                    callback(messages)
                } else {
                    callback(nil)
                }
            }
        }
        task.resume()
    }
}
