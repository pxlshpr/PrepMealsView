import SwiftUI
import SwiftHaptics
import SwiftUISugar
import PrepDataTypes
import PrepCoreDataStack

extension MealsList.Meal {
    
    struct Header: View {
        @EnvironmentObject var viewModel: ViewModel
        @Environment(\.colorScheme) var colorScheme
    }
}

extension MealsList.Meal.Header {
    
    var body: some View {
        content
    }
    
    var listRowBackground: some View {
        let includeBottomSeparator = Binding<Bool>(
            get: {
                !viewModel.meal.foodItems.isEmpty && !viewModel.targetingDropOverHeader
            },
            set: { _ in }
        )
        return ListRowBackground(includeBottomSeparator: includeBottomSeparator)
    }
    
    var content: some View {
        ZStack(alignment: .top) {
            HStack {
                Spacer()
                mealMenuButton
            }
            .frame(height: 44)
            .background(
                listRowBackground
            )
            HStack {
                titleButton
                Spacer()
            }
            .frame(height: 65)
        }
    }
    
    var content_legacy: some View {
        HStack {
            titleButton
            Spacer()
            mealMenuButton
        }
    }
    
    var titleButton: some View {
        var label: some View {
            
            @ViewBuilder
            var upcomingLabel: some View {
                if viewModel.isUpcomingMeal {
                    Text("UPCOMING")
                        .foregroundColor(.white)
                        .font(.caption2)
                        .bold()
                        .padding(.vertical, 3)
                        .padding(.horizontal, 5)
                        .background(
                            RoundedRectangle(cornerRadius: 4)
                                .foregroundColor(Color.accentColor)
                        )
                        .transition(.scale)
                }
            }
            
            var timeText: some View {
                Text("**\(viewModel.meal.timeString)**")
            }
            
            var separatorText: some View {
                Text("???")
            }
            var nameText: some View {
                Text(viewModel.meal.name)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            return HStack {
                HStack {
                    timeText
                    separatorText
                    nameText
                }
                .fixedSize(horizontal: true, vertical: false)
                upcomingLabel
                Spacer()
            }
            .textCase(.uppercase)
            .font(.footnote)
            .foregroundColor(Color(.secondaryLabel))
        }
        
        return Button {
            tappedEditMeal()
        } label: {
            label
                .padding(.leading, 20)
                .frame(maxHeight: .infinity)
                .padding(.bottom, 16.75)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
//        .background(.green.opacity(0.2))
    }
    
    //MARK: - Menu
    
    var mealMenuButton: some View {
        Menu {
            Button {
                viewModel.actionHandler(.addFood(viewModel.meal))
            } label: {
                Label("Add Food", systemImage: "plus")
            }
            
            Button {
                
            } label: {
                Label("Mark as Eaten", systemImage: "checkmark.circle")
            }
            
            
            Divider()
            
            
            Button {
                
            } label: {
                Label("Summary", systemImage: "chart.bar.xaxis")
            }
            
            Button {
                
            } label: {
                Label("Food Label", systemImage: "chart.bar.doc.horizontal")
            }
            
            
            Divider()
            
            
            Button {
                tappedEditMeal()
            } label: {
                Label("Edit", systemImage: "pencil")
            }
            
            Button(role: .destructive) {
                do {
                    try DataManager.shared.deleteMeal(viewModel.meal)
                } catch {
                    print("Couldn't delete meal: \(error)")
                }
            } label: {
                Label("Delete", systemImage: "trash")
            }
            
        } label: {
            Image(systemName: "ellipsis")
                .foregroundColor(.accentColor)
                .padding(.top, 10)
                .padding(.bottom, 5)
                .padding(.leading)
                .padding(.vertical, 12)
                .padding(.trailing, 20)
                .frame(maxHeight: .infinity)
        }
        .contentShape(Rectangle())
    }
    
    var addFoodMenuButton: some View {
        Button {
            tappedAddFood()
        } label: {
            Label("Add food", systemImage: "plus")
                .textCase(.none)
        }
    }
    var completeButton: some View {
        Button {
            withAnimation {
                viewModel.tappedComplete()
            }
            Haptics.feedback(style: .soft)
        } label: {
            Label("Mark all foods as eaten", systemImage: "checkmark.circle")
                .textCase(.none)
        }
    }
    
    var deleteButton: some View {
        Button(role: .destructive) {
            tappedDeleteMeal()
        } label: {
            Label(viewModel.deleteString, systemImage: "trash.fill")
                .textCase(.none)
        }
    }
    
    //MARK: - Actions
    
    func tappedEditMeal() {
        viewModel.actionHandler(.editMeal(viewModel.meal))
        //        viewModel.didTapEditMeal(viewModel.meal)
    }
    
    func tappedAddFood() {
        Haptics.feedback(style: .light)
        //TODO: Present Meal
        viewModel.actionHandler(.addFood(viewModel.meal))
    }
    
    func tappedDeleteMeal() {
        Haptics.feedback(style: .rigid)
        viewModel.tappedDelete()
    }
    
}
