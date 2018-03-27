import UIKit

struct Style<View> {
    let style: (View) -> Void
    
    init(_ style: @escaping (View) -> Void) {
        self.style = style
    }
    
    func apply(to view: View) {
        style(view)
    }
}

extension UIView {
    convenience init<V>(style: Style<V>) {
        self.init(frame: .zero)
        apply(style)
    }
    
    func apply<V>(_ style: Style<V>) {
        guard let view = self as? V else {
            debugPrint("Could not apply style for \(V.self) to \(type(of: self))")
            return
        }
        style.apply(to: view)
    }
}

extension UIViewController {
    convenience init<V>(style: Style<V>) {
        self.init(nibName: nil, bundle: nil)
        apply(style)
    }
    
    func apply<V>(_ style: Style<V>) {
        guard let view = self as? V else {
            debugPrint("Could not apply style for \(V.self) to \(type(of: self))")
            return
        }
        style.apply(to: view)
    }
}

