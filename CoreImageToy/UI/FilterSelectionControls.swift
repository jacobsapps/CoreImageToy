//
//  FilterSelectionControls.swift
//  CoreImageToy
//
//  Created by Jacob Bartlett on 22/03/2024.
//

import SwiftUI

struct FilterSelectionControls: View {
    
    enum Detent: CaseIterable {
        
        case small
        case medium
        case large
        
        var detent: PresentationDetent {
            switch self {
            case .small:
                return .fraction(0.2)
            case .medium:
                return .fraction(0.55)
            case .large:
                return .fraction(0.85)
            }
        }
    }
    
    @Binding var viewModel: ImagesViewModel
    @State private var selectedDetent: PresentationDetent = Detent.small.detent
    private let availableDetents: Set<PresentationDetent> = Set(Detent.allCases.map { $0.detent })
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.filterCategories) { category in
                    Section(category.name) {
                        ForEach(category.filterSelection) { selection in
                            Button(action: {
                                viewModel.select(category: category, selection: selection)
                                
                            }, label: {
                                HStack(spacing: 12) {
                                    Text(selection.id)
                                        .font(.body)
                                        .lineLimit(1)
                                        .truncationMode(.tail)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                    if viewModel.isSelected(category: category, selection: selection) {
                                        if selection.sortOrder > 0 {
                                            Text("(#\(selection.sortOrder))")
                                                .font(.caption)
                                                .fontWeight(.medium)
                                        }
                                        
                                        Image(systemName: "checkmark")
                                            .fixedSize(horizontal: true, vertical: true)
                                    }
                                }
                            })
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        viewModel.removeAllFilters()
                        
                    }, label: {
                        Image(systemName: "trash")
                    })
                }
            }
            .navigationTitle("CoreImage Filters")
            .navigationBarTitleDisplayMode(.inline)
        }
        .presentationDetents(availableDetents, selection: $selectedDetent)
        .presentationDragIndicator(.visible)
        .presentationCornerRadius(12)
        .presentationBackgroundInteraction(.enabled)
        .interactiveDismissDisabled()
    }
}
