//
//  ToastView.swift
//  AdmiralUIResources
//
//  Created on 26.07.2021.
//

import AdmiralTheme
import AdmiralCore
import SwiftUI

/**
 ToastViewType - Public enum for type ToastView
 
 ToastViewType can be one of the following values:
 - default - The default state of the toast.
 - success - The success state of the toast.
 - additional - The additional state of the toast.
 - attention - The attention state of the toast.
 - error - The error state of the toast is useful to show the number of errors.
 */
public enum ToastViewType: String {
    /// The default state of the toast.
    case `default`
    /// The success state of the toast.
    case success
    /// The additional state of the toast.
    case additional
    /// The attention state of the toast.
    case attention
    /// The error state of the toast is useful to show the number of errors.
    case error
    
}

/**
 ToastImageType - Public enum for type of image ToastView
 
 ToastImageType can be one of the following values:
 - success - The success state of the image toast.
 - info - The info state of the image toast.
 - attention - The attention state of the image toast.
 - error - The error state of the image toast.
 */
public enum ToastImageType: String {
    /// The success state of the image toast.
    case success
    /// The info state of the image toast.
    case info
    /// The attention state of the image toast.
    case attention
    /// The error state of the image toast.
    case error
    
}

/**
 ToastView - An input field with an informer. It is necessary if additional information may be required to fill in the field correctly.

 You can create a ToastView with the zero frame rectangle by specifying the following parameters in init:

 - title: Title of the toast.
 - linkText: Title of link button.
 - linkAction: Callback of the link button. If callback equal nil link button is hidden.
 - image: Image of the toast. If image equal nil image is hidden.
 - imageType: Type image.
 - imageColorType: Type color image.
 - closeAction: Callback of the close button. If callback equal nil close button is hidden.
 - imageAction: Callback of the top left image button.
 - closeView: A view for close action
 - type: Type color background toast.
 - cornerRadius: Toast corner radius
 - borderWidth: Notification border width

 ## Example to create ToastView
 # Code
 ```
 ToastView(
     title: "At break point",
     linkText: "Link Text",
     linkAction: {},
     imageType: .info,
     imageColorType: .info,
     closeAction: {},
     type: .default)
```
 */
@available(iOS 14.0, *)
public struct ToastView: View {
    
    enum Constants {
        static let closeImage = AssetSymbol.Service.Outline.close.swiftUIImage
        static let maxHeight: CGFloat = LayoutGrid.halfModule * 33
    }
    
    // MARK: - Internal Properties
    
    @Environment(\.isEnabled) private var isEnabled
    
    /// Timer duration.
    public var timerDuration: Int?
    
    /// Title of the toast.
    public let title: String
    
    /// Title of link button.
    public let linkText: String?
    
    /// Callback of the link button. If callback equal nil link button is hidden.
    public let linkAction: (() -> ())?
    
    /// Image of the toast.
    public let image: Image?
    
    /// Callback of the close button. If callback equal nil close button is hidden.
    public let closeAction: (() -> ())?
    
    /// Type color background toast.
    public let type: ToastViewType
    
    /// Toast image type.
    public let imageType: ToastImageType?
    
    /// Toast image color type.
    public let imageColorType: ToastImageType?
    
    /// Image action.
    public let imageAction: (() -> ())?
    
    /// Close image.
    public let closeView: () -> (AnyView?)
    
    /// Toast corner radius
    public let cornerRadius: CGFloat
    
    /// Notification border width
    public let borderWidth: CGFloat
    
    /// Accessibility id.
    public let accessibilityIdentifier: String?

    @State public var segmentSize: CGSize = .zero

    // MARK: - Internal Properties

    /// Toast direction.
    var direction: ToastNotificationsDirection = .up
    
    // MARK: - Private Properties

    @ObservedObject public var schemeProvider: SchemeProvider<ToastViewScheme>
    
    // MARK: - Initializer
    
