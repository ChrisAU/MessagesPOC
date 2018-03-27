import Foundation

protocol AnyRenderer {
    func _render(_ data: Any)
}

protocol Renderer: AnyRenderer {
    associatedtype DataType
    func render(_ data: DataType)
}

extension Renderer {
    func _render(_ data: Any) {
        guard let data = data as? DataType else {
            return
        }
        render(data)
    }
}

