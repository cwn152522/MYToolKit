//
//  ViewController.swift
//  Demo
//
//  Created by mac on 2018/11/19.
//  Copyright © 2018年 mac. All rights reserved.
//

import UIKit
import MYToolKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    //MARK: - 属性定义
    var table: UITableView! = {//列表
        let tableview = UITableView.init()
        tableview.tableHeaderView  = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
        tableview.tableFooterView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
       return tableview
    }()
    var data: [Article]! = {//数据
        var array = [Article].init()
        return array
    }()

    
    //MARK: - 页面生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configTable()
        self.configButton()
        
        //列表数据请求
        self.getDataFromServer(){error in
            self.table.reloadData()
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    //MARK: - 控件初始化
    func configButton(){
//        let button: UIButton = UIButton.init()
//        button.setTitleColor(UIColor.red, for: UIControlState.normal)
//        button.setTitle("哈哈哈", for: UIControlState.normal)
//        self.view.addSubview(button)
//        button.cwn_makeConstraints { (maker: UIView!) in
//            maker.centerXtoSuper()(0)?.centerYtoSuper()(0)
//        }
    }
    func configTable(){
        self.table.dataSource = self
        self.table.delegate = self
        self.view.addSubview(self.table)
        
        //2.swift调用pod里的oc库 桥接文件Demo-Bridging-Header.h里#import "MYToolKit/MYToolKit-umbrella.h"
        self.table.cwn_makeConstraints { (maker: UIView!) in
            maker.edgeInsetsToSuper()(UIEdgeInsets.zero)
        }
    }
    
    
    
    //MARK: - 数据请求
    func getDataFromServer(completion:@escaping((_ error: Error?)->(Void))){
        //注释掉的代码，模拟的json格式为
        /*
         {对象
         -----------------------
            "":"",             情况1
         -----------------------
            "":{               情况2
            },
         -----------------------
            "":[               情况3
                {
                    "":"",
                    "":{       情况4
                    }
                }
            ]
         }
         */
        
//        let json:String = """
//            {
//                "articleId":"87",
//                "sortType":"笑话",
//                "imgUrl":"k",
//                "author":"陈某某1",
//                "thumb":"l",
//                "content":"阿哈哈哈哈",
//                "articled":{
//                    "articleId":"8733",
//                    "sortType":"笑话33",
//                    "imgUrl":"k33",
//                    "author":"陈某某2",
//                    "thumb":"l33",
//                    "content":"阿哈33哈哈哈",
//                    "article":null
//                },
//                 "articles":[{
//                     "articleId":"87",
//                     "sortType":"笑话",
//                     "imgUrl":"k",
//                     "author":"陈某某3",
//                     "thumb":"l",
//                     "content":"阿哈哈哈哈",
//                     "article":{
//                     "articleId":"8733",
//                     "sortType":"笑话33",
//                     "imgUrl":"k33",
//                     "author":"陈某某4",
//                     "thumb":"l33",
//                     "content":"阿哈33哈哈哈",
//                     "article":null
//                     }
//                 }]
//            }
//            """
//        
//        let data1 = json.data(using: String.Encoding.utf8)
//        let dic = try? JSONSerialization.jsonObject(with: data1!, options: JSONSerialization.ReadingOptions.mutableLeaves)
//
//        //3.swift调pod里swift文件 import MYToolKit
//        let result: Article? = try? JSONModel.cwn_makeModel(Article.self , jsonDic: dic as? [String : Any], hintDic: [
//                "Author":"author",
//                "article":"articled",
//                "articled":[
//                    "Author":"author",
//                 ],
//                "articles":[[
//                    "Author":"author",
//                    "article":[
//                        "Author":"author",
//                    ]
//                ]],
//        ])
//
//        self.data = result != nil ? [result!] : []//数组不能为nil，否则列表数据源强解的时候会崩溃
//            completion(nil)
        
        
        //实际请求例子(//3.swift调pod里swift文件 import MYToolKit)
        let manager = AFHTTPSessionManager.init(sessionConfiguration: URLSessionConfiguration.default)
        manager.responseSerializer.acceptableContentTypes = Set.init(arrayLiteral: "text/html")
        manager.get("http://123.207.65.130/ArticleController/queryQiuShiBaiKeArticles?page=20", parameters: nil, progress: nil, success: { (task, obj) in
            let dic:[String:Any?] = obj as! [String:Any?]
            let code: Int = dic["code"] as! Int
            if code == 200 {//请求成功
                let array:[[String:Any]] = dic["data"] as! [[String:String]]
                var model_Arr = [Article]()
                for article:[String: Any] in array{
                    //json解析
                    //swift调用pod里的swift库 import MYToolKit
                    let model: Article? = try? JSONModel.cwn_makeModel(Article.self , jsonDic: article, hintDic: [
                        "Author":"author",
                    ])
                    

                    if model != nil {
                        model_Arr.append(model!)
                    }
                }
                self.data = model_Arr
                completion(nil)
            }
        }) { (task, error) in
            print(error.localizedDescription)
        }
    }
    
    //MARK: - UITableViewDatasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //1.cell获取(swift调pod里的oc文件)
        let cell: QiuShiBaiKeCellTableViewCell = QiuShiBaiKeCellTableViewCell.getFromXib(with: tableView, indexPath: indexPath) as! QiuShiBaiKeCellTableViewCell;
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        //2.cell赋值
        let article = self.data[indexPath.row]
        cell.headerImage.sd_setImage(with: URL.init(string: article.imgUrl), completed: nil)
        cell.name.text = article.Author
        cell.content.text = article.content.trimmingCharacters(in: CharacterSet.init(charactersIn: "\n"))
        cell.thumb.sd_setImage(with: NSURL.init(string: article.thumb)! as URL, completed: nil)
        cell.thumbHeight.constant = article.thumb.count == 0 ? 0 : 154.5
        return cell
    }

    //MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    
    //MARK: - Others
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

