import UIKit
import FlexLayout
import PinLayout

class HeaderView: UICollectionReusableView, Renderer {
    static let template = HeaderView()
    
    private lazy var container = UIView(style: Stylesheet.Header.container)
    private lazy var text = UILabel(style: Stylesheet.Header.title)
    
    func render(_ model: String) {
        flex.define { (flex) in
            flex.addItem(container).direction(.row).alignSelf(.center)
                .maxWidth(50%)
                .margin(15)
                .define { flex in
                    flex.addItem(text)
            }
        }
        text.text = model
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
        container.pin.width(size.width)
        layout()
        return frame.size
    }
    
    private func layout() {
        flex.layout(mode: .adjustHeight)
    }
}

