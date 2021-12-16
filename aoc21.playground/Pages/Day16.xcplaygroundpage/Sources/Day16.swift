import Foundation

func inputData() -> String {
    return "820D4A801EE00720190CA005201682A00498014C04BBB01186C040A200EC66006900C44802BA280104021B30070A4016980044C800B84B5F13BFF007081800FE97FDF830401BF4A6E239A009CCE22E53DC9429C170013A8C01E87D102399803F1120B4632004261045183F303E4017DE002F3292CB04DE86E6E7E54100366A5490698023400ABCC59E262CFD31DDD1E8C0228D938872A472E471FC80082950220096E55EF0012882529182D180293139E3AC9A00A080391563B4121007223C4A8B3279B2AA80450DE4B72A9248864EAB1802940095CDE0FA4DAA5E76C4E30EBE18021401B88002170BA0A43000043E27462829318F83B00593225F10267FAEDD2E56B0323005E55EE6830C013B00464592458E52D1DF3F97720110258DAC0161007A084228B0200DC568FB14D40129F33968891005FBC00E7CAEDD25B12E692A7409003B392EA3497716ED2CFF39FC42B8E593CC015B00525754B7DFA67699296DD018802839E35956397449D66997F2013C3803760004262C4288B40008747E8E114672564E5002256F6CC3D7726006125A6593A671A48043DC00A4A6A5B9EAC1F352DCF560A9385BEED29A8311802B37BE635F54F004A5C1A5C1C40279FDD7B7BC4126ED8A4A368994B530833D7A439AA1E9009D4200C4178FF0880010E8431F62C880370F63E44B9D1E200ADAC01091029FC7CB26BD25710052384097004677679159C02D9C9465C7B92CFACD91227F7CD678D12C2A402C24BF37E9DE15A36E8026200F4668AF170401A8BD05A242009692BFC708A4BDCFCC8A4AC3931EAEBB3D314C35900477A0094F36CF354EE0CCC01B985A932D993D87E2017CE5AB6A84C96C265FA750BA4E6A52521C300467033401595D8BCC2818029C00AA4A4FBE6F8CB31CAE7D1CDDAE2E9006FD600AC9ED666A6293FAFF699FC168001FE9DC5BE3B2A6B3EED060"
}

func decode(hex: Character) -> [Int] {
    let data: [Character:[Int]] = [
        "0": [0, 0, 0, 0],
        "1": [0, 0, 0, 1],
        "2": [0, 0, 1, 0],
        "3": [0, 0, 1, 1],
        "4": [0, 1, 0, 0],
        "5": [0, 1, 0, 1],
        "6": [0, 1, 1, 0],
        "7": [0, 1, 1, 1],
        "8": [1, 0, 0, 0],
        "9": [1, 0, 0, 1],
        "A": [1, 0, 1, 0],
        "B": [1, 0, 1, 1],
        "C": [1, 1, 0, 0],
        "D": [1, 1, 0, 1],
        "E": [1, 1, 1, 0],
        "F": [1, 1, 1, 1],
    ]
    return data[hex]!
}

func num(_ bits: ArraySlice<Int>) -> Int {
    return bits.reduce(0) {2 * $0 + $1}
}

func packet(bits: inout [Int], versions: inout Int) -> Int {
    let version = num(bits[0..<3])
    versions = versions + version
    let type = num(bits[3..<6])
    bits.removeFirst(6)

    if type == 4 {
        var literal = 0
        while true {
            let literalFlag = bits[0]
            literal = literal * 16 + num(bits[1..<5])
            bits.removeFirst(5)
            guard literalFlag == 1 else { break }
        }
        return literal
        
    } else {
        let ltype = bits.removeFirst()
        var items = [Int]()
        if ltype == 0 {
            let subBits = num(bits[0..<15])
            bits.removeFirst(15)
            
            var subData = Array(bits[0..<subBits])
            bits.removeFirst(subBits)
            while subData.count > 7 {
                items.append(packet(bits: &subData, versions: &versions))
            }
            
        } else {
            let subPackets = num(bits[0..<11])
            bits.removeFirst(11)
            for _ in 0..<subPackets {
                items.append(packet(bits: &bits, versions: &versions))
            }
        }
            
        switch type {
        case 0: return items.reduce(0, +)
        case 1: return items.reduce(1, *)
        case 2: return items.min()!
        case 3: return items.max()!
        case 5: return items[0] > items[1] ? 1 : 0
        case 6: return items[0] < items[1] ? 1 : 0
        case 7: return items[0] == items[1] ? 1 : 0
        default: return 0
        }
    }
}

public func part1() -> Int {
    var data = inputData().flatMap({decode(hex: $0)})
    var versions = 0
    packet(bits: &data, versions: &versions)
    return versions
}

public func part2() -> Int {
    var data = inputData().flatMap({decode(hex: $0)})
    var versions = 0
    return packet(bits: &data, versions: &versions)
}
