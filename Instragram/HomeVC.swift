//
//  HomeVC.swift
//  Instragram
//
//  Created by 刘铭 on 16/4/29.
//  Copyright © 2016年 极客学院. All rights reserved.
//

import UIKit

class HomeVC: UICollectionViewController {
    
    // refresher variable
    var refresher : UIRefreshControl!
    
    // size of page
    var page: Int = 10

    var uuidArray = [String]()
    var picArray = [AVFile]()
    
    // default func
    override func viewDidLoad() {
        super.viewDidLoad()

        // background color 
        collectionView?.backgroundColor = .whiteColor()
        
        // title at the top
        self.navigationItem.title = AVUser.currentUser().username.uppercaseString
        
        // pull to refresh
        refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(refresh), forControlEvents: .ValueChanged)
        collectionView?.addSubview(refresher)
        
        // load posts func 
        loadPosts()
    }
    
    // refreshing func 
    func refresh() {
        
        // reload data information
        collectionView?.reloadData()
        
        // stop animating of refresher 
        refresher.endRefreshing()
    }
    
    // load posts func 
    func loadPosts() {
        let query = AVQuery(className: "Posts")
        query.whereKey("username", equalTo: AVUser.currentUser().username)
        query.limit = page
        query.findObjectsInBackgroundWithBlock { (objects:[AnyObject]!, error:NSError!) in
            if error == nil {
                
                // clean up
                self.uuidArray.removeAll(keepCapacity: false)
                self.picArray.removeAll(keepCapacity: false)
                
                // find objects related to our request
                for object in objects {
                    
                    // add found data to arrays
                    self.uuidArray.append(object.valueForKey("uuid") as! String)
                    self.picArray.append(object.valueForKey("pic") as! AVFile)
                }
                
                self.collectionView?.reloadData()
            }else {
                print(error.localizedDescription)
            }
        }
    }

    // MARK: UICollectionViewDataSource
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return picArray.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        // define cell
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! PictureCell
        
        // get picture from the picArray
        picArray[indexPath.row].getDataInBackgroundWithBlock { (data:NSData!, error:NSError!) in
            if error == nil {
                cell.picImg.image = UIImage(data: data)
            }else {
                print(error.localizedDescription)
            }
        }
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        // define header
        let header = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "Header", forIndexPath: indexPath) as! HeaderView
        
        // STEP 1.
        // get users data with connections to collumns of AVUser class
        header.fullnameLbl.text = (AVUser.currentUser()?.objectForKey("fullname") as? String)?.uppercaseString
        header.webTxt.text = AVUser.currentUser().objectForKey("web") as? String
        header.webTxt.sizeToFit()
        header.bioLbl.text = AVUser.currentUser().objectForKey("bio") as? String
        header.bioLbl.sizeToFit()
        header.button.setTitle("编辑个人主页", forState: UIControlState.Normal)
        
        let avaQuery = AVUser.currentUser().objectForKey("ava") as! AVFile
        avaQuery.getDataInBackgroundWithBlock { (data:NSData!, error:NSError!) in
            header.avaImg.image = UIImage(data: data!)
        }
        
        // count total posts
        let posts = AVQuery(className: "posts")
        posts.whereKey("username", equalTo: AVUser.currentUser().username)
        posts.countObjectsInBackgroundWithBlock { (count:Int, error:NSError!) in
            if error == nil {
                header.posts.text = "\(count)"
            }
        }
        
        // count total followers
        let followers = AVQuery(className: "Follow")
        followers.whereKey("following", equalTo: AVUser.currentUser().username)
        followers.countObjectsInBackgroundWithBlock { (count:Int, error:NSError!) in
            if error == nil {
                header.followers.text = "\(count)"
            }
        }
        
        // count total followings
        let followings = AVQuery(className: "Follow")
        followings.whereKey("follower", equalTo: AVUser.currentUser().username)
        followings.countObjectsInBackgroundWithBlock { (count:Int, error:NSError!) in
            if error == nil {
                header.followings.text = "\(count)"
            }
        }
        
        // tap posts
        let postsTap = UITapGestureRecognizer(target: self, action: #selector(postsTapHandler))
        postsTap.numberOfTapsRequired = 1
        
        return header
    }
    
    func postsTapHandler() {
        
    }

    /*
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath)
    
        // Configure the cell
    
        return cell
    }
 */
}
