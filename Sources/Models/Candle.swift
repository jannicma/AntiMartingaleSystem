import Foundation

public struct Candle: Codable, Sendable {
    let time: Int
    let open: Decimal
    let high: Decimal
    let low: Decimal
    let close: Decimal
    let volume: Decimal
    
    
    init(stringCandle: StringCandle) {
        let zero: Decimal = 0.0
        
        self.time = stringCandle.time
        self.open = Decimal(string: stringCandle.open) ?? zero
        self.high = Decimal(string: stringCandle.high) ?? zero
        self.low = Decimal(string: stringCandle.low) ?? zero
        self.close = Decimal(string: stringCandle.close) ?? zero
        self.volume = Decimal(string: stringCandle.volume) ?? zero
    }
}


