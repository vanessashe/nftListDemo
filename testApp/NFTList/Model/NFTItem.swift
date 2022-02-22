//
//  NFTItem.swift
//  nftDemoApp
//
//  Created by shelin on 2022/2/22.
//

import Foundation

struct NFTItem {
    let image_url: String
    let name: String
    let desc: String
    let permalink: String
    let collectionName:String
    
    
    static func create(by data: [String:Any]) -> NFTItem? {
        if let name = data["name"] as? String,
           let image_url = data["image_url"] as? String,
           let desc = data["description"] as? String,
           let permalink = data["permalink"] as? String,
           let collection = data["collection"] as? [String:Any],
           let collectionName = collection["name"] as? String{
            return NFTItem(image_url: image_url, name: name, desc: desc, permalink: permalink, collectionName: collectionName)
        }
        return nil
    }
}
