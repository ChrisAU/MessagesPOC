import UIKit

protocol CellFactory {
    func register(`in` collectionView: UICollectionView)
    func cell(`for` model: ItemModel, at indexPath: IndexPath) -> UICollectionViewCell?
}

class DefaultCellFactory<Model: ItemModel, Cell: UICollectionViewCell>: CellFactory
where Cell: Renderer, Cell.DataType == Model {
    private weak var collectionView: UICollectionView?
    
    func register(in collectionView: UICollectionView) {
        collectionView.register(Cell.self)
        self.collectionView = collectionView
    }
    
    func cell(for model: ItemModel, at indexPath: IndexPath) -> UICollectionViewCell? {
        guard let model = model as? Model, let collectionView = collectionView else {
            return nil
        }
        let cell: Cell = collectionView.dequeueReusableCell(at: indexPath)
        cell.render(model)
        return cell
    }
}

