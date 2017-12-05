//
//  Purse.swift
//  SampleCollectionView
//
//  Created by 松山友也 on 2017/12/05.
//  Copyright © 2017年 Tomoya Matsuyama. All rights reserved.
//

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

struct UserData {
    var githubLists: [String] = []
    var imageLists: [URL] = []
    var searchText: [String] = []
}

class Purse{
    static func getUser(userName: String) -> UserData {
        var userData: UserData = UserData()
        guard
            let encodedUsername = userName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let url = URL(string: "https://qiita.com/api/v2/users/\(encodedUsername)")
            else { return userData }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            do {
                let object = try JSONDecoder().decode(User.self, from: data)
                guard let githubName = object.github_login_name else { return }
                guard let imageData = object.profile_image_url else { return }
                userData.githubLists.append("ID: " + githubName)
                userData.searchText.append(userName)
                userData.imageLists.append(imageData)
            } catch let e {
                print(e)
            }
        }
        task.resume()
        Thread.sleep(forTimeInterval: 0.5)
        return userData
    }
}
