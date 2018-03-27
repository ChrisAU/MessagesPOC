import UIKit

protocol HeaderFactory {
    func register(`in` collectionView: UICollectionView)
    func header(`for` model: String, at indexPath: IndexPath) -> UICollectionReusableView?
}

class DefaultHeaderFactory<Model, Header: UICollectionReusableView>: HeaderFactory
where Header: Renderer, Header.DataType == Model {
    private weak var collectionView: UICollectionView?
    
    func register(in collectionView: UICollectionView) {
        collectionView.registerHeader(Header.self)
        self.collectionView = collectionView
    }
    
    func header(for model: String, at indexPath: IndexPath) -> UICollectionReusableView? {
        guard let model = model as? Model, let collectionView = collectionView else {
            return nil
        }
        let header: Header = collectionView.dequeueReusableHeader(at: indexPath)
        header.render(model)
        return header
    }
}
