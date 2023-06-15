//
//  ProtocolBindingTestApp.swift
//  ProtocolBindingTest
//
//  Created by Andy Kayley on 14/06/2023.
//

import SwiftUI
import WithTypeErasure
import UsingAnyKeyword

@main
struct ProtocolBindingTestApp: App {
    var body: some Scene {
        WindowGroup {
            VStack {
                TypeErasedPickerView(viewModel: StoreViewModel())
                AnyKeywordPickerView<StorePickerOptions, AKStoreViewModel>(viewModel: AKStoreViewModel())
            }
        }
    }
}


final class AKStoreViewModel: UsingAnyKeyword.PickerViewViewModel {
    typealias Option = StorePickerOptions

    var selectedPickerOption: StorePickerOptions?
    
    var pickerOptions: [StorePickerOptions] {
        StorePickerOptions.allCases
    }
    
    init() {
        self.selectedPickerOption = pickerOptions.first
    }
    
    func optionChanged(to pickerOption: Option?) {
        self.selectedPickerOption = pickerOption
        print("\(#function): \(pickerOption)")
    }
}



final class StoreViewModel: WithTypeErasure.PickerViewViewModel {
    var selectedPickerOption: AnyPickerOption?
    
    var pickerOptions: [AnyPickerOption] {
        StorePickerOptions.typeErasedCases
    }
 
    init() {
        self.selectedPickerOption = pickerOptions.first
    }
    
    func optionChanged(to pickerOption: AnyPickerOption?) {
        self.selectedPickerOption = pickerOption
        print("\(#function): \(pickerOption?.wrapped ?? nil)")
    }
}

enum StorePickerOptions: String, WithTypeErasure.PickerOption, UsingAnyKeyword.PickerOption, CaseIterable {
    var id: String {
        self.rawValue
    }
    
    typealias Id = String
    
    case highestRated = "Highest rated"
    case brand = "brand"
    case price = "price"
    case popular = "Popular"
    
    var description: String {
        self.rawValue
    }
    
    static var typeErasedCases: [AnyPickerOption] {
        Self.allCases.map { myImpl in
            AnyPickerOption(wrapped: myImpl)
        }
    }
}
