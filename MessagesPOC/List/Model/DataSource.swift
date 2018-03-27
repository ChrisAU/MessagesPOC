import UIKit
import Dwifft

@objc class DataSource: NSObject, UICollectionViewDataSource {
    private var diffCalculator: CollectionViewDiffCalculator<String, Item>?
    private var sectionedValues: SectionedValues<String, Item> {
        let tuples = sections.map { ($0.title, $0.items) }
        return SectionedValues(tuples)
    }
    private var cellFactories: [CellFactory] = []
    private var headerFactories: [HeaderFactory] = []
    private weak var collection: UICollectionView?
    
    var sections: [Section] = [] {
        didSet {
            self.diffCalculator?.sectionedValues = sectionedValues
        }
    }
    
    func bind(_ collection: UICollectionView,
              with cellFactories: [CellFactory],
              and headerFactories: [HeaderFactory]) {
        diffCalculator = CollectionViewDiffCalculator(collectionView: collection,
                                                      initialSectionedValues: sectionedValues)
        self.collection = collection
        self.cellFactories = cellFactories
        self.headerFactories = headerFactories
        collection.dataSource = self
        headerFactories.forEach { $0.register(in: collection) }
        cellFactories.forEach { $0.register(in: collection) }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return diffCalculator?.numberOfSections() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader {
            guard let title = diffCalculator?.value(forSection: indexPath.section),
                let header = headerFactories.first(evaluating: { $0.header(for: title, at: indexPath) }) else {
                    return UICollectionReusableView()
            }
            return header
        } else {
            return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return diffCalculator?.numberOfObjects(inSection: section) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let model = diffCalculator?.value(atIndexPath: indexPath).model,
            let cell = cellFactories.first(evaluating: { $0.cell(for: model, at: indexPath) }) else {
                return UICollectionViewCell()
        }
        return cell
    }
}

fileprivate extension Sequence {
    func first<T>(evaluating f: @escaping (Element) -> (T?)) -> T? {
        for element in self {
            if let result = f(element) {
                return result
            }
        }
        return nil
    }
}

