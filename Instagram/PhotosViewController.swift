//
//  PhotosViewController.swift
//  Instagram
//
//  Created by Dam Vu Duy on 3/9/16.
//  Copyright © 2016 dotRStudio. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController {
  var mediaData:NSDictionary?

    override func viewDidLoad() {
        super.viewDidLoad()
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
            }
          }
      });
      task.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

