//
//  Article.swift
//  Demo
//
//  Created by cwn on 2018/11/20.
//  Copyright © 2018年 mac. All rights reserved.
//

import UIKit

class Article: Codable {
    var articleId: String!
    var sortType: String!
    var imgUrl: String!
    var Author: String!
    var thumb: String!
    var content: String!
//    
//    enum CodingKeys:String,CodingKey{
//        case Author="author"
//        case articleId 
//        case sortType
//        case imgUrl
//        case thumb
//        case content
//    }
}
