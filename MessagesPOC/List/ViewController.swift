import UIKit

class ListViewController: UIViewController, ListViewType {
    convenience init() { self.init(style: Stylesheet.List.viewController) }
    private lazy var collection = Stylesheet.List.makeCollectionView()
    private let dataSource = DataSource()
    private let presenter = ListPresenter<ListViewController>()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.attachView(self)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        presenter.detachView(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Stylesheet.List.viewController.apply(to: self)
        view.addSubview(collection)
        dataSource.bind(
            collection,
            with: [
                DefaultCellFactory<TextModel, TextCell>()
            ], and: [
                DefaultHeaderFactory<String, HeaderView>()
            ])
        collection.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if #available(iOS 11.0, *) {
            collection.pin.margin(view.safeAreaInsets).all()
        } else {
            collection.pin.all()
        }
    }
    
    func setSections(_ sections: [Section]) {
        dataSource.sections = sections
        
        collection.setNeedsLayout()
    }
}

extension ListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        let adjustedWidth = adjustWidthWithSafeArea(collectionView.bounds.width)
        let model = dataSource.sections[section].title
        HeaderView.template.render(model)
        let size = HeaderView.template.sizeThatFits(CGSize(width: adjustedWidth,
                                                               height: .greatestFiniteMagnitude))
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let adjustedWidth = adjustWidthWithSafeArea(collectionView.bounds.width)
        let model = dataSource.sections[indexPath.section].items[indexPath.row].model
        // TODO: Add other templates (and genericise)
        TextCell.template.render(model as! TextModel)
        let size = TextCell.template.sizeThatFits(CGSize(width: adjustedWidth,
                                                             height: .greatestFiniteMagnitude))
        return size
    }
    
    private func adjustWidthWithSafeArea(_ width: CGFloat) -> CGFloat {
        if #available(iOS 11.0, *) {
            return width - view.safeAreaInsets.left - view.safeAreaInsets.right
        } else {
            return width
        }
    }
}

protocol ListViewType {
    func setSections(_ sections: [Section])
}

class ListPresenter<T: AnyObject & ListViewType>: Presenter<T> {
    override func attachView(_ view: T) {
        super.attachView(view)
        let sections = [
            Section(title: "Yesterday", items: [
                Item.text(TextModel(title: "Short Text", sent: false, last: false)),
                Item.text(TextModel(title: "Maecenas ultricies lobortis vulputate. Nulla fringilla neque magna, a ultrices tortor suscipit ac. Morbi tempus erat vitae erat accumsan posuere. Suspendisse quis venenatis tortor. Nullam facilisis viverra nibh, finibus eleifend diam eleifend non. Aliquam consectetur scelerisque pellentesque. Donec in lacus a erat faucibus convallis vitae ac odio.", sent: true, last: false)),
                Item.text(TextModel(title: "Nunc sit amet egestas lacus. Nulla gravida ipsum vel neque finibus, quis ullamcorper mauris egestas. Duis ullamcorper felis quis quam porta rutrum. Suspendisse at lectus purus. Cras ut tristique mauris. Ut eu nisi sed ligula sagittis imperdiet. Ut at arcu turpis. Morbi malesuada sem lectus, eget imperdiet sapien commodo id. Donec rhoncus, mi nec dictum vehicula, risus risus pulvinar ex, ut dictum mauris enim vitae lectus.", sent: false, last: false)),
                Item.text(TextModel(title: "Finito.", sent: true, last: true))
                ]),
            Section(title: "Today", items: [
                Item.text(TextModel(title: "Simple Text", sent: false, last: false)),
                Item.text(TextModel(title: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec venenatis, justo eget vulputate commodo, massa dolor rhoncus nisi, a suscipit nisl arcu id metus. Vestibulum mattis elit at justo eleifend consequat. Nam vitae tempor dui. Integer auctor felis id eleifend sagittis. Pellentesque ut porta ligula. Cras sit amet quam eu lorem feugiat congue. Integer vehicula, ex eget egestas venenatis, erat massa tempor ante, vel ornare erat eros non ipsum. Maecenas rhoncus tincidunt lorem eget vulputate. Maecenas iaculis metus at est porta ultrices. Fusce sit amet turpis justo. Nunc vel nisl ut ex laoreet hendrerit vel a ante.", sent: true, last: false)),
                Item.text(TextModel(title: "Praesent vestibulum risus risus, a sagittis ante interdum in. Nunc vitae sollicitudin eros, quis ultricies lectus. Integer scelerisque, ante nec dictum ornare, odio sapien lacinia justo, in volutpat velit magna at erat. Cras ornare dui a diam rutrum, tempus imperdiet nisi tincidunt. Quisque congue lectus rutrum neque mattis accumsan. Proin et augue metus. Praesent feugiat magna id dolor pharetra iaculis. Fusce quis porttitor magna, ac aliquet ligula.", sent: false, last: false)),
                Item.text(TextModel(title: "Ut euismod at purus eu finibus. Donec ultrices leo dui, sed hendrerit est pulvinar eu. Nulla eget ullamcorper mi, quis lobortis elit. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Donec elementum, ipsum non placerat aliquam, erat turpis faucibus libero, id sollicitudin velit libero in sem. Suspendisse varius ipsum ac neque pharetra, sit amet gravida lacus vestibulum. Donec elit arcu, scelerisque a sem eu, pretium volutpat enim. In massa diam, convallis non auctor sit amet, rutrum id ante.", sent: true, last: true))
                ])
        ]
        
        view.setSections(sections)
    }
}
