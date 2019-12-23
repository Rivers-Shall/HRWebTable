//
//  NewsRecord.swift
//  HRWebTable
//
//  Created by 肖江 on 2019/12/23.
//  Copyright © 2019 rivers. All rights reserved.
//

import Foundation

class NewsRecord {
    var title : String
    var dateStr : String
    var nViews : Int
    var url : URL
    
    init(title : String, dateStr : String, nViews : Int, url : URL) {
        self.title = title
        self.dateStr = dateStr
        self.nViews = nViews
        self.url = url
    }
}

class Records {
    static let instance = Records()
    static func getInstance() -> Records {
        return instance
    }
    
    // 人事通知
    var info = [NewsRecord]()
    // 人事新闻
    var news = [NewsRecord]()
    // 公示公告
    var notion = [NewsRecord]()
    // 招聘信息
    var jd = [NewsRecord]()
    
    func getNews(at indexPath : IndexPath) -> NewsRecord {
        var newsSet = [NewsRecord]()
        switch indexPath.section {
        case 0:
            newsSet = info
        case 1:
            newsSet = news
        case 2:
            newsSet = notion
        case 3:
            newsSet = jd
        default:
            fatalError()
        }
        return newsSet[indexPath.row]
    }
    
    private init() {
        
    }
}
