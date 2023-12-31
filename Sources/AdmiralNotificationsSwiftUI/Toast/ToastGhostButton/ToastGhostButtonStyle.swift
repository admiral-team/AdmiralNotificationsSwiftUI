//
//  ToastGhostButtonStyle.swift
//  AdmiralSwiftUI
//
//  Created on 08.09.2021.
//

import AdmiralTheme
import AdmiralCore
import SwiftUI
/**
 The style for creating the Ghost Button. Is used in cases when the main button is not enough, often goes with it in pairs when you need to designate several actions, one of which is the main one.

 To configure the current button style for a view hierarchy, use the buttonStyle(_:) modifier.
 You can create buttons in three sizes: (small, medium, big) by specifying size Type in init ToastGhostButtonStyle:
 # Code
 ```
Button("Text", action: {})
    .buttonStyle(ToastGhostButtonStyle(sizeType: .small))
 ```
 Big - the main button, the width of which depends on the width of the screen;
 Medium - an additional button of a smaller size, the button does not change its size depending on the width of the screen;
 Small - changes its width depending on the content inside it, often used with the keyboard.

 You can create a button with an activity indicator instead of text by specifying isLoading: .constant(true) in init ToastGhostButtonStyle. In this case, the text that you pass to the Button will not be shown, but the activity indicator will be shown instead:

 # Code
 ```
 Button("Text", action: {})
    .buttonStyle(ToastGhostButtonStyle(isLoading: .constant(true)))
 ```
*/
@available(iOS 14.0.0, *)
public struct ToastGhostButtonStyle: ButtonStyle {

    // MARK: - Public Properties

    /// The loading flag of GhostButton
    @Binding public var isLoading: Bool

    /// The size type of GhostButton
    public var sizeType: ToastButtonSizeType?

    // MARK: - Private Properties

    @ObservedObject private var schemeProvider: SchemeProvider<ToastGhostButtonScheme>

    // MARK: - Inializer

    public init(
        isLoading: Binding<Bool> = .constant(false),
        sizeType: ToastButtonSizeType? = nil,
        schemeProvider: SchemeProvider<ToastGhostButtonScheme> = AppThemeSchemeProvider<ToastGhostButtonScheme>()
    ) {
        self._isLoading = isLoading
        self.sizeType = sizeType
        self.schemeProvider = schemeProvider
    }

    // MARK: - Body

    public func makeBody(configuration: Self.Configuration) -> some View {
        GhostButton(
            isLoading: $isLoading,
            schemeProvider: schemeProvider,
            sizeType: sizeType,
            configuration: configuration
        )
    }
}

@available(iOS 14.0.0, *)
private extension ToastGhostButtonStyle {
    struct GhostButton: View {

        // MARK: - Environment

        @Environment(\.isEnabled) private var isEnabled

        // MARK: - Properties

        @Binding var isLoading: Bool
        var sizeType: ToastButtonSizeType?
        let configuration: Configuration

        private var schemeProvider: SchemeProvider<ToastGhostButtonScheme>

        // MARK: - Initializer

        init(
            isLoading: Binding<Bool>,
            schemeProvider: SchemeProvider<ToastGhostButtonScheme>,
            sizeType: ToastButtonSizeType?,
            configuration: Configuration
        ) {

            self.sizeType = sizeType
            self.configuration = configuration
            self._isLoading = isLoading
            self.schemeProvider = schemeProvider
        }

        // MARK: - Body

        var body: some View {
            let scheme = schemeProvider.scheme
            let content = isLoading ?
                ToastActivityIndicator(style: .contrast, size: .medium).eraseToAnyView()
                : configuration.label.eraseToAnyView()

            switch sizeType {
            case .small, .medium, .big:
                buttonWithSize(
                    content: content,
                    sizeType: sizeType,
                    scheme: scheme
                )
            default:
                contentButton(scheme: scheme, content: content)
                    .frame(minHeight: LayoutGrid.halfModule * 10, idealHeight: LayoutGrid.module * 6, maxHeight: LayoutGrid.module * 6)
                    .background(
                        Rectangle()
                            .fill(Color.clear)
                    )
            }
        }

        // MARK: - Private Methods

        private func contentButton(
            scheme: ToastGhostButtonScheme,
            content: AnyView
        ) -> some View {
                let normal = scheme.textColor.parameter(for: .normal)?.swiftUIColor
                let disabled = scheme.textColor.parameter(for: .disabled)?.swiftUIColor
                let highlighted = scheme.textColor.parameter(for: .highlighted)?.swiftUIColor

                return content
                    .font(scheme.font.swiftUIFont)
                    .foregroundColor(isEnabled ? (configuration.isPressed ? highlighted : normal) : disabled)
        }

        private func buttonWithSize(
            content: AnyView,
            sizeType: ToastButtonSizeType?,
            scheme: ToastGhostButtonScheme
        ) -> some View  {
            return contentButton(scheme: scheme, content: content)
                .frame(maxWidth: .infinity)
                .frame(width: sizeType?.width, height: sizeType?.height)
                .background(
                    Rectangle()
                        .fill(Color.clear)
                )
        }

    }
}

@available(iOS 14.0, *)
struct GhostButton_Previews: PreviewProvider {

    static var previews: some View {
        Button("Text", action: {})
            .buttonStyle(ToastGhostButtonStyle(isLoading: .constant(false)))
    }
}
