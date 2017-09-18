//
//  MoviesViewController.swift
//  MoviesFlicks
//
//  Created by Raghav Nyati on 9/16/17.
//  Copyright © 2017 Raghav Nyati. All rights reserved.
//

import UIKit
import AFNetworking

class MoviesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    var movies: [NSDictionary]?
    let searchBar = UISearchBar()
    //@IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.sizeToFit()
        searchBar.placeholder = "Search Now Playing movies"
        self.navigationItem.titleView = searchBar
        
        searchBar.delegate = self
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        loadData()
    }

    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        let cancelSearchBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(TabViewController.cancelBarButtonItemClicked))
        self.navigationItem.setRightBarButton(cancelSearchBarButtonItem, animated: true)
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        // closes the keyboard
        searchBar.resignFirstResponder()
        
        // If you are using a search controller
        // self.searchDisplayControllerCustom.setActive(false, animated: true)
        
        // remove the cancel button
        self.navigationItem.setRightBarButton(nil, animated: true)
    }
    
    func cancelBarButtonItemClicked() {
        self.searchBarCancelButtonClicked(self.searchBar)
    }
    
    func loadData(){
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = URL(string:"https://api.themoviedb.org/3/movie/top_rated?api_key=\(apiKey)")
        let request = URLRequest(url: url!)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        
        let task : URLSessionDataTask = session.dataTask(
            with: request as URLRequest,
            completionHandler: { (data, response, error) in
                if let data = data {
                    if let responseDictionary = try! JSONSerialization.jsonObject(
                        with: data, options:[]) as? NSDictionary {
                        
                        print("responseDictionary: \(responseDictionary)")
                        
                        self.movies = responseDictionary["results"] as? [NSDictionary]
                        //?.append(responseFieldDictionary)
                        
                        //DispatchQueue.main.async {
                            self.tableView.reloadData()
                        //}
                        // This is where you will store the returned array of posts in your posts property
                        // self.feeds = responseFieldDictionary["posts"] as! [NSDictionary]
                    }
                }
        });
        task.resume()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if let movies = movies{
            return movies.count
        }else{
            return 0
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MovieCell
        
        let movie = movies![indexPath.row]
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        
        let baseUrl = "http://image.tmdb.org/t/p/w500"
        let posterPath = movie["poster_path"] as! String
        
        let imageUrl = NSURL(string: baseUrl + posterPath)
        cell.posterView.setImageWith(imageUrl! as URL)
        
        cell.titleLabel.text = title
        cell.overviewLabel.text = overview
        
        //cell.textLabel?.text = title
        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
