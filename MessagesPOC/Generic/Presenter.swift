import Foundation

class Presenter<View: AnyObject> {
    weak var view: View?
    
    func attachView(_ view: View) {
        self.view = view
    }
    
    func detachView(_ view: View) {
        self.view = nil
    }
}
