// MainView.swift
// Copyright © AdmiralUI. All rights reserved.

import AdmiralNotificationsSwiftUI
import AdmiralTheme
import SwiftUI

struct MainView: View {
    @StateObject private var viewModel = MainViewModel()
    @State private var bottomOffset: CGFloat = 0.0
    
    // MARK: - Body
    
    var body: some View {
        ZToastNotificationsView(
            hideAnimationDuration: Double(viewModel.toastModel?.duration ?? 5),
            direction: viewModel.toastModel?.toastDirection ?? .up,
            isAfterTouchUpdateTimer: viewModel.toastModel?.toastDirection == .up,
            topOffset: 0,
            bottomOffset: $bottomOffset,
            toastsDidDisappear: {},
            content: { presenter in
                AppTheme.default.colors.backgroundBasic.swiftUIColor.edgesIgnoringSafeArea(.all)
                VStack(spacing: .zero) {
                    ToastSettingsView(model: $viewModel.toastModel)
                    button
                }
                .padding(.top, 16)
                .onChange(
                    of: viewModel.buttonActionId,
                    perform: { _ in
                        guard let model = viewModel.toastModel else { return presenter.closeToasts() }
                        switch model.toastType {
                        case .action:
                            presenter.showView(
                                ToastView(
                                    title: model.title,
                                    timerDuration: model.duration,
                                    closeView: { EmptyView() },
                                    type: model.toastViewType,
                                    cornerRadius: model.cornerRadius
                                ),
                                hideAnimationDuration: Double(model.duration ?? .zero)
                            )
                        case .notification:
                            presenter.showView(
                                ToastView(
                                    title: model.title,
                                    linkText: model.linkText,
                                    linkAction: model.linkActionHandler,
                                    imageType: model.imageType,
                                    imageColorType: model.imageType,
                                    closeAction: model.closeActionHandler,
                                    closeView: { EmptyView() },
                                    type: model.toastViewType,
                                    cornerRadius: model.cornerRadius,
                                    borderWidth: model.borderWidth
                                )
                            )
                        }
                    }
                )
            }
        )
    }
    
    // MARK: - Layouts
    
    private var button: some View {
        Button(
            action: {
                viewModel.buttonActionId = UUID().uuidString
            }) {
                Text("Show toast")
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .font(.system(size: 18, weight: .bold))
                    .padding()
                    .foregroundColor(AppTheme.default.colors.textPrimary.swiftUIColor)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(AppTheme.default.colors.elementAccent.swiftUIColor, lineWidth: 4)
                    )
            }
            .cornerRadius(25)
            .padding()
    }
}
