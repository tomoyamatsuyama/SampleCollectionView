//
//  ViewController.swift
//  SampleCollectionView
//
//  Created by 松山友也 on 2017/11/14.
//  Copyright © 2017年 Tomoya Matsuyama. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController, UISearchBarDelegate {
    @IBOutlet weak private var searchBar: UISearchBar!
    @IBOutlet weak private var collectionView: UICollectionView!
    var userData: UserData = UserData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        searchBar.enablesReturnKeyAutomatically = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    private func imageSet(imageData: URL) -> Data {
        var imgData: Data = Data()
        do {
            imgData = try NSData(contentsOf: imageData, options: NSData.ReadingOptions.mappedIfSafe) as Data
            return imgData
        } catch {
            print("Error: can't create image.")
        }
        return imgData
    }
    
    private func bind(cell: TestCollectionViewCell, index: Int) -> TestCollectionViewCell {
        cell.testLabel.text = userData.githubLists[index]
        let img = UIImage(data: imageSet(imageData: userData.imageLists[index]))
        cell.imgView.image = img
        return cell
    }
    
    private func goToWeb(selectedCell: Int){
        let storyboard: UIStoryboard = UIStoryboard(name: "Web", bundle: Bundle.main)
        let webView: WebViewController = storyboard.instantiateViewController(withIdentifier: "WebView") as! WebViewController
        webView.url = userData.searchText[selectedCell]
        self.navigationController?.pushViewController(webView, animated: true)
    }
    
    internal func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        userData = Purse.getUser(userName: searchBar.text!)
        collectionView.reloadData()
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userData.githubLists.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = bind(cell: collectionView.dequeueReusableCell(withReuseIdentifier: "TestCell", for: indexPath) as! TestCollectionViewCell, index: indexPath.row)
        return cell
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        goToWeb(selectedCell: indexPath.row)
    }
}


