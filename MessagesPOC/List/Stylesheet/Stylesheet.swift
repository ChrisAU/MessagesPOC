import UIKit

enum Stylesheet {
    enum List {
        static var view = Style<UIView> {
            $0.backgroundColor = UIColor.lightGray
        }
        
        static let viewController = Style<UIViewController> {
            $0.title = "List"
            view.apply(to: $0.view)
        }
        
        static let list = Style<UICollectionView> {
            view.apply(to: $0)
        }
        
        static func makeCollectionView() -> UICollectionView {
            let flowLayout = UICollectionViewFlowLayout()
            flowLayout.minimumLineSpacing = 0
            flowLayout.minimumInteritemSpacing = 0
            
            if #available(iOS 11.0, *) {
                flowLayout.sectionInsetReference = .fromSafeArea
            }
            
            let collection = UICollectionView(frame: .zero,
                                              collectionViewLayout: flowLayout)
            collection.apply(list)
            return collection
        }
    }
    
    enum Cell {
        static let container = Style<UIView> {
            $0.backgroundColor = UIColor.white
            $0.layer.cornerRadius = 15
            $0.layer.borderColor = UIColor.black.cgColor
            $0.layer.borderWidth = 1 / UIScreen.main.scale
        }
        
        static let title = Style<UILabel> {
            $0.textColor = UIColor.black
            $0.numberOfLines = 0
            $0.lineBreakMode = .byWordWrapping
        }
    }
    
    enum Header {
        static let container = Style<UIView> {
            $0.backgroundColor = UIColor.lightGray
        }
        
        static let title = Style<UILabel> {
            $0.textColor = UIColor.darkGray
            $0.font = UIFont.boldSystemFont(ofSize: 13)
        }
    }
}

