//
//  DetailViewController.swift
//  MovieViewer
//
//  Created by Ali Hadwan on 1/24/16.
//  Copyright © 2016 Ali Hadwan. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var scrrollView: UIScrollView!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var movie: NSDictionary?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      scrrollView.contentSize = CGSize(width: scrrollView.frame.size.width, height: infoView.frame.origin.y + infoView.frame.size.height)
        
        let title = movie!["title"] as? String
        titleLabel.text = title
        
        let overview = movie!["overview"]
        overviewLabel.text = overview as? String
        //titleLabel.sizeToFit()
        overviewLabel.sizeToFit()

        
        
        let baseUrl = "http://image.tmdb.org/t/p/w500"
        
        
        
        if let posterpath = movie! ["poster_path"] as? String{
            let imageUrl = NSURL(string: baseUrl + posterpath)
            
            imageView.setImageWithURL(imageUrl!)
        }
        
        
                print(movie)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
