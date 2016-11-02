//
//  RTNItem.swift
//  ratethisnow
//
//  Created by Keith Elliott on 10/17/16.
//  Copyright © 2016 GittieLabs. All rights reserved.
//

import Foundation
import Messages

struct RTNItem {
    var caption: String?
    var image: UIImage?
    var rating1: Rating?
    var rating2: Rating?
    
    init(){
        self.rating1 = Rating.unrated
        self.rating2 = Rating.unrated
    }
    
    init?(queryItems: [URLQueryItem]) {
        var decodedCaption: String?
        var decodedRating1: Rating?
        var decodedRating2: Rating?
        for queryItem in queryItems {
            guard let value = queryItem.value else { return nil }
            if let rating = Rating(rawValue: value), queryItem.name == "rating1"{
                decodedRating1 = rating
            }
            if let rating = Rating(rawValue: value), queryItem.name == "rating2"{
                decodedRating2 = rating
            }
            if queryItem.name == "caption"{
                decodedCaption = value
            }
        }
        
        guard let image = UIImage(named: "add_rating") else { return nil }
        self.image = image
        self.caption = decodedCaption
        self.rating1 = decodedRating1 ?? Rating.unrated
        self.rating2 = decodedRating2 ?? Rating.unrated
    }
    
    init?(message: MSMessage?){
        guard let url = message?.url else { return nil }
        guard let urlComponents = NSURLComponents(url: url, resolvingAgainstBaseURL: false), let queryItems = urlComponents.queryItems else { return nil }
        
        self.init(queryItems: queryItems)
    }
}


enum Rating: String{
    case unrated
    case _1Star
    case _2Stars
    case _3Stars
    case _4Stars
    case _5Stars
    
    var image: UIImage {
        let name = self.rawValue
        guard let image = UIImage(named: name) else { fatalError("Unable to find rating image: \(name)") }
        return image
    }
    
}

extension Rating: CustomStringConvertible {
    var description: String {
        get {
            switch self {
            case ._1Star:
                return "1 star"
            case ._2Stars:
                return "2 stars"
            case ._3Stars:
                return "3 stars"
            case ._4Stars:
                return "4 stars"
            case ._5Stars:
                return "5 stars"
            default:
                return "unrated"
            }
        }
    }
}
