//
//  PhotoDetailsViewController.swift
//  Instagram
//
//  Created by Liem Ly Quan on 3/9/16.
//  Copyright © 2016 dotRStudio. All rights reserved.
//

import UIKit
import AFNetworking

class PhotoDetailsViewController: UIViewController {
  @IBOutlet weak var photoDetailsView: UIImageView!
  
  var url:NSURL?


    override func viewDidLoad() {
        super.viewDidLoad()
        photoDetailsView.setImageWithURL(url!)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  

}