    /// Initializes and returns a newly allocated view object.
    /// - Parameters:
    ///   - title: Title of the toast.
    ///   - linkText: Title of link button.
    ///   - linkAction: Callback of the link button. If callback equal nil link button is hidden.
    ///   - image: Image of the toast. If image equal nil image is hidden.
    ///   - imageType: Type image.
    ///   - imageColorType: Type color image.
    ///   - closeAction: Callback of the close button. If callback equal nil close button is hidden.
    ///   - imageAction: Callback of the top left image button.
    ///   - closeView: A view for close action
    ///   - type: Type color background toast.
    public init<T: View>(
        title: String,
        linkText: String? = nil,
        linkAction: (() -> ())? = nil,
        image: Image? = nil,
        imageType: ToastImageType? = nil,
        imageColorType: ToastImageType? = nil,
        schemeProvider: SchemeProvider<ToastViewScheme> = AppThemeSchemeProvider<ToastViewScheme>(),
        closeAction: (() -> ())? = nil,
        imageAction: (() -> ())? = nil,
        @ViewBuilder closeView: @escaping () -> (T?) = { return nil },
        type: ToastViewType = .default,
        cornerRadius: CGFloat = LayoutGrid.module,
        borderWidth: CGFloat = .zero,
        accessibilityIdentifier: String? = nil
    ) {
        self.accessibilityIdentifier = accessibilityIdentifier
        self.title = title
        if let image = image {
            self.image = image
        } else {
            switch imageType {
            case .attention:
                self.image = AssetSymbol.Service.Solid.errorTriangle.swiftUIImage
            case .error:
                self.image = AssetSymbol.Service.Solid.error.swiftUIImage
            case .info:
                self.image = AssetSymbol.Service.Solid.info.swiftUIImage
            case .success:
                self.image = AssetSymbol.Service.Solid.check.swiftUIImage
            case .none:
                self.image = nil
            }
        }
        self.imageType = imageType
        self.imageColorType = imageColorType
        self.linkText = linkText
        self.linkAction = linkAction
        self.imageAction = imageAction
        self.closeAction = closeAction
        self.type = type
        self.cornerRadius = cornerRadius
        self.schemeProvider = schemeProvider
        self.borderWidth = borderWidth
        self.closeView = { return closeView()?.eraseToAnyView() }
    }
    
    public init(
        title: String,
        linkText: String? = nil,
        linkAction: (() -> ())? = nil,
        image: Image? = nil,
        imageType: ToastImageType? = nil,
        imageColorType: ToastImageType? = nil,
        schemeProvider: SchemeProvider<ToastViewScheme> = AppThemeSchemeProvider<ToastViewScheme>(),
        closeAction: (() -> ())? = nil,
        imageAction: (() -> ())? = nil,
        type: ToastViewType = .default,
        cornerRadius: CGFloat = LayoutGrid.module,
        borderWidth: CGFloat = .zero,
        accessibilityIdentifier: String? = nil
    ) {
        self.accessibilityIdentifier = accessibilityIdentifier
        self.title = title
        if let image = image {
            self.image = image
        } else {
            switch imageType {
            case .attention:
                self.image = AssetSymbol.Service.Solid.errorTriangle.swiftUIImage
            case .error:
                self.image = AssetSymbol.Service.Solid.error.swiftUIImage
            case .info:
                self.image = AssetSymbol.Service.Solid.info.swiftUIImage
            case .success:
                self.image = AssetSymbol.Service.Solid.check.swiftUIImage
            case .none:
                self.image = nil
            }
        }
        self.imageType = imageType
        self.imageColorType = imageColorType
        self.linkText = linkText
        self.linkAction = linkAction
        self.imageAction = imageAction
        self.closeAction = closeAction
        self.cornerRadius = cornerRadius
        self.type = type
        self.schemeProvider = schemeProvider
        self.borderWidth = borderWidth
        self.closeView = { return nil }
    }
    
    public init<T: View>(
        title: String,
        linkText: String? = nil,
        linkAction: (() -> ())? = nil,
        timerDuration: Int?,
        schemeProvider: SchemeProvider<ToastViewScheme> = AppThemeSchemeProvider<ToastViewScheme>(),
        closeAction: (() -> ())? = nil,
        @ViewBuilder closeView: @escaping () -> (T?) = { return nil },
        type: ToastViewType = .default,
        cornerRadius: CGFloat = LayoutGrid.module,
        borderWidth: CGFloat = .zero,
        accessibilityIdentifier: String? = nil
    ) {
        self.accessibilityIdentifier = accessibilityIdentifier
        self.title = title
        self.image = nil
        self.imageType = nil
        self.imageColorType = nil
        self.timerDuration = timerDuration
        self.linkText = linkText
        self.linkAction = linkAction
        self.closeAction = closeAction
        self.imageAction = nil
        self.type = type
        self.cornerRadius = cornerRadius
        self.schemeProvider = schemeProvider
        self.borderWidth = borderWidth
        self.closeView = { return closeView()?.eraseToAnyView() }
    }
    
