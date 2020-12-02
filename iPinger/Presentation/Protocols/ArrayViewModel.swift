//
//  ArrayViewModel.swift
//  iPinger
//
//  Created by Jose Bolivar on 2/12/20.
//

import Foundation

// Protocol that represents a ViewModel that provides data of an a array of a determined type
protocol ArrayViewModel: class {
    associatedtype ViewModel
    var viewModel: [ViewModel] { get set }

    func count() -> Int
}

extension ArrayViewModel {
    func count() -> Int {
        return self.viewModel.count
    }

    func itemAtIndex(_ index: Int) -> ViewModel {
        return self.viewModel[index]
    }
}

