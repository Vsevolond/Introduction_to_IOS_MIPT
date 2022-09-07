// Этот файл пуст не по ошибке. В этот раз вам необходимо самостоятельно импортировать необходимые модули и запустить проверку
import FirstCourseThirdTaskChecker


class Stack: FirstCourseThirdTaskChecker.ArrayInitializableStorage {
    var arr = [Int]()
    
    override var count: Int {
        get {
            return arr.count
        }
    }
    
    required init() {
        super.init()
    }
    
    required init(array: [Int]) {
        arr = array
        super.init(array: array)
    }
    
    override func push(_ element: Int) {
        arr.append(element)
    }
    
    override func pop() -> Int {
        return arr.popLast()!
    }
    
}

class Queue: FirstCourseThirdTaskChecker.ArrayInitializableStorage {
    var arr = [Int]()
    
    override var count: Int {
        get {
            return arr.count
        }
    }
    
    required init() {
        super.init()
    }
    
    required init(array: [Int]) {
        arr = array
        super.init(array: array)
    }
    
    override func push(_ element: Int) {
        arr.append(element)
    }
    
    override func pop() -> Int {
        return arr.removeFirst()
    }
}

let checker = Checker()

let stack = Stack()
let queue = Queue()

checker.checkInheritance(stack: stack, queue: queue)

struct StackP: FirstCourseThirdTaskChecker.StorageProtocol, FirstCourseThirdTaskChecker.ArrayInitializable {
    
    var arr: [Int]
    
    var count: Int {
        get {
            return arr.count
        }
    }
    
    init() {
        arr = [Int]()
    }
    
    mutating func push(_ element: Int) {
        arr.append(element)
    }
    
    mutating func pop() -> Int {
        return arr.popLast()!
    }
    
    init(array: [Int]) {
        arr = array
    }
}

struct QueueP: FirstCourseThirdTaskChecker.StorageProtocol, FirstCourseThirdTaskChecker.ArrayInitializable {
    
    var arr: [Int]
    
    var count: Int {
        get {
            return arr.count
        }
    }
    
    init() {
        arr = [Int]()
    }
    
    mutating func push(_ element: Int) {
        arr.append(element)
    }
    
    mutating func pop() -> Int {
        return arr.removeFirst()
    }
    
    init(array: [Int]) {
        arr = array
    }
}

let stackP = StackP()
let queueP = QueueP()

checker.checkProtocols(stack: stackP, queue: queueP)


extension FirstCourseThirdTaskChecker.User: FirstCourseThirdTaskChecker.JSONSerializable, FirstCourseThirdTaskChecker.JSONInitializable {
    
    
    public func toJSON() -> String {
        return "{\"fullName\": \"\(self.fullName)\", \"email\": \"\(self.email)\"}"
    }
    
    public convenience init(JSON: String) {
        self.init()
        self.fullName = String(JSON[JSON.index(JSON.firstIndex(of: " ")!, offsetBy: 2)..<JSON.index(before: JSON.firstIndex(of: ",")!)])
        self.email = String(JSON[JSON.index(JSON.lastIndex(of: " ")!, offsetBy: 2)..<JSON.index(before: JSON.lastIndex(of: "}")!)])
        //print(self.fullName, self.email)
    }
    
}

//let user = FirstCourseThirdTaskChecker.User()

checker.checkExtensions(userType: FirstCourseThirdTaskChecker.User.self)

