import UIKit
import FlexLayout

class TextCell: UICollectionViewCell, Renderer {
    static let template = TextCell()
    
    private lazy var container = UIView(style: Stylesheet.Cell.container)
    private lazy var text = UILabel(style: Stylesheet.Cell.title)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func render(_ model: TextModel) {
        contentView.flex.define { (flex) in
            flex.addItem(container).direction(.row).alignSelf(model.sent ? .end : .start)
                .minWidth(20%).maxWidth(75%)
                .marginTop(15).marginBottom(model.last ? 15 : 0).marginHorizontal(15).padding(15)
                .define { flex in
                    flex.addItem(text)
            }
        }
        text.text = model.title
        text.flex.markDirty()
        
        setNeedsLayout()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        text.text = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layout()
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        contentView.pin.width(size.width)
        layout()
        return contentView.frame.size
    }
    
    private func layout() {
        contentView.flex.layout(mode: .adjustHeight)
    }
}

