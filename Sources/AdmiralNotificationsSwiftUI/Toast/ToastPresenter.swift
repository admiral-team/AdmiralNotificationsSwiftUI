//
//  ToastPresenter.swift
//  AdmiralSwiftUI
//
//  Created on 04.08.2021.
//

import AdmiralCore
import SwiftUI
import Combine
/**
 ToastPresenter - an object that controls a ToastView life cycle.
 You can create a ToastPresenter with the zero frame rectangle by specifying the following parameters in init:
 - animationDuration: Double: The full animation duration of ToastPresenter.
 - hideAnimationDuration: Double: The hide animation time of ToastPresenter.
 ## Example to create ToastPresenter
 # Code
 ```
 let presenter = ToastPresenter(
     animationDuration: animationDuration,
     hideAnimationDuration: hideAnimationDuration
 )
```
 */
@available(iOS 14.0.0, *)
public class ToastPresenter: ObservableObject {

    // MARK: - Constants

    public enum Constants {
        public static let hideAnimationDuration: Double = 2.0
    }

    // MARK: - Internal Properties

    @Published public var toast: ToastView?
    @Published public var toastNext: ToastView?

    @Published public var animationDuration: Double = Durations.Default.double
    @Published public var hideAnimationDuration: Double = Constants.hideAnimationDuration
    @Published public var direction: ToastNotificationsDirection = .up

    public var isToastDisappear: Bool = true
    public var isNextToastDisappear: Bool = true

    // MARK: - Private Properties

    private var timer: Timer?
    private var currentCount: Double = 0
    private let queue = OperationQueue()

    // MARK: - Initializer

    /// Initializes and returns a newly allocated view object with the specified frame rectangle.
    /// - Parameters:
    ///   - animationDuration: Animation duration.
    ///   - hideAnimationDuration: Cancel animation duration.
    public init(
        animationDuration: Double = Durations.Default.double,
        hideAnimationDuration: Double = Constants.hideAnimationDuration,
        direction: ToastNotificationsDirection = .up
    ) {
        self.animationDuration = animationDuration
        self.hideAnimationDuration = hideAnimationDuration
        self.direction = direction

        queue.maxConcurrentOperationCount = 1
    }

    deinit {
        self.queue.cancelAllOperations()
        self.toast = nil
        self.toastNext = nil
    }

    // MARK: - Public Methods
    public func changeDirection(_ direction: ToastNotificationsDirection) {
        self.direction = direction
    }

    public func showView(
        _ view: ToastView,
        animationDuration: Double = Durations.Default.double,
        hideAnimationDuration: Double = Constants.hideAnimationDuration
    ) {
        self.animationDuration = animationDuration
        self.hideAnimationDuration = hideAnimationDuration

        let showOperation = BlockOperation {
            let semaphore = DispatchSemaphore(value: 0)

            OperationQueue.main.addOperation { [weak self] in
                guard let `self` = self else {
                    semaphore.signal()
                    return
                }

                if !self.isToastDisappear {
                    self.toast = nil
                    self.toastNext = self.toastView(view, closeAction: { [weak self] in
                        self?.currentCount = 0
                        self?.timer?.invalidate()
                        self?.timer = nil
                        self?.toastNext = nil
                        self?.addHideOperation()
                    })
                    self.toastNext?.direction = direction
                } else {
                    self.toastNext = nil
                    self.toast = self.toastView(view, closeAction: { [weak self] in
                        self?.currentCount = 0
                        self?.timer?.invalidate()
                        self?.timer = nil
                        self?.toast = nil
                        self?.addHideOperation()
                    })
                    self.toast?.direction = direction
                }

                // WORKAROUND: Work for solve problem set pause.
                DispatchQueue.main.asyncAfter(deadline: .now() + self.animationDuration) {
                    semaphore.signal()
                }
            }

            semaphore.wait()
        }

        addCancelOperation()
        queue.addOperation(showOperation)
    }

    // MARK: - Internal Methods

    public func toastView(_ view: ToastView, closeAction: @escaping () -> ()) -> ToastView {
        if let timerDuration = view.timerDuration {
            var tostView = ToastView(
                title: view.title,
                linkText: view.linkText,
                linkAction: view.linkAction,
                timerDuration: timerDuration,
                schemeProvider: view.schemeProvider,
                closeAction: closeAction,
                closeView: view.closeView,
                type: view.type,
                cornerRadius: view.cornerRadius,
                borderWidth: view.borderWidth,
                accessibilityIdentifier: view.accessibilityIdentifier
            )
            tostView.direction = direction
            return tostView
        } else {
            var tostView = ToastView(
                title: view.title,
                linkText: view.linkText,
                linkAction: view.linkAction,
                image: view.image,
                imageType: view.imageType,
                imageColorType: view.imageColorType,
                schemeProvider: view.schemeProvider,
                closeAction: closeAction,
                closeView: view.closeView,
                type: view.type,
                cornerRadius: view.cornerRadius,
                borderWidth: view.borderWidth,
                accessibilityIdentifier: view.accessibilityIdentifier
            )
            tostView.direction = direction
            return tostView
        }
    }

    public func cancelHideToast() {
        self.currentCount = 0
        DispatchQueue.main.async {
            self.timer?.invalidate()
            self.timer = nil
            self.toast = nil
            self.toastNext = nil
        }
    }

    public func addHideOperation() {
        let hideOperation = BlockOperation {
            let semaphore = DispatchSemaphore(value: 0)

            OperationQueue.main.addOperation { [weak self] in
                guard let `self` = self else {
                    semaphore.signal()
                    return
                }
                // WORKAROUND: Work for solve problem set pause.
                DispatchQueue.main.asyncAfter(deadline: .now() + self.animationDuration) {
                    semaphore.signal()
                }
            }

            semaphore.wait()
        }
        queue.addOperation(hideOperation)
    }

    public func addCancelOperation() {
        self.timer?.invalidate()
        self.timer = nil
        self.currentCount = 0
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { [weak self] _ in
            guard let `self` = self else { return }

            self.currentCount += 0.1
            if self.currentCount >= self.hideAnimationDuration {
                self.currentCount = 0
                self.timer?.invalidate()
                self.timer = nil
                self.toast = nil
                self.toastNext = nil
                self.addHideOperation()
            }
        })
    }


    public func closeToasts() {
        self.toast = nil
        self.toastNext = nil
    }

}
