//
//  ViewController.swift
//  Demo
//
//  Created by mac on 2018/11/19.
//  Copyright © 2018年 mac. All rights reserved.
//

import UIKit

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
        let button: UIButton = UIButton.init()
        button.setTitleColor(UIColor.red, for: UIControlState.normal)
        button.setTitle("哈哈哈", for: UIControlState.normal)
        self.view.addSubview(button)
        button.cwn_makeConstraints { (maker: UIView!) in
            maker.centerXtoSuper()(0)?.centerYtoSuper()(0)
        }
    }
    func configTable(){
        self.table.dataSource = self
        self.table.delegate = self
        self.view.addSubview(self.table)
        
        self.table.cwn_makeConstraints { (maker: UIView!) in
            maker.edgeInsetsToSuper()(UIEdgeInsets.zero)
        }
    }
    
    
    
    //MARK: - 数据请求
    func getDataFromServer(completion:@escaping((_ error: Error?)->(Void))){
        let manager = AFHTTPSessionManager.init(sessionConfiguration: URLSessionConfiguration.default)
        manager.responseSerializer.acceptableContentTypes = Set.init(arrayLiteral: "text/html")
        manager.get("http://localhost/ArticleController/queryQiuShiBaiKeArticles", parameters: nil, progress: nil, success: { (task, obj) in
            let dic:[String:Any?] = obj as! [String:Any?]
            let code: Int = dic["code"] as! Int
            if code == 200 {//请求成功
                let array:[[String:String]] = dic["data"] as! [[String:String]]
                var model_Arr = [Article]()
                for article:[String: String] in array{
                    if let data = try?JSONSerialization.data(withJSONObject: article, options: JSONSerialization.WritingOptions.prettyPrinted) {
                        let model: Article? = try? JSONDecoder.init().decode(Article.self, from: data)
                        
                        //json解析
                        let result: Article? = try! JSONModel.cwn_makModel(Article.self , jsonDic: article, hintDic: nil) as? Article
                        print(result ?? "")
                            
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
        //1.cell获取
        let cell =  UITableViewCell.init(fromClassWith: table, indexPath: indexPath)
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        
        //2.cell赋值
        let article = self.data[indexPath.row]
        cell?.textLabel?.text = article.Author
        return cell!
    }

    
    
    //MARK: - Others
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

