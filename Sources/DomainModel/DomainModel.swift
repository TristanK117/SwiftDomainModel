struct DomainModel {
    var text = "Hello, World!"
        // Leave this here; this value is also tested in the tests,
        // and serves to make sure that everything is working correctly
        // in the testing harness and framework.
}

////////////////////////////////////
// Money
//
public enum MoneyError: Error {
    case invalidCurrency(desired: String)
}

public struct Money {
    var amount: Int
    var currency: String

    public init(amount: Int, currency: String) {
        let validCurrencies = ["USD", "GBP", "EUR", "CAN"]
        guard validCurrencies.contains(currency) else {
            fatalError("Invalid currency: \(currency)")
        }
        self.amount = amount
        self.currency = currency
    }

    public func convert(_ to: String) -> Money {
        let validCurrencies = ["USD", "GBP", "EUR", "CAN"]
        guard validCurrencies.contains(to) else {
            fatalError("Invalid target currency: \(to)")
        }

        let usd = self.toUSD()
        let convertedAmount = Money.usdTo(currency: to, amount: usd)
        return Money(amount: convertedAmount, currency: to)
    }

    public func add(_ other: Money) -> Money {
        let totalUSD = self.toUSD() + other.toUSD()
        let finalAmount = Money.usdTo(currency: other.currency, amount: totalUSD)
        return Money(amount: finalAmount, currency: other.currency)
    }

    private func toUSD() -> Int {
        switch currency {
        case "USD": return amount
        case "GBP": return amount * 2
        case "EUR": return Int(Double(amount) / 1.5)
        case "CAN": return Int(Double(amount) / 1.25)
        default:
            fatalError("Invalid internal currency in toUSD()")
        }
    }

    private static func usdTo(currency: String, amount: Int) -> Int {
        switch currency {
        case "USD": return amount
        case "GBP": return amount / 2
        case "EUR": return Int(Double(amount) * 1.5)
        case "CAN": return Int(Double(amount) * 1.25)
        default:
            fatalError("Invalid target currency in usdTo()")
        }
    }
}
////////////////////////////////////
// Job
//

public class Job {
    public enum JobType {
        case Hourly(Double)
        case Salary(Int)
    }

    public var title: String
    public var type: JobType

    public init(title: String, type: JobType) {
        self.title = title
        self.type = type
    }

    public func calculateIncome(_ hours: Int = 2000) -> Int {
        switch type {
        case .Hourly(let rate):
            return Int(rate * Double(hours))
        case .Salary(let salary):
            return salary
        }
    }

    public func raise(byAmount amount: Double) {
        switch type {
        case .Hourly(let rate):
            type = .Hourly(rate + amount)
        case .Salary(let salary):
            type = .Salary(salary + Int(amount))
        }
    }

    public func raise(byPercent percent: Double) {
        switch type {
        case .Hourly(let rate):
            type = .Hourly(rate * (1 + percent))
        case .Salary(let salary):
            type = .Salary(Int(Double(salary) * (1 + percent)))
        }
    }
}
//
//////////////////////////////////////
//// Person
////
public class Person {
    public var firstName: String
    public var lastName: String
    public var age: Int

    public var job: Job? {
        didSet {
            if age < 16 {
                job = nil
            }
        }
    }

    public var spouse: Person? {
        didSet {
            if age < 18 {
                spouse = nil
            }
        }
    }

    public init(firstName: String, lastName: String, age: Int, job: Job? = nil, spouse: Person? = nil) {
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
        self.job = age >= 16 ? job : nil
        self.spouse = age >= 18 ? spouse : nil
    }

    public func toString() -> String {
        let jobDesc: String
        if let job = job {
            switch job.type {
            case .Hourly(let rate):
                jobDesc = "Hourly(\(Int(rate)))"
            case .Salary(let salary):
                jobDesc = "Salary(\(salary))"
            }
        } else {
            jobDesc = "nil"
        }

        let spouseName = spouse?.firstName ?? "nil"

        return "[Person: firstName:\(firstName) lastName:\(lastName) age:\(age) job:\(jobDesc) spouse:\(spouseName)]"
    }
}

////////////////////////////////////
// Family
//
public class Family {
    public var members: [Person] = []

    public init(spouse1: Person, spouse2: Person) {
        guard spouse1.spouse == nil && spouse2.spouse == nil else {
            fatalError("One or both spouses are already married.")
        }

        spouse1.spouse = spouse2
        spouse2.spouse = spouse1

        members.append(spouse1)
        members.append(spouse2)
    }

    public func haveChild(_ child: Person) -> Bool {
        guard members.count >= 2 else { return false }

        let parent1 = members[0]
        let parent2 = members[1]

        if parent1.age >= 21 || parent2.age >= 21 {
            members.append(child)
            return true
        }

        return false
    }

    public func householdIncome() -> Int {
        var total = 0
        for person in members {
            if let job = person.job {
                total += job.calculateIncome()
            }
        }
        return total
    }
}
