//
//  ToastViewStyle.swift
//  AdmiralSwiftUI
//
//  Created on 26.07.2021.
//

import AdmiralTheme
/**
 ToastViewScheme - the visual scheme.
 You can create a by specifying the following parameters in init:
 - ToastViewScheme() - Initialize default ToastViewScheme with default themezation
 # Example to create ToastViewScheme:
 # Code
 ```
 let scheme = ToastViewScheme()
 ```
 */
@available(iOS 14.0.0, *)
public struct ToastViewScheme: AppThemeScheme {

    // MARK: - Properties

    /// The title label color
    public var titleTextColor = ToastViewParameters<AColor>()

    /// The close button tint color
    public var closeTintColor = ToastViewParameters<AColor>()

    /// The close button title color
    public var closeTitleColor = ToastViewParameters<AColor>()

    /// The background color
    public var backgroundColor = ToastViewParameters<AColor>()

    /// The image tint color
    public var imageTintColor = ToastImageParameters<AColor>()
    
    /// The border color
    public var borderColor = ToastViewParameters<AColor>()

    /// The title label font
    public var titleTextFont: AFont

    /// The close button title font
    public var closeTitleFont: AFont

    /// The bottom button scheme
    public var buttonScheme: ToastGhostButtonScheme

    /// Cound down view scheme.
    public var countDownViewScheme: CoundDownViewScheme

    // MARK: - Initializer

    public init(theme: AppTheme = .default) {

        let alpha = theme.colors.disabledAlpha

        titleTextFont = theme.fonts.body2
        closeTitleFont = theme.fonts.body2

        buttonScheme = ToastGhostButtonScheme(theme: theme)
        countDownViewScheme = CoundDownViewScheme(theme: theme)

        // Default Normal
        titleTextColor.set(parameter: theme.colors.textPrimary, isEnabled: true, type: .default)
        closeTintColor.set(parameter: theme.colors.elementPrimary, isEnabled: true, type: .default)
        closeTitleColor.set(parameter: theme.colors.elementAccent, isEnabled: true, type: .default)
        backgroundColor.set(parameter: theme.colors.backgroundAdditionalOne, isEnabled: true, type: .default)
        borderColor.set(parameter: theme.colors.backgroundAdditionalOne, isEnabled: true, type: .default)
        imageTintColor.set(parameter: theme.colors.elementSuccess, isEnabled: true, type: .info)

        // Success Normal
        titleTextColor.set(parameter: theme.colors.textPrimary, isEnabled: true, type: .success)
        closeTintColor.set(parameter: theme.colors.elementPrimary, isEnabled: true, type: .success)
        closeTitleColor.set(parameter: theme.colors.elementAccent, isEnabled: true, type: .success)
        backgroundColor.set(parameter: theme.colors.backgroundSuccess, isEnabled: true, type: .success)
        borderColor.set(parameter: theme.colors.backgroundSuccess, isEnabled: true, type: .default)
        imageTintColor.set(parameter: theme.colors.elementSuccess, isEnabled: true, type: .success)

        // Attention Normal
        titleTextColor.set(parameter: theme.colors.textPrimary, isEnabled: true, type: .attention)
        closeTintColor.set(parameter: theme.colors.elementPrimary, isEnabled: true, type: .attention)
        closeTitleColor.set(parameter: theme.colors.elementAccent, isEnabled: true, type: .attention)
        backgroundColor.set(parameter: theme.colors.backgroundAttention, isEnabled: true, type: .attention)
        borderColor.set(parameter: theme.colors.backgroundAttention, isEnabled: true, type: .attention)
        imageTintColor.set(parameter: theme.colors.elementAttention, isEnabled: true, type: .attention)

        // Addition Normal
        titleTextColor.set(parameter: theme.colors.textPrimary, isEnabled: true, type: .additional)
        closeTintColor.set(parameter: theme.colors.elementPrimary, isEnabled: true, type: .additional)
        closeTitleColor.set(parameter: theme.colors.elementAccent, isEnabled: true, type: .additional)
        backgroundColor.set(parameter: theme.colors.backgroundSelected, isEnabled: true, type: .additional)
        borderColor.set(parameter: theme.colors.backgroundSelected, isEnabled: true, type: .additional)

        // Error Normal
        titleTextColor.set(parameter: theme.colors.textPrimary, isEnabled: true, type: .error)
        closeTintColor.set(parameter: theme.colors.elementPrimary, isEnabled: true, type: .error)
        closeTitleColor.set(parameter: theme.colors.elementAccent, isEnabled: true, type: .error)
        backgroundColor.set(parameter: theme.colors.backgroundError, isEnabled: true, type: .error)
        borderColor.set(parameter: theme.colors.backgroundError, isEnabled: true, type: .error)
        imageTintColor.set(parameter: theme.colors.elementError, isEnabled: true, type: .error)

        // Default Disabled
        titleTextColor.set(parameter: theme.colors.textPrimary.withAlpha(alpha), isEnabled: false, type: .default)
        closeTintColor.set(parameter: theme.colors.elementPrimary.withAlpha(alpha), isEnabled: false, type: .default)
        closeTitleColor.set(parameter: theme.colors.elementAccent.withAlpha(alpha), isEnabled: false, type: .default)
        backgroundColor.set(parameter: theme.colors.backgroundAdditionalOne.withAlpha(alpha), isEnabled: false, type: .default)
        borderColor.set(parameter: theme.colors.backgroundAdditionalOne.withAlpha(alpha), isEnabled: false, type: .default)
        imageTintColor.set(parameter: theme.colors.elementSuccess.withAlpha(alpha), isEnabled: false, type: .info)

        // Success Disabled
        titleTextColor.set(parameter: theme.colors.textPrimary.withAlpha(alpha), isEnabled: false, type: .success)
        closeTintColor.set(parameter: theme.colors.elementPrimary.withAlpha(alpha), isEnabled: false, type: .success)
        closeTitleColor.set(parameter: theme.colors.elementAccent.withAlpha(alpha), isEnabled: false, type: .success)
        backgroundColor.set(parameter: theme.colors.backgroundSuccess.withAlpha(alpha), isEnabled: false, type: .success)
        borderColor.set(parameter: theme.colors.backgroundSuccess.withAlpha(alpha), isEnabled: false, type: .success)
        imageTintColor.set(parameter: theme.colors.elementSuccess.withAlpha(alpha), isEnabled: false, type: .success)

        // Attention Disabled
        titleTextColor.set(parameter: theme.colors.textPrimary.withAlpha(alpha), isEnabled: false, type: .attention)
        closeTintColor.set(parameter: theme.colors.elementPrimary.withAlpha(alpha), isEnabled: false, type: .attention)
        closeTitleColor.set(parameter: theme.colors.elementAccent.withAlpha(alpha), isEnabled: false, type: .attention)
        backgroundColor.set(parameter: theme.colors.backgroundAttention.withAlpha(alpha), isEnabled: false, type: .attention)
        borderColor.set(parameter: theme.colors.backgroundAttention.withAlpha(alpha), isEnabled: false, type: .attention)
        imageTintColor.set(parameter: theme.colors.elementAttention.withAlpha(alpha), isEnabled: false, type: .attention)

        // Addition Disabled
        titleTextColor.set(parameter: theme.colors.textPrimary.withAlpha(alpha), isEnabled: false, type: .additional)
        closeTintColor.set(parameter: theme.colors.elementPrimary.withAlpha(alpha), isEnabled: false, type: .additional)
        closeTitleColor.set(parameter: theme.colors.elementAccent.withAlpha(alpha), isEnabled: false, type: .additional)
        backgroundColor.set(parameter: theme.colors.backgroundSelected.withAlpha(alpha), isEnabled: false, type: .additional)
        borderColor.set(parameter: theme.colors.backgroundSelected.withAlpha(alpha), isEnabled: false, type: .additional)

        // Error Disabled
        titleTextColor.set(parameter: theme.colors.textPrimary.withAlpha(alpha), isEnabled: false, type: .error)
        closeTintColor.set(parameter: theme.colors.elementPrimary.withAlpha(alpha), isEnabled: false, type: .error)
        closeTitleColor.set(parameter: theme.colors.elementAccent.withAlpha(alpha), isEnabled: false, type: .error)
        backgroundColor.set(parameter: theme.colors.backgroundError.withAlpha(alpha), isEnabled: false, type: .error)
        borderColor.set(parameter: theme.colors.backgroundError.withAlpha(alpha), isEnabled: false, type: .error)
        imageTintColor.set(parameter: theme.colors.elementError.withAlpha(alpha), isEnabled: false, type: .error)
    }

}

