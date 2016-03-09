//
//  PhotosViewController.swift
//  Instagram
//
//  Created by Dam Vu Duy on 3/9/16.
//  Copyright © 2016 dotRStudio. All rights reserved.
//

import UIKit
import AFNetworking

class PhotosViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  var mediaData:NSDictionary?
  
  @IBOutlet weak var mainTableView: UITableView!
  override func viewDidLoad() {
    super.viewDidLoad()
    
    mainTableView.delegate = self
    mainTableView.dataSource = self
    
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
              NSLog("response: \(responseDictionary)")
              self.mainTableView.reloadData()
          }
        }
    });
    task.resume()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if let data = mediaData {
      return (data["data"]?.count)!
    }
    return 0
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("PhotoCell", forIndexPath: indexPath) as! PhotoCellController
    
    let photoUrl = mediaData!["data"]?[indexPath.row]["images"]!!["standard_resolution"]!!["url"] as! String
    
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
  
  
  
}

