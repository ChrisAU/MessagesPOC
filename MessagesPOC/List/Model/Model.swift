import Foundation

struct Section: Equatable {
    static func ==(lhs: Section, rhs: Section) -> Bool {
        return lhs.title == rhs.title
    }
    
    let title: String
    let items: [Item]
}

func == (lhs: Item, rhs: Item) -> Bool {
    switch (lhs, rhs) {
    case (.text(let lhs), .text(let rhs)):
        return lhs == rhs
    }
}

enum Item: Equatable {
    case text(TextModel)
    
    var model: ItemModel {
        switch self {
        case .text(let model): return model
        }
    }
}

protocol ItemModel { }


func == (lhs: TextModel, rhs: TextModel) -> Bool {
    guard lhs.title == rhs.title else { return false }
    guard lhs.sent == rhs.sent else { return false }
    guard lhs.last == rhs.last else { return false }
    return true
}

struct TextModel: ItemModel, Equatable {
    let title: String
    let sent: Bool
    let last: Bool
}
