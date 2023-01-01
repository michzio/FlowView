import SwiftUI

public protocol NavigationTitleConvertible {
    var navigationTitle: String { get }
}

final class PageFlowViewModel<T>: FlowViewModel where T: NavigationTitleConvertible {

    let configuration: PageFlowViewConfiguration

    let data: [T]

    override var navigationTitle: String {
        data[selection].navigationTitle
    }

    override var backgroundColor: Color {
        configuration.backgroundColor
    }

    override var primaryTintColor: Color {
        configuration.primaryTintColor
    }

    override var hasProgressBar: Bool {
        configuration.hasProgressBar
    }

    override var disableSwipe: Bool {
        configuration.disableSwipe
    }

    override var pagesCount: Int {
        data.count
    }

    init(data: [T], configuration: PageFlowViewConfiguration) {
        self.configuration = configuration
        self.data = data
        super.init()
    }
}
