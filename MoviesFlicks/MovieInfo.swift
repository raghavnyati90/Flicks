//
//  MovieInfo.swift
//  MoviesFlicks
//
//  Created by Raghav Nyati on 9/16/17.
//  Copyright © 2017 Raghav Nyati. All rights reserved.
//

import Foundation

class MovieInfo{
    
    var title: String?
    var posterPath: String?
    var id: Int?
    var voteAverage: Float?
    var voteCount: Int?
    var overview: String?
    var adult: Bool?
    var releaseDate: String?
    var backdropPath: String?
    
    init(id: Int?, title: String?, posterPath: String?, voteAverage: Float?, voteCount: Int?, overview: String?, adult: Bool?, releaseDate: String?, backdropPath: String?){
        self.id = id
        self.title = title
        self.posterPath = posterPath
        self.voteAverage = voteAverage
        self.voteCount = voteCount
        self.overview = overview
        self.adult = adult
        self.releaseDate = releaseDate
        self.backdropPath = backdropPath
    }
}
