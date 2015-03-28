

var items = [String]()

class A {
    var v = "val"
}

class B: A {
    
}

var a = A()

a.v

var c =  a as? B