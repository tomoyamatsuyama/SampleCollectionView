//
//  ViewController.swift
//  SampleCollectionView
//
//  Created by 松山友也 on 2017/11/14.
//  Copyright © 2017年 Tomoya Matsuyama. All rights reserved.
//

import UIKit
import Foundation

struct User: Codable{
    var description: String?
    var facebook_id: String?
    var followees_count: Int?
    var followers_count: Int?
    var github_login_name: String?
    var id: String?
    var items_count: Int?
    var linkedin_id: String?
    var location: String?
    var name: String?
    var organization: String?
    var permanent_id: Int?
    var profile_image_url: URL?
    var twitter_screen_name: String?
    var website_url: String?
}

class ViewController: UIViewController, UICollectionViewDataSource,UICollectionViewDelegate , UISearchBarDelegate {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var githubLists: [String] = []
    var imageLists: [Data] = []
    var searchText: [String] = []
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return githubLists.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TestCell", for: indexPath) as! TestCollectionViewCell
        cell.testLabel.text = githubLists[indexPath.row]
        let imgData = imageLists[indexPath.row]
        let img = UIImage(data: imgData)
        cell.imgView.image = img
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectCell: String = searchText[indexPath.row]
        self.performSegue(withIdentifier: "NextToWeb", sender: selectCell)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let WebViewController = segue.destination as! WebViewController
        WebViewController.url = sender as! String
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        searchBar.enablesReturnKeyAutomatically = false
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        let userName = searchBar.text!
        
        guard
            let encodedUsername = userName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let url = URL(string: "https://qiita.com/api/v2/users/\(encodedUsername)")
        else { return }
        
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            
            do {
                let object = try JSONDecoder().decode(User.self, from: data)
                
                guard let githubName = object.github_login_name else { return }
                guard let imageData = object.profile_image_url else { return }
                self.githubLists.append("ID: " + githubName)
                DispatchQueue.main.async {
                    self.searchText.append(searchBar.text!)
                }
                
                do {
                    let imgData = try NSData(contentsOf: imageData, options: NSData.ReadingOptions.mappedIfSafe)
                    self.imageLists.append(imgData as Data)
                } catch {
                    print("Error: can't create image.")
                }
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
                
            } catch let e {
                print(e)
            }
        }
        task.resume()
        self.collectionView.reloadData()
    }


}

