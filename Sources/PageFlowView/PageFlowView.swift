import SwiftUI

public struct PageFlowViewConfiguration {

    let backgroundColor: Color
    let primaryTintColor: Color
    let hasProgressBar: Bool
    let disableSwipe: Bool

    public init(
        backgroundColor: Color = .white,
        primaryTintColor: Color = .accentColor,
        hasProgressBar: Bool = true,
        disableSwipe: Bool = false
    ) {
        self.backgroundColor = backgroundColor
        self.primaryTintColor = primaryTintColor
        self.hasProgressBar = hasProgressBar
        self.disableSwipe = disableSwipe
    }
}

public struct PageFlowView<T, Content>: View where T: NavigationTitleConvertible, T: Hashable, Content: View {

    private let data: [T]
    private let selection: Int
    private let configuration: PageFlowViewConfiguration
    private let isActive: Binding<Bool>?

    private let pageContent: (T) -> Content


    public var body: some View {
        PageFlowViewContent<T>(
            viewModel: PageFlowViewModel(data: data, configuration: configuration),
            selection: selection,
            pageContent: { AnyView(pageContent($0)) }
        )
        .id(data)
    }

    public init(
        data: [T],
        selection: T,
        configuration: PageFlowViewConfiguration = .init(),
        isActive: Binding<Bool>? = nil,
        @ViewBuilder pageContent: @escaping (T) -> Content
    ) {
        self.data = data
        self.selection = data.firstIndex(of: selection) ?? 0
        self.configuration = configuration
        self.isActive = isActive
        self.pageContent = pageContent
    }

    public init(
        data: [T],
        selectedPage: Int,
        configuration: PageFlowViewConfiguration = .init(),
        isActive: Binding<Bool>? = nil,
        @ViewBuilder pageContent: @escaping (T) -> Content
    ) {
        self.data = data
        self.selection = selectedPage
        self.configuration = configuration
        self.isActive = isActive
        self.pageContent = pageContent
    }
}

struct PageFlowViewContent<T>: View where T: NavigationTitleConvertible, T: Hashable {

    @StateObject private var viewModel: PageFlowViewModel<T>

    private let selection: Int
    private let pageContent: (T) -> AnyView

    private let isActive: Binding<Bool>?

    var body: some View {
        FlowView(viewModel: viewModel, pages: pages, isActive: isActive)
            .onChange(of: selection) { selection in
                withAnimation {
                    viewModel.selection = selection
                }
            }
    }

    private var pages: [AnyView] {
        viewModel.data.map { model in
            pageContent(model)
        }
    }

    init(
        viewModel: @escaping @autoclosure () -> PageFlowViewModel<T>,
        selection: Int,
        configuration: PageFlowViewConfiguration = .init(),
        isActive: Binding<Bool>? = nil,
        pageContent: @escaping (T) -> AnyView
    ) {
        self.selection = selection
        self.pageContent = pageContent

        self.isActive = isActive

        _viewModel = StateObject(wrappedValue: viewModel())
    }
}

struct SwiftUIView_Previews: PreviewProvider {

    enum TestModel: String, CaseIterable, NavigationTitleConvertible {
        case first
        case second
        case third
        case four
        case five
        case six
        case seven
        case eight
        case nine

        var navigationTitle: String {
            rawValue
        }
    }

    struct PageFlowViewTest: View {

        @State private var isOdd = false

        @State private var data: [TestModel] = TestModel.allCases
        @State private var selection: TestModel = .first

        var body: some View {
            NavigationView {
                VStack {
                    PageFlowView(data: data, selection: selection) { model in
                        ZStack {
                            Color.white
                            Button {
                                selection = data.randomElement() ?? .first
                            } label: {
                                Text(model.rawValue)
                            }
                        }
                    }
                    
                    Button {
                        isOdd.toggle()
                        data = isOdd ? [.first, .third, .five, .seven, .nine] : [.second, .four, .six, .eight]
                    } label: {
                        Text("Change model")
                    }
                }
            }
        }
    }

    static var previews: some View {
        PageFlowViewTest()
    }
}
