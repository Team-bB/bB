var sayHelloTwo : (String)->String = { "Hello \($0)" }
let result: String = sayHelloTwo("a")
print(result)
