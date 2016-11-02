//
//  RTNCreateRatedViewController.swift
//  ratethisnow
//
//  Created by Keith Elliott on 10/17/16.
//  Copyright © 2016 GittieLabs. All rights reserved.
//

import UIKit
import CoreGraphics
import Messages

class RTNCreateRatingViewController: UIViewController {
    static let storyboardIdentifier = "RTNCreateRatingViewController"
    var delegate: RTNCreateRatingViewControllerDelegate?
    
    @IBOutlet weak var captionTF: UITextField!
    
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var ratingStarsBtn: UIButton!
    @IBOutlet weak var ratedImageBtn: UIButton!
    @IBOutlet weak var sender1: UILabel!
    @IBOutlet weak var sender2: UILabel!
    
    var ratedItem: RTNItem?
    var conversation: MSConversation?
    
    func isOrigSender() -> Bool{
        if let message = self.conversation?.selectedMessage{
            return message.senderParticipantIdentifier == self.conversation?.localParticipantIdentifier
        }
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        guard let ratedItem = ratedItem else { return }
        self.captionTF.text = ratedItem.caption ?? ""
        let rating = getRatingForUser()
        
        switch rating {
        case ._1Star:
            self.ratingStarsBtn.setBackgroundImage(#imageLiteral(resourceName: "_1star"), for: .normal)
        case ._2Stars:
            self.ratingStarsBtn.setBackgroundImage(#imageLiteral(resourceName: "_2stars"), for: .normal)
        case ._3Stars:
            self.ratingStarsBtn.setBackgroundImage(#imageLiteral(resourceName: "_3stars"), for: .normal)
        case ._4Stars:
            self.ratingStarsBtn.setBackgroundImage(#imageLiteral(resourceName: "_4stars"), for: .normal)
        case ._5Stars:
            self.ratingStarsBtn.setBackgroundImage(#imageLiteral(resourceName: "_5stars"), for: .normal)
        default:
            self.ratingStarsBtn.setBackgroundImage(#imageLiteral(resourceName: "unrated"), for: .normal)
        }
        
        if rating != .unrated{
            self.ratedImageBtn.isUserInteractionEnabled = false
        }
    }
    
    func getRatingForUser() -> Rating{
        var rating = Rating.unrated
        
        if isOrigSender(){
            rating = ratedItem?.rating1 ?? Rating.unrated
        }
        else{
            rating = ratedItem?.rating2 ?? Rating.unrated
        }
        
        return rating
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func changeRatedItem(_ sender: AnyObject) {
    }
    
    @IBAction func changeRating(_ sender: AnyObject) {
        let rating = getRatingForUser()
        
        switch rating {
        case ._1Star:
            if isOrigSender(){
                self.ratedItem?.rating1 = Rating._2Stars
            }
            else{
                self.ratedItem?.rating2 = Rating._2Stars
            }
            self.ratingStarsBtn.setBackgroundImage(#imageLiteral(resourceName: "_2stars"), for: .normal)
        case ._2Stars:
            if isOrigSender(){
                self.ratedItem?.rating1 = Rating._3Stars
            }
            else{
                self.ratedItem?.rating2 = Rating._3Stars
            }
            self.ratingStarsBtn.setBackgroundImage(#imageLiteral(resourceName: "_3stars"), for: .normal)
        case ._3Stars:
            if isOrigSender(){
                self.ratedItem?.rating1 = Rating._4Stars
            }
            else{
                self.ratedItem?.rating2 = Rating._4Stars
            }
            self.ratingStarsBtn.setBackgroundImage(#imageLiteral(resourceName: "_4stars"), for: .normal)
        case ._4Stars:
            if isOrigSender(){
                self.ratedItem?.rating1 = Rating._5Stars
            }
            else{
                self.ratedItem?.rating2 = Rating._5Stars
            }
            self.ratingStarsBtn.setBackgroundImage(#imageLiteral(resourceName: "_5stars"), for: .normal)
        case .unrated:
            if isOrigSender(){
                self.ratedItem?.rating1 = Rating._1Star
            }
            else{
                self.ratedItem?.rating2 = Rating._1Star
            }
            self.ratingStarsBtn.setBackgroundImage(#imageLiteral(resourceName: "_1star"), for: .normal)
        default:
            if isOrigSender(){
                self.ratedItem?.rating1 = Rating.unrated
            }
            else{
                self.ratedItem?.rating2 = Rating.unrated
            }
            self.ratingStarsBtn.setBackgroundImage(#imageLiteral(resourceName: "unrated"), for: .normal)
        }
    }
    @IBAction func addRating(_ sender: AnyObject) {
        self.ratedItem?.caption = self.captionTF.text
        self.ratedItem?.image = self.ratedImageBtn.backgroundImage(for: .normal)
        delegate?.addRatingForItem(self.ratedItem!, layoutImg: self.createLayoutImage())
    }
}

extension RTNCreateRatingViewController {
    func createLayoutImage()->UIImage?{
        let size = CGSize(width:self.view.bounds.width, height: self.view.bounds.height)
        UIGraphicsBeginImageContextWithOptions(size, true, 1.0)
        self.view.drawHierarchy(in: self.view.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

extension RTNCreateRatingViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
}

protocol RTNCreateRatingViewControllerDelegate: class {
    func addRatingForItem(_ item: RTNItem, layoutImg: UIImage?)
}
