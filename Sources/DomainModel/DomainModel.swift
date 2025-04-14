struct DomainModel {
    var text = "Hello, World!"
        // Leave this here; this value is also tested in the tests,
        // and serves to make sure that everything is working correctly
        // in the testing harness and framework.
}

////////////////////////////////////
// Money
//
enum MoneyError: Error {
    case invalidCurrency(desired: String)
}

public struct Money {
    var amount: Int
    var currency: String
    
    init(amount: Int, currency: String) throws {
        let validCurrency = ["USD", "GBP", "EUR", "CAN"]
        guard validCurrency.contains(currency) else {
            throw MoneyError.invalidCurrency(desired: currency)
        }
        self.amount = amount
        self.currency = currency
    }
    
    public func convert(_ to: String) throws -> Money {
         let validCurrencies = ["USD", "GBP", "EUR", "CAN"]
         if !validCurrencies.contains(to) {
             throw MoneyError.invalidCurrency(desired: to)
         }

         let usd = self.toUSD()
         let convertedAmount = Money.usdTo(currency: to, amount: usd)
         return try Money(amount: convertedAmount, currency: to)
     }

     public func add(_ other: Money) throws -> Money { // testing
         let totalUSD = self.toUSD() + other.toUSD()
         let finalAmount = Money.usdTo(currency: self.currency, amount: totalUSD)
         return try Money(amount: finalAmount, currency: self.currency)
     }

     private func toUSD() -> Int {
         switch currency {
         case "USD": return amount
         case "GBP": return amount * 2
         case "EUR": return Int(Double(amount) / 1.5)
         case "CAN": return Int(Double(amount) / 1.25)
         default: return 0
         }
     }

     private static func usdTo(currency: String, amount: Int) -> Int {
         switch currency {
         case "USD": return amount
         case "GBP": return amount / 2
         case "EUR": return Int(Double(amount) * 1.5)
         case "CAN": return Int(Double(amount) * 1.25)
         default: return 0
         }
     }
}
////////////////////////////////////
// Job
//
public class Job {
    public enum JobType {
        case Hourly(Double)
        case Salary(UInt)
    }
}

////////////////////////////////////
// Person
//
public class Person {
}

////////////////////////////////////
// Family
//
public class Family {
}
