import SwiftUI

public protocol SelectionRepresentable {
    var rawValue: Int { get }
}

open class FlowViewModel: ObservableObject {
    
    @Published public var progress: CGFloat = 0
    @Published public var selection: Int = 0 {
        didSet {
            updateProgress()
        }
    }
    
    open var navigationTitle: String {
        fatalError("Implement flow navigation bar title!")
    }
    
    open var backgroundColor: Color {
        .primary
    }

    open var primaryTintColor: Color {
        .accentColor
    }
    
    open var pagesCount: Int {
        fatalError("Implement total pages count!")
    }

    public init() {
        updateProgress()
    }
    
    open func updateProgress() {
        guard pagesCount > 0 else {
            progress = 0
            return
        }
        progress = CGFloat(selection + 1) / CGFloat(pagesCount)
    }
    
    open func onBackButton() -> Bool {
        false
    }
    
    public func setPage(_ page: SelectionRepresentable) {
        if #available(iOS 15, *) {
            withAnimation {
                selection = page.rawValue
            }
        } else {
            selection = page.rawValue
        }
    }
}
