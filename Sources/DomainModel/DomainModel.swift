struct DomainModel {
    var text = "Hello, World!"
        // Leave this here; this value is also tested in the tests,
        // and serves to make sure that everything is working correctly
        // in the testing harness and framework.
}

////////////////////////////////////
// Money
//

public struct Money {
//    public enum MoneyError: Error {
//        case CurrencyInvalid(String)
//    }
    
    let currencies = ["USD", "GBP", "EUR", "CAN"]
    var amount: Int
    var currency: String
    
    init(amount: Int, currency: String) {
        self.amount = amount
//        guard currencies.contains(currency) else {
//            print("Invalid currency: \(currency)")
//            throw MoneyError.CurrencyInvalid("Invalid currency: \(currency)")
//        }
        self.currency = currency
    }
    
    func convert(_ currency: String) -> Money {
        var tempCurr: Float
        var retCurrency = currency
        var retAmount: Int
        
        switch(self.currency) {
        case "GBP":
            tempCurr = 2.0*Float(self.amount)
        case "EUR":
            tempCurr = 2.0/3.0*Float(self.amount)
        case "CAN":
            tempCurr = 4.0/5.0*Float(self.amount)
        default:
            tempCurr = 1.0*Float(self.amount)
        }
        
        switch(currency) {
        case "GBP":
            retAmount = Int(tempCurr * (1.0/2.0))
        case "EUR":
            retAmount = Int(tempCurr * 1.5)
        case "CAN":
            retAmount = Int(tempCurr * 1.25)
        case "USD":
            retAmount = Int(tempCurr)
        default:
            retCurrency = self.currency
            retAmount = self.amount
        }
        
        return Money(amount: retAmount, currency: retCurrency)
    }
    
    func add(_ other: Money) -> Money {
        let exchangeMoney = convert(other.currency)
        
        return Money(amount: exchangeMoney.amount + other.amount, currency: other.currency)
    }
    
    func subtract(_ other: Money) -> Money {
        let exchangeMoney = convert(other.currency)
        
        return Money(amount: exchangeMoney.amount - other.amount, currency: other.currency)
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
    
    var title: String
    var type: JobType
    
    init(title: String, type: JobType) {
        self.title = title
        self.type = type
    }
    
    func calculateIncome(_ hour: Int) -> Int {
        switch self.type {
        case let .Salary(salary):
            return Int(salary)
        case let .Hourly(salary):
            return Int(salary * Double(hour))
        }
        
    }
    
    func raise(byAmount: Double ) {
        switch self.type {
        case let .Salary(salary):
            self.type = .Salary(UInt(Double(Double(salary) + byAmount)))
        case let .Hourly(salary):
            self.type = .Hourly(Double(salary + byAmount))
        }
    }
    
    func raise(byPercent: Double) {
        switch self.type {
        case let .Salary(salary):
            self.type = .Salary(UInt(Double(salary) * (1.0 + byPercent)))
        case let .Hourly(salary):
            self.type = .Hourly(Double(salary) * (1.0 + byPercent))
        }
    }
}

////////////////////////////////////
// Person
//
public class Person {
    var firstName: String
    var lastName: String
    var age: Int
    var job: Job? {
        didSet {
            if (age < 18) {
                self.job = nil
            }
        }
    }
    var spouse: Person? {
        didSet {
            if (age < 18) {
                self.spouse = nil
            }
        }
    }
    
    init(firstName: String, lastName: String, age: Int, job: Job? = nil, spouse: Person? = nil) {
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
        self.job = job
        self.spouse = spouse
    }
    
    func toString() ->String {
        let job = self.job == nil ? "nil" : String(describing: self.job?.type)
        let spouseName = self.spouse == nil ? "nil" : String(describing: self.spouse?.firstName)
                
        return "[Person: firstName:\(self.firstName) lastName:\(self.lastName) age:\(self.age) job:\(job) spouse:\(spouseName)]"
    }
}

////////////////////////////////////
// Family
//
public class Family {
    var members: [Person] = []
    
    init(spouse1: Person, spouse2: Person) {
        if (spouse1.spouse == nil && spouse2.spouse == nil) {
            spouse1.spouse = spouse2
            spouse2.spouse = spouse1
            
            self.members.append(spouse1)
            self.members.append(spouse2)
        }
    }
    
    func haveChild(_ child: Person) -> Bool {
        for member in self.members {
            if (member.age > 21) {
                members.append(child)
                return true
            }
        }
        
        return false
    }
    
    func householdIncome() -> Int {
        var total: Int = 0
        
        for member in self.members {
            if (member.job != nil) {
                total += (member.job?.calculateIncome(2000) ?? 0)
            }
        }
        
        return total
    }
}
