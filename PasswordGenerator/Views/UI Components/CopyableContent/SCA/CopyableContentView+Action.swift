import Foundation

extension CopyableContentView {

    enum Action {

        case copyContent
        case updateContent(String)
        case changeCopyState(Bool)
    }
}
