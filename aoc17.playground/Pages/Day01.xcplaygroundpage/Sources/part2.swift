/*
The captcha requires you to review a sequence of digits (your puzzle input) and find the sum of all digits that match the next digit in the list. The list is circular, so the digit after the last digit is the first digit in the list.

Now, instead of considering the next digit, it wants you to consider the digit halfway around the circular list. That is, if your list contains 10 items, only include a digit in your sum if the digit 10/2 = 5 steps forward matches it. Fortunately, your list has an even number of elements.

For example:

1212 produces 6: the list contains 4 items, and all four digits match the digit 2 items ahead.
1221 produces 0, because every comparison is between a 1 and a 2.
123425 produces 4, because both 2s match each other, but no other digit has a match.
123123 produces 12.
12131415 produces 4.
What is the solution to your new captcha?
*/

func actpac2(_ str: String) -> Int
{
    let str2 = str.dropFirst(str.count/2)+str
    return zip(str, str2).reduce(0) {
        (acc, ss) in
        guard ss.0 == ss.1 else { return acc }
        guard let i = Int(String(ss.0)) else { return acc }
        return i + acc
    }
}

public func part2() -> Int {
    let s = firstLineFromFile(named: "input")
    return actpac2(s)
}

/*
6 == actpac2("1212")
0 == actpac2("1221")
4 == actpac2("123425")
12 == actpac2("123123")
4 == actpac2("12131415")
*/
