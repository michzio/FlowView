import SwiftUI

public struct ProgressBar: View {

    public struct Configuration {
        let tintColor: Color
        let height: CGFloat

        public init(tintColor: Color = .accentColor, height: CGFloat = 6) {
            self.tintColor = tintColor
            self.height = height
        }
    }
    
    @Binding private var progress: CGFloat

    private let configuration: Configuration
    
    public init(progress: Binding<CGFloat>, configuration: Configuration = .init()) {
        self.configuration = configuration
        
        _progress = progress
    }
    
    public var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                progressRectangle(for: geometry)
                    .opacity(0.2)
                progressRectangle(for: geometry, progress: progress)
                    .animation(.linear)
            }
            .cornerRadius(configuration.height / 2)
        }
        .frame(maxHeight: configuration.height)
    }
    
    private func progressRectangle(for geometry: GeometryProxy, progress: CGFloat = 1) -> some View {
        Rectangle()
            .frame(width: geometry.size.width * progress, height: configuration.height)
            .foregroundColor(configuration.tintColor)
    }
}

struct ProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        ProgressBar(progress: Binding<CGFloat>.constant(0.2))
            .padding()
    }
}
