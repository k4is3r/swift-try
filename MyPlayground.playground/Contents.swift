import Foundation

enum DebitCategories: String{
    case healt
    case food, rent, tax
    case transportation, entretaining
}

enum TransactionType {
    case debit(_ value: Debit)
    case gain(_ value: Gain)
}

class Transactions {
    var value: Float
    var name: String
    
    init(value: Float, name: String) {
        self.value = value
        self.name = name
    }
}

class Debit: Transactions{
    var category: DebitCategories
    
    init(value: Float, name: String, category:DebitCategories) {
        self.category = category
        super.init(value: value, name: name)
    }
}

class Gain: Transactions{
    
}

class Account {
    var amount: Float = 0{
        willSet{
            print("Vamos a cambiar el valor", amount, newValue)
        }
        didSet{
            print("Tenemos nuevo valor",amount)
        }
    }
    var name: String = ""
    var transactions: [Transactions] = []
    var debits: [Debit] = []
    var gains: [Gain] = []
    init(amount: Float, name: String) {
        self.amount = amount
        self.name = name
    }
    
    @discardableResult
    func addTransaction( transaction: TransactionType) -> Float {
        switch transaction {
        case .debit(let debit):
            if (amount - debit.value) < 0{
                return 0
            }
            amount -= debit.value
            transactions.append(debit)
            debits.append(debit)
        case .gain(let gain):
            amount += gain.value
            transactions.append(gain)
        }
        
        return amount
    }
    /*
    func debits() -> [Transactions]{
        return transactions.filter({$0 is Debit})
    }
    func gains() -> [Transactions]{
        return transactions.filter({$0 is Gain})
    }
    */
    func transactionsFor(category: DebitCategories) -> [Transactions] {
        return transactions.filter({ (transaction) -> Bool in
            guard let transaction = transaction as? Debit else{
                return false
            }
            return transaction.category == category
        })
    }
}

class Person{
    var name: String
    var lastName: String
    var account: Account?
    
    var fullName: String {
        get{
            return "\(name) \(lastName)"
        }
        set{
            name = String(newValue.split(separator: " ").first ?? "")
            lastName = "\(newValue.split(separator: " ").last ?? "" )"
        }
    }
    
    init(name: String, lastName: String) {
        self.name = name
        self.lastName = lastName
    }
}

var me = Person(name: "Eduardo", lastName: "Imery")
var account = Account(amount: 100_000, name: "X Bank")

me.account = account

print(me.account!)

me.account?.addTransaction(
    transaction: .debit(Debit(value: 20,
                              name: "Cafe con amigos",
                              category:DebitCategories.food
    ))
)

me.account?.addTransaction(
    transaction: .debit(Debit(value: 100,
                              name: "Juego PS4",
                              category:.entretaining
    ))
)

me.account?.addTransaction(
    transaction: .debit(Debit(value: 3400,
                              name: "MacbookPro",
                              category:.entretaining
    ))
)

me.account?.addTransaction(
    transaction: .gain(Gain(value: 1200,name: "Rembolso compra"))
)


print(me.account!.amount)
print(me.fullName)
let transactions = me.account?.transactionsFor(category: .entretaining) as? [Debit]
for transaction in transactions ?? []{
    let type = transaction.category.rawValue
    print(type.capitalized)
     print(
        transaction.name,
        transaction.value,
        transaction.category.rawValue
    )
}

