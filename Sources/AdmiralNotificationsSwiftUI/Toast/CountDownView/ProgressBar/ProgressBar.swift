//
//  ProgressBar.swift
//  AdmiralSwiftUI
//
//  Created on 18.08.2022.
//

import AdmiralTheme
import AdmiralCore
import SwiftUI

@available(iOS 14.0, *)
struct ProgressBar: View {

    // MARK: - Internal Properties

    var counter: Int
    var countTo: Int

    // MARK: - Private Properties

    @ObservedObject private var schemeProvider: SchemeProvider<ProgressBarScheme>

    // MARK: - Initiazer

    init(
        counter: Int,
        countTo: Int,
        schemeProvider: SchemeProvider<ProgressBarScheme> = AppThemeSchemeProvider<ProgressBarScheme>()
    ) {
        self.counter = counter
        self.countTo = countTo
        self.schemeProvider = schemeProvider
    }

    // MARK: - Body

    var body: some View {
        let scheme = schemeProvider.scheme
        Circle()
            .trim(from: progress(), to: 1)
            .stroke(
                style: StrokeStyle(
                    lineWidth: LayoutGrid.halfModule / 2,
                    lineCap: .round,
                    lineJoin:.round
                )
            )
            .foregroundColor(scheme.tintColor.swiftUIColor)
            .animation(counter == 0 ? nil : .linear(duration: 1))
    }

    // MARK: - Internal Methods

    func completed() -> Bool {
        return progress() == 1
    }

    func progress() -> CGFloat {
        return (CGFloat(counter) / CGFloat(countTo - 1))
    }
}

@available(iOS 14.0, *)
struct ProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ProgressBar(counter: 0, countTo: 10)
        }
    }
}
