import SwiftUI

extension View {
    func onReceive(
        _ name: Notification.Name,
        center: NotificationCenter = .default,
        object: AnyObject? = nil,
        perform action: @escaping (Notification) -> Void
    ) -> some View {
        onReceive(center.publisher(for: name, object: object), perform: action)
    }

    @ViewBuilder func applyIf<V: View, W: View>(
        _ condition: Bool,
        @ViewBuilder modifiers: (Self) -> V,
        @ViewBuilder elseModifiers: (Self) -> W
    ) -> some View {
        if condition {
            modifiers(self)
        } else {
            elseModifiers(self)
        }
    }
}
