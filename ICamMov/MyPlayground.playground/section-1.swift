

var items = [String]()


items.append("a")
items.append("bcc")

var i = 100
for (i,v) in enumerate(items){
    println("\(i):\(v)")
    break
}

println(i)

