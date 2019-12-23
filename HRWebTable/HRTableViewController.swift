//
//  HRTableViewController.swift
//  HRWebTable
//
//  Created by 肖江 on 2019/12/23.
//  Copyright © 2019 rivers. All rights reserved.
//

import UIKit

let hrWebURLString = "http://hr.nju.edu.cn"
let hrWebURL = URL(string: hrWebURLString)!

class HRTableViewController: UITableViewController {
    
    let model = Records.getInstance()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        loadHRContents()
    }
    
    func loadHRContents() {
        let request = URLRequest(url: hrWebURL)
        let task = URLSession(configuration: .default).dataTask(with: request) { (data, response, error) in
            let alertController = UIAlertController(title: "Oops!", message: "There was an error fetching hr.nju.edu.cn details.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default)
            alertController.addAction(okAction)
            if let data = data {
                var webpageStr = String(data: data, encoding: .utf8)!
                webpageStr = webpageStr.replacingOccurrences(of: "\n", with: "")
                webpageStr = webpageStr.replacingOccurrences(of: "\r", with: "")
                //print(s)
                self.model.info = self.getNews(from: webpageStr, for: "人事通知")
                self.model.news = self.getNews(from: webpageStr, for: "人事新闻")
                self.model.notion = self.getNews(from: webpageStr, for: "公示公告")
                self.model.jd = self.getNews(from: webpageStr, for: "招聘信息")
            } else {
                DispatchQueue.main.async {
                  self.present(alertController, animated: true, completion: nil)
                }
                return
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        task.resume()
    }
    
    func getNews(from webpageStr: String, for target : String) -> [NewsRecord] {
        var news = [NewsRecord]()
        var allNewsStr = ""
        let allNewsRegex = try! NSRegularExpression(pattern: "<div class=\"tt\">.*?\(target).*?</div>\\s*<div class=\"con\">\\s*<div id=\".*?\">\\s*<ul class=\"news_list\">(.*?)</ul>",
                                        options: [])
        if let match = allNewsRegex.firstMatch(in: webpageStr, options: [], range: NSRange(location: 0, length: webpageStr.count)) {
            print("match")
            if let range = Range(match.range(at: 1), in: webpageStr) {
                allNewsStr = String(webpageStr[range])
            }
        } else {
            print("no match")
        }
        
        let newsEntityRegex = try! NSRegularExpression(pattern: "<span class=\"news_title\"><a href='(.*?)' target='_blank' title='(.*?)'>.*?</a></span><span class=\"news_meta\">(.*?)</span><span class=\"news_meta1\">\\((.*?)\\)</span>",
                                                       options: [])
        let matches = newsEntityRegex.matches(in: allNewsStr, options: [], range: NSRange(location: 0, length: allNewsStr.count))
        print(matches.count)
        for match in matches {
            if match.numberOfRanges == 5 {
                let urlRange = Range(match.range(at: 1), in: allNewsStr)!
                let url = URL(string: hrWebURLString + String(allNewsStr[urlRange]))!
                
                let titleRange = Range(match.range(at: 2), in: allNewsStr)!
                let title = String(allNewsStr[titleRange])
                
                let dateRange = Range(match.range(at: 3), in: allNewsStr)!
                let dateStr = String(allNewsStr[dateRange])
                
                let nViewsRange = Range(match.range(at: 4), in: allNewsStr)!
                let nViews = Int(String(allNewsStr[nViewsRange]))!
                
                news.append(NewsRecord(title: title, dateStr: dateStr, nViews: nViews, url: url))
            } else {
                print("正则表达式选取单体新闻时出错")
            }
        }
        
        return news
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 4
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section {
        case 0:
            return model.info.count
        case 1:
            return model.news.count
        case 2:
            return model.notion.count
        case 3:
            return model.jd.count
        default:
            fatalError()
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RightDetailCell", for: indexPath)

        // Configure the cell...
        let news = model.getNews(at: indexPath)
        cell.textLabel?.text = news.title
        cell.detailTextLabel?.text = news.dateStr
        cell.accessoryType = .disclosureIndicator
        if news.nViews > 1000 {
            cell.imageView?.image = UIImage(named: "fire")
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "人事通知"
        case 1:
            return "人事新闻"
        case 2:
            return "公示公告"
        case 3:
            return "招聘信息"
        default:
            fatalError()
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        switch segue.identifier {
        case "showNewsDetail":
            guard let destinationView = segue.destination as? ViewController else {
                fatalError("Bad Segue")
            }
            guard let senderCell = sender as? UITableViewCell else {
                fatalError("Bad Segue Sender")
            }
            guard let senderIndex = tableView.indexPath(for: senderCell) else {
                fatalError("Bad Segue Sender")
            }
            let newsRecord = model.getNews(at: senderIndex)
            
            destinationView.targetURL = newsRecord.url
        default:
            fatalError("Bad Segue")
        }
    }

}
