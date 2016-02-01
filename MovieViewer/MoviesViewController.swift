//
//  MovieViewController.swift
//  MovieViewer
//
//  Created by Ali Hadwan on 1/22/16.
//  Copyright © 2016 Ali Hadwan. All rights reserved.
//

import UIKit
import AFNetworking
import BXProgressHUD


class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate{
    
    
    @IBOutlet weak var networkErrorLabel: UILabel!
    @IBOutlet weak var networkErrorView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var movies: [NSDictionary]?
    let refreshControl = UIRefreshControl()
    var movieData: [NSDictionary]!
    var endpoint: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        networkErrorView.hidden = true
        networkErrorLabel.hidden = true
        
        
        refreshControl.backgroundColor = UIColor.blackColor()
        refreshControl.tintColor = UIColor.whiteColor()
        
        
        searchBar.delegate = self
        
        
        // Initialize a UIRefreshControl
        //let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        
        
        tableView.dataSource = self
        tableView.delegate = self
        movieData = movies
        
        networkRequest()
                // Do any additional setup after loading the view.
        
        switch tabBarController?.selectedIndex{
        case 0?:
            navigationItem.title = "Now Playing"
            
        case 1?:
             navigationItem.title = "Top Rated"
        case 2?:
            navigationItem.title = "Upcoming"
        default: break
        }
        
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
        self.movieData = self.movies
        self.tableView.reloadData()
        //self.collectionView.reloadData()
        
    }
    
    var targetView: UIView {
        
        return self.view
        
    }
    
    func networkRequest(){
        
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string: "https://api.themoviedb.org/3/movie/\(endpoint)?api_key=\(apiKey)")
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate: nil,
            delegateQueue: NSOperationQueue.mainQueue()
        )
        
        BXProgressHUD.showHUDAddedTo(targetView).hide(afterDelay: 1)
        
        let task: NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            print("response: \(responseDictionary)")
                            
                            self.movies = responseDictionary["results"] as? [NSDictionary]
                            self.movieData = self.movies
                            self.tableView.reloadData()
                            self.refreshControl.endRefreshing()
                            
                    }
                    
                    
                }
        })
        task.resume()
        
//        if Reachability.isConnectedToNetwork() == true {
//            
//            print("Network OK")
//        }
//        else{
//            print("No Network Connection")
//            networkErrorView.hidden = false
//            BXProgressHUD.hideHUDForView(self.view, animated: true)
//            searchBar.hidden = true
//            networkErrorLabel.hidden = false
//            
//        }
    
    }
    
    // network alert
    
    
    
    
    @IBAction func tap(sender: AnyObject) {
        
        view.endEditing(true)
    }
    
    // Makes a network request to get updated data
    // Updates the tableView with the new data
    // Hides the RefreshControl
    func refreshControlAction(refreshControl: UIRefreshControl) {
        
        networkRequest()
        
    }
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        movieData = searchText.isEmpty ? movies : movies!.filter({ (movie: NSDictionary) -> Bool in
            return (movie["title"] as! String).rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil
        })
        self.tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        view.endEditing(true)
    }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        if let movieData = movieData{
            return movieData.count
        }else{
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCell
        //let movie = movies![indexPath.row]
        let movie = movieData![indexPath.row]
        let title = movie ["title"] as! String
        let overview = movie ["overview"] as! String
        
        cell.titleLabel!.text = title
        //cell.overviewLabel.text = overview
        
        
        let baseUrl = "http://image.tmdb.org/t/p/w500"
        
        
        
        if let posterpath = movie ["poster_path"] as? String{
            let imageUrl = NSURL(string: baseUrl + posterpath)
            
            cell.posterView.setImageWithURL(imageUrl!)
        }
        
        //print("(indexPath.row)")
        return cell
        
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPathForCell(cell)
        let movie = movies![indexPath!.row]
        let detailViewController = segue.destinationViewController as! DetailViewController
        detailViewController.movie = movie
        print("Ali")
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    
}