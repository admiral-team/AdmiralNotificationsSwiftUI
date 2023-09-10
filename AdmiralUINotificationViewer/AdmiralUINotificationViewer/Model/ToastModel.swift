// ToastModel.swift
// Copyright © AdmiralUI. All rights reserved.

import AdmiralNotificationsSwiftUI
import SwiftUI

/// Содержание нотификации
struct ToastModel {
     init(
        title: String = "",
        duration: Int? = 2,
        toastType: ToastType = .notification,
        toastViewType: ToastViewType = .success,
        toastDirection: ToastNotificationsDirection = .up,
        image: Image? = nil,
        linkText: String? = nil,
        cornerRadius: CGFloat = 20,
        borderWidth: CGFloat = 2,
        linkActionHandler: (() -> ())? = nil,
        closeActionHandler: (() -> ())? = nil
    ) {
        self.title = title
        self.duration = duration
        self.toastViewType = toastViewType
        self.toastType = toastType
        self.toastDirection = toastDirection
        self.image = image
        self.linkText = linkText
        self.cornerRadius = cornerRadius
        self.borderWidth = borderWidth
        self.linkActionHandler = linkActionHandler
        self.closeActionHandler = closeActionHandler
        switch toastViewType {
        case .additional:
            imageType = .info
            imageColorType = .info
        case .error:
            imageType = .error
            imageColorType = .error
        case .success:
            imageType = .success
            imageColorType = .success
        default:
            imageType = nil
            imageColorType = nil
        }
    }

    /// Title нотификации.
     var title: String
    /// Тип нотификации - action/notification
     var toastType: ToastType
    /// Время показа нотификации.
     var duration: Int?
    /// Image расположенная в левом углу внутри нотификации.
     var image: Image?
    /// Тип картинки.
     var imageType: ToastImageType?
    /// Цвет картинки.
     var imageColorType: ToastImageType?
    /// Title кнопки внутри нотификации.
     var linkText: String?
    /// Направление показа анимации.
     var toastDirection: ToastNotificationsDirection?
    /// Тип представления нотификации success/error/additional.
     var toastViewType: ToastViewType
    /// Corner radius
     var cornerRadius: CGFloat
    /// Border width
     var borderWidth: CGFloat
    /// Событие нажатия на кнопку.
     let linkActionHandler: (() -> ())?
    /// Событие закрытия нотификации.
     let closeActionHandler: (() -> ())?
}

extension ToastModel: Equatable {
     static func == (lhs: ToastModel, rhs: ToastModel) -> Bool {
        lhs.title == rhs.title &&
        lhs.toastDirection == rhs.toastDirection &&
        lhs.duration == rhs.duration &&
        lhs.toastType == rhs.toastType &&
        lhs.cornerRadius == rhs.cornerRadius &&
        lhs.borderWidth == rhs.borderWidth
    }
}
