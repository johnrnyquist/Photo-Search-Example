//
//  ViewController.swift
//  Photo Search Example
//
//  Created by John Nyquist on 11/17/17.
//  Copyright © 2017 Nyquist Art + Logic LLC. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    fileprivate func searchFlickrBy(_ searchString:String) {
        // Do any additional setup after loading the view, typically from a nib.
        let manager = AFHTTPSessionManager()
        
        let searchParameters:[String:Any] = ["method": "flickr.photos.search",
                                             "api_key": "713bc93d1d496ba2746a3b28c96e3892",
                                             "format": "json",
                                             "nojsoncallback": 1,
                                             "text": searchString,
                                             "extras": "url_m",
                                             "per_page": 5]
        
        manager.get("https://api.flickr.com/services/rest/",
                    parameters: searchParameters,
                    progress: nil,
                    success: { (operation: URLSessionDataTask, responseObject:Any?) in
                        if let responseObject = responseObject as? [String: AnyObject] { //unwrap the optional
                            print(responseObject)
                            if let photos = responseObject["photos"] as? [String: AnyObject] { //dictionary
                                if let photoArray = photos["photo"] as? [[String: AnyObject]] { //array of dictionaries
                                    self.scrollView.contentSize = CGSize(width: 320, height: 320 * CGFloat(photoArray.count))
                                    
                                    for (i, photoDictionary) in photoArray.enumerated() {                             //1
                                        
                                        if let imageURLString = photoDictionary["url_m"] as? String {               //2
                                            
                                            let imageData = NSData(contentsOf: URL(string: imageURLString)!)        //2
                                            
                                            if let imageDataUnwrapped = imageData {                                     //3
                                                
                                                let imageView = UIImageView(frame: CGRect(x:0, y:320*CGFloat(i), width:320, height:320))     //#1
                                                if let url = URL(string: imageURLString) {
                                                    imageView.setImageWith(url)                                             //#2
                                                    self.scrollView.addSubview(imageView)
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
        }) { (operation:URLSessionDataTask?, error:Error) in
            print("Error: " + error.localizedDescription)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchFlickrBy("dogs")
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        for subview in self.scrollView.subviews {
            subview.removeFromSuperview()
        }
        searchBar.resignFirstResponder()
        if let searchText = searchBar.text {
            searchFlickrBy(searchText)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

