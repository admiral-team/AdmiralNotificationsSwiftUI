//
//  ZToastNotificationsView.swift
//  AdmiralSwiftUI
//
//  Created on 04.08.2021.
//

import AdmiralCore
import SwiftUI
import UIKit
/**
 ToastNotificationsDirection - Public enum for direction ZToastNotificationsView

 ToastNotificationsDirection can be one of the following values:
 - up - Toast show from up.
 - down - Toast show from dowm.
 */
/// Toast notification show direction.
public enum ToastNotificationsDirection {
    /// Toast show from up.
    case up
    /// Toast show from dowm.
    case down
}

/**
 ZToastNotificationsView - A View for show toast.

 You can create a ZToastNotificationsView with the zero frame rectangle by specifying the following parameters in init:

 - animationDuration: Double - Animation duration.
 - hideAnimationDuration: Double - Hidden toast animation duration.
 - content: (ToastPresenter) -> (Content) - Сlosure passing in the argument by the parameter of the representative and returning View
 - direction: ToastNotificationsDirection - Can be in the following states: up, down
 */
/// View for show toast.
@available(iOS 14.0.0, *)
public struct ZToastNotificationsView<Content>: View where Content: View {

    // MARK: - Public Properties

    /// Toast presenter.
    @StateObject public var toastPresenter = ToastPresenter()

    /// Content.
    public var content: (ToastPresenter) -> (Content)

    // MARK: - Private Properties

    private var direction: ToastNotificationsDirection = .up
    private var isAfterTouchUpdateTimer: Bool = true
    @State private var toastOffset: CGFloat = 0.0
    @State private var toastNextOffset: CGFloat = 0.0
    @Binding private var topOffset: CGFloat
    @Binding private var bottomOffset: CGFloat
    private var toastsDidDisappear: () -> () = {}

    private var defaultToastYOffset: CGFloat {
        return UIScreen.main.bounds.height - ToastView.Constants.maxHeight - bottomOffset
    }

    // MARK: - Initializer

    /// Initializes and returns a newly allocated view object with the specified frame rectangle.
    /// - Parameters:
    ///   - animationDuration: Animation duration.
    ///   - hideAnimationDuration: Hidden toast animation duration.
    ///   - content: Content.
    public init(
        animationDuration: Double = Durations.Default.double,
        hideAnimationDuration: Double = 7.0,
        direction: ToastNotificationsDirection = .down,
        isAfterTouchUpdateTimer: Bool = true,
        topOffset: Binding<CGFloat> = .constant(0),
        bottomOffset: Binding<CGFloat> = .constant(0),
        toastsDidDisappear: @escaping  ()->() = {},
        @ViewBuilder content: @escaping (ToastPresenter) -> (Content))
    {
        self.content = content
        self.direction = direction
        self._topOffset = topOffset
        self.isAfterTouchUpdateTimer = isAfterTouchUpdateTimer
        self._bottomOffset = bottomOffset
        self.toastsDidDisappear = toastsDidDisappear

        self._toastPresenter = StateObject<ToastPresenter>(
            wrappedValue: ToastPresenter(
                animationDuration: animationDuration,
                hideAnimationDuration: hideAnimationDuration,
                direction: direction
            )
        )
    }

    // MARK: - Body

    public var body: some View {
        ZStack {
            content(toastPresenter)
            VStack {
                switch direction {
                case .up:
                    toastView
                        .onAppear {
                            toastPresenter.isToastDisappear = false
                        }
                        .onDisappear {
                            toastOffset = .zero
                            toastPresenter.isToastDisappear = true
                            removeTostsFromModel()
                        }
                    toastNextView
                        .onAppear {
                            toastPresenter.isNextToastDisappear = false
                        }
                        .onDisappear {
                            toastNextOffset = .zero
                            toastPresenter.isNextToastDisappear = true
                            removeTostsFromModel()
                        }
                case .down:
                    toastDownView
                        .onAppear {
                            toastPresenter.isToastDisappear = false
                        }
                        .onDisappear {
                            toastPresenter.isToastDisappear = true
                            removeTostsFromModel()
                        }
                    toastDownNextView
                        .onAppear {
                            toastPresenter.isNextToastDisappear = false
                        }
                        .onDisappear {
                            toastPresenter.isNextToastDisappear = true
                            removeTostsFromModel()
                        }
                }
                Spacer()
            }
            .padding(.horizontal, LayoutGrid.doubleModule)
        }
        .onChange(of: direction) { newValue in
            toastPresenter.direction = newValue
        }
    }

    // MARK: - Layouts

