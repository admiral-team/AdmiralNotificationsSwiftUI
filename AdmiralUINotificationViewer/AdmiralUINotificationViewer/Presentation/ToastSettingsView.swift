// ToastSettingsView.swift
// Copyright © AdmiralUI. All rights reserved.

import SwiftUI
import AdmiralNotificationsSwiftUI
import AdmiralCore
import AdmiralTheme

struct ToastSettingsView: View {
    
    // MARK: - Properties
    
    @Binding var model: ToastModel?
    @State private var cornerRadius: CGFloat = 10
    @State private var duration: Int = 5
    
    // MARK: - Body
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: LayoutGrid.doubleModule) {
                VStack(spacing: LayoutGrid.module) {
                    makeTitle("State:")
                    makeToastStateToggle("Notification", .notification)
                    makeToastStateToggle("Action", .action)
                }
                VStack(spacing: LayoutGrid.module) {
                    makeTitle("Toast direction:")
                    makeToastDirectionToggle("Up", .up)
                    makeToastDirectionToggle("Down", .down)
                }
                VStack(spacing: LayoutGrid.module) {
                    makeTitle("Toast View Type:")
                    makeToastViewTypeToggle("Success", .success)
                    makeToastViewTypeToggle("Additional", .additional)
                    makeToastViewTypeToggle("Error", .error)
                    makeToastViewTypeToggle("Default", .default)
                    makeToastViewTypeToggle("Attention", .attention)
                }
                VStack(spacing: LayoutGrid.module) {
                    makeTitle("Duration: \(duration)")
                    Slider(
                        value: Binding(
                            get: { return Double(duration) },
                            set: {
                                duration = Int($0)
                                model?.duration = duration
                            }
                        ),
                        in: 1...20
                    )
                    makeTitle("Corner radius: \(Int(cornerRadius))")
                    Slider(
                        value: Binding(
                            get: { return Double(cornerRadius) },
                            set: {
                                cornerRadius = CGFloat($0)
                                model?.cornerRadius = cornerRadius
                            }
                        ),
                        in: 1...20
                    )
                }
            }
            .padding(.horizontal, LayoutGrid.doubleModule)
        }
    }
    
    // MARK: - Layouts
    
    private func makeTitle(_ title: String) -> some View {
        HStack(spacing: .zero) {
            Text(title)
                .foregroundColor(AppTheme.default.colors.textPrimary.swiftUIColor)
                .font(.system(size: 19, weight: .bold))
            Spacer()
        }
    }
    
    private func makeToastViewTypeToggle(_ title: String, _ toastViewType: ToastViewType) -> some View {
        let toastTypeColor: Color = {
            switch toastViewType {
            case .additional:
                return AppTheme.default.colors.elementAdditional.swiftUIColor
            case .attention:
                return AppTheme.default.colors.elementAttention.swiftUIColor
            case .default:
                return AppTheme.default.colors.elementAccent.swiftUIColor
            case .error:
                return AppTheme.default.colors.elementError.swiftUIColor
            case .success:
                return AppTheme.default.colors.elementSuccess.swiftUIColor
            }
        }()
        
        return HStack {
            Toggle(title, isOn: Binding(
                get: { return model?.toastViewType == toastViewType },
                set: { value in
                    guard value else { return }
                    model?.toastViewType = toastViewType
                }
            ))
            .toggleStyle(CheckboxToggleStyle(viewType: toastViewType, model: $model))
            .foregroundColor(toastTypeColor)
            Spacer()
        }
    }
    
    private func makeToastStateToggle(_ title: String, _ toastType: ToastType) -> some View {
        Toggle(
            title,
            isOn: Binding(
                get: { return model?.toastType == toastType },
                set: { value in
                    model?.toastType = value ? toastType : toastType.toggle()
                }
            )
        )
        .foregroundColor(AppTheme.default.colors.textPrimary.swiftUIColor)
        .font(.system(size: 16, weight: .semibold))
    }
    
    private func makeToastDirectionToggle(_ title: String, _ direction: ToastNotificationsDirection) -> some View {
        Toggle(
            title,
            isOn: Binding(
                get: { return model?.toastDirection == direction },
                set: { value in
                    model?.toastDirection = value ? direction : (direction == .up ? .down : .up)
                }
            )
        )
        .foregroundColor(AppTheme.default.colors.textPrimary.swiftUIColor)
        .font(.system(size: 16, weight: .semibold))
    }
}

private struct CheckboxToggleStyle: ToggleStyle {
    let viewType: ToastViewType
    @Binding var model: ToastModel?
    
    func makeBody(configuration: Configuration) -> some View {
        Button(action: {
            model?.toastViewType = viewType
        }, label: {
            HStack {
                Image(systemName: viewType == model?.toastViewType ? "circle.fill" : "circle")
                    .imageScale(.large)
                configuration.label
            }
        })
        .buttonStyle(PlainButtonStyle())
    }
}
