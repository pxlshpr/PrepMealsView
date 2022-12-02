import SwiftUI
import SwiftHaptics

extension MealsList {

    var list: some View {
        List {
            ForEach(meals) { meal in
                Meal(
                    meal: meal,
                    didTapAddFood: didTapAddFood,
                    didTapMealFoodItem: didTapMealFoodItem
                )
            }
            quickAddButtons
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .background(Color(.systemGroupedBackground))
    }
    
    var scrollView: some View {
        ScrollView {
            LazyVStack {
                ForEach(meals) { meal in
                    Meal(
                        meal: meal,
                        didTapAddFood: didTapAddFood,
                        didTapMealFoodItem: didTapMealFoodItem
                    )
                }
                quickAddButtons
            }
        }
//        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .background(Color(.systemGroupedBackground))
//        .onAppear {
//            DispatchQueue.main.async {
//                self.animation = .none
//            }
//        }
    }
    
    //MARK: - Buttons
    
    var addMealButton: some View {
        Button {
            onTapAddMeal(nil)
            Haptics.feedback(style: .soft)
        } label: {
            HStack {
                Image(systemName: "note.text.badge.plus")
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 15, style: .continuous)
                    .foregroundColor(Color(.tertiarySystemFill))
            )
        }
        .buttonStyle(.borderless)
    }

    var quickAddButtons: some View {
        
        var listRowBackground: some View {
            ZStack {
                ListRowBackground(
                    color: .constant(Color(.systemGroupedBackground)),
                    includeTopSeparator: .constant(false),
                    includeBottomSeparator: .constant(false),
                    includeTopPadding: .constant(true)
                )
            }
        }
        
        return Section {
            HStack(spacing: 15) {
                addMealButton
                if isToday {
                    quickAddButton()
                }
                ForEach(mealTimeSuggestions.indices, id: \.self) {
                    quickAddButton(at: mealTimeSuggestions[$0])
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .padding(.vertical, 15)
        .listRowBackground(listRowBackground)
        .listRowSeparator(.hidden)
    }
    
    func quickAddButton(at time: Date? = nil) -> some View {
        Button {
            onTapAddMeal(time ?? Date())
            Haptics.successFeedback()
        } label: {
            HStack {
                if let time {
                    Text(time.hourString)
                } else {
                    Text("Now")
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 15, style: .continuous)
                    .foregroundColor(Color(.tertiarySystemFill))
            )
        }
        .buttonStyle(.borderless)
    }
}