public struct ToastViewParameters<P> {

    public var parameters: [String: P?] = [:]

    public mutating func set(parameter: P?, isEnabled: Bool, type: ToastViewType) {
        let key = paramKey(isEnabled: isEnabled, type: type)
        parameters[key] = parameter
    }

    public func parameter(isEnabled: Bool, type: ToastViewType) -> P? {
        let key = paramKey(isEnabled: isEnabled, type: type)
        let defaultKey = paramKey(isEnabled: true, type: .default)

        guard let parameter = parameters[key] ?? parameters[defaultKey] else { return nil }
        return parameter
    }

    private func paramKey(isEnabled: Bool, type: ToastViewType) -> String {
        return "\(isEnabled ? 1 : 0).\(type.rawValue)"
    }

}

public struct ToastImageParameters<P> {

    public var parameters: [String: P?] = [:]

    public mutating func set(parameter: P?, isEnabled: Bool, type: ToastImageType) {
        let key = paramKey(isEnabled: isEnabled, type: type)
        parameters[key] = parameter
    }

    public func parameter(isEnabled: Bool, type: ToastImageType) -> P? {
        let key = paramKey(isEnabled: isEnabled, type: type)
        let defaultKey = paramKey(isEnabled: true, type: .info)

        guard let parameter = parameters[key] ?? parameters[defaultKey] else { return nil }
        return parameter
    }

    private func paramKey(isEnabled: Bool, type: ToastImageType) -> String {
        return "\(isEnabled ? 1 : 0).\(type.rawValue)"
    }

}