    private var toastView: some View {
        toastPresenter.toast
            .transition(
                AnyTransition
                    .offset(
                        .init(width: 0, height: -(LayoutGrid.halfModule * 43) - topOffset)
                    )
                    .combined(
                        with:
                        .offset(
                            .init(width: 0, height: topOffset)
                        )
                    )
            )
            .gesture(
                DragGesture(minimumDistance: 0, coordinateSpace: .local)
                    .onChanged { value in
                        if value.translation.height <= 0 {
                            toastOffset = value.translation.height
                            toastPresenter.closeToasts()
                        }
                        toastPresenter.cancelHideToast()
                    }
                    .onEnded { value in
                        if value.translation.height < -LayoutGrid.doubleModule {
                            toastPresenter.closeToasts()
                        } else {
                            if isAfterTouchUpdateTimer {
                                toastPresenter.addCancelOperation()
                            }
                        }
                    }
            )
            .offset(x: 0.0, y: topOffset)
            .animation(.easeInOut(duration: toastPresenter.animationDuration))
            .ignoresSafeArea()
    }

    private var toastNextView: some View {
        toastPresenter.toastNext
            .transition(
                AnyTransition
                    .offset(
                        .init(width: 0, height: -(LayoutGrid.halfModule * 43) - topOffset)
                    )
                    .combined(
                        with:
                        .offset(
                            .init(width: 0, height: 0.0)
                        )
                    )
            )
            .gesture(
                DragGesture(minimumDistance: 0, coordinateSpace: .local)
                    .onChanged { value in
                        if value.translation.height <= 0 {
                            toastNextOffset = value.translation.height
                        }
                        if isAfterTouchUpdateTimer {
                            toastPresenter.cancelHideToast()
                        }
                    }
                    .onEnded { value in
                        if value.translation.height < -LayoutGrid.doubleModule {
                            toastPresenter.closeToasts()
                        } else {
                            if isAfterTouchUpdateTimer {
                                toastPresenter.addCancelOperation()
                            }
                        }
                    }
            )
            .offset(x: 0.0, y: topOffset)
            .animation(.easeInOut(duration: toastPresenter.animationDuration))
            .ignoresSafeArea()
    }

    private var toastDownView: some View {
        toastPresenter.toast
            .transition(
                AnyTransition
                    .offset(
                        .init(width: 0, height: UIScreen.main.bounds.height)
                    )
                    .combined(
                        with:
                        .offset(
                            .init(width: 0, height: defaultToastYOffset)
                        )
                    )
            )
            .gesture(
                DragGesture(minimumDistance: 0, coordinateSpace: .local)
                    .onChanged { value in
                        if value.translation.height > 0 {
                            toastOffset = value.translation.height
                        }
                        if isAfterTouchUpdateTimer {
                            toastPresenter.cancelHideToast()
                        }
                    }
                    .onEnded { value in
                        if value.translation.height > LayoutGrid.doubleModule {
                            toastPresenter.closeToasts()
                            toastOffset = 0
                        } else {
                            toastOffset = 0
                            if isAfterTouchUpdateTimer {
                                toastPresenter.addCancelOperation()
                            }
                        }
                    }
            )
            .offset(x: 0.0, y: defaultToastYOffset)
            .animation(.easeInOut(duration: toastPresenter.animationDuration))
            .ignoresSafeArea()
    }

    private var toastDownNextView: some View {
        toastPresenter.toastNext
            .transition(
                AnyTransition
                    .offset(
                        .init(width: 0, height: UIScreen.main.bounds.height)
                    )
                    .combined(
                        with:
                        .offset(
                            .init(width: 0, height: defaultToastYOffset)
                        )
                    )
            )
            .gesture(
                DragGesture(minimumDistance: 0, coordinateSpace: .local)
                    .onChanged { value in
                        if value.translation.height > 0 {
                            toastNextOffset = value.translation.height
                        }
                        if isAfterTouchUpdateTimer {
                            toastPresenter.cancelHideToast()
                        }
                    }
                    .onEnded { value in
                        if value.translation.height > LayoutGrid.doubleModule {
                            toastPresenter.closeToasts()
                            toastNextOffset = 0
                        } else {
                            toastNextOffset = 0
                            if isAfterTouchUpdateTimer {
                                toastPresenter.addCancelOperation()
                            }
                        }
                    }
            )
            .offset(x: 0.0, y: defaultToastYOffset)
            .animation(.easeInOut(duration: toastPresenter.animationDuration))
            .ignoresSafeArea()
    }

    private func removeTostsFromModel() {
        if toastPresenter.isToastDisappear, toastPresenter.isNextToastDisappear {
            toastsDidDisappear()
        }
    }

}

