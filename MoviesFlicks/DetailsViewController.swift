//
//  DetailsViewController.swift
//  MoviesFlicks
//
//  Created by Raghav Nyati on 9/16/17.
//  Copyright © 2017 Raghav Nyati. All rights reserved.
//

import UIKit
import AFNetworking

class DetailsViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    var selectedMovie: MovieInfo!
    
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: infoView.frame.origin.y + infoView.frame.size.height)
        overviewLabel.text = selectedMovie.overview
        overviewLabel.sizeToFit()
        titleLabel.text = selectedMovie.title
        
        self.title = selectedMovie.title
        //self.navigationController?.title = selectedMovie.title
        let baseUrl = "http://image.tmdb.org/t/p/original"
        
        if let posterPath = selectedMovie.posterPath{
            let imageUrl = NSURL(string: baseUrl + posterPath)
            posterImageView.setImageWith(imageUrl! as URL)
        }else{
            posterImageView.image = nil
        }
        
        
        //print(selectedMovie.overview)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
