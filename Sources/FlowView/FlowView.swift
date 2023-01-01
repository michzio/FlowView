import SwiftUI

public struct FlowView: View {
    
    @Environment(\.presentationMode) private var presentationMode
    @ObservedObject private var viewModel: FlowViewModel
    
    @State private var storedPageSelection: Int?
    @State private var landscapeId = 0
    
    private let pages: [AnyView]
    private let isActive: Binding<Bool>?
    
    public init(viewModel: FlowViewModel, pages: [AnyView], isActive: Binding<Bool>? = nil) {
        self.pages = pages
        self.isActive = isActive
        
        _viewModel = ObservedObject(wrappedValue: viewModel)
    }
    
    public var body: some View {
        ZStack {
            viewModel.backgroundColor.ignoresSafeArea()
            VStack(spacing: 0) {
                progressBar
                pagesTabView
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton)
        .navigationBarTitle(viewModel.navigationTitle, displayMode: .inline)
        .onReceive(UIApplication.didBecomeActiveNotification, perform: restorePageOnActivation)
        .onReceive(UIApplication.didEnterBackgroundNotification, perform: storePageOnMinimization)
        .onReceive(UIDevice.orientationDidChangeNotification, perform: refreshLayoutOnRotation)
    }
    
    @ViewBuilder private var progressBar: some View {
        if viewModel.hasProgressBar {
            ProgressBar(progress: $viewModel.progress)
                .padding(.horizontal, 16)
        }
    }
    
    private var backButton: some View {
        Button(action: onBackButtonTapped) {
            Image(systemName: "chevron.backward")
                .foregroundColor(viewModel.primaryTintColor)
        }
    }
    
    private var pagesTabView: some View {
        TabView(selection: $viewModel.selection) {
            ForEach(pages.indices, id: \.self) { index in
                pages[index]
                    .tag(index)
                    .applyIf(viewModel.disableSwipe) {
                        $0.highPriorityGesture(DragGesture())
                    } elseModifiers: {
                        $0.gesture(DragGesture())
                    }
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .id(pages.count + landscapeId)
    }
    
    private func onBackButtonTapped() {
        guard !viewModel.onBackButton() else { return }
        if viewModel.selection < 1 {
            guard isActive != nil else { return presentationMode.wrappedValue.dismiss() }
            isActive?.wrappedValue = false
        } else {
            withAnimation {
                viewModel.selection -= 1
            }
        }
    }
    
    private func refreshLayoutOnRotation(_ notification: Notification) {
        landscapeId = UIDevice.current.orientation.isLandscape ? 1_000 : 0
    }
    
    /// hotfix on restoring correct page selection on ipad during minimization of app
    private func storePageOnMinimization(_ notification: Notification) {
        storedPageSelection = viewModel.selection
    }
    
    private func restorePageOnActivation(_ notification: Notification) {
        guard let selection = storedPageSelection else { return }
        viewModel.selection = selection
    }
}

struct FlowView_Previews: PreviewProvider {
    static var previews: some View {
        FlowView(viewModel: FlowViewModel(), pages:[AnyView(EmptyView())])
    }
}
