// MainViewModel.swift
// Copyright © AdmiralUI. All rights reserved.

import Combine
import SwiftUI
import AdmiralNotificationsSwiftUI

final class MainViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var toastModel: ToastModel?
    @Published var buttonActionId = UUID().uuidString
    
    // MARK: - Initializer
    
    init() {
        toastModel = ToastModel(
            title: "Notification title",
            duration: 2,
            toastType: .notification,
            toastViewType: .error,
            image: nil,
            linkText: nil,
            cornerRadius: 20,
            borderWidth: 2,
            linkActionHandler: {},
            closeActionHandler: {}
        )
    }
    
}
