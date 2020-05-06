//
//  RTNRatingsViewController.swift
//  ratethisnow
//
//  Created by Keith Elliott on 10/17/16.
//  Copyright © 2016 GittieLabs. All rights reserved.
//

import UIKit

class RTNRatingsViewController: UICollectionViewController {
    static let storyboardIdentifier = "RTNRatingsViewController"
    var delegate :RTNRatingsViewControllerDelegate?
    
    enum RatingsCollectionItem{
        case rating(RTNItem)
        case add
    }

    var ratingsList: [RatingsCollectionItem]
    
    // MARK: Initialization
    
    required init?(coder aDecoder: NSCoder) {
        self.ratingsList = [RatingsCollectionItem]()
        self.ratingsList.insert(RatingsCollectionItem.add, at: 0)
        super.init(coder: aDecoder)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

   
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.ratingsList.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let rating = self.ratingsList[indexPath.row]
        
        switch rating {
        case .add:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddRatedItemCell.reuseId, for: indexPath) as? AddRatedItemCell else { fatalError("failed to find add cell")}
            
            cell.imageView.image = UIImage(named:"add_rating")
            return cell
            
        case .rating(let ratedItem):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RatedItemCell.reuseId, for: indexPath) as? RatedItemCell else { fatalError("failed to obtain rating cell") }
            
            cell.ratedItem = ratedItem
            return cell
        }
    }

    // MARK: UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let rating = self.ratingsList[indexPath.row]
        
        switch rating {
        case .add:
            delegate?.didSelectRatingsItem()
        default:
            break;
        }
    }
}

protocol RTNRatingsViewControllerDelegate: class {
    func didSelectRatingsItem()
}
