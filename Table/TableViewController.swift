//
//  TableViewController.swift
//  MovieApp
//
//  Created by 村上拓麻 on 2019/03/01.
//  Copyright © 2019 村上拓麻. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import SwiftyJSON
import AlamofireImage

class TableViewController: UIViewController,UISearchBarDelegate{
    
    private var ActivityIndicator: UIActivityIndicatorView!
    private var articles : [[String:Any?]] = []
    private let error_description = error.responseError             //レスポンスされなかった時のエラー
    private let error_conection = error.conectionError              //接続されなかった時のエラー
    private var count: Int = 0      //格納されたき映画の有無を確かめる変数
    
    
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        searchBar.placeholder = "検索したい映画"
        title = "MovieSearch"

        tableView.register(UINib(nibName: "TableViewMyCell", bundle: nil), forCellReuseIdentifier: "myCell")
        
        
        /*indicatorのコード*/
        ActivityIndicator = UIActivityIndicatorView()
        ActivityIndicator.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        ActivityIndicator.center = self.view.center
        // クルクルをストップした時に非表示する
        ActivityIndicator.hidesWhenStopped = true
        // 色を設定
        ActivityIndicator.style = UIActivityIndicatorView.Style.gray
        //Viewに追加
        self.view.addSubview(ActivityIndicator)
    }

    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)   //ｌキーボード以外を触るとキーボードが閉じる
        count = 0
        if searchBar.text != "" {
            var result = searchBar.text!
            let s = result.remove(characterSet: .whitespaces)
            request(s)
        }else {
            self.alert("入力してください。")
        }
      
    }

   private func request(_ search:String)   {
        ActivityIndicator.startAnimating()      //indicatorスタート

        /*初期化*/
        articles = []
        
        Alamofire.request("https://api.themoviedb.org/3/search/movie?api_key=<<Your APIKey>>&query=\(search)&ja",method: .post, encoding: JSONEncoding.default).responseJSON{ response in
            guard let object = response.result.value else {
                self.alert(self.error_description.error_description!)
                return
            }
            
            let json = JSON(object)
          
            json["results"].forEach{(_,json) in

                let article : [String:Any?] = [
                    "title" : json["title"].string,
                    "image_url" : json["poster_path"].string,
                    "popularity" : json["popularity"].double,
                    "ori_title" : json["original_title"].string
                ]
                if article["title"]! == nil || article["image_url"]! == nil || article["popularity"]! == nil {
                    self.ActivityIndicator.stopAnimating()      //Indicatorストップ
                    return
                }
                self.articles.append(article)
                
            }

            self.count = self.articles.count

            if self.count == 0{
                self.alert("該当しませんでした。")
            }
            self.count = 0
            
            self.tableView.reloadData()
            self.ActivityIndicator.stopAnimating()

        }
    }
    
    private func alert(_ message:String){
        let ac = UIAlertController(title:"⚠️",message:message,preferredStyle:.alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac,animated:true)
    }
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//    }
//
//    override var canBecomeFirstResponder: Bool {
//        return true
//    }
}


extension TableViewController: UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell") as! TableViewMyCell

         count = 0
         count = self.articles.count

        if count == 0{
            alert("該当する映画がありませんでした。")
        }else{
        let article = articles[indexPath.row]
            if let ori_title: String = article["ori_title"]! as? String{
                cell.label?.text = ori_title
            }else{
            
            self.alert(self.error_description.error_description!)
        }
        
        if let url_sourse = article["image_url"] {
            let url = URL(string: "https://image.tmdb.org/t/p/w500\(url_sourse!)")!
        
        
        Alamofire.request(url).responseImage { response in
            if let catPicture = response.result.value {
                cell.imageMovie?.image = catPicture
                }
            }
        }else{
            self.alert(self.error_description.error_description!)
        }
        
        if let popu = article["popularity"] {
            let stardata = popu as! Double
            let star =  round(stardata*10)/10
            switch star {               //評価の星を決める処理
            case 0.0 ..< 0.5:
                cell.popularity?.image = UIImage(named: "0.5Image.png")!
            case 0.5 ..< 1.0:
                cell.popularity?.image = UIImage(named: "1Image.png")!
            case 1.0 ..< 1.5:
                cell.popularity?.image = UIImage(named: "1.5Image.png")!
            case 1.5 ..< 2.0:
                cell.popularity?.image = UIImage(named: "2Image.png")!
            case 2.0 ..< 2.5:
                cell.popularity?.image = UIImage(named: "2.5Image.png")!
            case 2.5 ..< 3.0:
                cell.popularity?.image = UIImage(named: "3Image.png")!
            case 3.0 ..< 3.5:
                cell.popularity?.image = UIImage(named: "3.5Image.png")!
            case 3.5 ..< 4.0:
                cell.popularity?.image = UIImage(named: "4Image.png")!
            case 4.0 ..< 4.5:
                cell.popularity?.image =  UIImage(named: "4.5Image.png")!
            case 4.5 ..< 5.0:
                let imagedata = UIImage(named: "5Image.png")
                cell.popularity?.image = imagedata
            default:
                let imagedata = UIImage(named: "5Image.png")
                cell.popularity?.image = imagedata
            }
            
        }else{
            self.alert(self.error_description.error_description!)

            }
        }
        return cell

    }
}


extension String {
    /// StringからCharacterSetを取り除く
    func remove(characterSet: CharacterSet) -> String {
        return components(separatedBy: characterSet).joined()
    }
    
    /// StringからCharacterSetを抽出する
    func extract(characterSet: CharacterSet) -> String {
        return remove(characterSet: characterSet.inverted)
    }
}
