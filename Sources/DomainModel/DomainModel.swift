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
