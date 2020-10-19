//
//  ArticlesViewController.swift
//  Articles
//
//  Created by Liat Prassa
//  Copyright © 2020 Home. All rights reserved.
//

import UIKit
import Alamofire

class ArticlesViewController: UIViewController {
    
    @IBOutlet weak var articlesTable: UITableView!
    
    fileprivate let articleCellIdentifier = "ArticleTableViewCell"
    fileprivate let articleCellNix = UINib(nibName: "ArticleTableViewCell", bundle: nil)
    fileprivate let url = "https://cdn.theculturetrip.com/home-assignment/response.json"
    
    var articlesArray: [Article] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sendArticlesRequest()
        setupTableView()
    }
    
    func sendArticlesRequest(){
        
        guard let url = URL(string: url) else {
            return
        }
        
        AF.request(url, method: .get,  parameters: nil, encoding: JSONEncoding.default)
            .responseJSON {[weak self] response in
                switch response.result {
                case .success(let value):
                    if let json = value as? [String: Any] {
                        let array: [[String:Any]] = json["data"] as! [[String:Any]]
                        for itemDic in array {
                            let article = Article()
                            if let datesDic = itemDic["metaData"] as? [String:Any] {
                                article.createDate = datesDic["creationTime"] as? String
                            }
                            if let autorDic = itemDic["author"] as? [String:Any] {
                                let auther = Author()
                                auther.id = autorDic["id"] as? String
                                auther.name = autorDic["authorName"] as? String
                                if let avatr = autorDic["authorAvatar"] as?  [String:Any] {
                                    auther.avatar = avatr["imageUrl"] as? String
                                }
                                article.auther = auther
                            }
                            article.id = itemDic["id"] as? String
                            article.title = itemDic["title"] as? String
                            article.imageUrl = itemDic["imageUrl"] as? String
                            article.category = itemDic["category"] as? String
                            article.isSaved = itemDic["isSaved"] as? Bool
                            article.isLiked =  itemDic["isLiked"] as? Bool
                            article.likesCount = itemDic["likesCount"] as? Int
                            self?.articlesArray.append(article)
                        }
                        DispatchQueue.main.async{
                            self?.articlesTable.reloadData()
                        }
                    }
                case .failure(let error):
                    print(error)
                }
        }
    }
    
    private func setupTableView() {
        articlesTable.register(articleCellNix, forCellReuseIdentifier: articleCellIdentifier)
        articlesTable.delegate = self
        articlesTable.dataSource = self
        articlesTable.rowHeight = UITableView.automaticDimension        
    }
}

extension ArticlesViewController:  UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articlesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleTableViewCell", for: indexPath as IndexPath) as! ArticleTableViewCell
        cell.configureCell(article: articlesArray[indexPath.row])
        return cell
    }
}
