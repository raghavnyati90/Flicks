//
//  TabViewController.swift
//  MoviesFlicks
//
//  Created by Raghav Nyati on 9/16/17.
//  Copyright © 2017 Raghav Nyati. All rights reserved.
//

import UIKit
import MBProgressHUD

class TabViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate{

    @IBOutlet weak var networkError: UIView!
    //@IBOutlet weak var networkError: UIView!
    
    var movies: [NSDictionary]?
    var allMovies: [NSDictionary]?
    let searchBar = UISearchBar()
    var moviesArray: [MovieInfo] = []
    var selectedMovie: MovieInfo!
    var endPoint = "now_playing"
    var navBarTitle = "Now Playing"
    
    var refreshControl: UIRefreshControl?;
    var refreshing = false;
    
    let segmentedControl = UISegmentedControl(items: ["Grid", "Table"])
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        segmentedControl.setImage(UIImage(named: "Icon-Table"), forSegmentAt: 0)
        segmentedControl.setImage(UIImage(named: "Icon-Collection"), forSegmentAt: 1)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.sizeToFit()
        let segmentedButton = UIBarButtonItem(customView: segmentedControl)
        
        //let dummyButton = UIBarButtonItem(customView: searchBar)
        //searchBar.sizeToFit()
        //navigationItem.rightBarButtonItems = [dummyButton]
        navigationItem.leftBarButtonItem = segmentedButton
        searchBar.sizeToFit()
        searchBar.placeholder = "Search \(navBarTitle) movies"
        self.navigationItem.titleView = searchBar

        searchBar.delegate = self
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        loadData()
        
        refreshControl = UIRefreshControl();
        refreshControl?.addTarget(self, action: #selector(TabViewController.refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl!, at: 0);
    }
    
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        refreshing = true;
        self.refreshControl = refreshControl
        loadStarted()
        loadData()
    }

    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        let cancelSearchBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(TabViewController.cancelBarButtonItemClicked))
        self.navigationItem.setRightBarButton(cancelSearchBarButtonItem, animated: true)
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        (movies, searchBar.text) = (allMovies, "")
        
        //closes the keyboard
        searchBar.resignFirstResponder()
        
        //reload table view
        tableView.reloadData();
        
        // remove the cancel button
        self.navigationItem.setRightBarButton(nil, animated: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        movies = searchText.isEmpty ? allMovies: allMovies?.filter({(data: NSDictionary) -> Bool in
            let left = data["title"]! as! String
            return left.range(of: searchText, options: .caseInsensitive) != nil
        })
        tableView.reloadData()
    }
    
    func cancelBarButtonItemClicked() {
        self.searchBarCancelButtonClicked(self.searchBar)
    }
 
    func loadData(){
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = URL(string:"https://api.themoviedb.org/3/movie/\(endPoint)?api_key=\(apiKey)")
        let request = URLRequest(url: url!,
                                 cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData,
                                 timeoutInterval: 10)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        
        // Display HUD right before the request is made
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let task : URLSessionDataTask = session.dataTask(
            with: request as URLRequest,
            completionHandler: { (data, response, error) in
                if error != nil {
                    self.loadComplete(false)
                    self.showNetworkError()
                }else if let data = data {
                    if let responseDictionary = try! JSONSerialization.jsonObject(
                        with: data, options:[]) as? NSDictionary {
                        
                        print("responseDictionary: \(responseDictionary)")
                        
                        self.movies = responseDictionary["results"] as? [NSDictionary]
                        self.allMovies = self.movies
                        //?.append(responseFieldDictionary)
                        
                        //DispatchQueue.main.async {
                        self.tableView.reloadData()
                        //}
                        // This is where you will store the returned array of posts in your posts property
                        // self.feeds = responseFieldDictionary["posts"] as! [NSDictionary]
                    }
                }
            MBProgressHUD.hide(for: self.view, animated: true)
        });
        task.resume()
    }
    
    func loadStarted() {
        //progressBar.progress = 0.0;
        //time = 0.0;
        hideNetworkError();
    }
    
    func loadComplete(_ showContent : Bool? = true) {
        if(showContent != false) {
            self.tableView.isHidden = false;
            UIView.animate(withDuration: 1.0, animations: {
                self.tableView.alpha = 1.0;
            });
            if(refreshing == true) {
                refreshing = false;
                self.refreshControl!.endRefreshing();
            }
        } else {
        }
    }
    
    func showNetworkError() {
        self.networkError.alpha = 0.0;
        self.networkError.isHidden = false;
        UIView.animate(withDuration: 0.5, animations: {
            self.networkError.alpha = 1.0;
        });
    }
    
    func hideNetworkError() {
        if(self.networkError.isHidden == false) {
            UIView.animate(withDuration: 0.5, animations: {
                self.networkError.alpha = 0.0;
            });
            runAfterDelay(0.5, block: {
                self.networkError.isHidden = true;
            });
        }
    }
    
    func runAfterDelay(_ delay: TimeInterval, block: @escaping ()->()) {
        let time = DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: time, execute: block)
    }
    
    @IBAction func tapOnNetworkError(_ sender: Any) {
        hideNetworkError()
        loadStarted()
        loadData()
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
        
        cell.selectionStyle = .none
        let movie = movies![indexPath.row]
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        
        let baseUrl = "http://image.tmdb.org/t/p/w500"
        
        if let posterPath = movie["poster_path"] as? String{
            let imageUrl = NSURL(string: baseUrl + posterPath)
            //NSURLRequest(url: <#T##URL#>)
            let imageRequest = NSURLRequest(url: imageUrl! as URL)
            cell.posterView.setImageWith(imageRequest as URLRequest, placeholderImage: nil,
                                         success: {(imageRequest, imageResponse, image) -> Void in
                                            
                                            // imageResponse will be nil if the image is cached
                                            if imageResponse != nil {
                                                print("Image was NOT cached, fade in image")
                                                cell.posterView.alpha = 0.0
                                                cell.posterView.image = image
                                                UIView.animate(withDuration: 0.3, animations: { () -> Void in
                                                    cell.posterView.alpha = 1.0
                                                })
                                            } else {
                                                print("Image was cached so just update the image")
                                                cell.posterView.image = image
                                            }},
                                         failure: {(imageRequest, imageResponse, error) -> Void in
                                            // do something for the failure condition
            })
            cell.posterView.setImageWith(imageUrl! as URL)
        }else{
            cell.posterView.image = nil
        }
        
        cell.titleLabel.text = title
        cell.overviewLabel.text = overview
        
        let movieInfo = MovieInfo(id: movie["id"] as! Int!, title: movie["title"] as! String!, posterPath: movie["poster_path"] as! String!, voteAverage: movie["vote_average"] as! Float!, voteCount: movie["vote_count"] as! Int!, overview: movie["overview"] as! String!, adult: movie["adult"] as! Bool!, releaseDate: movie["release_date"] as! String!, backdropPath: movie["backdrop_path"] as! String!)
        
        moviesArray.append(movieInfo)
        
        // Use a red color when the user selects the cell
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.red
        cell.selectedBackgroundView = backgroundView
        
        return cell
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedMovie = moviesArray[indexPath.row]
        performSegue(withIdentifier: "NowPlayingSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "NowPlayingSegue"{
            let destinationViewController = segue.destination as! DetailsViewController
            destinationViewController.selectedMovie = selectedMovie
        }
    }

}