    public var body: some View {
        let scheme = schemeProvider.scheme
        VStack(alignment: .leading, spacing: 0.0) {
            if direction == .down {
                Spacer(minLength: 0.0)
            }
            HStack(alignment: .top, spacing: 0) {
                if let image = image {
                    Button(action: imageAction ?? {}, label: {
                        if let imageColorType = imageColorType {
                            image
                                .foregroundColor(scheme.imageTintColor.parameter(isEnabled: isEnabled, type: imageColorType)?.swiftUIColor)
                                .frame(
                                    width: LayoutGrid.halfModule * 7,
                                    height: LayoutGrid.halfModule * 7)
                        } else {
                            image
                                .frame(
                                    width: LayoutGrid.halfModule * 7,
                                    height: LayoutGrid.halfModule * 7)
                        }
                    })
                    .padding(.trailing, LayoutGrid.halfModule * 3)
                    .accessibilityIdentifier(ToastViewAccessibilityIdentifiers.imageView.accessibilityViewIdentifier(accessibilityIdentifier: accessibilityIdentifier))
                } else if let timerDuration = timerDuration {
                    CountdownView(countTo: timerDuration, schemeProvider: .constant(scheme: scheme.countDownViewScheme))
                        .frame(
                            width: LayoutGrid.halfModule * 7,
                            height: LayoutGrid.halfModule * 7)
                        .padding(.trailing, LayoutGrid.doubleModule)
                }
                HStack(alignment: .center, spacing: 0.0) {
                    VStack(alignment: .leading, spacing: LayoutGrid.module) {
                        Text(title)
                            .foregroundColor(scheme.titleTextColor.parameter(isEnabled: isEnabled, type: type)?.swiftUIColor)
                            .font(scheme.titleTextFont.swiftUIFont)
                            .frame(minHeight: LayoutGrid.halfModule * 7)
                            .accessibilityIdentifier(accessibilityIdentifier ?? "")
                        if let linkText = linkText, let linkAction = linkAction {
                            Button(linkText, action: linkAction)
                                .buttonStyle(ToastGhostButtonStyle(schemeProvider: .constant(scheme: scheme.buttonScheme)))
                                .frame(height: LayoutGrid.tripleModule)
                                .accessibilityIdentifier(ToastViewAccessibilityIdentifiers.linkText.accessibilityViewIdentifier(accessibilityIdentifier: accessibilityIdentifier))
                        }
                    }
                    Spacer(minLength: 0.0)
                    if let closeAction = closeAction {
                        Button(action: closeAction, label: {
                            if closeView() == nil {
                                Constants.closeImage
                                    .frame(width: LayoutGrid.module * 3, height: LayoutGrid.module * 3)
                                    .foregroundColor(scheme.closeTintColor.parameter(isEnabled: isEnabled, type: type)?.swiftUIColor)
                            } else {
                                closeView()
                                    .foregroundColor(scheme.closeTintColor.parameter(isEnabled: isEnabled, type: type)?.swiftUIColor)
                            }
                        })
                        .padding(.trailing, LayoutGrid.doubleModule)
                        .accessibilityIdentifier(ToastViewAccessibilityIdentifiers.closeButton.accessibilityViewIdentifier(accessibilityIdentifier: accessibilityIdentifier))
                    }
                }

            }
            .padding(.top, LayoutGrid.doubleModule)
            .padding(.leading, LayoutGrid.halfModule * 3)
            .padding(.bottom, LayoutGrid.doubleModule)
            .background(scheme.backgroundColor.parameter(isEnabled: isEnabled, type: type)?.swiftUIColor)
            .cornerRadius(cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(
                        scheme.borderColor.parameter(isEnabled: isEnabled, type: type)?.swiftUIColor ?? .clear,
                        lineWidth: borderWidth
                    )
            )
            if direction == .up {
                Spacer(minLength: 0.0)
            }
        }
        .frame(height: Constants.maxHeight)
    }
    
}

@available(iOS 14.0, *)
struct ToastView_Previews: PreviewProvider {
    static var previews: some View {
        ToastView(
            title: "At break point",
            
            linkText: "Link Text",
            linkAction: {
                print("Tap")
            },
            imageType: .info,
            imageColorType: .info,
            closeAction: {},
            type: .default
        )
    }
}
