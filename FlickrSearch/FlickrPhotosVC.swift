

import UIKit

class FlickrPhotosVC: UICollectionViewController {
    private let flickCellID = "FlickrCellID"
    private let sectionInsets = UIEdgeInsets(
        top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    
    private var searches = [FlickrSearchResults]()
    private let flickr = Flickr()
    
    func photoForIndexPath(indexPath: NSIndexPath) -> FlickrPhoto {
        return searches[indexPath.section].searchResults[indexPath.row]
    }

}

extension FlickrPhotosVC: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {

        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        textField.addSubview(activityIndicator)
        activityIndicator.frame = textField.bounds
        activityIndicator.startAnimating()
        flickr.searchFlickrForTerm(textField.text!) {
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