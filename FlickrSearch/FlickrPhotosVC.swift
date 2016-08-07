import UIKit

class FlickrPhotosVC:
UICollectionViewController {
    
    // set reuse id in main.storyboard
    private let flickrCellReuseID = "FlickrCellReuseID"
    
    private let sectionInsets = UIEdgeInsets(
        top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    
    private var searches = [FlickrSearchResults]()
    private let flickr = Flickr()
    
    func photoForIndexPath(indexPath: NSIndexPath) -> FlickrPhoto {
        return searches[indexPath.section].searchResults[indexPath.row]
    }
    
    
    // Data Source methods
    override func numberOfSectionsInCollectionView(
        collectionView: UICollectionView) -> Int {
        return searches.count
    }
    
    override func collectionView(
        collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int {
        return searches[section].searchResults.count
    }
    
    override func collectionView(
        collectionView: UICollectionView,
        cellForItemAtIndexPath indexPath: NSIndexPath)
        -> UICollectionViewCell {
            
            let cell = collectionView
                .dequeueReusableCellWithReuseIdentifier(
                    flickrCellReuseID,
                    forIndexPath: indexPath) as! FlickrPhotoCell
            
            let flickrPhoto = photoForIndexPath(indexPath)
            cell.backgroundColor = UIColor.blackColor()
            cell.imageView.image = flickrPhoto.thumbnail
            
            return cell
    }
    
    //
}

extension FlickrPhotosVC:
UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        let activityIndicator = UIActivityIndicatorView(
            activityIndicatorStyle: .Gray)
        textField.addSubview(activityIndicator)
        activityIndicator.frame = textField.bounds
        activityIndicator.startAnimating()
        
        guard let searchText = textField.text where searchText != "" else {
            activityIndicator.removeFromSuperview()
            return false
        }
        
        print(searchText)
        
        flickr.searchFlickrForTerm(searchText) {// call back
            results, error in
            
            activityIndicator.removeFromSuperview()
            if error != nil {
                print("Error searching : \(error)")
            }
            
            if results != nil {
                print("Found \(results!.searchResults.count) matching \(results!.searchTerm)")
                self.searches.insert(results!, atIndex: 0)
                self.collectionView?.reloadData()
            }
        }
        textField.text = nil
        textField.resignFirstResponder()
        return true
    }
}


extension FlickrPhotosVC:
UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let flickrPhoto =  photoForIndexPath(indexPath)
        
        if var size = flickrPhoto.thumbnail?.size {
            size.width += 10
            size.height += 10
            size.height /= 2
            size.width /= 2
            return size
        }
        return CGSize(width: 100, height: 100)
    }
    
    
    func collectionView(
        collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        
        return sectionInsets
    }
}


