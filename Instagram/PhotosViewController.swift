//
//  PhotosViewController.swift
//  Instagram
//
//  Created by Dam Vu Duy on 3/9/16.
//  Copyright © 2016 dotRStudio. All rights reserved.
//

import UIKit
import AFNetworking


class PhotosViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {
  var mediaData:NSDictionary?
  var isMoreDataLoading = false
    
    
  @IBOutlet weak var mainTableView: UITableView!
  override func viewDidLoad() {
    super.viewDidLoad()
    
    mainTableView.delegate = self
    mainTableView.dataSource = self
    
    fetchData()
    
    let refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged)
    mainTableView.insertSubview(refreshControl, atIndex: 0)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func fetchData() {
    // Do any additional setup after loading the view, typically from a nib.
    let clientId = "e05c462ebd86446ea48a5af73769b602"
    let url = NSURL(string:"https://api.instagram.com/v1/media/popular?client_id=\(clientId)")
    let request = NSURLRequest(URL: url!)
    let session = NSURLSession(
      configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
      delegate:nil,
      delegateQueue:NSOperationQueue.mainQueue()
    )
    
    let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
      completionHandler: { (dataOrNil, response, error) in
        if let data = dataOrNil {
          if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
            data, options:[]) as? NSDictionary {
              self.mediaData = responseDictionary
              self.mainTableView.reloadData()
          }
        }
    });
    task.resume()
    
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//    if let data = mediaData {
//      return (data["data"]?.count)!
//    }
//    return 0
    return 1
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("PhotoCell", forIndexPath: indexPath) as! PhotoCellController
    
    let photoUrl = mediaData!["data"]?[indexPath.section]["images"]!!["standard_resolution"]!!["url"] as! String
    
    cell.photoView.setImageWithURL(NSURL(string: photoUrl)!)
    return cell
  }
  
  
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    let vc = segue.destinationViewController as! PhotoDetailsViewController
    let indexPath = mainTableView.indexPathForCell(sender as! UITableViewCell)
    let urlString = mediaData!["data"]?[indexPath!.row]["images"]!!["standard_resolution"]!!["url"] as! String
    vc.url = NSURL(string: urlString)
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    mainTableView.deselectRowAtIndexPath(indexPath, animated: true)
  }
  
  func refreshControlAction(refreshControl: UIRefreshControl) {
    let clientId = "e05c462ebd86446ea48a5af73769b602"
    let url = NSURL(string:"https://api.instagram.com/v1/media/popular?client_id=\(clientId)")
    let request = NSURLRequest(URL: url!)
    let session = NSURLSession(
      configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
      delegate:nil,
      delegateQueue:NSOperationQueue.mainQueue()
    )
    
    let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
      completionHandler: { (dataOrNil, response, error) in
        if let data = dataOrNil {
          if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
            data, options:[]) as? NSDictionary {
              self.mediaData = responseDictionary
              self.mainTableView.reloadData()
              refreshControl.endRefreshing()
          }
        }
    });
    task.resume()
    
  }
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if let data = mediaData {
          return (data["data"]?.count)!
        }
        return 0
  }
  
  func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let headerView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
    headerView.backgroundColor = UIColor(white: 1, alpha: 0.9)
    
    let profileView = UIImageView(frame: CGRect(x: 10, y: 10, width: 30, height: 30))
    profileView.clipsToBounds = true
    profileView.layer.cornerRadius = 15
    profileView.layer.borderColor = UIColor(white: 0.7, alpha: 0.8).CGColor
    profileView.layer.borderWidth = 1
    let profileUrlString = mediaData!["data"]?[section]["user"]!!["profile_picture"] as! String
    profileView.setImageWithURL(NSURL(string: profileUrlString)!)
    headerView.addSubview(profileView)
    
    let usernameLabel = UILabel(frame: CGRect(x: 50, y: 10, width: 200, height: 30))
    usernameLabel.text = mediaData!["data"]?[section]["user"]!!["username"] as! String
    headerView.addSubview(usernameLabel)
    
    return headerView
  }
  
  func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return CGFloat(50)
  }

    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = mainTableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - mainTableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && mainTableView.dragging) {
                isMoreDataLoading = true
                
                loadMoreData()
            }
        }
    }
    
    
    func loadMoreData() {
        
        let tableFooterView: UIView = UIView(frame: CGRectMake(0, 0, 320, 50))
        let loadingView: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        loadingView.startAnimating()
        loadingView.center = tableFooterView.center
        tableFooterView.addSubview(loadingView)
        self.mainTableView.tableFooterView = tableFooterView
        
        let clientId = "e05c462ebd86446ea48a5af73769b602"
        let url = NSURL(string:"https://api.instagram.com/v1/media/popular?client_id=\(clientId)")
        let request = NSURLRequest(URL: url!)
        
        // Configure session so that completion handler is executed on main UI thread
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (data, response, error) in
                
                // Update flag
                self.isMoreDataLoading = false
                
                if let data = data {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            
                            let temp2 = NSMutableDictionary()
                            
                            temp2.setValuesForKeysWithDictionary(self.mediaData as! [String : AnyObject])
                            
                            temp2.setValuesForKeysWithDictionary(responseDictionary as! [String : AnyObject])
                    
                            self.mediaData = temp2
                            
                    }
                }
                // ... Use the new data to update the data source ...
                
                // Reload the tableView now that there is new data
                self.mainTableView.reloadData()
                loadingView.stopAnimating()
        });
        task.resume()
    }
  
}

