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
    var data: [String]! = {//数据
        var array = [String].init()
        for  i in 0...100 {
            array.append("哈哈哈\(i)")
        }
        return array
    }()

    
    //MARK: - 页面生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configTable()
        self.configButton()
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
    
    
    //MARK: - UITableViewDatasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //1.cell获取
        let cell =  UITableViewCell.init(fromClassWith: table, indexPath: indexPath)
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        
        //2.cell赋值
        let string = self.data[indexPath.row]
        cell?.textLabel?.text = string
        return cell!
    }

    
    
    //MARK: - Others
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

