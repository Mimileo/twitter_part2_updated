//
//  HomeTableViewController.swift
//  Twitter
//
//  Created by Mireya Leon on 9/17/20.
//  Copyright © 2020 Dan. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {

    var tweetArray = [NSDictionary]()
    var numberOfTweets: Int!
    //let timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(loadTweets), userInfo: nil, repeats: true)

    let myRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        // when view loads, load tweets
        
        //self.tableView.estimatedRowHeight = 200;
        //self.tableView.rowHeight = UITableView.automaticDimension;
        
        myRefreshControl.addTarget(self, action: #selector(loadTweets), for: .valueChanged)
        //Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(loadTweets), userInfo: nil, repeats: true)
        self.tableView.refreshControl = myRefreshControl
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 190
       
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.loadTweets()
    }
    
    @objc func loadTweets() {
        numberOfTweets = 20
        
        let myUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let myParams = ["count" : numberOfTweets]
        
        TwitterAPICaller.client?.getDictionariesRequest(url: myUrl, parameters: myParams, success: { (tweets: [NSDictionary]) in
            
            // clean list, then repopulate
            self.tweetArray.removeAll()
            // print(tweets)
            for tweet in tweets {
                //print(tweet["text"]!)
                self.tweetArray.append(tweet)
            }
            
            // update table with new data
            self.tableView.reloadData()
            // stop animating once new data loaded
            self.refreshControl?.endRefreshing()
            
        }, failure: { (Error) in
            print(Error.localizedDescription)
            print("Could not retrieve tweets!")
        })
        
    }
    
    func loadMoreTweets() {
        let myUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        
        numberOfTweets = numberOfTweets + 20
        let myParams = ["count": numberOfTweets]

        TwitterAPICaller.client?.getDictionariesRequest(url: myUrl, parameters: myParams, success: { (tweets: [NSDictionary]) in
            
            // clean list, then repopulate
            self.tweetArray.removeAll()
            // print(tweets)
            for tweet in tweets {
                //print(tweet["text"]!)
                self.tweetArray.append(tweet)
            }
            
            // update table with new data
            self.tableView.reloadData()
        }, failure: { (Error) in
            print(Error.localizedDescription)
            print("Could not retrieve tweets!")
        })
    }
    
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // when user gets to end of page
        if indexPath.row + 1 == tweetArray.count {
            // load more tweets
            loadMoreTweets()
        }
    }
    
    

    @IBAction func onLogout(_ sender: Any) {
        TwitterAPICaller.client?.logout()
        self.dismiss(animated: true, completion: nil)
        // set log in to false upon log out
        UserDefaults.standard.set(false, forKey: "userLoggedIn")
    }
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell" , for: indexPath) as! TweetCellTableViewCell
        
        let user =  tweetArray[indexPath.row]["user"] as! NSDictionary
        if (tweetArray[indexPath.row].value(forKey: "entities") != nil) {
            let tweetMedia = tweetArray[indexPath.row]["entities"] as! NSDictionary
            //print(tweetMedia)
            if (tweetMedia.value(forKey: "media") != nil) {
                let media = tweetMedia["media"] as! NSArray
                let mediaDictionary = media[0] as! NSDictionary
                print(mediaDictionary["media_url_https"]!)
                let tweetImageValue = mediaDictionary["media_url_https"] as? String
                
                let tweetImageUrl = URL(string: tweetImageValue!)
                let data = try? Data(contentsOf: tweetImageUrl!)
                       
                if let imageData = data {
                           cell.tweetImage.image = UIImage(data: imageData)
                } else {
                    cell.tweetImage.isHidden = true
                }
                
            }
                   //let mediaArray = tweetMedia.contains(where: "") //as? NSArray
                   /*if (tweetMedia.keys.contains("media_url_https")) {
                       let tweetImage = tweetMedia["media_url_https"] as! String
                       print(tweetMedia.keys.contains("media_url_https"))
                       print(tweetImage)
                   }*/
        } else {
            print("false")
        }
       
        cell.userNameLabel.text = user["name"] as? String
        cell.tweetContent.text = tweetArray[indexPath.row]["text"] as? String
        
        //set the image
        cell.profileImageView.layer.borderWidth = 1.0
        cell.profileImageView.layer.masksToBounds = false
        //cell.profileImageView.bounds.size = CGSize(width: 100, height: 100)
        cell.profileImageView.layer.borderColor = UIColor.white.cgColor
        cell.profileImageView.layer.cornerRadius = cell.profileImageView.frame.size.width / 2
            //cell.profileImageView.frame.size.width / 2

        cell.profileImageView.clipsToBounds = true
        
        tableView.deselectRow(at: indexPath, animated: true)
        let profileImageurl = (user["profile_image_url_https"] as? String)!
        let start = profileImageurl.startIndex
        let end = profileImageurl.index(profileImageurl.endIndex, offsetBy: -10)
        let format = profileImageurl.suffix(3)
        let baseprofile = profileImageurl[start ..< end] + "bigger." + String(format)

        
        let imageUrl = URL(string: String(baseprofile))
        let data = try? Data(contentsOf: imageUrl!)
        
        if let imageData = data {
            cell.profileImageView.image = UIImage(data: imageData)
        }
        cell.setFavorited(tweetArray[indexPath.row]["favorited"] as! Bool)
        cell.tweetId = tweetArray[indexPath.row]["id"] as! Int
        cell.setRetweeted(tweetArray[indexPath.row]["retweeted"] as! Bool)
        //cell.isSelected = false
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweetArray.count
    }
    
   

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
