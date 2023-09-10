// ToastType.swift
// Copyright © AdmiralUI. All rights reserved.


import Foundation

/// Тип показа нотификации
enum ToastType {
    /// Toast c таймером
    case action
    /// Toast без таймера
    case notification
}

extension ToastType {
    func toggle() -> ToastType {
        switch self {
        case .action:
            return .notification
        case .notification:
            return .action
        }
    }
}
