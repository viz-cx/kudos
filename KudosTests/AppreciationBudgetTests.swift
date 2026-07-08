import Testing
@testable import Kudos

struct AppreciationBudgetTests {
    @Test func fractionFromBasisPoints() {
        #expect(AppreciationBudget(currentEnergyBasisPoints: 10000).fraction == 1)
        #expect(AppreciationBudget(currentEnergyBasisPoints: 0).fraction == 0)
        #expect(AppreciationBudget(currentEnergyBasisPoints: 7300).fraction == 0.73)
    }
    @Test func isEmptyWhenZero() {
        #expect(AppreciationBudget(currentEnergyBasisPoints: 0).isEmpty)
        #expect(!AppreciationBudget(currentEnergyBasisPoints: 5000).isEmpty)
    }
    @Test func percentTextRounds() {
        #expect(AppreciationBudget(currentEnergyBasisPoints: 7350).percentText == "74%")
    }
}
